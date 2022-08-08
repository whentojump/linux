CC = clang
MAKE = make

LINUX_SRC_TREE_ROOT = $(realpath $(CURDIR)/../../..)
LINUX_SRC_TREE_BPF_SAMPLES = $(realpath $(LINUX_SRC_TREE_ROOT)/samples/bpf)

BPF_PROGS = $(addprefix autogen/, $(shell cat autogen/program_name.txt))
BPF_PROG_SRC_FILES = $(addsuffix .c, $(basename $(BPF_PROGS)))

all: compile_bpf_samples

.INTERMEDIATE: generate_program_source

$(BPF_PROG_SRC_FILES): generate_program_source ;

generate_program_source: kern_base.c workload_base.c autogen/program_name.txt autogen/program_size.txt
	./generate_prog_src.sh $^

# "call" into the Makefile of source tree root
compile_bpf_samples: $(BPF_PROG_SRC_FILES)
	$(MAKE) -C $(LINUX_SRC_TREE_ROOT) M=$(LINUX_SRC_TREE_BPF_SAMPLES) BPF_SAMPLES_PATH=$(LINUX_SRC_TREE_BPF_SAMPLES)

clean:
	rm -vf autogen/kern_*.c
	rm -vf autogen/workload_*.c
	$(MAKE) -C $(LINUX_SRC_TREE_ROOT) M=$(LINUX_SRC_TREE_BPF_SAMPLES) clean
	@find $(LINUX_SRC_TREE_BPF_SAMPLES) -type f -name '*~' -delete
