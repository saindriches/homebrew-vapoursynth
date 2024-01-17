class LSmash < Formula
  desc "Cross-platform library that handles the ISO Base Media file format"
  homepage "https://l-smash.github.io/l-smash"
  url "https://github.com/vimeo/l-smash/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "9a2ae612e3d84116225725013cda2a6e996f65767d923fc07bb67025de9d2215"
  license "ISC"
  head "https://github.com/vimeo/l-smash.git", branch: "master"

  depends_on "saindriches/vapoursynth/obuparse"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
