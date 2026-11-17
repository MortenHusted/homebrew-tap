class Portman < Formula
  desc "portman: local-dev DNS, proxy, and service runner (CLI + daemon)"
  homepage "https://github.com/MortenHusted/portman"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.7/portman-aarch64-apple-darwin.tar.xz"
      sha256 "8ff9738c6570bb20a1daa5d45b9e8362a621fb0f22964d99a41524f3fe10eb56"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.7/portman-x86_64-apple-darwin.tar.xz"
      sha256 "49b392cf3116fc45af56f6e0c4bcad38030466c281d9211a87a493d69817ebaf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.7/portman-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2802f9bb3e2dbfe38d9528d593c6c2c16772998d6cb90d753ee85918a701e51d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.7/portman-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b6775afa04cf3b304508d206b276b602c4c520ba6c218b24577adad64874730e"
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
