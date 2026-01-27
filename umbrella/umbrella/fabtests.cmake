#
# fabtests.cmake  umbrella fabtests (lives in ofi)
# 17-Jul-2020  chuck@ece.cmu.edu
#

#
# config:
#  FABTESTS_REPO - url of git repository
#  FABTESTS_TAG  - tag to checkout of git
#  FABTESTS_TAR  - cache tar file name
#

if (NOT TARGET fabtests)

#
# umbrella option variables
#
umbrella_defineopt (FABTESTS_REPO "https://github.com/ofiwg/libfabric.git"
     STRING "FABTESTS/ofi GIT repository")
umbrella_defineopt (FABTESTS_TAG "main" STRING "FABTESTS GIT tag")
umbrella_defineopt (FABTESTS_TAR "ofi-${FABTESTS_TAG}.tar.gz"
                    STRING "FABTESTS cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (FABTESTS_DOWNLOAD fabtests ${FABTESTS_TAR}
                   GIT_REPOSITORY ${FABTESTS_REPO}
                   GIT_TAG ${FABTESTS_TAG})
umbrella_patchcheck (FABTESTS_PATCHCMD fabtests)

#
# depends
#
include (umbrella/ofi)

#
# create fabtests target
#
ExternalProject_Add (fabtests DEPENDS ofi
    ${FABTESTS_DOWNLOAD} ${FABTESTS_PATCHCMD}
    CONFIGURE_COMMAND <SOURCE_DIR>/fabtests/configure ${UMBRELLA_COMP}
                      ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                      --prefix=${CMAKE_INSTALL_PREFIX}
                      --enable-shared
    UPDATE_COMMAND "")

#
# add extra autogen prepare step
#
ExternalProject_Add_Step (fabtests prepare
    COMMAND cd fabtests &&
            ${UMBRELLA_PREFIX}/ensure-autogen <SOURCE_DIR>/fabtests/autogen.sh
    COMMENT "preparing source for configure"
    DEPENDEES update
    DEPENDERS configure
    WORKING_DIRECTORY <SOURCE_DIR>)

endif (NOT TARGET fabtests)
