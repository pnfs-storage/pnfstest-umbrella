# pnfstest-umbrella

This is an umbrella repository used to build pnfs-related benchmarks
and test programs.  Umbrella repositories require cmake to build.

# configuration

All configuration is done using cmake variables.  Key variables:
```
CMAKE_INSTALL_PREFIX - where to install
CMAKE_PREFIX_PATH - where to look for prebuilt programs/libs we need
```

Variables can be set using the "-D" flag to cmake.  For example:
```
cmake -DCMAKE_INSTALL_PREFIX=/home/benchtest ...
```

# bootstrapping

Building the benchmark/test software requires a working MPI installation.
The installed MPI should be configured to make efficient use of the
underlying HPC network (e.g. it should favor using RDMA if supported,
rather than falling back on only using TCP).

If an appropriate MPI is not installed, it may be available in
the operating system's packaging manager system (e.g. apt on
UBUNTU-like systems and yum/dnf on CENTOS/ROCKY like systems).
But it will likely require root access to install/update system
level packages.

For cases where an appropriate MPI is not available/installed, we
provide a bootstrapping mechanism to build your own MPICH and/or
OpenMPI and install it in the directory of your choice (with or
without root access).

To build a bootstrap MPI use cmake with bootstrap/CMakeLists.txt.
To configure the bootstrap MPI, set these cmake variables with "-D"
on the cmake command line:
* BOOTSTRAP set to either 'mpich' or 'openmpi' to choose which MPI to compile
* CMAKE_INSTALL_PREFIX set to directory prefix to install the bootstrap
* HWLOC_TAG set to 'v2.12'  (newer versions changed the ABI/API)
* OPENMPI_DEVICE set to 'ofi' or 'ucx' to choose backend (if BOOTSTRAP=openmpi)
* MPICH_DEVICE set to 'ofi' or 'ucx' to choose backend (if BOOTSTRAP=mpich)
* OFI_OPT_PROVIDERS set to desired provider (verbs, opx, psm2, psm3) for ofi

For example, a typical config is to use either mpich or openmpi with
ofi libfabric's verbs provider.   To install mpich with this config
into $HOME/mpich the following commands can be used from the top level
directory of this repository:
```
mkdir build-bootstrap
cd build-bootstrap
cmake -DBOOTSTRAP=mpich -DCMAKE_INSTALL_PREFIX=${HOME}/mpich \
    -DHWLOC_TAG=v2.12 \
    -DMPICH_DEVICE=ofi -DOFI_OPT_PROVIDERS=verbs ../bootstrap
make -j 16
```

To do the same with openmpi:
```
mkdir build-bootstrap
cd build-bootstrap
cmake -DBOOTSTRAP=openmpi -DCMAKE_INSTALL_PREFIX=${HOME}/openmpi \
    -DHWLOC_TAG=v2.12 \
    -DOPENMPI_DEVICE=ofi -DOFI_OPT_PROVIDERS=verbs ../bootstrap
make -j 16
```

# building pnfstest-umbrella packages

