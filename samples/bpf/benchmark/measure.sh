#!/bin/bash

prog_num=$( cat program_name.txt | wc -l )

any_failure=no

for prog_name in $( cat program_name.txt )
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
echo "Nominal program size"
echo "===================="
echo "By \"nominal\", we mean we start from this value, estimate how many lines"
echo "of C code there should be, and then generate the program. The obtained"
echo "BPF assembly may have a slightly different size."
echo "-------------------------------------------------------------------------"

cat program_size.txt

echo
echo "Real program size"
echo "================="
echo "By \"real\", we mean this is the actual size of obtained BPF programs,"
echo "measured through tools like \`llvm-objdump' and \`bpftool'."
echo "-------------------------------------------------------------------------"

for prog_name in $( cat program_name.txt )
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
