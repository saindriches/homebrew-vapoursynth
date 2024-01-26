class Fft3dfilter < Formula
  desc "VapourSynth port of FFT3DFilter"
  homepage "https://github.com/myrsloik/VapourSynth-FFT3DFilter"
  url "https://github.com/myrsloik/VapourSynth-FFT3DFilter/archive/refs/tags/R2.tar.gz"
  sha256 "d6656e265da213bb396bab5cc0455522c491494cd2954a54c013788323e231f1"
  license "GPL-2.0-only"
  head "https://github.com/myrsloik/VapourSynth-FFT3DFilter.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "vapoursynth"

  patch :DATA

  def install
    lib.mkpath
    (lib/"vapoursynth").mkpath

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    cd "build" do
      cp shared_library("libfft3dfilter").to_s, lib/"vapoursynth/"
    end
  end
end

__END__
diff --git a/meson.build b/meson.build
index c8f6cec..8a95495 100644
--- a/meson.build
+++ b/meson.build
@@ -43,5 +43,5 @@ endif
 shared_module('fft3dfilter', sources,
   dependencies : deps,
   install : true,
-  install_dir : join_paths(vapoursynth_dep.get_pkgconfig_variable('libdir'), 'vapoursynth')
+#  install_dir : join_paths(vapoursynth_dep.get_pkgconfig_variable('libdir'), 'vapoursynth')
 )
