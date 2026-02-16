#
# CMakeLists.txt  build pnfstest environment 
# 20-Jan-2026  chuck@ece.cmu.edu
#

#
# general command line config:
#
#   -DCMAKE_INSTALL_PREFIX=/usr/local     # installation prefix
#   -DCMAKE_BUILD_TYPE=RelWithDebInfo     # or Release, Debug, etc.
#      (XXX: currently only applied to cmake-based builds)
#
# finding dependencies:
#
#   -DCMAKE_PREFIX_PATH='/pkg'            # look for additional installs here
#
# the following also applies for configure scripts:
#   -DCMAKE_INCLUDE_PATH='/pkg/include'   # extra include directories
#   -DCMAKE_LIBRARY_PATH='/pkg/lib'       # extra library path
#
# note these are all cmake lists (so more than one directory can
# be specified using a semicolon to create a path).
#
# specifying alternate compilers (overrides CC/CXX environment variables):
#   -DCC=/bin/cc
#   -DCXX=/bin/cxx
#
#   you may also use the longer names
#     -DCMAKE_C_COMPILER
#     -DCMAKE_CXX_COMPILER
#
# specifying which mpi to use by pointing at the wrappers:
#   -DMPI_C_COMPILER=/usr/bin/mpicc
#   -DMPI_CXX_COMPILER=/usr/bin/mpicxx
#   -DMPIEXEC=/usr/bin/mpiexec
#

cmake_minimum_required (VERSION 3.6)

#
# put the umbrella scripts in our search path and include umbrella-init
# (umbrella-init needs to run before "project")
#
list (APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/umbrella")
include (umbrella-init NO_POLICY_SCOPE)

#
# we don't really use MPICXX for now. The difference between CXX and MPICXX
# is that CXX refers to the MPI C API being usable from C++, whereas MPICXX
# refers to the MPI-2 C++ API that was removed again in MPI-3.
# To enable MPICXX, run umbrella with -DMPI_CXX_SKIP_MPICXX=Off.
#
set (MPI_CXX_SKIP_MPICXX ON CACHE BOOL "True if MPICXX should be skipped")

#
# need to mark project as using C/CXX so we can probe for MPI
# using a compiler that may have been passed in via the command line
# or by using environment vars.
#
project (pnfstest-umbrella C CXX)

#
# propagate the MPICXX setting to all cmake subprojects
#
list(APPEND UMBRELLA_CMAKECACHE
            -DMPI_CXX_SKIP_MPICXX:BOOL=${MPI_CXX_SKIP_MPICXX})

#
# configure umbrella for MPI and pull in the main routines
#
set (UMBRELLA_MPI 1)
include (umbrella-main)

#
# cache variables that control what we build
#
umbrella_opt_default (OFI_PREBUILT "try")
umbrella_opt_default (RDMA_CORE_PREBUILT "try")

#
# set git tags to the versions we want to stick to by default...
#
umbrella_opt_default (FABTESTS_TAG "main")
umbrella_opt_default (FIO_TAG "master")
umbrella_opt_default (IOR_TAG "main")
umbrella_opt_default (IPERF2_TAG "master")
umbrella_opt_default (IPERF3_TAG "master")
umbrella_opt_default (NETPERF_TAG "master")
umbrella_opt_default (OSU_MICRO_BENCHMARKS_URLVERS "7.5.2")
umbrella_opt_default (PERFTEST_TAG "master")
umbrella_opt_default (QPERF_TAG "master")

#
# set other configs before we start pulling in the pieces...
#
include (umbrella/fabtests)
include (umbrella/fio)
include (umbrella/ior)
include (umbrella/iperf2)
include (umbrella/iperf3)
include (umbrella/netperf)
include (umbrella/osu-micro-benchmarks)
include (umbrella/perftest)
include (umbrella/qperf)
