#!/bin/bash

if (($# != 2))
then
    echo 
    echo "Usage: $0 BASE_PROG BASE_WORKLOAD"
    echo
    exit
fi

base_prog_src_filename=$1
base_workload_src_filename=$2

base_workload_c_insns=$( cat $base_workload_src_filename | wc -l )

#
# Replicate by a larger step (0.1k lines of C code) for better I/O efficiency
#

replicate_step=100

rm -vf autogen/workload_0.1k_step.c

replicate_time=$( bc <<< "$replicate_step / $base_workload_c_insns" )

for i in $( seq $replicate_time )
do
    cat $base_workload_src_filename >> autogen/workload_0.1k_step.c
done

IFS=$'\n'

for line in $( paste program_name.txt program_size.txt )
do
    prog_name=$( cut -f 1 <<< $line )
    prog_size=$( cut -f 2 <<< $line )

    # Get the source filename
    src_name=$( sed 's/.o/.c/' <<< $prog_name )

    # Calculate how many times the base workload should get replicated
    bpf_asm_insns=$prog_size
    # TODO calculate $c_insns from $bpf_asm_insns
    c_insns=$bpf_asm_insns
    replicate_time=$( bc <<< "$c_insns / $replicate_step" )

    # Generate source files
    echo "Generating autogen/$src_name"
    cp $base_prog_src_filename autogen/$src_name
    # The variable-length part is wrapped with an `#include' directive.
    # Change the included filename accordingly.
    sed -i "s/workload_base/workload_${replicate_time}00/" autogen/$src_name
    # Now handle the included part, i.e. workload
    rm -vf autogen/workload_${replicate_time}00.c
    echo "Generating autogen/workload_${replicate_time}00.c"
    for i in $( seq $replicate_time )
    do
        cat autogen/workload_0.1k_step.c >> autogen/workload_${replicate_time}00.c
    done
done
