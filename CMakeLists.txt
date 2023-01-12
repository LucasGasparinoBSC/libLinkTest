# Set the minimun CMake version
cmake_minimum_required(VERSION 3.20)

# Options
option(USE_ACC "Enable use of OpenACC" ON)

# Set the project name and languages
project(libLinkTest LANGUAGES C CXX Fortran)

# Build libraries as shared
set(LIBRARY_TYPE SHARED)

# Set the C/C++ standard
set(CMAKE_C_STANDARD 14)

# Set the default build type to Release
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Set the compiler options
set(CMAKE_C_FLAGS "")
set(CMAKE_C_FLAGS_DEBUG "-g -O0")
set(CMAKE_C_FLAGS_RELEASE "")
set(CMAKE_CXX_FLAGS "")
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0")
set(CMAKE_CXX_FLAGS_RELEASE "")
set(CMAKE_Fortran_FLAGS "")
set(CMAKE_Fortran_FLAGS_DEBUG "-g -O0")
set(CMAKE_Fortran_FLAGS_RELEASE "")
if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
	if(USE_ACC)
		message(FATAL_ERROR "OpenACC not supported with GNU compiler")
	endif()
	# Common GNNU+MPI flags
	set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} "-cpp")
	set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-cpp")
	set(CMAKE_Fortran_FLAGS ${CMAKE_Fortran_FLAGS} "-cpp -ffree-line-length-none")
	# Debug
	set(CMAKE_C_FLAGS_DEBUG ${CMAKE_C_FLAGS_DEBUG} "-Wall -Wextra -Wpedantic")
	set(CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG} "-Wall -Wextra -Wpedantic")
	set(CMAKE_Fortran_FLAGS_DEBUG ${CMAKE_Fortran_FLAGS_DEBUG} "-Wall -Wextra -Wpedantic -fbacktrace -Wconversion-extra -ftrapv -fcheck=all -ffpe-trap=invalid,zero,overflow")
	# Release
	set(CMAKE_C_FLAGS_RELEASE ${CMAKE_C_FLAGS_RELEASE} "-O3 -march=native")
	set(CMAKE_CXX_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE} "-O3 -march=native")
	set(CMAKE_Fortran_FLAGS_RELEASE ${CMAKE_Fortran_FLAGS_RELEASE} "-O3 -march=native")
elseif(CMAKE_C_COMPILER_ID STREQUAL "NVHPC" OR CMAKE_C_COMPILER_ID STREQUAL "PGI")
    message("-- NVHPC compiler detected")
    set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} "-cpp -lstdc++ -cuda -Minfo=accel")
    set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-cpp -lstdc++ -cuda -Minfo=accel")
    set(CMAKE_Fortran_FLAGS ${CMAKE_Fortran_FLAGS} "-cpp -lstdc++ -cuda -Minfo=accel")
    # Debug
    set(CMAKE_C_FLAGS_DEBUG ${CMAKE_C_FLAGS_DEBUG} "-Minform=inform -C -Mbounds -Mchkptr -traceback -Ktrap=fp,unf")
    set(CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG} "-Minform=inform -C -Mbounds -Mchkstk -traceback -Ktrap=fp,unf")
    set(CMAKE_Fortran_FLAGS_DEBUG ${CMAKE_Fortran_FLAGS_DEBUG} "-Minform=inform -C -Mbounds -Mchkstk -traceback -Ktrap=fp,unf")
    # Release
    set(CMAKE_C_FLAGS_RELEASE ${CMAKE_C_FLAGS_RELEASE} "-fast")
    set(CMAKE_CXX_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE} "-fast")
    set(CMAKE_Fortran_FLAGS_RELEASE ${CMAKE_Fortran_FLAGS_RELEASE} "-fast")
    # GPU options
    if(USE_ACC)
        message("Setting up ACC flags with managed memory")
        message("IMPORTANT: Verify the device compute capability!!!")
        set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} "-DUSE_ACC -gpu=cc61,managed,lineinfo,ptxinfo -cuda -acc")
        set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-DUSE_ACC -gpu=cc61,managed,lineinfo,ptxinfo -cuda -acc")
        set(CMAKE_Fortran_FLAGS ${CMAKE_Fortran_FLAGS} "-DUSE_ACC -gpu=cc61,managed,lineinfo,ptxinfo -cuda -acc")
    endif()
endif()
string(REPLACE ";" " " CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
string(REPLACE ";" " " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
string(REPLACE ";" " " CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}")
string(REPLACE ";" " " CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}")
string(REPLACE ";" " " CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}")
string(REPLACE ";" " " CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG}")
string(REPLACE ";" " " CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}")
string(REPLACE ";" " " CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")
string(REPLACE ";" " " CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE}")

# use, i.e. don't skip the full RPATH for the build tree
set(CMAKE_SKIP_BUILD_RPATH FALSE)

# when building, don't use the install RPATH already
# (but later on when installing)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")

# add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# the RPATH to be used when installing, but only if it's not a system directory
list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_PREFIX}/lib" isSystemDir)
if("${isSystemDir}" STREQUAL "-1")
    set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
endif("${isSystemDir}" STREQUAL "-1")

# Add subdirectories with source code
add_subdirectory(sources)