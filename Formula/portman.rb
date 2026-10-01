class Portman < Formula
  desc "portman: local-dev DNS, proxy, and service runner (CLI + daemon)"
  homepage "https://github.com/MortenHusted/portman"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.3/portman-aarch64-apple-darwin.tar.xz"
      sha256 "8cf34724c82df04c75da6fb15bb5b451e33ee441b9aa362924abfc6da50ca1dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.3/portman-x86_64-apple-darwin.tar.xz"
      sha256 "3565dd3b0042ffd89093517610fa69e8dc811564bc012d1b8b283d6a3e2d211c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.3/portman-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "49eb9f5365c9ff73ba0498831fc7aa80d2a56ca88f5116878d5e65cbe5ad22a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.3/portman-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "21c66464396ae4d04c735bced659c698803bc86c5737b620fa5048a1b4a09cc9"
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
