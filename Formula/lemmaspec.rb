class Lemmaspec < Formula
  desc "Typed, deterministic specifications compiled to deductive logic"
  homepage "https://github.com/MortenHusted/lemmaspec"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.4.1/lemmaspec-aarch64-apple-darwin.tar.xz"
      sha256 "4bcca02c28861e3b4b5a005f4d985868cd26c1f05c5fee71d3dbac756c115466"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.4.1/lemmaspec-x86_64-apple-darwin.tar.xz"
      sha256 "3ae54a119cdcecfc5ad3e8966bf78d76c60bbe1519a60e4e46aa91c910b9cb04"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.4.1/lemmaspec-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "85a3719426668aa7e24a2011207c6c249b7e50ed76e135502a98bca7258d339f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/lemmaspec/releases/download/v0.4.1/lemmaspec-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "12d81fa495af465ed9c2bbbbf0ca3f7cf72cdea32195a43cc37e85393958efce"
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
