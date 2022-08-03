#!/bin/bash

prog_num=$( cat program_name.txt | wc -l )

any_failure=no

for prog_name in $( cat program_name.txt )
do
    echo $prog_name
    ./user autogen/$prog_name || any_failure=yes
done

echo
echo "//////////////// Summary ///////////////"

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
echo "--------------------"
echo "For now we are not really doing the calculation or estimation. So this is"
echo "basically nonsense."
echo "-------------------------------------------------------------------------"

cat program_size.txt

echo
echo "Real program size"
echo "-----------------"

for prog_name in $( cat program_name.txt )
do
    llvm-objdump -d  autogen/$prog_name                                       |\
        tail     -n  1                                                        |\
        cut      -d ':' -f 1                                                  |\
        tr       -d ' '
done

echo
echo "CPU cycles"
echo "----------"

dmesg                                                                         |\
    grep   't_delta'                                                          |\
    tail -n $prog_num                                                         |\
    cut  -c 25-
