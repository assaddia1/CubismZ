#!/bin/bash
set -x #echo on

if [ -z "$1" ]
then
    	echo "missing file"
        exit
else
    	h5file=$1
fi

if [ -z "$2" ]
then
	echo "setting err=22"
	err=22
else
	err=$2
fi

bs=32
ds=512
nb=$(echo "$ds/$bs" | bc)

rm -f tmp.cz

../../Tools/bin/fpzip/hdf2ch -bpdx $nb -bpdy $nb -bpdz $nb -sim io -simdata $h5file -outdata tmp.cz -threshold $err

mpirun -n 8 ../../Tools/bin/fpzip/ch2diff -simdata1 tmp.cz  -simdata2 ref.cz

