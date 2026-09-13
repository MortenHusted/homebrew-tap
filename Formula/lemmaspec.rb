class Lemmaspec < Formula
  desc "Typed, deterministic specifications compiled to deductive logic"
  homepage "https://github.com/MortenHusted/lemmaspec"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.3.0/lemmaspec-aarch64-apple-darwin.tar.xz"
      sha256 "e4512b7119c2ed56d8986714507585e5208cc0ed261591e7a7822001a4ede08d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.3.0/lemmaspec-x86_64-apple-darwin.tar.xz"
      sha256 "07d4104c3e90dab5872814accc5b9411f1772d301f7097f9f8467ff31399d28c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.3.0/lemmaspec-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0bb38657da83dd7ac4e9c2c7a603a5d9c3fb216fcc5619a1ce6986cfcb1effe0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.3.0/lemmaspec-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "125ee0af5c620e45a1f0eae53e70e8b2fbbccdcbb98e58f3cf356311ca49e863"
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
