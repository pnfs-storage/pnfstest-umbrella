#
# rdma-core.cmake  umbrella for linux rdma core package
# 16-Jul-2020  chuck@ece.cmu.edu
#

#
# config:
#  RDMA_CORE_REPO - url of git repository
#  RDMA_CORE_TAG  - tag to checkout of git
#  RDMA_CORE_TAR  - cache tar file name (default should be ok)
#

umbrella_prebuilt_check(rdma-core FILE rdma/rdma_verbs.h)

if (NOT TARGET rdma-core)

#
# umbrella option variables
#
umbrella_defineopt (RDMA_CORE_REPO "https://github.com/linux-rdma/rdma-core"
                    STRING "RDMA_CORE GIT repository")
umbrella_defineopt (RDMA_CORE_TAG "master" STRING "RDMA_CORE GIT tag")
umbrella_defineopt (RDMA_CORE_TAR "rdma-core-${RDMA_CORE_TAG}.tar.gz"
                                STRING "RDMA_CORE cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (RDMA_CORE_DOWNLOAD rdma-core ${RDMA_CORE_TAR}
                   GIT_REPOSITORY ${RDMA_CORE_REPO}
                   GIT_TAG ${RDMA_CORE_TAG})
umbrella_patchcheck (RDMA_CORE_PATCHCMD rdma-core)

#
# depends
#
include (umbrella/libnl)

#
# rdma-core uses GNUInstallDirs.cmake.   that sometimes picks
# $prefix/lib64 for lib installs, but that isn't something that
# we need for umbrella builds.  ensure it is switched off by
# setting DCMAKE_INSTALL_LIBDIR to $prefix/lib
#
# building rdma man pages from git requires rst2man and pandoc.
# XXX: rather than add extra depends on those, just switch man
# pages off for now.
#
set (RDMA_CORE_CMAKECACHE ${UMBRELLA_CMAKECACHE}
     -DCMAKE_INSTALL_LIBDIR:STRING=${CMAKE_INSTALL_PREFIX}/lib
     -DNO_MAN_PAGES:BOOL=on)

#
# create rdma-core target
# XXX: needs PKG_CONFIG_USE_CMAKE_PREFIX_PATH because they use cmake 2.8
# XXX: need to add "-L" and RPATH workarounds
#
ExternalProject_Add (rdma-core DEPENDS libnl
    ${RDMA_CORE_DOWNLOAD} ${RDMA_CORE_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=YES
    CMAKE_CACHE_ARGS ${RDMA_CORE_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET rdma-core)
