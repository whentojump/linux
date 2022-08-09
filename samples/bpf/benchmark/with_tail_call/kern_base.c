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

// TODO Program type, entry prototype
//
//      Looks for tail calls to work, we will have to load *all* the programs,
//      populate fd's into the map, and *only* attach and trigger the first
//      program.
//
//      Btw, what is section name used for? We have been manually attaching
//      programs to perf events, which involve trace id of syscalls. Section
//      name is used by libbpf etc to automatically infer such things?

// TODO How does this end?
//
//      The last program attempts to issue a tail call that does not exist in
//      the program array. It then "falls through" and returns back to the
//      caller in filter.h.

#define PROG(X) SEC("tracepoint/syscalls/sys_enter_dup")                       \
int bpf_prog ## X(void *ctx) {                                                 \
	char msg[] = "ret = 0x%llx\n";                                         \
	u64 ret;                                                               \
	#include "workload_one_call.c"                                         \
	bpf_tail_call(ctx, &progs, X+1);                                       \
	return 0;                                                              \
}

char _license[] SEC("license") = "GPL";

#include "prog_def.c"
