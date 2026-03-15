class Spicygit < Formula
  desc "Terminal UI for git-spice — manage stacked branches and PRs"
  homepage "https://github.com/MortenHusted/spicygit"
  url "https://github.com/MortenHusted/spicygit/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e3a252a1248b16924ada9f4064c3962323d7888322a5e458e09ed9551dcff8d8"
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
