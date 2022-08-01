CC = clang
MAKE = make
LINUX_SRC_TREE_ROOT = $(realpath $(CURDIR)/../../..)
LINUX_SRC_TREE_BPF_SAMPLES = $(realpath $(LINUX_SRC_TREE_ROOT)/samples/bpf)

all: trigger bpf-samples

bpf-samples:
	$(MAKE) -C $(LINUX_SRC_TREE_ROOT) M=$(LINUX_SRC_TREE_BPF_SAMPLES) BPF_SAMPLES_PATH=$(LINUX_SRC_TREE_BPF_SAMPLES)

trigger: trigger.c
	$(CC) $^ -o $@

clean:
	rm -vf trigger
	$(MAKE) -C $(LINUX_SRC_TREE_ROOT) M=$(LINUX_SRC_TREE_BPF_SAMPLES) clean
	@find $(LINUX_SRC_TREE_BPF_SAMPLES) -type f -name '*~' -delete
