class AikidoMcp < Formula
  desc "Unofficial Aikido Security MCP server over the shared aikido-core client."
  homepage "https://github.com/MortenHusted/aikido-rs"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/aikido-rs/releases/download/v0.1.0/aikido-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "90a8b95ef26715cb01a437c8df50f3940471d7b43110cd5c991437c0a1b5dcec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/aikido-rs/releases/download/v0.1.0/aikido-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "b4d5d165c61bcbe7f06b8e1a8fbb16fa45af0a853c9aeeed03bb67a861561fd8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MortenHusted/aikido-rs/releases/download/v0.1.0/aikido-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aca6a6d67aebe696249450521ec7831cd9e8d748e2b6e06c83203ac7d01f2209"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MortenHusted/aikido-rs/releases/download/v0.1.0/aikido-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6b5c0428985ce624eb1b13dd657742aa7d5c6d822e4c31b47236b050ed1769ae"
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
      bin.install "aikido-mcp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "aikido-mcp"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "aikido-mcp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "aikido-mcp"
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
