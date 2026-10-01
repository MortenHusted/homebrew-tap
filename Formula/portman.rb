class Portman < Formula
  desc "portman: local-dev DNS, proxy, and service runner (CLI + daemon)"
  homepage "https://github.com/MortenHusted/portman"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.2/portman-aarch64-apple-darwin.tar.xz"
      sha256 "2ad2b441c6f51731edcf83e403f36c0833fbed6228648f60035eb46015652671"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.2/portman-x86_64-apple-darwin.tar.xz"
      sha256 "2b2c2eb99fad163562cf2de54c2f6cb10ae639f77605e9a9238a5c1251889909"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.2/portman-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "11548fef866737b2c125920fe262dc78756deb985d115d9a2da4f43c661fbde1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/portman/releases/download/v0.1.2/portman-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f504b98b60a80d72fe02bc0b665db5e2e9cf34fc29a7dc4ff67da318e4c775a1"
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
