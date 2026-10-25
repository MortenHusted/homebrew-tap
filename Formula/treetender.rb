class Treetender < Formula
  desc "Resource accounting and lifecycle coordination for Git workspaces"
  homepage "https://github.com/MortenHusted/treetender"
  url "https://github.com/MortenHusted/treetender/archive/ad778d1b39bf20f0664b663fbc85f4dd809286fb.tar.gz"
  version "0.2.0"
  sha256 "a1078b329c9f7ebbd0dfdbb3f54d33101e2645ff9b9977eafd85499a85e33970"
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
    (testpath/"workspace/treetender.toml").unlink
    (testpath/"workspace/treetender.toml").write <<~TOML
      version = 1
      [[resources]]
      id = "test-database"
      kind = "data"
      target = "mysql:local/example-lane"
      description = "Formula inventory fixture"
      manager = "External scripts"
    TOML
    system bin/"treetender", "--repo", testpath/"workspace", "--state-dir", testpath/"state", "register"
    status_command = "#{bin}/treetender --repo #{testpath}/workspace --state-dir #{testpath}/state"
    status = JSON.parse(shell_output("#{status_command} --json status"))
    assert_empty status.fetch("result").fetch("resources")
    assert_empty status.fetch("result").fetch("observations")
    assert_empty status.fetch("result").fetch("issues")
    assert_equal "External scripts", status.dig("result", "declarations", "resources", 0, "manager")
  end
end
