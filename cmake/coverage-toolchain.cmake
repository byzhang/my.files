SET (CMAKE_BASE_FLAGS   "-march=native -fno-omit-frame-pointer -fPIC -I/usr/local/include -Wall -Wextra -Wcast-align -Wcast-qual -Wctor-dtor-privacy -Wformat=2 -Winit-self -Wlogical-op -Wmissing-declarations -Wmissing-include-dirs -Wnoexcept -Wold-style-cast -Woverloaded-virtual -Wredundant-decls -Wstrict-null-sentinel -Wstrict-overflow=5 -Wundef -Wuseless-cast -Wzero-as-null-pointer-constant")
SET (CMAKE_COVERAGE_FLAGS "-coverage -g -O0 -fno-inline -fno-inline-small-functions -fno-default-inline")
SET (CMAKE_C_COMPILER   /usr/bin/gcc)
SET (CMAKE_C_FLAGS      "-std=c99 -march=native ${CMAKE_COVERAGE_FLAGS}")
SET (CMAKE_CXX_COMPILER /usr/bin/g++)
SET (CMAKE_CXX_FLAGS    "-std=c++11 ${CMAKE_BASE_FLAGS} ${CMAKE_COVERAGE_FLAGS}")
SET (CMAKE_INCLUDE_SYSTEM_FLAG_CXX "isystem")

set (CMAKE_C_FLAGS          "${CMAKE_C_FLAGS}" CACHE STRING "c flags")
set (CMAKE_CXX_FLAGS        "${CMAKE_CXX_FLAGS}" CACHE STRING "c++ flags")
SET (CMAKE_EXPORT_COMPILE_COMMANDS 1)
set (CMAKE_EXPORT_COMPILE_COMMANDS "${CMAKE_EXPORT_COMPILE_COMMANDS}" CACHE STRING "export compile_commands.json")

IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Debug CACHE STRING
      "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel."
      FORCE)
ENDIF(NOT CMAKE_BUILD_TYPE)
set (CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE}" CACHE STRING "build type")
