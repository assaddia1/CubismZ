#!/bin/bash
set -x #echo on

if [ -z "$1" ]
then
    	echo "missing file"
        exit
else
    	h5file=$1
fi

bs=32
#ds=512
ds=1024
nb=$(echo "$ds/$bs" | bc)

(cd ../tools; make clean; make all sz=1)

rm -f tmp00000.StreamerGridPointIterative.channel0

ulimit -s 1600000000
export OMP_NUM_THREADS=1

../tools/hdf2ch -bpdx $nb -bpdy $nb -bpdz $nb -sim io -simdata $h5file  -outdata tmp  -threshold $2

#mpirun -n 8 ../tools/ch2diff -simdata1 tmp00000.StreamerGridPointIterative.channel0  -simdata2 ref.channel0

