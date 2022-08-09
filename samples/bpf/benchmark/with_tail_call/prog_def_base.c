SEC("tracepoint/syscalls/sys_enter_dup")
int bpf_prog_9999(void *ctx) {
	char msg[] = "ret = 0x%llx\n";
	u64 ret;
	#include "workload_one_call.c"
	bpf_tail_call(ctx, &progs, 9999+1);
	return 0;
}
