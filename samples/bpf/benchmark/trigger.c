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
