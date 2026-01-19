#
# ucx.cmake  umbrella for Unified Communication X (UCX) communications package
# 15-Dec-2025  chuck@ece.cmu.edu
#

#
# config:
#  UCX_REPO - url of git repository
#  UCX_TAG  - tag to checkout of git
#  UCX_TAR  - cache tar file name (default should be ok)
#
# opts:
#  UCX_VERBS - build with verbs
#

umbrella_prebuilt_check(ucx FILE ucp/api/ucp_version.h)

if (NOT TARGET ucx)

#
# umbrella option variables
#
umbrella_defineopt (UCX_REPO "https://github.com/openucx/ucx.git"
                    STRING "UCX GIT repository")
umbrella_defineopt (UCX_TAG "master" STRING "UCX GIT tag")
umbrella_defineopt (UCX_TAR "ucx-${UCX_TAG}.tar.gz" STRING "UCX cache tar file")

umbrella_defineopt (UCX_VERBS OFF BOOL "Build ucx with verbs")

unset(UCX_OPT_DEPENDS)
unset(UCX_EXTRA_FLAGS)

if (UCX_VERBS)
    message(STATUS "  ucx: enable verbs")
    list(APPEND UCX_OPT_DEPENDS rdma-core)
    include(umbrella/rdma-core)
    list(APPEND UCX_EXTRA_FLAGS --with-verbs)
else()
    list(APPEND UCX_EXTRA_FLAGS --without-verbs)
endif()

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (UCX_DOWNLOAD ucx ${UCX_TAR}
                   GIT_REPOSITORY ${UCX_REPO}
                   GIT_TAG ${UCX_TAG})
umbrella_patchcheck (UCX_PATCHCMD ucx)

#
# create ucx target
#
ExternalProject_Add (ucx DEPENDS ${UCX_OPT_DEPENDS}
    ${UCX_DOWNLOAD} ${UCX_PATCHCMD}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure ${UMBRELLA_COMP}
                      ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                      --prefix=${CMAKE_INSTALL_PREFIX}
                      --enable-shared ${UCX_EXTRA_FLAGS}
    UPDATE_COMMAND "")

#
# add extra autogen prepare step
#
ExternalProject_Add_Step (ucx prepare
    COMMAND ${UMBRELLA_PREFIX}/ensure-autogen <SOURCE_DIR>/autogen.sh
    COMMENT "preparing source for configure"
    DEPENDEES update
    DEPENDERS configure
    WORKING_DIRECTORY <SOURCE_DIR>)

endif (NOT TARGET ucx)
