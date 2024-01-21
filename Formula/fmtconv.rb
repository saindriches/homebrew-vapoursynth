class Fmtconv < Formula
  desc "Format conversion tools for Vapoursynth and Avisynth+"
  homepage "https://forum.doom9.org/showthread.php?t=166504"
  url "https://gitlab.com/EleonoreMizo/fmtconv/-/archive/r30/fmtconv-r30.tar.gz"
  sha256 "96afa0bd073addd2982263c7cee8b750050cf01bc57671a77a20532f7482a488"
  license "WTFPL"
  head "https://gitlab.com/EleonoreMizo/fmtconv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^r(\d+(?:\.\d+)*?)$/i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    cd "build/unix" do
      system "./autogen.sh"
      system "./configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"

      mkdir lib/"vapoursynth"
      (lib/"vapoursynth").install_symlink lib/shared_library("libfmtconv").to_s
    end
  end

  def caveats
    <<~EOS
      +-------------------------------------------------------------+
      | Not all functions work properly on Apple Silicon as of now. |
      +-------------------------------------------------------------+
    EOS
  end
end
