SET (CMAKE_BASE_FLAGS   "-march=native -fno-omit-frame-pointer -fPIC -I/usr/local/include -Weverything -Wno-c++98-compat -Wno-header-hygiene -Wno-shadow -Wno-exit-time-destructors") #-Wall -Wextra -Woverloaded-virtual -Winline")
SET (CMAKE_C_COMPILER /usr/bin/clang)
SET (CMAKE_C_FLAGS          "-std=c99 -march=native -Winline")
SET (CMAKE_CXX_COMPILER /usr/bin/clang++)
SET (CMAKE_CXX_FLAGS        "-std=c++11 ${CMAKE_BASE_FLAGS}")
SET (CMAKE_INCLUDE_SYSTEM_FLAG_CXX "isystem")

set (CMAKE_C_FLAGS          "${CMAKE_C_FLAGS}" CACHE STRING "c flags")
set (CMAKE_CXX_FLAGS        "${CMAKE_CXX_FLAGS}" CACHE STRING "c++ flags")
SET (CMAKE_EXPORT_COMPILE_COMMANDS 1)
set (CMAKE_EXPORT_COMPILE_COMMANDS "${CMAKE_EXPORT_COMPILE_COMMANDS}" CACHE STRING "export compile_commands.json")

IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Release CACHE STRING
      "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel."
      FORCE)
ENDIF(NOT CMAKE_BUILD_TYPE)
set (CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE}" CACHE STRING "build type")
