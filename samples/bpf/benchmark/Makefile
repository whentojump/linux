CC = clang
MAKE = make

LINUX_SRC_TREE_ROOT = $(realpath $(CURDIR)/../../..)
LINUX_SRC_TREE_BPF_SAMPLES = $(realpath $(LINUX_SRC_TREE_ROOT)/samples/bpf)

BPF_PROGS = $(shell cat program_list.txt)
BPF_PROG_SRC_FILES = $(addsuffix .c, $(basename $(BPF_PROGS)))

all: trigger compile_bpf_samples

generate_bpf_prog_src_files: kern_base.c
	./generate_prog.sh $^

# "call" into the Makefile of source tree root
compile_bpf_samples: generate_bpf_prog_src_files
	$(MAKE) -C $(LINUX_SRC_TREE_ROOT) M=$(LINUX_SRC_TREE_BPF_SAMPLES) BPF_SAMPLES_PATH=$(LINUX_SRC_TREE_BPF_SAMPLES)

trigger: trigger.c
	$(CC) $^ -o $@

clean:
	rm -vf trigger
	rm -vf $(BPF_PROG_SRC_FILES)
	$(MAKE) -C $(LINUX_SRC_TREE_ROOT) M=$(LINUX_SRC_TREE_BPF_SAMPLES) clean
	@find $(LINUX_SRC_TREE_BPF_SAMPLES) -type f -name '*~' -delete
