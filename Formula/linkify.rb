class Linkify < Formula

  desc "Manage locally with your precious links"
  homepage "https://github.com/mbuczko/linkify"
  version "0.1.5"

  if OS.linux?
    url "https://github.com/mbuczko/linkify/archive/v0.1.4.tar.gz"
    sha256 "3e44178f34f91dcdafc562fa949b3853e7a669f965cf2551cfce5e32d0a9c4f5"
  else
     url "https://github.com/mbuczko/linkify/archive/v0.1.4.zip"
     sha256 "c4d2a6e75ada1678dfd716332f31b1cbefedc564c82316af28007a383ca9acc6"
  end

  depends_on "rust" => :build

  def datadir
    var/"linkify"
  end

  def database
    datadir/"default.db"
  end

  def install
    system "cargo", "build", "--release", "--bin", "linkify"
    bin.install "target/release/linkify"
  end

  def post_install
    # Make sure the datadir exists
    datadir.mkpath
  end

  def caveats
    <<~EOS
      We've installed your Linkify database at #{database} without any users initialized.
      To add a user run:
          linkify --db #{database} users add <username>

      and set user's password when asked. To generate a token for HTTP communication, required
      also by browser extension, run subsequently:
          linkify --db #{database} users token <username>

      Generated token allows you to authenticate with HTTP server running at http://localhost:8001.
      To not specify database each time when linkify is used as a command line, export database
      path to environmental variable:
          export LINKIFY_DB_PATH=#{database}

      You may also export the same way user, password and/or token, eg:
          export LINKIFY_USER=<username>
          export LINKIFY_PASSWORD=<password>
          export LINKIFY_API_KEY=<generated token>
    EOS
  end

  plist_options :manual => "LOG_LEVEL=debug linkify --db #{HOMEBREW_PREFIX}/var/linkify/default.db server"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/linkify</string>
          <string>--db=#{database}</string>
          <string>server</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{datadir}</string>
      </dict>
      </plist>
    EOS
  end

end
