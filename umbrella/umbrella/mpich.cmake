#
# mpich.cmake  umbrella for mpich package
# 01-Oct-2017  chuck@ece.cmu.edu
#

#
#  MPICH_REPO - url of git repository
#  MPICH_TAG  - tag to checkout of git
#  MPICH_TAR  - cache tar file name (default should be ok)
#
#  MPICH_DEVICE - configure backing device (ofi or ucx)
#

if (NOT TARGET mpich)

#
# umbrella option variables
#
umbrella_defineopt (MPICH_REPO "https://github.com/pmodels/mpich.git"
                    STRING "MPICH GIT repository")
umbrella_defineopt (MPICH_TAG "main" STRING "MPICH GIT tag")
umbrella_defineopt (MPICH_TAR "mpich-${MPICH_TAG}.tar.gz"
                    STRING "MPICH cache tar file")

umbrella_defineopt (MPICH_DEVICE ofi STRING "mpich device (ofi, ucx)")

include(umbrella/hwloc)
include(umbrella/json-c)

set(MPICH_OPT_DEPENDS hwloc json-c)
unset(MPICH_EXTRA_FLAGS)

if (${MPICH_DEVICE} STREQUAL "ofi")
    include(umbrella/ofi)
    list(APPEND MPICH_OPT_DEPENDS ofi)
    list(APPEND MPICH_EXTRA_FLAGS --with-device=ch4:ofi)
elseif (${MPICH_DEVICE} STREQUAL "ucx")
    include(umbrella/ucx)
    list(APPEND MPICH_OPT_DEPENDS ucx)
    list(APPEND MPICH_EXTRA_FLAGS --with-device=ch4:ucx)
else()
    message(FATAL_ERROR "mpich: unknown device ${MPICH_DEVICE}")
endif()

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (MPICH_DOWNLOAD mpich ${MPICH_TAR}
                   GIT_REPOSITORY ${MPICH_REPO}
                   GIT_TAG ${MPICH_TAG})
umbrella_patchcheck (MPICH_PATCHCMD mpich)

#
# create mpich target
#
ExternalProject_Add (mpich DEPENDS ${MPICH_OPT_DEPENDS}
    ${MPICH_DOWNLOAD} ${MPICH_PATCHCMD}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure ${UMBRELLA_COMP}
                      ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                      --prefix=${CMAKE_INSTALL_PREFIX}
                      ${MPICH_EXTRA_FLAGS}
                      UPDATE_COMMAND "")

#
# add extra autogen prepare step
#
ExternalProject_Add_Step (mpich prepare
    COMMAND ${UMBRELLA_PREFIX}/ensure-autogen <SOURCE_DIR>/autogen.sh
    COMMENT "preparing source for configure"
    DEPENDEES update
    DEPENDERS configure
    WORKING_DIRECTORY <SOURCE_DIR>)

endif (NOT TARGET mpich)
