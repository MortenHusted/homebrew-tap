class Stele < Formula
  desc "Deterministic code facts and executable specifications"
  homepage "https://github.com/MortenHusted/stele"
  url "https://github.com/MortenHusted/stele/releases/download/v0.6.0/stele-0.6.0-aarch64-apple-darwin.tar.gz"
  sha256 "ab90f3706a412b64d91039d9fc26742a9271f14b8b149e1ce5773d29e5583e4b"
  license :cannot_represent

  depends_on arch: :arm64
  depends_on "git"
  depends_on :macos

  resource "ruby-tool-bundle" do
    url "https://github.com/MortenHusted/stele/archive/refs/tags/v0.6.0.tar.gz"
    sha256 "7c6c2179c09ec9c8617ab815e0700e95464896bf70d52c856e45439da023a761"
  end

  def install
    bin.install "stele"
    pkgshare.install "LICENSE", "NOTICE", "THIRD_PARTY_NOTICES.md", "THIRD_PARTY_INVENTORY.json",
                     "BUILD.json", "licenses"
    resource("ruby-tool-bundle").stage do
      (pkgshare/"ruby").install "toolchain/ruby/Gemfile", "toolchain/ruby/Gemfile.lock"
      (pkgshare/"marketplace").install ".claude-plugin", ".agents", "plugins"
    end
  end

  def caveats
    <<~EOS
      Stele uses a source-available license. See:
        #{pkgshare}/LICENSE

      Verified Ruby calls require a separate Ruby/Bundler tool bundle.
      Copy #{pkgshare}/ruby/Gemfile and Gemfile.lock to a writable directory,
      install its gems with BUNDLE_GEMFILE set to that Gemfile, then set
      CODEMAP_RUBY_TOOL_BUNDLE to its absolute path when running Stele.

      To give Claude Code and Codex the skills of the installed binary, add
      the marketplace this formula installs:
        claude plugin marketplace add #{opt_pkgshare}/marketplace
        claude plugin install stele@stele
        codex plugin marketplace add #{opt_pkgshare}/marketplace
        codex plugin add stele@stele
      Claude Code reads the plugin in place, so brew upgrade moves it with the
      binary. Codex copies it: run `codex plugin add stele@stele` after an
      upgrade, and keep #{opt_pkgshare}/marketplace as the source in
      ~/.codex/config.toml, since Codex records the versioned Cellar path.
    EOS
  end

  test do
    assert_match "stele #{version}", shell_output("#{bin}/stele --version")
    (testpath/"example.stele").write <<~STELE
      spec example {
        relation ready { args: [symbol] }
        fact input { relation: ready args: [sample] }
        expect available { query: "ready(sample)" count: 1 }
      }
    STELE
    system bin/"stele", "spec", "walk", testpath/"example.stele"
    assert_path_exists pkgshare/"licenses"
    assert_path_exists pkgshare/"ruby/Gemfile.lock"
    assert_path_exists pkgshare/"marketplace/.claude-plugin/marketplace.json"
    assert_path_exists pkgshare/"marketplace/.agents/plugins/marketplace.json"
    assert_path_exists pkgshare/"marketplace/plugins/stele/skills/stele/SKILL.md"
  end
end
