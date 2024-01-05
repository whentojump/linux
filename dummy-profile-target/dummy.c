#include <linux/kernel.h>
#include <linux/syscalls.h>

static long one(void) { return 1L; }
static long two(void) { return 2L; }
static long identity(long in) { long out = in; return out; }

SYSCALL_DEFINE0(dummy)
{
	printk("a dummy syscall\n");
	return one() + two() + identity(3);
}
