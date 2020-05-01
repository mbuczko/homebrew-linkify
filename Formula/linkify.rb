class Linkify < Formula

  desc "Manage locally with your precious links"
  homepage "https://github.com/mbuczko/linkify"
  version "0.1.3"

  if OS.linux?
    url "https://github.com/mbuczko/linkify/archive/v0.1.3.tar.gz"
    sha256 "3387fc4a990c53a0104c7afb34887db155128dc967c9f29d974a24049f71d7f2"
  else
     url "https://github.com/mbuczko/linkify/archive/v0.1.3.zip"
     sha256 "6b27c5702446779a812430de5f49077bc92495b57e31dc5f851203280c8f1208"
  end

  #depends_on "rust" => :build

  def install
    system "cargo", "build", "--release", "--bin", "linkify"
    bin.install "target/release/linkify"
  end

end
