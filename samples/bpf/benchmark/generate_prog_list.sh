#!/bin/bash

prompt() {
    echo
    echo "Usage: use default size (seq 100000 100000 1000000)"
    echo
    echo "       $0"
    echo
    echo "       the script also accepts argument(s) in the same format as seq(1)"
    echo
    echo "       $0 LAST"
    echo "       $0 FIRST LAST"
    echo "       $0 FIRST INCREMENT LAST"
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
        seq 100000 100000 1000000 > autogen/program_size.txt
        echo "No custom program size specified. Use the default:"
    else
        seq $@ 1> /dev/null 2> /dev/null || prompt # check if arguments are valid
        seq $@ > autogen/program_size.txt
        echo "Custom program size specified:"
    fi
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
