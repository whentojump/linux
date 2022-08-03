#!/bin/bash

prog_num=$( cat program_list.txt | wc -l )

for prog in $( cat program_list.txt )
do
    echo $prog
    ./user autogen/$prog
done

echo
echo "//////////////// Summary ///////////////"
echo
echo "Nominal (estimated) program size"
echo "--------------------------------"

for prog in $( cat program_list.txt )
do
    sed -e 's/.o//' -e 's/kern_//' <<< $prog
done

echo
echo "Real program size"
echo "-----------------"

for prog in $( cat program_list.txt )
do
    llvm-objdump -d  autogen/$prog                                            |\
        tail     -n  1                                                        |\
        cut      -d ':' -f 1                                                  |\
        tr       -d ' '
done

echo
echo "Time"
echo "----"

dmesg                                                                         |\
    grep   't_delta'                                                          |\
    tail -n $prog_num                                                         |\
    cut  -c 25-
