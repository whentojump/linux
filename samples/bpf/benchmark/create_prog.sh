#!/bin/bash

for prog in $( cat program_list.txt )
do
    # Get the source filename
    src=$( sed 's/.o/.c/' <<< $prog )

    # Extract program size information from filename
    bpf_asm_kilo_insns=$( sed -e 's/^kern_//' -e 's/k.o$//' <<< $prog )
    bpf_asm_insns=$( bc <<< "1000 * $bpf_asm_kilo_insns" )
    # TODO estimate $c_insns from $bpf_asm_insns

    # Generate source files
    echo "Generating $src"
    cp kern_base.c $src
    # The variable-length part is wrapped with an `#include' directive.
    # Change the included filename accordingly.
    sed -i "s/workload_base/workload_${bpf_asm_kilo_insns}k/" $src
done
