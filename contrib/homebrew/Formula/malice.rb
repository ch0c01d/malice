class Malice < Formula
  desc "malice - VirusTotal Wanna Be - Now with 100% more Hipster"
  homepage "https://github.com/maliceio/malice"
  url "https://github.com/maliceio/malice.git",
    :revision => "d845ec0fa2788b26a36b7b5bf4440d0bf4502abb"
  version "0.1.0-alpha"
  head "https://github.com/maliceio/malice.git"

  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build
  depends_on "libmagic" => :run

  # It's possible that the user wants to manually install Docker and Machine,
  # for example, they want to compile Docker manually
  # depends_on "docker" => :recommended
  # depends_on "docker-machine" => :recommended

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/maliceio/malice").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    # Language::Go.stage_deps resources, gopath/"src"

    (var/"log/malice").mkpath

    cd gopath/"src/github.com/maliceio/malice" do
      system "go", "get", "-v"
      system "go", "build", "-o", bin/"malice"
      # bin.install "bin/malice"
    end

    if build.with? "completions"
      zsh_completion.install gopath/"src/github.com/maliceio/malice/contrib/completion/zsh/_malice"
    end
  end

  test do
    system "#{bin}/malice --version"
  end
end
