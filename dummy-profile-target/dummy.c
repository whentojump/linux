#include <linux/kernel.h>
#include <linux/syscalls.h>

#define FOO(x) (x & 0xbeefdeadL)

SYSCALL_DEFINE1(dummy, long, in)
{
        long out;

        if ((in & ~0xdeadbeefL) && FOO(in)) {
                in++;
                in--;
        }

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

        if (out < 500 && out > 400) {
                out++;
                out--;
        }

        return out;
}
