class Dovi < Formula
  desc "Library to read & write Dolby Vision metadata"
  homepage "https://github.com/quietvoid/dovi_tool"
  url "https://github.com/quietvoid/dovi_tool/archive/refs/tags/2.1.0.tar.gz"
  sha256 "06b7332649959710ec00e25a9b4e4a88ee7766149726d6e2f60c3b5bb6292664"
  license "MIT"
  head "https://github.com/quietvoid/dovi_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "rust" => :build

  def install
    cd "dolby_vision" do
      system "cargo", "install", "cargo-c"
      system "cargo", "cinstall", "--prefix=#{prefix}"
    end
  end
end
