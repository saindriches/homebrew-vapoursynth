class Delogohd < Formula
  desc "Delogo filter for VapourSynth"
  homepage "https://github.com/HomeOfAviSynthPlusEvolution/DelogoHD"
  url "https://github.com/saindriches/DelogoHD/archive/refs/tags/r12b.tar.gz"
  version "12"
  sha256 "074d93f9504ce31387f772be6323378bc4f7dcc66fc0455de6673a60e4c49a1f"
  license "GPL-2.0-only"
  head "https://github.com/HomeOfAviSynthPlusEvolution/DelogoHD.git", branch: "master"

  depends_on "cmake" => :build

  on_arm do
    depends_on "sse2neon" => :build
  end

  patch :DATA

  def install
    lib.mkpath
    (lib/"vapoursynth").mkpath

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cp shared_library("libDelogoHD").to_s, lib/"vapoursynth/"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index d9ee846..b3b9d54 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -1,22 +1,28 @@
 cmake_minimum_required (VERSION 3.1)
 project (DelogoHD)
-file(GLOB API_FILES ${PROJECT_SOURCE_DIR}/*_interface.cpp)
+file(GLOB API_FILES ${PROJECT_SOURCE_DIR}/vs_interface.cpp)
 file(GLOB CORE_FILES ${PROJECT_SOURCE_DIR}/delogo_engine.*.cpp)
 add_library(DelogoHD SHARED ${API_FILES} ${CORE_FILES} version.rc)
 find_package(Git)
-if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
-  set_target_properties(DelogoHD PROPERTIES COMPILE_FLAGS "-msse4.1")
-elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
-  set_target_properties(DelogoHD PROPERTIES COMPILE_FLAGS "-msse4.1")
-elseif(CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
-  set_target_properties(DelogoHD PROPERTIES COMPILE_FLAGS "-msse4.1 -std=c++17")
-elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
-  set_target_properties(DelogoHD PROPERTIES COMPILE_FLAGS "/arch:SSE4.1")
+if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|amd64|AMD64")
+  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
+    set_target_properties(DelogoHD PROPERTIES COMPILE_FLAGS "-msse4.1")
+  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
+    set_target_properties(DelogoHD PROPERTIES COMPILE_FLAGS "-msse4.1")
+  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
+    set_target_properties(DelogoHD PROPERTIES COMPILE_FLAGS "-msse4.1 -std=c++17")
+  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
+    set_target_properties(DelogoHD PROPERTIES COMPILE_FLAGS "/arch:SSE4.1")
+  else()
+    set_target_properties(DelogoHD PROPERTIES COMPILE_FLAGS "/arch:SSE2")
+  endif()
+elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64")
+  set(USE_SSE2NEON 1)
+    set_target_properties(DelogoHD PROPERTIES COMPILE_FLAGS "-march=armv8-a+fp+simd+crypto+crc -std=c++17")
 else()
-  set_target_properties(DelogoHD PROPERTIES COMPILE_FLAGS "/arch:SSE2")
+  message(WARNING "Value of CMAKE_SYSTEM_PROCESSOR (${CMAKE_SYSTEM_PROCESSOR}) is unsupported")
 endif()
-execute_process(COMMAND ${GIT_EXECUTABLE} describe --first-parent --tags --always OUTPUT_VARIABLE GIT_REPO_VERSION)
-string(REGEX REPLACE "(r[0-9]+).*" "\\1" VERSION ${GIT_REPO_VERSION})
+set(VERSION "r12")
 configure_file (
   "${PROJECT_SOURCE_DIR}/version.hpp.in"
   "${PROJECT_SOURCE_DIR}/version.hpp"
@@ -28,5 +34,5 @@ configure_file (
 include_directories(include)
 add_custom_command(
   TARGET DelogoHD POST_BUILD
-  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:DelogoHD> "../Release_${VERSION}/${_DIR}/$<TARGET_FILE_NAME:DelogoHD>"
+  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:DelogoHD> "../$<TARGET_FILE_NAME:DelogoHD>"
 )
diff --git a/delogo_engine.hpp b/delogo_engine.hpp
index 921d353..0822c88 100644
--- a/delogo_engine.hpp
+++ b/delogo_engine.hpp
@@ -9,10 +9,14 @@
 #include <cstdlib>
 #include <assert.h>
 
-#if _MSC_VER
-  #include <intrin.h>
-#else
-  #include <x86intrin.h>
+#if (defined(__i386__) || defined(__x86_64__))
+ #if _MSC_VER
+   #include <intrin.h>
+ #else
+   #include <x86intrin.h>
+ #endif
+#elif (defined(__aarch64__) || defined(__arm64__))
+  #include "sse2neon.h"
 #endif
 
 #if !_WIN32
