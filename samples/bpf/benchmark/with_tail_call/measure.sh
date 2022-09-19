#!/bin/bash

prog_num=$( cat autogen/program_name.txt | wc -l )

any_failure=no

for prog_name in $( cat autogen/program_name.txt )
do
    echo $prog_name
    ./user autogen/$prog_name || any_failure=yes
done

echo
echo "//////////////////////////// Summary ///////////////////////////"

if [[ $any_failure == yes ]]; then
    echo
    echo "!!!WARNING!!!"
    echo "Looks one or more of the programs have failed, possibly because of"
    echo "the limit of BPF program size. This script does NOT yet handle such"
    echo "cases well, and please treat the following report carefully. Some"
    echo "manual adjustments might be needed."
fi

echo
echo "Size of a single tail call"
echo "=========================="
echo "Unit: how many times to repeat the base workload."
echo "-------------------------------------------------------------------------"

one_call_size=$( tail -n 1 autogen/program_size.txt )
echo $one_call_size

echo
echo "Number of tail calls"
echo "===================="

head -n -1 autogen/program_size.txt

echo
echo "Relative program size"
echo "====================="
echo "Unit: how many times to repeat the base workload."
echo "-------------------------------------------------------------------------"

for call_num in $( head -n -1 autogen/program_size.txt )
do
    bc <<< "$one_call_size * $call_num"
done

echo
echo "Actual program size"
echo "==================="
echo "Unit: number of assembly instructions, measured through tools like"
echo "\`llvm-objdump' and \`bpftool'."
echo "-------------------------------------------------------------------------"

for prog_name in $( cat autogen/program_name.txt )
do
    llvm-objdump -d  autogen/$prog_name                                       |\
        tail     -n  1                                                        |\
        cut      -d ':' -f 1                                                  |\
        tr       -d ' '
done

echo
echo "CPU cycles"
echo "=========="

dmesg                                                                         |\
    grep   't_delta'                                                          |\
    tail -n $prog_num                                                         |\
    cut  -c 25-
