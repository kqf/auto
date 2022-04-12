# Install the developer tools
xcode-select --install

# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install the main tools
brew update
brew install openssl readline sqlite3 xz zlib
brew install bash-git-prompt pyenv pyenv-virtualenv
