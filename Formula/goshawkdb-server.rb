class GoshawkdbServer < Formula
  desc "A distributed, transactional, fault-tolerant object store"
  homepage "https://goshawkdb.io/"
  url "https://src.goshawkdb.io/server/archive/goshawkdb_0.1.tar.gz"
  sha256 "3324046db99ef1cc88309f5d10bd1136371820252de2521baea162856ab9076b"

  depends_on "go" => :build
  depends_on "lmdb"

  go_resource "github.com/glycerine/go-capnproto" do
    url "https://github.com/glycerine/go-capnproto.git",
      :revision => "db36ab24140ac1737830f5a0d8c87ea26f367fbb"
  end

  go_resource "github.com/glycerine/rbtree" do
    url "https://github.com/glycerine/rbtree.git",
      :revision => "cd7940bb26b149ce2faf398e7c63fff01aa7b394"
  end

  go_resource "github.com/msackman/chancell" do
    url "https://github.com/msackman/chancell.git",
      :revision => "f422164a269c10a3ec7495720dc97100d598fb98"
  end

  go_resource "github.com/msackman/gomdb" do
    url "https://github.com/msackman/gomdb.git",
      :revision => "e5477472276299169a7eda58c5f0d0d615c758c8"
  end

  go_resource "github.com/msackman/skiplist" do
    url "https://github.com/msackman/skiplist.git",
      :revision => "57733164b18444c51f63e9a80f1693961dde8036"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "803f01ea27e23d998825ec085f0d153cac01c828"
  end

  go_resource "goshawkdb.io/common" do
    url "https://src.goshawkdb.io/common",
      :revision => "df8631857532c03a6f3b3a5a7aca6eeafa3c5629", :using => :hg
  end


  def install
    gopath = buildpath/"gopath"
    mkdir_p gopath/"src/goshawkdb.io/"
    ln_s buildpath, gopath/"src/goshawkdb.io/server"
    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/goshawkdb.io/server/goshawkdb" do
      system "go", "build", "-o", bin/"goshawkdb" "main.go"
    end
  end

end
