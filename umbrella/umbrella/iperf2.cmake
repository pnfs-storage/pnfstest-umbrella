#
# iperf2.cmake  umbrella for iperf2 package
# 01-Oct-2017  chuck@ece.cmu.edu
#

#
# config:
#  IPERF2_REPO - url of git repository
#  IPERF2_TAG  - tag to checkout of git
#  IPERF2_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET iperf2)

#
# umbrella option variables
#
umbrella_defineopt (IPERF2_REPO "https://git.code.sf.net/p/iperf2/code"
                    STRING "IPERF2 GIT repository")
umbrella_defineopt (IPERF2_TAG "master" STRING "IPERF2 GIT tag")
umbrella_defineopt (IPERF2_TAR "iperf2-${IPERF2_TAG}.tar.gz"
                                STRING "IPERF2 cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (IPERF2_DOWNLOAD iperf2 ${IPERF2_TAR}
                   GIT_REPOSITORY ${IPERF2_REPO}
                   GIT_TAG ${IPERF2_TAG})
umbrella_patchcheck (IPERF2_PATCHCMD iperf2)

#
# create iperf2 target
#
ExternalProject_Add (iperf2 ${IPERF2_DOWNLOAD} ${IPERF2_PATCHCMD}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure ${UMBRELLA_COMP}
                      ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                      --prefix=${CMAKE_INSTALL_PREFIX}
    UPDATE_COMMAND "")

endif (NOT TARGET iperf2)
