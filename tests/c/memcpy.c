/*-
 * Copyright (c) 1990, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * This code is derived from software contributed to Berkeley by
 * Chris Torek.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

/*
 * sizeof(word) MUST BE A POWER OF TWO
 * SO THAT wmask BELOW IS ALL ONES
 */
typedef	long word;		/* "word" used for medium copy speed */

#define	wsize	sizeof(word)
#define	wmask	(wsize - 1)

/* "pointer" used for optimal copy speed when pointers are large */
#ifdef __CHERI__
typedef	__uintcap_t ptr;
#  define __CAP __capability
#else
# define __CAP
typedef	uintptr_t ptr;
#endif

#define	psize	sizeof(ptr)
#define	pmask	(psize - 1)
#define bigptr	(psize>wsize)


#define MEMCOPY
/*
 * Copy a block of memory, handling overlap.
 * This is the routine that actually implements
 * (the portable versions of) bcopy, memcpy, and memmove.
 */

#ifdef BUILD_MEMCPY_C
void * __CAP 
memcpy_c(void * __CAP dst0, const void * __CAP src0, size_t length)
#elif defined(MEMMOVE)
void *
memmove
(void *dst0, const void *src0, size_t length)
#elif defined(MEMCOPY)
void *
memcpy
(void *dst0, const void *src0, size_t length)
#else
void
bcopy(const void *src0, void *dst0, size_t length)
#endif
{
	char * __CAP dst = (char * __CAP)dst0;
	const char * __CAP src = (const char * __CAP)src0;
	size_t t;
	
#ifdef BUILD_MEMCPY_C
	const int handle_overlap = 0;
#elif defined(MEMCOPY)
	const int handle_overlap = 0;
#else
	const int handle_overlap = 1;
#endif

	if (length == 0 || dst == src)		/* nothing to do */
		goto done;

	/*
	 * Macros: loop-t-times; and loop-t-times, t>0
	 */
#define	TLOOP(s) if (t) TLOOP1(s)
#define	TLOOP1(s) do { s; } while (--t)

  /*
   * Comparing pointers is not good C practice, but this should use our CPtrCmp
   * instruction.  XXX Is there a way to do the right thing type-wise and still
   * get the efficient instruction?
   */
	if (dst < src || !handle_overlap) {
		/*
		 * Copy forward.
		 */
		t = (int)src;	/* only need low bits */
		if ((t | (int)dst) & wmask) {
			/*
			 * Try to align operands.  This cannot be done
			 * unless the low bits match.
			 */
			if ((t ^ (int)dst) & wmask || length < wsize)
				t = length;
			else
				t = wsize - (t & wmask);
			length -= t;
			dst += t;
			src += t;
			TLOOP1(dst[-t] = src[-t]);
		}
		/*
		 * If pointers are bigger than words, try to copy by words.
		 */
		if (bigptr) {
			t = (int)src;	/* only need low bits */
			if ((t | (int)dst) & pmask) {
				/*
				 * Try to align operands.  This cannot be done
				 * unless the low bits match.
				 */
				if ((t ^ (int)dst) & pmask || length < psize)
					t = length / wsize;
				else
					t = (psize - (t & pmask)) / wsize;
				length -= t*wsize;
				dst += t*wsize;
				src += t*wsize;
				TLOOP(((word * __CAP)dst)[-t] = ((word * __CAP)src)[-t];);
			}
		}
		/*
		 * Copy whole words, then mop up any trailing bytes.
		 */
		t = length / psize;
		src += t*psize;
		dst += t*psize;
		TLOOP(((ptr * __CAP)dst)[-t] = ((ptr * __CAP)src)[-t];);
		t = length & pmask;
		//TLOOP(*dst++ = *src++);
		TLOOP(dst[-t] = src[-t]);
	}	else {
		/*
		 * Copy backwards.  Otherwise essentially the same.
		 * Alignment works as before, except that it takes
		 * (t&wmask) bytes to align, not wsize-(t&wmask).
		 */
		src += length;
		dst += length;
		t = (int)src;
		if ((t | (int)dst) & wmask) {
			if ((t ^ (int)dst) & wmask || length <= wsize)
				t = length;
			else
				t &= wmask;
			length -= t;
			dst -= t;
			src -= t;
			TLOOP1(dst[t] = src[t]);
		}
		if (bigptr) {
			t = (int)src;	/* only need low bits */
			if ((t | (int)dst) & pmask) {
				if ((t ^ (int)dst) & pmask || length < psize)
					t = length / wsize;
				else
					t = (psize - (t & pmask)) / wsize;
				length -= t*wsize;
				dst -= t;
			  src -= t;
				TLOOP(((word * __CAP)dst)[t] = ((word * __CAP)src)[t];);
			}
		}
		t = length / psize;
		src -= t*psize;
		dst -= t*psize;
		TLOOP(((ptr * __CAP)dst)[t] = ((ptr * __CAP)src)[t];);
		t = length & pmask;
		//TLOOP(*--dst = *--src);
		TLOOP(dst[-t] = src[-t]);
	}
done:
#if defined(MEMCOPY) || defined(MEMMOVE)
	return (dst0);
#else
	return;
#endif
}
