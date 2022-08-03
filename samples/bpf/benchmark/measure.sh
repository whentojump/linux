#!/bin/bash

prog_num=$( cat program_list.txt | wc -l )

for prog in $( cat program_list.txt )
do
    echo $prog
    ./user autogen/$prog
done

echo "/////////// Summary ///////////"
dmesg | grep 't_delta' | tail -n $prog_num | cut -c 25-
