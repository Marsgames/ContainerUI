cask "containerui" do
  version "1.0.0"
  sha256 :no_check # updated automatically by release workflow

  url "https://github.com/Marsgames/ContainerUI/releases/download/v#{version}/ContainerUI.dmg"
  name "ContainerUI"
  desc "Native macOS interface for Apple's container system"
  homepage "https://github.com/Marsgames/ContainerUI"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "ContainerUI.app"

  zap trash: [
    "~/Library/Preferences/fr.raphaelDAUMAS.ContainerUI.plist",
    "~/Library/Application Support/ContainerUI",
  ]
end
