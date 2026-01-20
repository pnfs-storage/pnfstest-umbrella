#
# openmpi.cmake  umbrella for openmpi package
# 12-Jan-2026  chuck@ece.cmu.edu
#

#
# config:
#  OPENMPI_REPO - url of git repository
#  OPENMPI_TAG  - tag to checkout of git
#  OPENMPI_TAR  - cache tar file name (default should be ok)
#
#  OPENMPI_DEVICE - configure backing device (ofi or ucx)
#

if (NOT TARGET openmpi)

#
# umbrella option variables
#
umbrella_defineopt (OPENMPI_REPO "https://github.com/open-mpi/ompi.git"
                    STRING "OPENMPI GIT repository")
umbrella_defineopt (OPENMPI_TAG "main" STRING "OPENMPI GIT tag")
umbrella_defineopt (OPENMPI_TAR "opemmpi-${OPENMPI_TAG}.tar.gz"
                    STRING "OPENMPI cache tar file")

umbrella_defineopt (OPENMPI_DEVICE ofi STRING "openmpi device (none, ofi, ucx)")

include(umbrella/hwloc)
include(umbrella/libevent)
include(umbrella/pmix)

set(OPENMPI_OPT_DEPENDS hwloc libevent pmix)
unset(OPENMPI_EXTRA_FLAGS)

if (${OPENMPI_DEVICE} STREQUAL "none")
elseif (${OPENMPI_DEVICE} STREQUAL "ofi")
    include(umbrella/ofi)
    list(APPEND OPENMPI_OPT_DEPENDS ofi)
    list(APPEND OPENMPI_EXTRA_FLAGS --with-ofi)
elseif (${OPENMPI_DEVICE} STREQUAL "ucx")
    include(umbrella/ucx)
    list(APPEND OPENMPI_OPT_DEPENDS ucx)
    list(APPEND OPENMPI_EXTRA_FLAGS --with-ucx)
else()
    message(FATAL_ERROR "openmpi: unknown device ${OPENMPI_DEVICE}")
endif()

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (OPENMPI_DOWNLOAD openmpi ${OPENMPI_TAR}
                   GIT_REPOSITORY ${OPENMPI_REPO}
                   GIT_TAG ${OPENMPI_TAG})
umbrella_patchcheck (OPENMPI_PATCHCMD openmpi)

#
# create openmpi target
#
ExternalProject_Add (openmpi DEPENDS ${OPENMPI_OPT_DEPENDS}
    ${OPENMPI_DOWNLOAD} ${OPENMPI_PATCHCMD}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure ${UMBRELLA_COMP}
                      ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                      ${UMBRELLA_PKGCFGPATH}
                      --prefix=${CMAKE_INSTALL_PREFIX}
                      ${OPENMPI_EXTRA_FLAGS}
                      UPDATE_COMMAND "")

#
# add extra autogen prepare step
#
ExternalProject_Add_Step (openmpi prepare
    COMMAND ${UMBRELLA_PREFIX}/ensure-autogen <SOURCE_DIR>/autogen.pl
    COMMENT "preparing source for configure"
    DEPENDEES update
    DEPENDERS configure
    WORKING_DIRECTORY <SOURCE_DIR>)

endif (NOT TARGET openmpi)
