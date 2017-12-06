# File       : Makefile
# Created    : Wed Nov 29 2017 07:34:13 PM (+0100)
# Author     : Fabian Wermelinger
# Description: Build CubismZ tools
# Copyright 2017 ETH Zurich. All Rights Reserved.

MPICC = mpic++
mpicc = mpicc
blocksize ?= 32
hdf-incdir ?= /opt/hdf5_mpich/include
hdf-libdir ?= /opt/hdf5_mpich/lib

all: tools

tools: thirdparty tools-only


tools-only:
	$(MAKE) -C Tools/ install MPICC=$(MPICC) bs=$(blocksize) hdf-inc=$(hdf-incdir) hdf-lib=$(hdf-libdir) dir=default
	$(MAKE) -C Tools/ install MPICC=$(MPICC) bs=$(blocksize) hdf-inc=$(hdf-incdir) hdf-lib=$(hdf-libdir) dir=default dir=wavz_zlib wavz=1 zlib=1
	$(MAKE) -C Tools/ install MPICC=$(MPICC) bs=$(blocksize) hdf-inc=$(hdf-incdir) hdf-lib=$(hdf-libdir) dir=default dir=fpzip fpzip=1
	$(MAKE) -C Tools/ install MPICC=$(MPICC) bs=$(blocksize) hdf-inc=$(hdf-incdir) hdf-lib=$(hdf-libdir) dir=default dir=zfp zfp=1
	$(MAKE) -C Tools/ install MPICC=$(MPICC) bs=$(blocksize) hdf-inc=$(hdf-incdir) hdf-lib=$(hdf-libdir) dir=default dir=sz sz=1

thirdparty:
	$(MAKE) -C ThirdParty/ CC=$(MPICC) cc=$(mpicc)

clean:
	$(MAKE) -C Tools/ clean
	$(MAKE) -C ThirdParty/ clean
