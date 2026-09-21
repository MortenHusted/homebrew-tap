class Lemmaspec < Formula
  desc "Typed, deterministic specifications compiled to deductive logic"
  homepage "https://github.com/MortenHusted/lemmaspec"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.3.1/lemmaspec-aarch64-apple-darwin.tar.xz"
      sha256 "6ae0bba94a7f30b8a4d16d93d2b9fbb6a017148113e6f25fafa51256fb3a000a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.3.1/lemmaspec-x86_64-apple-darwin.tar.xz"
      sha256 "39d09efb31aadf3e07a86183f97641640f8e9540f095fe1920f962678578e854"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.3.1/lemmaspec-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "79df40e4f54d27633f6f1d4c66828f06b0b099626fbcc66595821638b6389ac7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.3.1/lemmaspec-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f63d06bb045895012ae0436376332c0e7d9cc16005bd4ae7951f03db4870585a"
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
