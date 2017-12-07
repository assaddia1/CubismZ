#!/bin/bash
#
# test_sz.sh
# CubismZ
#
# Copyright 2017 ETH Zurich. All rights reserved.
#
set -x #echo on

h5file=../Data/data_005000-p.h5

nproc=1
if [ ! -z ${1+x} ]
then
    nproc=$1; shift
fi

if [ -z ${1+x} ]
then
    echo "setting err=0.01"
    err=0.01
else
    err=$1; shift
fi

bs=32
ds=512
nb=$(echo "$ds/$bs" | bc)

rm -f tmp.cz

# check if reference file exists, create it otherwise
if [ ! -f ref.cz ]
then
    ./genref.sh
fi

mpirun -n 1 ../../Tools/bin/sz/hdf2cz -bpdx $nb -bpdy $nb -bpdz $nb -sim io -simdata $h5file  -outdata tmp.cz  -threshold $err

mpirun -n $nproc ../../Tools/bin/sz/cz2diff -simdata1 tmp.cz -simdata2 ref.cz
