#!/bin/bash

#
# Pass the filename of base program source and base workload source via command
# line arguments. Based on them this script will generate BPF program source of
# variable lengths.
#

if (( $# != 2 ))
then
    echo
    echo "Usage: $0 BASE_PROG_SRC BASE_WORKLOAD_SRC"
    echo
    exit
fi

base_prog_src_filename=$1
base_workload_src_filename=$2

base_workload_c_insns=$( cat $base_workload_src_filename | wc -l )

#
# Generate program_size.txt (if needed), and generate program_name.txt
#

if [[ -e autogen/program_size.txt ]]
then
    echo "Custom program size specified:"
else
    echo "No custom program size specified. Use the default:"
    seq 100000 100000 1000000 > autogen/program_size.txt
fi

cat autogen/program_size.txt

echo "Source for these BPF programs will be generated:"

# Remove the file of previous builds
rm -f autogen/program_name.txt

for i in $( seq $( cat autogen/program_size.txt | wc -l ) )
do
    printf "kern_%02d.o\n" $i >> autogen/program_name.txt
done

cat autogen/program_name.txt

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

IFS=$'\n'

#
# Generate the source for BPF programs
#

for line in $( paste autogen/program_name.txt autogen/program_size.txt )
do
    prog_name=$( cut -f 1 <<< $line )
    prog_size=$( cut -f 2 <<< $line )

    # Get the source filename
    prog_src_filename=$( sed 's/.o/.c/' <<< $prog_name )

    # Calculate how many times the base workload should get replicated
    bpf_asm_insns=$prog_size
    # The ratio is approximately 2.5 / 1. Also we want to keep the size a
    # multiple of 100.
    c_insns=$( bc <<< "$bpf_asm_insns / 250 * 100" )
    replicate_time=$( bc <<< "$c_insns / $replicate_step" )
    # Name the workload source file by number of lines of C code
    workload_src_filename="workload_${c_insns}.c"

    # Generate source files
    echo "Generating autogen/$prog_src_filename"
    cp $base_prog_src_filename autogen/$prog_src_filename
    # The variable-length part is wrapped with an `#include' directive.
    # Change the included filename accordingly.
    sed -i "s/workload_base.c/$workload_src_filename/" autogen/$prog_src_filename
    # Now handle the included part, i.e. workload.
    # Remove the file of previous builds.
    rm -f autogen/$workload_src_filename
    echo "Generating autogen/$workload_src_filename"
    for i in $( seq $replicate_time )
    do
        cat autogen/workload_0.1k_step.c >> autogen/$workload_src_filename
    done
done
