class LSmash < Formula
  desc "Cross-platform library that handles the ISO Base Media file format"
  homepage "https://l-smash.github.io/l-smash"
  url "https://github.com/vimeo/l-smash/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "9a2ae612e3d84116225725013cda2a6e996f65767d923fc07bb67025de9d2215"
  license "ISC"
  revision 1
  head "https://github.com/vimeo/l-smash.git", branch: "master"

  bottle do
    root_url "https://github.com/saindriches/homebrew-vapoursynth/releases/download/l-smash-2.18.0"
    sha256 cellar: :any,                 arm64_ventura: "002dac9ec065cadfd7574227b13132d5a910f3c1c9bf263a2a0193b577877a61"
    sha256 cellar: :any,                 ventura:       "c9549624924d1be8f5f3c488b0c26b886158eba0c47bbc477a767cb258af5441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7533e738dcc34ec0331ae96cd928762a24e0a9606c28dab62448cf07ae059a1"
  end

  depends_on "saindriches/vapoursynth/obuparse"

  def install
    ENV.append_to_cflags "-fPIC" if OS.linux?

    system "./configure", "--prefix=#{prefix}", "--extra-cflags=#{ENV.cflags}"
    system "make", "install"
  end
end
