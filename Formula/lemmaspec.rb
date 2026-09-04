class Lemmaspec < Formula
  desc "Typed, deterministic specifications compiled to deductive logic"
  homepage "https://github.com/MortenHusted/lemmaspec"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.2.0/lemmaspec-aarch64-apple-darwin.tar.xz"
      sha256 "e79920cbf8711b549671c1ff1a560ed0fb659625b936b1c0bed0bce79d1fb4ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.2.0/lemmaspec-x86_64-apple-darwin.tar.xz"
      sha256 "9e91e3de7b50ebc98b3b3eef1ab45916a73cbee589ebd21a6d370ed74d874d40"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.2.0/lemmaspec-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e523d2f9a1528a8000d40d0a797103c6010ff10de9f897d911c4c1f15bb3922d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.2.0/lemmaspec-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7b4436efbe50b41057cad9f34eeda3ed3ea2e13b74c6edbe52df5b1f698884ea"
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
    bin.install "lemmaspec" if OS.mac? && Hardware::CPU.arm?
    bin.install "lemmaspec" if OS.mac? && Hardware::CPU.intel?
    bin.install "lemmaspec" if OS.linux? && Hardware::CPU.arm?
    bin.install "lemmaspec" if OS.linux? && Hardware::CPU.intel?

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
