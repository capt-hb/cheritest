#include "../c/assert.h"

// compatibility with what the cheri-c-tests expect
#define faults exception_count

typedef __UINT64_TYPE__ __uint64_t;
typedef __INT64_TYPE__ __int64_t;
typedef __SIZE_TYPE__ size_t;

#ifndef TEST_EXPECTED_FAULTS
#define TEST_EXPECTED_FAULTS 0
#endif

extern volatile __int64_t continue_after_exception;

// Add a dummy reference to default_trap_handler here to define the alias
#define SET_TRAP_HANDLER \
	__asm__(".text\n\t" \
		".global default_trap_handler\n\t" \
		".ent default_trap_handler\n\t" \
		"default_trap_handler:\n\t" \
		"b exception_count_handler\n\t" \
		"nop\n\t" \
		".end default_trap_handler\n\t"); \


#define BEGIN_TEST(name)					\
	SET_TRAP_HANDLER					\
	int test(void) {					\
		continue_after_exception = TEST_EXPECTED_FAULTS;

#define END_TEST 						\
	assert_eq(exception_count, TEST_EXPECTED_FAULTS);	\
	return 0;						\
}
#define END_TEST2(retval)					\
	assert_eq(exception_count, TEST_EXPECTED_FAULTS);	\
	return (retval);					\
}

/* Allow some of the tests to continue after an exception: */


#define ASSERT_HAS_PERMISSION(x, perm) \
	assert_eq((__builtin_cheri_perms_get((void*)x) & __CHERI_CAP_PERMISSION_PERMIT_ ## perm ## __), __CHERI_CAP_PERMISSION_PERMIT_ ## perm ## __)

#define ASSERT_HAS_NOT_PERMISSION(x, perm) \
	assert_eq((__builtin_cheri_perms_get((void*)x) & __CHERI_CAP_PERMISSION_PERMIT_ ## perm ## __), 0)




#ifdef INCLUDE_XFAIL
#define XFAIL(x) assert(x)
#else
#define XFAIL(x) do {} while(0)
#endif
