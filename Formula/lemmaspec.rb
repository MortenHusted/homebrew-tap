class Lemmaspec < Formula
  desc "Typed, deterministic specifications compiled to deductive logic"
  homepage "https://github.com/MortenHusted/lemmaspec"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.4.2/lemmaspec-aarch64-apple-darwin.tar.xz"
      sha256 "a7369555cb4f53d9a20df6fb3e6ed059b47b600fbfbd6e2afc8ba12c64bc12d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.4.2/lemmaspec-x86_64-apple-darwin.tar.xz"
      sha256 "dd40a76039afc2702522a431221f18941eaa16ddfe22f8ffba514dafd7daec5c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.4.2/lemmaspec-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0c71ad09f9583e1e5f2100dc9b4ac8a6b5dfcc3e781c10d281b87f67e3d5a613"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.4.2/lemmaspec-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0d5de5eb64cc6fb9d23e5f22f604bdc959ea5d20cf0d4ff47b09898432ddebe9"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "lemmaspec"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "lemmaspec"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "lemmaspec"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "lemmaspec"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lemmaspec --version")
  end
end
