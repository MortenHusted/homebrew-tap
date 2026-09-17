class AikidoRs < Formula
  desc "Unofficial Aikido Security CLI — issues, repos, and containers from the terminal."
  homepage "https://github.com/MortenHusted/aikido-rs"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/aikido-rs/releases/download/v0.1.0/aikido-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4106f2d35f9a12eac1f06c42e525b4655d4bf729832a19ea4e816d61ac992911"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/aikido-rs/releases/download/v0.1.0/aikido-cli-x86_64-apple-darwin.tar.xz"
      sha256 "548bb1d6790241ea16054f1a6ce5eed5b067c6b0f550f13988ad047da304e7f6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/aikido-rs/releases/download/v0.1.0/aikido-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ea880cca8288672d3faa076c0da11ea9ed33ce5e8ca89e4b86e504dce82e4f05"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/aikido-rs/releases/download/v0.1.0/aikido-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1051a878ae8c111a7cf58d9275ae829c98605cadca83adab3ac19637b2884306"
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
      bin.install "aikido"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "aikido"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "aikido"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "aikido"
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
