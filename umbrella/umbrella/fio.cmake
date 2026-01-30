#
# fio.cmake  umbrella for fio benchmark
# 29-Jan-2026  chuck@ece.cmu.edu
#

#
# config:
#  FIO_REPO - url of git repository
#  FIO_TAG  - tag to checkout of git
#  FIO_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET fio)

#
# umbrella option variables
#
umbrella_defineopt (FIO_REPO "https://github.com/axboe/fio.git"
                    STRING "FIO GIT repository")
umbrella_defineopt (FIO_TAG "master" STRING "FIO GIT tag")
umbrella_defineopt (FIO_TAR "fio-${FIO_TAG}.tar.gz" STRING "FIO cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (FIO_DOWNLOAD fio ${FIO_TAR}
                   GIT_REPOSITORY ${FIO_REPO}
                   GIT_TAG ${FIO_TAG})
umbrella_patchcheck (FIO_PATCHCMD fio)

#
# fio does not use autoconfig, it just impefectly fakes it.
# work arounds...
#
string(REGEX REPLACE "^CPPFLAGS=" "" fio_cflags "${UMBRELLA_CPPFLAGS}")
string(REGEX REPLACE "^LDFLAGS=" "" fio_ldflags "${UMBRELLA_LDFLAGS}")

####
#
# create fio target
#
ExternalProject_Add (fio ${FIO_DOWNLOAD} ${FIO_PATCHCMD}
    CONFIGURE_COMMAND env CC=${CMAKE_C_COMPILER}
                          "CFLAGS=${fio_cflags}" "LDFLAGS=${fio_ldflags}"
                      <SOURCE_DIR>/configure
                      --prefix=${CMAKE_INSTALL_PREFIX}
    UPDATE_COMMAND "")

endif (NOT TARGET fio)
