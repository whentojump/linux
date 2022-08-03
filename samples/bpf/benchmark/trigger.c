/*
    This user program becomes less useful when the _trigger_ step has been
    incorporated in the same program as _load_ and _attach_: we expect it to be
    a single program that can be easily run (and stoped) repeatedly during
    tests.

    We keep this file though, in case sometime it can still be used to test
    certain things.
*/
#include <unistd.h>
#include <sys/syscall.h>

/*
	TODO
	How do we make sure we are using header files from _this_
	source tree?
*/

int main(void)
{
	return syscall(__NR_dup, 1);
}
