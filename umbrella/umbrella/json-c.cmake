#
# json-c.cmake  umbrella for json-c parser
# 19-Apr-2021  chuck@ece.cmu.edu
#

#
# config:
#  JSON_C_REPO - url of git repository
#  JSON_C_TAG  - tag to checkout of git
#  JSON_C_TAR  - cache tar file name (default should be ok)
#
#  JSON_C_LIBDIR - value for CMAKE_INSTALL_LIBDIR (for GNUInstallDirs.cmake)
#                  set to "" or "default" to take the system default.
#                  our default for umbrella is "lib"...
#

if (NOT TARGET json-c)

#
# umbrella option variables
#
umbrella_defineopt (JSON_C_REPO
    "https://github.com/json-c/json-c.git"
     STRING "json-c GIT repository")
umbrella_defineopt (JSON_C_TAG "master" STRING "json-c GIT tag")
umbrella_defineopt (JSON_C_TAR
     "json-c-${JSON_C_TAG}.tar.gz"
     STRING "json-c cache tar file")

umbrella_defineopt (JSON_C_LIBDIR "lib" STRING "libdir for GNUInstallDirs")

if ("${JSON_C_LIBDIR}" STREQUAL "" OR
    "${JSON_C_LIBDIR}"  STREQUAL "default")
    unset(json_c_libdirflag)
else()
    set(json_c_libdirflag -DCMAKE_INSTALL_LIBDIR=${JSON_C_LIBDIR})
endif()

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (JSON_C_DOWNLOAD json-c ${JSON_C_TAR}
                   GIT_REPOSITORY ${JSON_C_REPO}
                   GIT_TAG ${JSON_C_TAG})
umbrella_patchcheck (JSON_C_PATCHCMD json-c)
umbrella_testcommand (json-c JSON_C_TESTCMD "" )

#
# create deltafs-nexus target
#
ExternalProject_Add (json-c
    ${JSON_C_DOWNLOAD} ${JSON_C_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON ${json_c_libdirflag}
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
    ${JSON_C_TESTCMD}
)

endif (NOT TARGET json-c)
