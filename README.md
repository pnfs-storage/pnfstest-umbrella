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
provide a bootstrapping mechanism to build your own MPICH and/or OpenMPI
and install it in the directory of your choice.

# building pnfstest-umbrella packages

