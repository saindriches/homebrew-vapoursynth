class Obuparse < Formula
  desc "Simple and portable single file AV1 OBU parser"
  homepage "https://github.com/dwbuiten/obuparse"
  url "https://github.com/saindriches/obuparse/archive/refs/tags/v20240118.tar.gz"
  sha256 "5c13d4061469543c0232d09be452a268e468e5dcb883b23e2faf6f81b3c8ccac"
  license "ISC"
  head "https://github.com/dwbuiten/obuparse.git", branch: "master"

  bottle do
    root_url "https://github.com/saindriches/homebrew-vapoursynth/releases/download/obuparse-20240118"
    sha256 cellar: :any,                 ventura:      "9849b77710d50da9aac5cfa36178db9fba9b201331fe3b08d417ee62d793ea8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b1d2853bc803112529dd916d6f308ef662f5350759bcbae67daed414437018f8"
  end

  patch :DATA if OS.mac?

  def install
    system "make", "install", "PREFIX=#{prefix}"
    system "make", "install-tools", "PREFIX=#{prefix}"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 8643bac..527e26b 100644
--- a/Makefile
+++ b/Makefile
@@ -10,8 +10,7 @@ ifneq (,$(findstring mingw,$(CC)))
 	EXESUF=.exe
 	SYSTEM=MINGW
 else
-	LIBSUF=.so
-	LDFLAGS=-Wl,--version-script,obuparse.v
+	LIBSUF=.dylib
 endif

 all: libobuparse$(LIBSUF) libobuparse.a
@@ -36,8 +35,7 @@ install-header:
 install-shared: libobuparse$(LIBSUF) install-header
 	@install -d $(PREFIX)/lib
 ifneq ($(SYSTEM),MINGW)
-	@install -v libobuparse$(LIBSUF) $(PREFIX)/lib/libobuparse$(LIBSUF).1
-	@ln -sv libobuparse$(LIBSUF).1 $(PREFIX)/lib/libobuparse$(LIBSUF)
+	@install -v libobuparse$(LIBSUF) $(PREFIX)/lib/libobuparse$(LIBSUF)
 else
 	@install -d $(PREFIX)/bin
 	@install -v libobuparse$(LIBSUF) $(PREFIX)/bin/libobuparse$(LIBSUF)
@@ -51,7 +49,6 @@ uninstall:
 	@rm -fv $(PREFIX)/include/obuparse.h
 	@rm -fv $(PREFIX)/lib/libobuparse.a
 ifneq ($(SYSTEM),MINGW)
-	@rm -fv $(PREFIX)/lib/libobuparse$(LIBSUF).1
 	@rm -fv $(PREFIX)/lib/libobuparse$(LIBSUF)
 else
 	@rm -fv $(PREFIX)/bin/libobuparse$(LIBSUF)
