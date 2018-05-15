#-
# Copyright (c) 2011 Steven J. Murdoch
# Copyright (c) 2013-2016 Alexandre Joannou
# Copyright (c) 2014 Jonathan Woodruff
# All rights reserved.
#
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-10-C-0237
# ("CTSRD"), as part of the DARPA CRASH research programme.
#
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-11-C-0249
# ("MRC2"), as part of the DARPA MRC research programme.
#
# @BERI_LICENSE_HEADER_START@
#
# Licensed to BERI Open Systems C.I.C. (BERI) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  BERI licenses this
# file to you under the BERI Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at:
#
#   http://www.beri-open-systems.org/legal/license-1-0.txt
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
# @BERI_LICENSE_HEADER_END@
#

import os
import re
from collections import defaultdict

## Mapping of register numbers and register names, used internally and by the
## predicate itself in generating error messages, etc.
MIPS_REG_NUM2NAME=[
  "zero", "at", "v0", "v1", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7",
  "t0", "t1", "t2", "t3", "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7", "t8",
  "t9", "k0", "k1", "gp", "sp", "fp", "ra"
]

## Inverse mapping of register name to register number
MIPS_REG_NAME2NUM={}
for num, name in enumerate(MIPS_REG_NUM2NAME):
    MIPS_REG_NAME2NUM[name] = num

## Regular expressions for parsing the log file
# does a line.startswith() before full regex matching to speed up logfile parsing
class FasterRegex(object):
    def __init__(self, line_start, remaining):
        self.line_start = line_start
        assert self.line_start
        self.regex = re.compile('^' + line_start + remaining)

    def search(self, line):
        if not line.startswith(self.line_start):
            return None
        return self.regex.search(line)



hdigit="[0-9A-Fa-f]"
# FIXME: is this also at start of line? If so we can speed it up by using the FastRegex class
THREAD_RE=re.compile(r'======\s+Thread\s+([0-9]+)\s+======$')
MIPS_CORE_RE=FasterRegex('DEBUG MIPS COREID', r'\s+([0-9]+)$')
MIPS_REG_RE=FasterRegex('DEBUG MIPS REG', r'\s+([0-9]+)\s+(0x................)$')
MIPS_PC_RE=FasterRegex('DEBUG MIPS PC', r'\s+(0x................)$')
CAPMIPS_CORE_RE=FasterRegex('DEBUG CAP COREID', r'\s+([0-9]+)$')
CAPMIPS_PC_RE = FasterRegex('DEBUG CAP PCC', r'\s+t:([01])\s+[su]:([01]) perms:(0x'+hdigit+'+) ' +
                            r'type:(0x'+hdigit+'+) offset:(0x'+hdigit+'{16}) base:(0x'+hdigit+'{16}) length:(0x'+hdigit+'{16})$')
CAPMIPS_REG_RE = FasterRegex('DEBUG CAP REG', r'\s+([0-9]+)\s+t:([01])\s+[su]:([01]) perms:(0x'+hdigit+'+) ' +
                            r'type:(0x'+hdigit+'+) offset:(0x'+hdigit+'{16}) base:(0x'+hdigit+'{16}) length:(0x'+hdigit+'{16})$')
SAIL_CAP_PCC_RE = FasterRegex('DEBUG CAP PCC', r'\s+0b([01u]{257})$')
SAIL_CAP_REG_RE = FasterRegex('DEBUG CAP REG', r'\s+([0-9]+)\s+0b([01u]{257})$')
SAIL_CAP128_PCC_RE = FasterRegex('DEBUG CAP PCC', r'\s+0b([01u]{129})$')
SAIL_CAP128_REG_RE = FasterRegex('DEBUG CAP REG', r'\s+([0-9]+)\s+0b([01u]{129})$')
SAIL_CAP_REG_NULL_RE = FasterRegex('DEBUG CAP REG', r'\s+([0-9]+)\s+0b0\.\.\.0$')

class MipsException(Exception):
    pass


class Capability(object):
    def __init__(self, t, s, perms, ctype, offset, base, length):
        self.t      = t
        self.s      = s
        self.ctype  = ctype
        self.perms  = perms
        self.offset = offset
        self.base   = base
        self.length = length

    def __repr__(self):
        return 't:%x s:%x perms:0x%08x type:0x%06x offset:0x%016x base:0x%016x length:0x%016x'%(
            self.t, self.s, self.perms, self.ctype, self.offset, self.base, self.length)

    def __eq__(self, other):
        return self.t == other.t and self.s == other.s and \
            self.ctype == other.ctype and self.perms == other.perms and \
            self.offset == other.offset and self.base == other.base and \
            self.length == other.length

def capabilityFromStrings(t, s, perms, ctype, offset, base, length):
    return Capability(
        int(t),
        int(s),
        int(perms, 16),
        int(ctype, 16),
        int(offset, 16),
        int(base, 16),
        int(length, 16),
    )

def capabilityFromBinaryString(s):
    # sail prints capabilities as a 257 bit binary string...
    if 'u' in s:
        return None
    else:
        return Capability(
            int(s[0], 2),                 # tag
            int(s[256-192], 2),           # sealed
            int(s[256-223 : 257-193], 2), # perms
            int(s[256-247 : 257-224], 2), # otype
            int(s[256-191 : 257-128], 2), # offset
            int(s[256-127 : 257- 64], 2), # base
            int(s[256-63  : 257-  0], 2), # length
    )

def c128_atop_correction(a_mid, R, TB):
    alt = a_mid < R
    tblt = TB < R
    if alt == tblt:
        return 0
    else:
        return -1 if alt else 1

def capabilityFromBinaryString128(s):
    # sail 128 prints capabilities as a 129 bit binary string...
    if 'u' in s:
        return None
    else:
        tag   = int(s[0], 2)
        perms = s[128-127 : 129-113]
        perms_munged = perms[0:4] + (4*perms[4:5]) + perms[4:] # replicate access_system_regs
        perms = int(perms_munged, 2)
        e     = min(48, int(s[128-110 : 129-105], 2))
        sealed= int(s[128-104], 2)
        B     = int(s[128-103 : 129- 84], 2)
        T     = int(s[128-83  : 129- 64], 2)
        ptr   = int(s[128-63  : 129-  0], 2)
        # decode the raw compressed capability
        if sealed:
            otype_hi = B & 0xfff
            otype_lo = T & 0xfff
            otype = (otype_hi << 12) | otype_lo
            T = T & 0xff000
            B = B & 0xff000
        else:
            otype = 0
        R=(B - 2**12) & 0xfffff
        a_mid = (ptr >> e) & 0xfffff
        a_top = ptr >> (20+e)
        correction_t = c128_atop_correction(a_mid, R, T)
        correction_b = c128_atop_correction(a_mid, R, B)
        base = (B << e) | ((a_top + correction_b) << (20+e))
        top  = (T << e) | ((a_top + correction_t) << (20+e))
        #print "T=0x%05x B=0x%05x e=%2d otype=0x%06x\n" % (T, B, e, otype)
        #print "a_mid=0x%05x c_t=%d c_b=%d\n" % (a_mid, correction_t, correction_b)
        #print "base=0x%016x top=0x%016x" % (base, top)
        length = top - base
        return Capability(
            tag,                 # tag
            sealed,           # sealed
            perms, # perms
            otype, # otype
            ptr-base, # offset
            base, # base
            min(0xffffffffffffffff, length) , # length
    )


class ThreadStatus(object):
    '''Data object representing status of a thread (including cp2 registers if present)'''
    def __init__(self):
        self.reg_vals=[None] * len(MIPS_REG_NUM2NAME)
        self.pc=None
        self.cp2 = [None] * 32
        self.pcc = None

    def __getattr__(self, key):
        '''Return a register value by name'''
        if key.startswith("c"):
            regnum = int(key[1:])
            val = self.cp2[regnum]
            if val is None:
                raise MipsException("Attempted to read register not present or undef in log file: ", key)
            return val
        else:
            reg_num = MIPS_REG_NAME2NUM.get(key, None)
            if reg_num is None:
                raise MipsException("Not a valid register name", key)
            val = self.reg_vals[reg_num]
            if val is None:
                raise MipsException("Attempted to read register not present or undef in log file: ", key)
            return val

    def __getitem__(self, key):
        '''Return a register value by number'''
        if not type(key) is int or key < 0 or key > len(MIPS_REG_NUM2NAME):
            raise MipsException("Not a valid register number", key)
        val = self.reg_vals[key]
        if val is None:
            raise MipsException("Attempted to read register not present or undef in log file: ", key)
        return val

    # noinspection PyStringFormat
    def __repr__(self):
        v = []
        for i in range(len(self.reg_vals)):
            v.append("%3d: 0x%016x"%(i, self.reg_vals[i]))
        v.append(" PC: 0x%016x"%(self.pc))
        v.append('')
        for i in range(len(self.cp2)):
            reg_num = ("c%d"%i).rjust(3)
            v.append("%s: %s"%(reg_num, self.cp2[i]))
        v.append("PCC: %s"%(self.pcc))
        return "\n".join(v)


class MipsStatus(object):
    '''Represents the status of the MIPS CPU registers, populated by parsing
    a log file. If x is a MipsStatus object, registers can be accessed by name
    as x.<REGISTER_NAME> or number as x[<REGISTER_NUMBER>].'''
    def __init__(self, fh):
        self.fh = fh
        self.threads=defaultdict(ThreadStatus)
        self.parse_log()
        if not len(self.threads):
            raise MipsException("No reg dump found in %s"%self.fh)
        if self.pc is None:
            raise MipsException("Failed to parse PC from %s"%self.fh)

    def parse_log(self):
        '''Parse a log file and populate self.reg_vals and self.pc'''
        thread = 0
        is_sail = os.getenv("TEST_MACHINE", "").lower() == "sail"
        for line in self.fh:
            line = line.strip()
            thread_groups = THREAD_RE.search(line)
            if thread_groups:
                thread = int(thread_groups.group(1))
                continue

            # All other regexes start with "DEBUG " so skip any lines that don't
            # start with DEBUG to save time
            if not line.startswith("DEBUG "):
                continue

            # We use 'thread' for both thread id and core id.
            # This will need fixing if we ever have a CPU with both
            # multiple threads and multiple cores.
            core_groups = MIPS_CORE_RE.search(line)
            if core_groups:
                thread = int(core_groups.group(1))
                continue
            cap_core_groups = CAPMIPS_CORE_RE.search(line)
            if cap_core_groups:
                thread = int(cap_core_groups.group(1))
                continue
            reg_groups = MIPS_REG_RE.search(line)
            if reg_groups:
                reg_num = int(reg_groups.group(1))
                reg_val_hex = reg_groups.group(2)
                if 'u' in reg_val_hex:
                    # sail can produce undefined values
                    reg_val = None
                else:
                    reg_val = int(reg_val_hex, 16)
                t = self.threads[thread]
                t.reg_vals[reg_num] = reg_val
                continue
            pc_groups = MIPS_PC_RE.search(line)
            if pc_groups:
                reg_val = int(pc_groups.group(1), 16)
                t = self.threads[thread]
                t.pc = reg_val
                continue
            cap_reg_groups = CAPMIPS_REG_RE.search(line)
            if cap_reg_groups:
                cap_reg_num = int(cap_reg_groups.group(1))
                t = self.threads[thread]
                t.cp2[cap_reg_num] = capabilityFromStrings(*cap_reg_groups.groups()[1:8])
                continue
            cap_pc_groups = CAPMIPS_PC_RE.search(line)
            if cap_pc_groups:
                t = self.threads[thread]
                t.pcc = capabilityFromStrings(*cap_pc_groups.groups()[0:7])
                continue

            if not is_sail:
                continue  # the following regexes are only interesting for SAIL

            sail_cap_pcc_groups = SAIL_CAP_PCC_RE.search(line)

            if sail_cap_pcc_groups:
                pcc_string = sail_cap_pcc_groups.group(1)
                t = self.threads[thread]
                t.pcc = capabilityFromBinaryString(pcc_string)
                continue
            sail_cap_reg_groups = SAIL_CAP_REG_RE.search(line)
            if sail_cap_reg_groups:
                cap_reg_num = int(sail_cap_reg_groups.group(1))
                cap_string = sail_cap_reg_groups.group(2)
                t = self.threads[thread]
                t.cp2[cap_reg_num] = capabilityFromBinaryString(cap_string)
                continue
            sail_cap_reg_null_groups = SAIL_CAP_REG_NULL_RE.search(line)
            if sail_cap_reg_null_groups:
                # special case for null cap due to fact that sail abreviates printed cap with '...'. Arg.
                cap_reg_num = int(sail_cap_reg_null_groups.group(1))
                t = self.threads[thread]
                t.cp2[cap_reg_num] = Capability(0,0,0,0,0,0,0)
                continue
            sail_cap128_pcc_groups = SAIL_CAP128_PCC_RE.search(line)
            if sail_cap128_pcc_groups:
                pcc_string = sail_cap128_pcc_groups.group(1)
                t = self.threads[thread]
                t.pcc = capabilityFromBinaryString128(pcc_string)
                continue
            sail_cap128_reg_groups = SAIL_CAP128_REG_RE.search(line)
            if sail_cap128_reg_groups:
                cap_reg_num = int(sail_cap128_reg_groups.group(1))
                cap_string = sail_cap128_reg_groups.group(2)
                t = self.threads[thread]
                t.cp2[cap_reg_num] = capabilityFromBinaryString128(cap_string)
                continue

    def __getattr__(self, key):
        '''Return a register value by name. For backwards compatibility this defaults to thread zero.'''
        return getattr(self.threads[0], key)

    def __getitem__(self, key):
        '''Return a register value by number. For backwards compatibility this defaults to thread zero.'''
        return self.threads[0][key]

    def __repr__(self):
        v = []
        for i, t in self.threads.items():
            v.append("======  Thread %3d  ======" % i)
            v.append(t.__repr__())
        return "\n".join(v)

    class Cause(object):
        AdEL = 4
        AdES = 5
        IBUS = 6
        DBUS = 7
        SYSCALL = 8
        BREAK = 8
        ReservedInstruction = 10
        OVERFLOW = 12
        TRAP = 13
        FPE = 15
        COP2 = 18

    # See "Table 4.2: Capability Exception Codes" in the CHERI reference
    class CapCause(object):
        NONE = 0x00
        Length_Violation = 0x01
        Tag_Violation = 0x02
        Seal_Violation = 0x03
        Type_Violation = 0x04
        Call_Trap = 0x05
        Return_Trap = 0x06
        Trusted_Stack_Underflow = 0x07
        User_Permission_Violation = 0x08
        TLB_Store_Capability_Violation = 0x09
        Bounds_Not_Exactly_Representable = 0x0a
        # reserved = 0x0b
        # reserved = 0x0c
        # reserved = 0x0d
        # reserved = 0x0e
        # reserved = 0x0f
        Global_Violation = 0x10
        Permit_Execute_Violation = 0x11
        Permit_Load_Violation = 0x12
        Permit_Store_Violation = 0x13
        Permit_Load_Capability_Violation = 0x14
        Permit_Store_Capability_Violation = 0x15
        Permit_Store_Local_Capability_Violation = 0x16
        Permit_Seal_Violation = 0x17
        Access_System_Registers_Violation = 0x18
        Permit_CCall_Violation = 0x19
        Access_CCall_IDC_Violation = 0x1a
        Permit_Unseal_Violation = 0x1b
        # reserved = 0x1c
        # reserved = 0x1d
        # reserved = 0x1e
        # reserved = 0x1f


MIPS_ICACHE_TAG_RE=FasterRegex('DEBUG ICACHE TAG ENTRY', r'\s*([0-9]+) Valid=([01]) Tag value=([0-9a-fA-F]+)$')

class ICacheException(Exception):
    pass

class ICacheTag(object):
    def __init__(self, index, valid, value):
        self.index = int(index)
        self.valid = (valid == '1')
        self.value = int(value,16)

    def __repr__(self):
        return 'idx:%3d valid:%r value:0x%x'%(self.index, self.valid, self.value)

class ICacheStatus(object):
    '''Represents the status of the Instruction Cache, populated by parsing
    a log file. If x is a ICacheStatus object, tags can be accessed by name
    as x.[TAG_INDEX].'''
    def __init__(self, fh):
        self.fh = fh
        self.start_pos = self.fh.tell()
        self.icache_tags = [None] * 512
        self.parse_log()
        for i in range(512):
            if self.icache_tags[i] is None:
                raise ICacheException("Failed to parse icache tag %d from %s"%(i,self.fh))

    def parse_log(self):
        '''Parse a log file and populate self.icache_tags'''
        for line in self.fh:
            line = line.strip()
            icache_groups = MIPS_ICACHE_TAG_RE.search(line)
            if (icache_groups):
                tag_idx = int(icache_groups.group(1))
                self.icache_tags[tag_idx] = ICacheTag(*icache_groups.groups()[0:3])

    def __getitem__(self, key):
        '''Return a tag by index'''
        if not type(key) is int or key < 0 or key > 511:
            raise ICacheException("Not a valid tag index", key)
        return self.icache_tags[key]

    def __repr__(self):
        v = []
        for i in range(len(self.icache_tags)):
            v.append("%r\n"%(self.icache_tags[i]))
        return "\n".join(v)
