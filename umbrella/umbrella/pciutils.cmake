#
# pciutils.cmake  pciutils library and lspci binary
# 27-Jan-2026  chuck@ece.cmu.edu
#

#
# config:
#  PCIUTILS_REPO - url of git repository
#  PCIUTILS_TAG  - tag to checkout of git
#  PCIUTILS_TAR  - cache tar file name (default should be ok)
#

umbrella_prebuilt_check(pciutils FILE pci/pci.h)

if (NOT TARGET pciutils)

#
# umbrella option variables
#
umbrella_defineopt (PCIUTILS_REPO "https://github.com/pciutils/pciutils.git"
                    STRING "PCIUTILS GIT repository")
umbrella_defineopt (PCIUTILS_TAG "master" STRING "PCIUTILS GIT tag")
umbrella_defineopt (PCIUTILS_TAR "pciutils-${PCIUTILS_TAG}.tar.gz" STRING
                    "PCIUTILS cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (PCIUTILS_DOWNLOAD pciutils ${PCIUTILS_TAR}
                   GIT_REPOSITORY ${PCIUTILS_REPO}
                   GIT_TAG ${PCIUTILS_TAG})
umbrella_patchcheck (PCIUTILS_PATCHCMD pciutils)

#
# create pciutils target
#
ExternalProject_Add (pciutils ${PCIUTILS_DOWNLOAD} ${PCIUTILS_PATCHCMD}
    CONFIGURE_COMMAND ""
    BUILD_IN_SOURCE 1      # old school makefiles
    BUILD_COMMAND make ${UMBRELLA_COMP}
                       ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                       SHARED=yes PREFIX=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND make ${UMBRELLA_COMP}
                       ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                       SHARED=yes PREFIX=${CMAKE_INSTALL_PREFIX}
                       install install-lib
    UPDATE_COMMAND "")

endif (NOT TARGET pciutils)
