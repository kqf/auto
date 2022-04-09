set -x

# Install dev dependencies
sudo apt-get update; sudo apt-get install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y

# Install autojump
sudo apt-get install autojump -y

# Install pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
cd ~/.pyenv && src/configure && make -C src

# Install pyenv-virtualenv
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

# Install git bash prompt
git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1


# Now append the bashrc
cat >> testrc << 'EOL'
# pyenv install path
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi

# pyenv-virtualenv
if which pyenv-virtualenv-init > /dev/null; then
  eval "$(pyenv virtualenv-init -)";
fi

# git-bash-prompt
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    source $HOME/.bash-git-prompt/gitprompt.sh
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0
fi

# Autojump
. /usr/share/autojump/autojump.sh

EOL

# And now customize the prompt colors
cat > ~/.git-prompt-colors.sh  << 'EOL'
override_git_prompt_colors() {
	GIT_PROMPT_THEME_NAME="Custom" # needed for reload optimization, should be unique
	GIT_PROMPT_END_USER="${White}${ResetColor} $ "
	GIT_PROMPT_END_ROOT="${White}${ResetColor} # "
}
reload_git_prompt_colors "Custom"
EOL

echo -e "Done.\nRestart your shell"
