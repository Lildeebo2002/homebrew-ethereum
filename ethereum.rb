require 'formula'

class Ethereum < Formula
  version '1.4.9'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 24
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 '13c8050861bc3528bc36701a0cfbae8b37cae8d19e0ea910f108b3192c8a9eb0' => :yosemite
    sha256 'cbba3a26e0c8ed2b5a609f6b3cd6c0ac52d5b10e58e9aa6ba8eec88d7b702238' => :el_capitan
  end

  devel do
    bottle do
      revision 227
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 'f446e9089a2ad98e8025733da887d3cf02e074ad1500ecd8a5b1e0d7dc81a17d' => :yosemite
      sha256 '7ef5d33bf49649d4b58b9f09e1e576bb3b1094d90206dc014c02bb8a0c61cae7' => :el_capitan
    end

    version '1.5.0'
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'develop'
  end

  depends_on 'go' => :build

  def install
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"
    system "go", "env" # Debug env
    system "make", "all"
    bin.install 'build/bin/evm'
    bin.install 'build/bin/geth'
    bin.install 'build/bin/rlpdump'
  end

  test do
    system "make", "test"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ThrottleInterval</key>
        <integer>300</integer>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/geth</string>
            <string>-datadir=#{prefix}/.ethereum</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
