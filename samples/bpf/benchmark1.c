// SPDX-License-Identifier: GPL-2.0
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

char _license[] SEC("license") = "GPL";

SEC("tracepoint/syscalls/sys_enter_dup")
                // TODO choose a proper program type: 1. section name
int bpf_prog1() //                                    2. entry prototype
{
	char msg[] = "hello bpf\n";
	bpf_trace_printk(msg, sizeof(msg));
	return 0;
}
