require "language/go"

class GoshawkdbServer < Formula
  desc "A distributed, transactional, fault-tolerant object store"
  homepage "https://goshawkdb.io/"
  url "https://src.goshawkdb.io/server/archive/goshawkdb_0.3.tar.gz"
  sha256 "3ebdd026b08a34e483180c3cb931afd05b2062f66cfe07e1eb81b2154a4c442b"

  depends_on "go" => :build
  depends_on "lmdb"

  go_resource "github.com/glycerine/go-capnproto" do
    url "https://github.com/glycerine/go-capnproto.git",
      :revision => "6212efb58029e575442ea95cfa4285ef96ad4617"
  end

  go_resource "github.com/glycerine/rbtree" do
    url "https://github.com/glycerine/rbtree.git",
      :revision => "cd7940bb26b149ce2faf398e7c63fff01aa7b394"
  end

  go_resource "github.com/msackman/gotimerwheel" do
    url "https://github.com/msackman/gotimerwheel.git",
      :revision => "d3263727885fcb6e20fbd01d29774580ec548590"
  end

  go_resource "github.com/msackman/chancell" do
    url "https://github.com/msackman/chancell.git",
      :revision => "f422164a269c10a3ec7495720dc97100d598fb98"
  end

  go_resource "github.com/msackman/gomdb" do
    url "https://github.com/msackman/gomdb.git",
      :revision => "b380364713e00fe67c90f5867952663e95aba720"
  end

  go_resource "github.com/msackman/skiplist" do
    url "https://github.com/msackman/skiplist.git",
      :revision => "4c22b4dbe8ed82d9b62dd4923b3e3877242f03f4"
  end

  go_resource "goshawkdb.io/common" do
    url "https://src.goshawkdb.io/common",
      :revision => "f20880b28f79bec784f96f07328f653e73639d7c", :using => :hg
  end


  def install
    gopath = buildpath/"gopath"
    mkdir_p gopath/"src/goshawkdb.io/"
    ln_s buildpath, gopath/"src/goshawkdb.io/server"
    ENV["GOPATH"] = gopath

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/goshawkdb.io/server/cmd/goshawkdb" do
      system "go", "build", "-o", bin/"goshawkdb", "main.go"
    end
  end

end
