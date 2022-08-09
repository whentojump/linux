// SPDX-License-Identifier: GPL-2.0-only
/* Copyright (c) 2016 Facebook
 */
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <stdlib.h>
#include <linux/perf_event.h>
#include <bpf/libbpf.h>
#include <fcntl.h>
#include "perf-sys.h"

#define PROG_NAME "bpf_prog1"

struct bpf_program *prog;

static void attach(void) {
	int trace_id_fd;
	char config_str[256];
	struct perf_event_attr p_attr;
	int perf_event_fd;

	trace_id_fd = openat(AT_FDCWD,
		"/sys/kernel/debug/tracing/events/syscalls/sys_enter_dup/id", O_RDONLY);
	if (read(trace_id_fd, config_str, 256) < 0)
		/* error handling */;
	close(trace_id_fd);

	memset(&p_attr, 0, sizeof(p_attr));
	p_attr.type = PERF_TYPE_TRACEPOINT;
	p_attr.size = PERF_ATTR_SIZE_VER5;
	p_attr.config = atoi(config_str);

	perf_event_fd = sys_perf_event_open(&p_attr, -1, 0, -1, PERF_FLAG_FD_CLOEXEC);

	bpf_program__attach_perf_event(prog, perf_event_fd);
}

/*
	TODO
	What is perf and trace exactly? Looks like tracepoint is a subset of
	perf?

	Why the hello examples on the Internet don't have the attach step?
	because of older kernel versions?
	
	Why other examples specify syscall through SEC name of the BPF program?
	while here we manually craft a perf_event_attr struct?

	Kernel sample:
	attach_perf_event(program_struct, perf_event_fd) which involves ioctl(),
	there is also an attach() routine

	IU example:
	directly ioctl(perf_event_fd, prog_fd)
*/

// static void show(void) {
// 	/* the kernel tree version */
// 	/* somehow this is a one-shot print */
// 	/* TODO what is the mechanism of trace_pipe "file"? */

// 	// read_trace_pipe();

// 	/* IU version */
// 	/* this won't exit so the user program should be put into the bg */

// 	int trace_pipe_fd;
// 	char c;

// 	trace_pipe_fd = openat(AT_FDCWD,
// 		"/sys/kernel/debug/tracing/trace_pipe", O_RDONLY);
// 	for (;;) {
// 		if (read(trace_pipe_fd, &c, 1) == 1)
// 		putchar(c);
// 	}
// }

static void trigger(void) {
	syscall(__NR_dup, 1);
}

int main(int argc, char **argv)
{
	struct bpf_object *obj = NULL;

	if (argc != 2) {
		printf("                                                        \n");
		printf("Please provide the filename of BPF program. For example:\n");
		printf("                                                        \n");
		printf("  %s autogen/kern_01.o\n", argv[0]);
		printf("                                                        \n");
		return -1;
	}

	// TODO better error handling
	obj = bpf_object__open_file(argv[1], NULL); // what will be loaded
	prog = bpf_object__find_program_by_name(obj, PROG_NAME); // used in attach()
	if (bpf_object__load(obj)) return 1;

	attach();
	trigger();
	// show();
}
