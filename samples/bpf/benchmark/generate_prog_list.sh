#!/bin/bash

prompt() {
    echo
    echo "Usage: $0"
    echo "       $0 LAST"
    echo "       $0 FIRST LAST"
    echo "       $0 FIRST INCREMENT LAST"
    echo
    exit
}

if (( $# == 0 ))
then
    seq 100000 100000 1000000 > autogen/program_size.txt
    echo "No custom program size specified. Use the default:"
else
    seq $@ 1> autogen/program_size.txt 2> /dev/null || prompt
    echo "Custom program size specified:"
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
