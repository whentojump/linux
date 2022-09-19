## Get started

The following instructions assume directory hierarchy of `~/inner_unikernels/` and `~/linux/`.

```shell
# First, build the kernel. Detailed steps are not elaborated here.
# ...

# Build the benchmark programs

cd ~/linux/samples/bpf/benchmark/with_tail_call/
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

cd ~/linux/samples/bpf/benchmark/with_tail_call/
./measure.sh
```

Example output:

```
//////////////////////////// Summary ///////////////////////////

Size of a single tail call
==========================
Unit: how many times to repeat the base workload.
-------------------------------------------------------------------------
100000

Number of tail calls
====================
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20

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
1100000
1200000
1300000
1400000
1500000
1600000
1700000
1800000
1900000
2000000

Actual program size
===================
Unit: number of assembly instructions, measured through tools like
`llvm-objdump' and `bpftool'.
-------------------------------------------------------------------------
100007
200015
300023
400031
500039
600047
700055
800063
900071
1000079
1100087
1200095
1300103
1400111
1500119
1600127
1700135
1800143
1900151
2000159

CPU cycles
==========
1004205
2126470
3281615
4528513
5626115
6875193
7859945
8921442
9951184
11186578
12336124
13339547
14076688
15533656
16744719
17924336
18759150
19820298
21189313
21743488
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
Specify the size of BPF programs to generate.

Usage: ./generate_prog_list.sh ONE_CALL_SIZE CALL_NUM

       ONE_CALL_SIZE    size of a single tail call. unit: how many times to
                        repeat the base workload.

       CALL_NUM      := [ LAST | FIRST LAST | FIRST INCREMENT LAST ]
                        i.e. the same argument format as seq(1)


       use default size (100000 1 1 20)

       ./generate_prog_list.sh


       remove generated files

       ./generate_prog_list.sh clean
```

For example:

To let one tail call do 1/10 of the default workload:

```shell
./generate_prog_list.sh 10000  1 1 20
```

To include only the first 10 samples:

```shell
./generate_prog_list.sh 100000 1 1 10
```

To revert to the default:

```shell
./generate_prog_list.sh 100000 1 1 20
```

## Use prebuilt object files

```shell
cd ~/linux/samples/bpf/benchmark/with_tail_call/
make clean

wget https://github.com/whentojump/linux/releases/download/dummy/bpf_with_tail_call.tar.gz
tar zxvf bpf_with_tail_call.tar.gz
cp bpf_with_tail_call/* autogen/
rm -r bpf_with_tail_call bpf_with_tail_call.tar.gz

make use_prebuilt_object_files
```
