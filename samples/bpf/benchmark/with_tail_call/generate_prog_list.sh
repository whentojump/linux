#!/bin/bash

prompt() {
    echo
    echo "Specify the size of BPF programs to generate."
    echo
    echo "Usage: $0 ONE_CALL_SIZE CALL_NUM"
    echo
    echo "       ONE_CALL_SIZE    size of a single tail call. unit: how many times to"
    echo "                        repeat the base workload."
    echo
    echo "       CALL_NUM      := [ LAST | FIRST LAST | FIRST INCREMENT LAST ]"
    echo "                        i.e. the same argument format as seq(1)"
    echo
    echo
    echo "       use default size (100000 1 1 20)"
    echo
    echo "       $0"
    echo
    echo
    echo "       remove generated files"
    echo
    echo "       $0 clean"
    echo
    exit
}

if (( $# == 1 )) && [[ $1 == clean ]]
then
    rm -vf autogen/program_size.txt autogen/program_name.txt
    exit
else
    if (( $# == 0 ))
    then
        seq 1 1 20 > autogen/program_size.txt
        program_num=20
        echo 100000 >> autogen/program_size.txt
        echo "No custom program size specified. Use the default:"
    else
        seq ${@:2} 1> /dev/null 2> /dev/null || prompt # check if arguments are valid
        seq ${@:2} > autogen/program_size.txt
        program_num=$( wc -l < autogen/program_size.txt )
        echo $1 >> autogen/program_size.txt
        echo "Custom program size specified:"
    fi
fi

cat autogen/program_size.txt

echo "Source for these BPF programs will be generated:"

# Remove the file of previous builds
rm -f autogen/program_name.txt

for i in $( seq $program_num )
do
    printf "kern_%02d.o\n" $i >> autogen/program_name.txt
done

cat autogen/program_name.txt
