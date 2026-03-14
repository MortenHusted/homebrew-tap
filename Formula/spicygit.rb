class Spicygit < Formula
  desc "Terminal UI for git-spice — manage stacked branches and PRs"
  homepage "https://github.com/MortenHusted/spicygit"
  url "https://github.com/MortenHusted/spicygit/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "e54a07ec8f395428d38221f5c757c4b9eb4cb05b37944b847edbefbc2dd44f19"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # spicygit exits non-zero when not in a git repo
    assert_match "", shell_output("#{bin}/spicygit 2>&1", 1)
  end
end
