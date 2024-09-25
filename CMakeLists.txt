cmake_minimum_required (VERSION 3.13.0) # The minimum CMake version is chosen to enable policy CMP0079
project (bc7e)

set(libname bc7e)

if(MSVC)
    set(ISPC, "./ispc.exe")
else()
    set(ISPC, "ispc")
endif()

set(LIB_HEADERS
    bc7e_ispc_avx2.h
    bc7e_ispc_avx.h
    bc7e_ispc.h
    bc7e_ispc_sse2.h
    bc7e_ispc_sse4.h)

set(LIB_OBJECTS
    bc7e.obj
    bc7e_sse2.obj
    bc7e_sse4.obj
    bc7e_avx.obj
    bc7e_avx2.obj)

add_custom_command(
    OUTPUT ${LIB_HEADERS} ${LIB_OBJECTS}
    COMMAND "${ISPC}" "-g" "-O2" "${CMAKE_CURRENT_SOURCE_DIR}/bc7e.ispc"
    "-o" "bc7e.obj"
    "-h" "bc7e_ispc.h"
    "--target=sse2,sse4,avx,avx2"
    "--opt=fast-math"
    "--opt=disable-assertions"
    DEPENDS "bc7e.ispc")

add_library(${libname} STATIC bc7e.ispc ${LIB_HEADERS} ${LIB_OBJECTS})
#target_sources(${libname}
#    PUBLIC FILE_SET HEADERS
#    BASE_DIRS ${CMAKE_BINARY_DIR} FILES ${LIB_HEADERS}
#)
#install(TARGETS ${libname} FILE_SET HEADERS)
