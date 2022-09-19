## Get started

The following instructions assume directory hierarchy of `~/inner_unikernels/` and `~/linux/`.

```shell
# First, build the kernel. Detailed steps are not elaborated here.
# ...

# Build the benchmark programs

cd ~/linux/samples/bpf/benchmark/without_tail_call/
# This script creates autogen/program_name.txt and autogen/program_size.txt.
# See the next section for instructions for customization.
./generate_prog_list.sh
# Build the user program and BPF programs.
# Took too long? See the next section.
make clean; make

# Boot the VM

cd ~/linux/
~/inner_unikernels/q-script/yifei-q

# Inside the guest, run the tests.

cd ~/linux/samples/bpf/benchmark/without_tail_call/
./measure.sh
```

Example output:

```
//////////////////////////// Summary ///////////////////////////

!!!WARNING!!!
Looks one or more of the programs have failed, possibly because of
the limit of BPF program size. This script does NOT yet handle such
cases well, and please treat the following report carefully. Some
manual adjustments might be needed.

Relative program size
=====================
Unit: how many times to repeat the base workload.
-------------------------------------------------------------------------
100000
200000
300000
400000
500000
600000
700000
800000
900000
1000000

Actual program size
===================
Unit: number of assembly instructions, measured through tools like
`llvm-objdump' and `bpftool'.
-------------------------------------------------------------------------
100001
200001
300001
400001
500001
600001
700001
800001
900001
1000001

CPU cycles
==========
975542
1944581
2862417
3963880
5220014
5933620
6764664
7954736
8765898
```

Plot of the results:

(Unfortunately, we don't have scripts to automate this step. You have to copy the above columns into your favorite app like `*Office`, and draw the figure in app-dependent ways.)

![plot.png](plot.png)

If it took too long to build the BPF programs, you have two options:

1. Test with programs of smaller size
2. Use prebuilt object files

## Customize the BPF programs under test

One can test their desired portion within the whole segment, with custom range, granularity and number of samples. This is achieved by providing extra arguments to `./generate_prog_list.sh`, which inturn will change `autogen/program_name.txt` and `autogen/program_size.txt` before actually building the programs.

Usage:

```
Specify the size of BPF programs to generate. Unit: how many times to repeat the
base workload.

Usage: use default size (seq 100000 100000 1000000)

       ./generate_prog_list.sh

       the script also accepts argument(s) in the same format as seq(1)

       ./generate_prog_list.sh LAST
       ./generate_prog_list.sh FIRST LAST
       ./generate_prog_list.sh FIRST INCREMENT LAST

       remove generated files

       ./generate_prog_list.sh clean
```

For example:

To draw the first 1/100 of the upper limit:

```shell
./generate_prog_list.sh 1000 1000 10000
```

To include totally 20 samples:

```shell
./generate_prog_list.sh 1000 1000 20000
```

To revert to the default:

```shell
./generate_prog_list.sh 100000 100000 1000000
```

## Use prebuilt object files

```shell
cd ~/linux/samples/bpf/benchmark/without_tail_call/
make clean

wget https://github.com/whentojump/linux/releases/download/dummy/bpf_without_tail_call.tar.gz
tar zxvf bpf_without_tail_call.tar.gz
cp bpf_without_tail_call/* autogen/
rm -r bpf_without_tail_call bpf_without_tail_call.tar.gz

make use_prebuilt_object_files
```
