class LSmashWorks < Formula
  desc "Libav source plugin for VapourSynth"
  homepage "https://github.com/HomeOfAviSynthPlusEvolution/L-SMASH-Works"
  url "https://github.com/HomeOfAviSynthPlusEvolution/L-SMASH-Works/archive/refs/tags/1167.0.0.0.tar.gz"
  sha256 "97bff2bfa0af6a9b6b172dc8945814532237e9f03642c8a31e009aca56e14b1c"
  license "ISC"
  head "https://github.com/HomeOfAviSynthPlusEvolution/L-SMASH-Works.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "gcc" => [:build, :recommended]
  depends_on "ninja" => :build
  depends_on "ffmpeg"
  depends_on "saindriches/vapoursynth/l-smash"
  depends_on "vapoursynth"
  depends_on "xxhash"

  fails_with :clang if build.with? "gcc"

  on_arm do
    depends_on "sse2neon" => :build
  end

  # SSE2NEON for arm64
  patch :DATA

  def install
    args = %w[
      -DENABLE_DAV1D=OFF
      -DENABLE_MFX=OFF
      -DENABLE_XML2S=OFF
      -DBUILD_AVS_PLUGIN=OFF
    ]

    system "cmake", "-S", ".", "-B", "build_vs", "-G", "Ninja", *std_cmake_args, *args
    system "cmake", "--build", "build_vs", "-j#{ENV.make_jobs}"
    system "cmake", "--install", "build_vs"
  end
end

__END__
diff --git a/AviUtl/colorspace_simd.c b/AviUtl/colorspace_simd.c
index a20f633..49a7265 100644
--- a/AviUtl/colorspace_simd.c
+++ b/AviUtl/colorspace_simd.c
@@ -30,7 +30,11 @@
 #ifdef __GNUC__
 #pragma GCC target ("ssse3")
 #endif
+#if defined(__aarch64__) || defined(__arm64__)
+#include "sse2neon"
+#else
 #include <tmmintrin.h>
+#endif
 /* SSSE3 version of func convert_yv12i_to_yuy2 */
 void LW_FUNC_ALIGN convert_yv12i_to_yuy2_ssse3
 (
@@ -207,7 +211,11 @@ void LW_FUNC_ALIGN convert_yv12i_to_yuy2_ssse3
 #ifdef __GNUC__
 #pragma GCC target ("sse4.1")
 #endif
+#if defined(__aarch64__) || defined(__arm64__)
+#include "sse2neon"
+#else
 #include <smmintrin.h>
+#endif

 /* the inner loop branch should be deleted by forced inline expansion and "bit_depth" constant propagation. */
 static void LW_FUNC_ALIGN LW_FORCEINLINE convert_yuv420ple_i_to_yuv444p16le_sse41
diff --git a/AviUtl/lwcolor_simd.c b/AviUtl/lwcolor_simd.c
index 5fe8d0b..ccf0d20 100644
--- a/AviUtl/lwcolor_simd.c
+++ b/AviUtl/lwcolor_simd.c
@@ -36,7 +36,11 @@ typedef unsigned short USHORT;
 #ifdef __GNUC__
 #pragma GCC target ("sse4.1")
 #endif
+#if defined(__aarch64__) || defined(__arm64__)
+#include "sse2neon"
+#else
 #include <smmintrin.h>
+#endif

 static LW_FORCEINLINE void fill_rgb_buffer_sse41( BYTE *rgb_buffer, BYTE *lw48_ptr )
 {
diff --git a/common/lwsimd.c b/common/lwsimd.c
index 1fc9274..a61eef8 100644
--- a/common/lwsimd.c
+++ b/common/lwsimd.c
@@ -20,6 +20,28 @@

 /* This file is available under an ISC license. */

+#if defined(__aarch64__) || defined(__arm64__)
+/* Use SSE2NEON */
+int lw_check_sse2()
+{
+    return 1;
+}
+
+int lw_check_ssse3()
+{
+	return 1;
+}
+
+int lw_check_sse41()
+{
+    return 1;
+}
+
+int lw_check_avx2()
+{
+    return 0;
+}
+#else
 #include <stdint.h>

 #ifdef __GNUC__
@@ -78,3 +100,4 @@ int lw_check_avx2()
     }
     return 0;
 }
+#endif
\ No newline at end of file
diff --git a/common/planar_yuv_sse2.c b/common/planar_yuv_sse2.c
index 3209557..610f739 100644
--- a/common/planar_yuv_sse2.c
+++ b/common/planar_yuv_sse2.c
@@ -1,4 +1,8 @@
+#if defined(__aarch64__) || defined(__arm64__)
+#include "sse2neon"
+#else
 #include <emmintrin.h>
+#endif
 #include  <stdint.h>

 static inline __m128i _MM_PACKUS_EPI32(const __m128i* low, const __m128i* high)
