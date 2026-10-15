class Portman < Formula
  desc "portman: local-dev DNS, proxy, and service runner (CLI + daemon)"
  homepage "https://github.com/MortenHusted/portman"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.4/portman-aarch64-apple-darwin.tar.xz"
      sha256 "d6c32e13171677815272e36780af40984ce23c952062cd00f74cd1fcc1c27392"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.4/portman-x86_64-apple-darwin.tar.xz"
      sha256 "bd5f264f3bd7ddcf65294dd38ac10902aa02e375effe451851477fbcb78cb994"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.4/portman-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "128a363b6a995200f2d8b1fbb4662dddcf61450b52e76c0f4b379ebeac5a1156"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.4/portman-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "36e93db238d8341554836b94079ddd1437b0cea647316b71f437ba7b87f09ee4"
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
