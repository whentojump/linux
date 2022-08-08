// SPDX-License-Identifier: GPL-2.0
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

// Ref: https://pchaigno.github.io/ebpf/2021/03/22/cost-bpf-tail-calls.html
struct bpf_map_def SEC("maps") progs = {
	.type = BPF_MAP_TYPE_PROG_ARRAY,
	.key_size = sizeof(__u32),
	.value_size = sizeof(__u32),
	.max_entries = 34,
};

// TODO program type, entry prototype
// TODO how does this end?
#define PROG(X) SEC("tracepoint/syscalls/sys_enter_dup")                                          \
int bpf_prog ## X(void *ctx) {                                                 \
	bpf_tail_call(ctx, &progs, X+1);                                       \
	return 0;                                                              \
}

char _license[] SEC("license") = "GPL";

PROG(1)
PROG(2)
PROG(3)
PROG(4)
PROG(5)
PROG(6)
PROG(7)
PROG(8)
PROG(9)
PROG(10)
PROG(11)
PROG(12)
PROG(13)
PROG(14)
PROG(15)
PROG(16)
PROG(17)
PROG(18)
PROG(19)
PROG(20)
PROG(21)
PROG(22)
PROG(23)
PROG(24)
PROG(25)
PROG(26)
PROG(27)
PROG(28)
PROG(29)
PROG(30)
PROG(31)
PROG(32)
PROG(33)
