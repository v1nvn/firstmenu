# Homebrew Formula

This document describes the Homebrew formula for firstmenu.

## Formula Options

There are two options for distributing firstmenu via Homebrew:

1. **Homebrew Core** - Submit to official homebrew-core (requires review)
2. **Custom Tap** - Create your own tap (e.g., `v1nit/tap`)

## Option 1: Homebrew Core (Recommended)

Once you release v1.0.0, submit the formula to homebrew-core:

```bash
# 1. Fork https://github.com/Homebrew/homebrew-core
# 2. Add your formula to Formula/firstmenu.rb
# 3. Open a PR
```

### Formula for homebrew-core

```ruby
class Firstmenu < Formula
  desc "Lightweight macOS menu bar system monitor"
  homepage "https://github.com/v1nit/firstmenu"
  url "https://github.com/v1nit/firstmenu/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "<SHA256_WILL_BE_COMPUTED>"

  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/firstmenu"
  end

  test do
    system "#{bin}/firstmenu", "--version"
  end
end
```

## Option 2: Custom Tap

For faster distribution, use a custom tap:

### 1. Create the Tap Repository

```bash
# Create a new GitHub repo: v1nit/homebrew-tap
git clone https://github.com/v1nit/homebrew-tap.git
cd homebrew-tap
mkdir Formula
```

### 2. Add the Formula

Create `Formula/firstmenu.rb`:

```ruby
class Firstmenu < Formula
  desc "Lightweight macOS menu bar system monitor"
  homepage "https://github.com/v1nit/firstmenu"

  # Update these values for each release
  url "https://github.com/v1nit/firstmenu/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "<COMPUTE_SHA256_FOR_RELEASE_TARBALL>"

  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/firstmenu"
  end

  test do
    system "#{bin}/firstmenu", "--version"
  end
end
```

### 3. Users Install via Tap

```bash
brew tap v1nit/tap
brew install firstmenu
```

### 4. Update Formula for New Releases

```bash
# 1. Update version and sha256 in Formula/firstmenu.rb
# 2. git commit -am "Update firstmenu to vX.Y.Z"
# 3. git push
```

## Computing SHA256

```bash
# For release tarball
curl -L https://github.com/v1nit/firstmenu/archive/refs/tags/v1.0.0.tar.gz | shasum -a 256

# For release DMG
curl -L https://github.com/v1nit/firstmenu/releases/download/v1.0.0/firstmenu.dmg | shasum -a 256
```

## DMG-Based Formula (Alternative)

If you prefer distributing the DMG instead of building from source:

```ruby
class Firstmenu < Formula
  desc "Lightweight macOS menu bar system monitor"
  homepage "https://github.com/v1nit/firstmenu"

  url "https://github.com/v1nit/firstmenu/releases/download/v1.0.0/firstmenu.dmg"
  sha256 "<COMPUTE_SHA256_FOR_DMG>"

  depends_on :macos

  def install
    app "firstmenu.app"
  end

  test do
    system "#{appdir}/firstmenu.app/Contents/MacOS/firstmenu", "--version"
  end
end
```

## Automated Formula Updates

The `.github/workflows/release.yml` workflow generates a formula template automatically when you push a version tag.

To use it:

1. Push a tag: `git tag v1.0.0 && git push origin v1.0.0`
2. Download the `homebrew-formula` artifact from the release workflow run
3. Copy `Formula/firstmenu.rb` to your tap
4. Commit and push

## Testing the Formula

```bash
# Install from local file
brew install ./Formula/firstmenu.rb

# Test installation
firstmenu --version

# Uninstall
brew uninstall firstmenu
```
