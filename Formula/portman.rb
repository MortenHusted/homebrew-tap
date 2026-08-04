class Portman < Formula
  desc "portman: local-dev DNS, proxy, and service runner (CLI + daemon)"
  homepage "https://github.com/MortenHusted/portman"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.0/portman-aarch64-apple-darwin.tar.xz"
      sha256 "2893a8c47be0b6477178691a3dc296b833682378381f2efbef523b2279e18403"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.0/portman-x86_64-apple-darwin.tar.xz"
      sha256 "fc8616a2c2925778f6ae29640a84138aeb8c28400bfdef43cd709e933511b43d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.0/portman-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ff2554e7f8bf197ab8ae579533d42d4fb3dac50053e63a584f66b97d08172e22"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.0/portman-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e89edcc3c3671c16f020394aa251d27c1344ab42377fce0f069be46de7d70bcf"
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
    bin.install "portman", "portman-daemon" if OS.mac? && Hardware::CPU.arm?
    bin.install "portman", "portman-daemon" if OS.mac? && Hardware::CPU.intel?
    bin.install "portman", "portman-daemon" if OS.linux? && Hardware::CPU.arm?
    bin.install "portman", "portman-daemon" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
