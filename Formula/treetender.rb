class Treetender < Formula
  desc "Ownership-aware development workspace lifecycles for humans and agents"
  homepage "https://github.com/MortenHusted/treetender"
  url "https://github.com/MortenHusted/treetender/archive/8c2798da5cae5cdb534becfd4dcbb68152670e47.tar.gz"
  version "0.1.0"
  sha256 "424ef55ac523187606e9246c77c4dc6829bb0fcd1b46e3f2953a4c78ff68851d"
  license "MIT"
  head "https://github.com/MortenHusted/treetender.git", branch: "main"

  depends_on "rust" => :build
  depends_on "git"

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "examples", "docs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treetender --version")
    assert_match "treetender-cli/v1", shell_output("#{bin}/treetender --json agent schema")
    system "git", "init", "--initial-branch=main", "workspace"
    system bin/"treetender", "--repo", testpath/"workspace", "init"
    assert_path_exists testpath/"workspace/treetender.toml"
  end
end
