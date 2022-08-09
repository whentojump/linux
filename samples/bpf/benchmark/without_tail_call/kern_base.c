// SPDX-License-Identifier: GPL-2.0
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

char _license[] SEC("license") = "GPL";

SEC("tracepoint/syscalls/sys_enter_dup")
                // TODO choose a proper program type: 1. section name
int bpf_prog1() //                                    2. entry prototype
{
	/* buggy */
	/* the higher 4B will not be zeroed? */

	// char msg[] = "pid = 0x%lx\n";
	// u32 pid = (bpf_get_current_pid_tgid() & 0xFFFFFFFFULL);
	// bpf_trace_printk(msg, sizeof(msg), pid);

	char msg[] = "ret = 0x%llx\n";
	u64 ret;

	#include "workload_base.c"

	return 0;
}
