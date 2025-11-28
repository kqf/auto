# Install the developer tools
xcode-select --install

# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install the main tools
brew update
brew install openssl readline sqlite3 xz zlib
brew install bash-git-prompt pyenv pyenv-virtualenv autojump


# Update the .bash_profile
cat >> ~/.bashrc << 'EOL'
# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# pyenv-virtualenv
if which pyenv-virtualenv-init > /dev/null; then
  eval "$(pyenv virtualenv-init -)";
fi

# git-bash-prompt
if [ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    __GIT_PROMPT_DIR="/usr/local/opt/bash-git-prompt/share"
    source "/usr/local/opt/bash-git-prompt/share/gitprompt.sh"
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0
fi

# Enable autojump commands
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Search in python sources
alias pag="ag -G '\.(py|ipynb|pyx)$'"

# File transfer
function transfer() {
    # write to output to tmpfile because of progress bar
    tmpfile=$( mktemp -t transferXXX )
    curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $tmpfile;
    cat $tmpfile | pbcopy;
    cat $tmpfile;
    rm -f $tmpfile;
}

EOL

echo -n "\nRestart your shell"


# Disable accents, holding keys for continuous input
defaults write -g ApplePressAndHoldEnabled -bool false
