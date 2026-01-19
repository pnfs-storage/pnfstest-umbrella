#
# ofi.cmake  umbrella for OFI communications package
# 28-Sep-2017  chuck@ece.cmu.edu
#

#
# repo/src config:
#  OFI_REPO - url of git repository
#  OFI_TAG  - tag to checkout of git
#  OFI_TAR  - cache tar file name
#
# optional provider config:
#  OFI_OPT_PROVIDERS - list of optional providers to enable
#  OFI_VERBS - attempt to build verbs provider
#

umbrella_prebuilt_check(ofi FILE rdma/fi_endpoint.h)

if (NOT TARGET ofi)

#
# umbrella option variables
#
umbrella_defineopt (OFI_REPO "https://github.com/ofiwg/libfabric.git"
     STRING "OFI (libfabric) GIT repository")
umbrella_defineopt (OFI_TAG "main" STRING "OFI GIT tag")
umbrella_defineopt (OFI_TAR "ofi-${OFI_TAG}.tar.gz" STRING "OFI cache tar file")

umbrella_defineopt (OFI_OPT_PROVIDERS "" STRING
                    "List of enabled optional providers")
umbrella_defineopt (OFI_OPX OFF BOOL "Build ofi opx provider")
umbrella_defineopt (OFI_PROFILE OFF BOOL "Build ofi profile provider")
umbrella_defineopt (OFI_PSM2 OFF BOOL "Build ofi psm2 provider")
umbrella_defineopt (OFI_PSM3 OFF BOOL "Build ofi psm3 provider")
umbrella_defineopt (OFI_VERBS OFF BOOL "Build ofi verbs provider")
umbrella_defineopt (OFI_UCX OFF BOOL "Build ofi ucx provider")

unset(OFI_OPT_DEPENDS)
unset(OFI_EXTRA_FLAGS)

if (OFI_OPX OR opx IN_LIST OFI_OPT_PROVIDERS)
    message(STATUS "  ofi: enable build of opx provider")
    if (NOT TARGET libuuid)
        list(APPEND OFI_OPT_DEPENDS libuuid)
        include(umbrella/libuuid)
    endif ()
    list(APPEND OFI_EXTRA_FLAGS --enable-opx)
else()
    list(APPEND OFI_EXTRA_FLAGS --disable-opx)
endif()

if (OFI_PROFILE OR profile IN_LIST OFI_OPT_PROVIDERS)
    message(STATUS "  ofi: enable build of profile provider")
    list(APPEND OFI_EXTRA_FLAGS --enable-profile)
else()
    list(APPEND OFI_EXTRA_FLAGS --disable-profile)
endif()

if (OFI_PSM2 OR psm2 IN_LIST OFI_OPT_PROVIDERS)
    message(STATUS "  ofi: enable build of psm2 provider")
    list(APPEND OFI_OPT_DEPENDS psm2)
    include(umbrella/psm2)
    list(APPEND OFI_EXTRA_FLAGS --enable-psm2)
else()
    list(APPEND OFI_EXTRA_FLAGS --disable-psm2)
endif()

if (OFI_PSM3 OR psm3 IN_LIST OFI_OPT_PROVIDERS)
    message(STATUS "  ofi: enable build of psm3 provider")
    if (NOT TARGET libuuid)
        list(APPEND OFI_OPT_DEPENDS libuuid)
        include(umbrella/libuuid)
    endif ()
    list(APPEND OFI_EXTRA_FLAGS --enable-psm3)
else()
    list(APPEND OFI_EXTRA_FLAGS --disable-psm3)
endif()

if (OFI_VERBS OR verbs IN_LIST OFI_OPT_PROVIDERS)
    message(STATUS "  ofi: enable build of verbs provider")
    list(APPEND OFI_OPT_DEPENDS rdma-core)
    include(umbrella/rdma-core)
    list(APPEND OFI_EXTRA_FLAGS --enable-verbs)
else()
    list(APPEND OFI_EXTRA_FLAGS --disable-verbs)
endif()

if (OFI_UCX OR ucx IN_LIST OFI_OPT_PROVIDERS)
    message(STATUS "  ofi: enable build of ucx provider")
    list(APPEND OFI_OPT_DEPENDS ucx)
    include(umbrella/ucx)
    list(APPEND OFI_EXTRA_FLAGS --enable-ucx)
else()
    list(APPEND OFI_EXTRA_FLAGS --disable-ucx)
endif()

#
# link Debug build type to ofi --enable-debug config flag
#
unset (OFI_DEBUG)
if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    message(STATUS "  OFI debug enabled (via debug build type)")
    list(APPEND OFI_EXTRA_FLAGS --enable-debug)
endif ()

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (OFI_DOWNLOAD ofi ${OFI_TAR}
                   GIT_REPOSITORY ${OFI_REPO}
                   GIT_TAG ${OFI_TAG})
umbrella_patchcheck (OFI_PATCHCMD ofi)

#
# create ofi target
#
ExternalProject_Add (ofi DEPENDS ${OFI_OPT_DEPENDS}
    ${OFI_DOWNLOAD} ${OFI_PATCHCMD}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure ${UMBRELLA_COMP}
                      ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                      --prefix=${CMAKE_INSTALL_PREFIX}
                      ${OFI_EXTRA_FLAGS}
    UPDATE_COMMAND "")

#
# add extra autogen prepare step
#
ExternalProject_Add_Step (ofi prepare
    COMMAND ${UMBRELLA_PREFIX}/ensure-autogen <SOURCE_DIR>/autogen.sh
    COMMENT "preparing source for configure"
    DEPENDEES update
    DEPENDERS configure
    WORKING_DIRECTORY <SOURCE_DIR>)

endif (NOT TARGET ofi)
