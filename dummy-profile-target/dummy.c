#include <linux/kernel.h>
#include <linux/syscalls.h>

SYSCALL_DEFINE1(dummy, long, in)
{
	long out;

	switch (in) {
	case 1:
		out = 123;
		break;
	case 2:
		out = 456;
		break;
	default:
		out = 789;
	}

	return out;
}
