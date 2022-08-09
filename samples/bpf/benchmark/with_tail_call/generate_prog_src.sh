#!/bin/bash

#
# Pass the filename of base program source, base workload source and program
# list via command line arguments. Based on them this script will generate BPF
# program source of variable number of tail call(s).
#

if (( $# != 5 ))
then
    echo
    echo "Usage: $0 BASE_KERN_PROG_SRC BASE_WORKLOAD_SRC BASE_PROG_DEF_SRC PROG_NAME_LIST PROG_SIZE_LIST"
    echo
    exit
fi

base_kern_prog_src_filename=$1
base_workload_src_filename=$2
base_prog_def_src_filename=$3
prog_name_list_filename=$4
prog_size_list_filename=$5

base_workload_c_insns=$( cat $base_workload_src_filename | wc -l )

#
# Replicate by a larger step (0.1k lines of C code) for better I/O efficiency
#

replicate_step=100

# Remove the file of previous builds
rm -f autogen/workload_0.1k_step.c

replicate_time=$( bc <<< "$replicate_step / $base_workload_c_insns" )

for i in $( seq $replicate_time )
do
    cat $base_workload_src_filename >> autogen/workload_0.1k_step.c
done

#
# Workload of a single call or tail call
#

# TODO make it adjustable
bpf_asm_insns=100000
# The ratio is approximately 2.5 / 1. Also we want to keep the size a multiple
# of 100.
c_insns=$( bc <<< "$bpf_asm_insns / 250 * 100" )

# Remove the file of previous builds
rm -f autogen/workload_one_call.c

replicate_time=$( bc <<< "$c_insns / $replicate_step" )

for i in $( seq $replicate_time )
do
    cat autogen/workload_0.1k_step.c >> autogen/workload_one_call.c
done

IFS=$'\n'

#
# Generate the source for BPF programs
#

for line in $( paste $prog_name_list_filename $prog_size_list_filename )
do
    prog_name=$( cut -f 1 <<< $line )
    prog_size=$( cut -f 2 <<< $line )

    # Get the source filename
    prog_src_filename=$( sed 's/.o/.c/' <<< $prog_name )

    # Generate source files
    echo "Generating autogen/$prog_src_filename"
    cp $base_kern_prog_src_filename autogen/$prog_src_filename
    # The variable-length part is wrapped with an `#include' directive.
    # Change the included filename accordingly.
    prog_def_src_filename="prog_def_${prog_size}.c"
    sed -i "s/$base_prog_def_src_filename/$prog_def_src_filename/" autogen/$prog_src_filename
    # Now handle the included part, i.e. program definition.
    # Remove the file of previous builds.
    rm -f autogen/$prog_def_src_filename
    echo "Generating autogen/$prog_def_src_filename"
    for i in $( seq $prog_size )
    do
        # What is 9999? Hmm, it's just a magic number that is easier to grep and
        # generally won't mess up other parts of the program.
        sed "s/9999/$i/" $base_prog_def_src_filename >> autogen/$prog_def_src_filename
    done
done
