class Stele < Formula
  desc "Deterministic code facts and executable specifications"
  homepage "https://github.com/MortenHusted/stele"
  url "https://github.com/MortenHusted/stele/releases/download/v0.5.11/stele-0.5.11-aarch64-apple-darwin.tar.gz"
  sha256 "9eeb77c7951ba71a12c2f737cc7737c05294966d0466617b0a229937590b28eb"
  license :cannot_represent
  revision 1

  depends_on arch: :arm64
  depends_on "git"
  depends_on :macos

  resource "ruby-tool-bundle" do
    url "https://github.com/MortenHusted/stele/archive/refs/tags/v0.5.11.tar.gz"
    sha256 "b2dfbb70b06a25c1f4700d52a51684c866b4b9b433d94dce3cef458f642e6110"
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
      the marketplace this formula installs; brew upgrade then moves both:
        claude plugin marketplace add #{opt_pkgshare}/marketplace
        claude plugin install stele@stele
        codex plugin marketplace add #{opt_pkgshare}/marketplace
        codex plugin add stele@stele
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
