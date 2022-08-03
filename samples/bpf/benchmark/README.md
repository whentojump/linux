## Get started

The following instructions assume directory hierarchy of `~/inner_unikernels/` and `~/linux/`.

```shell
# First, build the kernel. Detailed steps are not elaborated here.
# ...

# Build the benchmark programs
cd ~/linux/samples/bpf/benchmark
make clean; make # Took too long? See the next section.

# Boot the VM
cd ~/linux
~/inner_unikernels/q-script/yifei-q

# Inside the guest, run the tests.
cd ~/linux/samples/bpf/benchmark/
./measure.sh
```

Example output:

```
//////////////// Summary ///////////////

!!!WARNING!!!
Looks one or more of the programs have failed, possibly because of
the limit of BPF program size. This script does NOT yet handle such
cases well, and please treat the following report carefully. Some
manual adjustments might be needed.

Nominal program size
--------------------
For now we are not really doing the calculation or estimation. So this is
basically nonsense.
-------------------------------------------------------------------------
40000
80000
120000
160000
200000
240000
280000
320000
360000
400000

Real program size
-----------------
100010
200010
300010
400010
500010
600010
700010
800010
900010
1000010

CPU cycles
----------
6429084
13321129
19634354
31091538
32524178
39286781
44947729
51403839
59768029
```

## What if it took too long to build the benchmark

One can also test their desired portion within the whole segment, with custom range, granularity and number of samples. This is achieved by changing `program_name.txt` and `program_size.txt` before actually building them. For example:

To draw the first 1/10 of the upper limit:

```shell
seq 1000 1000 10000 > program_size.txt
```

To include totally 20 samples:

```shell
seq 1000 1000 20000 > program_size.txt
# Always run the following after the number of samples has been changed, to sync the two files.
rm -vf program_name.txt
for i in $( seq $( cat program_size.txt | wc -l ) )
do
    printf "kern_%02d.o\n" $i >> program_name.txt
done
```

To revert to the default:

```shell
seq 100000 100000 1000000 > program_size.txt
# Always run the following after the number of samples has been changed, to sync the two files.
rm -vf program_name.txt
for i in $( seq $( cat program_size.txt | wc -l ) )
do
    printf "kern_%02d.o\n" $i >> program_name.txt
done
```

TODO prebuilt object files
