option(USE_SANITIZER "Using the GCC sanitizer" OFF)

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang")
#####################################################
  message( "${Gn}Detected AppleClang compiler (MacOS, iOS)${Na}" )
  add_definitions( "-O3 -fvisibility=hidden -fPIC" )
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
####################################################
  message( STATUS "${Gn}Detected Clang compiler (Android)${Na}" )
  add_definitions( "-O3 -fvisibility=hidden -fPIC" )
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-z,defs -Wl")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
##################################################
  message( STATUS "${Gn}Detected GNU compiler (Windows, Linux)${Na}" )
  if( USE_SANITIZER )
    message( STATUS "${Pk}Configure diagnostic build with GCC sanitizer${Na}")
    add_definitions( "-O0 -fvisibility=hidden -Wno-unused-variable -Wno-unused-but-set-variable  -fsanitize=address -fno-omit-frame-pointer -static-libasan" )
  else()
    add_definitions( "-O3 -fvisibility=hidden -Wno-unused-variable -Wno-unused-but-set-variable" )
  endif()
  if("${TARGET_PLATFORM}" MATCHES "win*")
    add_definitions("-DWIN32 -D_WIN32")
  else()
    add_definitions("-DLINUX -fPIC")
  endif()
  if("${TARGET_PLATFORM}" MATCHES "win*")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -static-libgcc -static-libstdc++ -Wl,-add-stdcall-alias -Wl,-enable-stdcall-fixup")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static-libgcc -static-libstdc++ -Wl,-enable-stdcall-fixup")
  elseif("${TARGET_PLATFORM}" MATCHES "linux*")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -static-libgcc -static-libstdc++ -Wl,-z,defs")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static-libgcc -static-libstdc++")
  endif()
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
  message( STATUS "${Gn}Detected MSVC compiler (Windows)${Na}" )
  add_definitions( "/W3 /D_CRT_SECURE_NO_WARNINGS /nologo /MT" )
else()
  message( STATUS "${Rd}Detected compiler ${CMAKE_CXX_COMPILER_ID} which is currently not supported${Na}" )
endif()

if( 32BITS)
  set( CMAKE_C_FLAGS "-m32")
  set( CMAKE_CXX_FLAGS "-m32") 
elseif( 64BITS)
  set( CMAKE_C_FLAGS "-m64")
  set( CMAKE_CXX_FLAGS "-m64") 
endif()

if(CMAKE_HOST_WIN32 AND MINGW)
  set(CMAKE_RC_COMPILER_INIT windres)
  ENABLE_LANGUAGE(RC)
  SET(CMAKE_RC_COMPILE_OBJECT "<CMAKE_RC_COMPILER> <DEFINES> -o <OBJECT> <SOURCE>")
endif(CMAKE_HOST_WIN32 AND MINGW)
