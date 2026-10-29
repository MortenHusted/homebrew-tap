class Stele < Formula
  desc "Deterministic code facts and executable specifications"
  homepage "https://github.com/MortenHusted/stele"
  url "https://github.com/MortenHusted/stele/releases/download/v0.5.7/stele-0.5.7-aarch64-apple-darwin.tar.gz"
  sha256 "10840bd1b4f22d9e799120782fc0fa128d2024b7430a460b8b5aa46c4407c67c"
  license :cannot_represent

  depends_on arch: :arm64
  depends_on "git"
  depends_on :macos

  resource "ruby-tool-bundle" do
    url "https://github.com/MortenHusted/stele/archive/refs/tags/v0.5.7.tar.gz"
    sha256 "1638f637bea4f63cc37d598ab8764753ed2067d67c39813d69a007c55238013c"
  end

  def install
    bin.install "stele"
    pkgshare.install "LICENSE", "NOTICE", "THIRD_PARTY_NOTICES.md", "THIRD_PARTY_INVENTORY.json",
                     "BUILD.json", "licenses"
    resource("ruby-tool-bundle").stage do
      (pkgshare/"ruby").install "toolchain/ruby/Gemfile", "toolchain/ruby/Gemfile.lock"
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
  end
end
