class Lemmaspec < Formula
  desc "Typed, deterministic specifications compiled to deductive logic"
  homepage "https://github.com/MortenHusted/lemmaspec"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.1.0/lemmaspec-aarch64-apple-darwin.tar.xz"
      sha256 "05791db1f4eb9898a9deb0358641e45d684592716270d9d1c6d0b5b18f6d277b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.1.0/lemmaspec-x86_64-apple-darwin.tar.xz"
      sha256 "031b075a9e07c6e353676ba3bff9393e8da640ae56228d07fee9651947a89887"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.1.0/lemmaspec-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bb2c64f63e1b0c7c61f383e74cee00a7b31368dc242a84ef48658dcb1a9df280"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.1.0/lemmaspec-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "721253b0e5c78f0db3c58bb2ff74f69f98d753ec2c6e49e80d993b3654c6fa6d"
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
end
