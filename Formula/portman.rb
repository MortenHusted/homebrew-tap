class Portman < Formula
  desc "portman: local-dev DNS, proxy, and service runner (CLI + daemon)"
  homepage "https://github.com/MortenHusted/portman"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.8/portman-aarch64-apple-darwin.tar.xz"
      sha256 "57a724542560415a0b4a6ad51f9dbfbf9fbe4c89972981716b31943d8ee25c5d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.8/portman-x86_64-apple-darwin.tar.xz"
      sha256 "013cfe8dc90b852977f7db3c0cf6e101d118095a988f87d2313c95e903ee23bf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.8/portman-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ba8c23432e0000e77ededa7473637f4e423b395ba293a30781b68b7d66725ff5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.8/portman-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e211ead0b9944f2c5821eb70b5fb5428d46cc69cd6178fefa03b0d71175db91e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
      bin.install "portman", "portman-daemon"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "portman", "portman-daemon"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "portman", "portman-daemon"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "portman", "portman-daemon"
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
