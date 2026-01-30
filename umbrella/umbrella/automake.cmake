#
# automake.cmake  umbrella for automake package
# 01-Oct-2017  chuck@ece.cmu.edu
#

#
# config:
#  AUTOMAKE_BASEURL - base url of automake
#  AUTOMAKE_URLFILE - tar file within urldir
#  AUTOMAKE_URLMD5  - md5 of tar file
#

if (NOT TARGET automake)

#
# umbrella option variables
#
umbrella_defineopt (AUTOMAKE_BASEURL
    "http://ftp.gnu.org/gnu/automake" STRING "base url for automake")
umbrella_defineopt (AUTOMAKE_URLFILE "automake-1.18.1.tar.gz"
    STRING "automake tar file name")
umbrella_defineopt (AUTOMAKE_URLMD5 "5a645b175491f97de4505aae83895017"
    STRING "MD5 of tar file")


#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (AUTOMAKE_DOWNLOAD automake ${AUTOMAKE_URLFILE}
    URL "${AUTOMAKE_BASEURL}/${AUTOMAKE_URLFILE}"
    URL_MD5 ${AUTOMAKE_URLMD5})
umbrella_patchcheck (AUTOMAKE_PATCHCMD automake)

#
# depends
#
include (umbrella/autoconf)

#
# create automake target
#
ExternalProject_Add (automake DEPENDS autoconf
    ${AUTOMAKE_DOWNLOAD} ${AUTOMAKE_PATCHCMD}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure ${UMBRELLA_COMP}
                      ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                      --prefix=${CMAKE_INSTALL_PREFIX}
                      UPDATE_COMMAND "")

endif (NOT TARGET automake)
