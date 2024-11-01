set -x

# Now append the bashrc
cat >> ~/.bashrc << 'EOL'

# pyenv install path
export PYENV_ROOT="/workspace/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# pyenv
eval "$(pyenv init --path)"

# pyenv-virtualenv
eval "$(pyenv virtualenv-init -)";

# git-bash-prompt
if [ -f "/workspace/.bash-git-prompt/gitprompt.sh" ]; then
    source /workspace/.bash-git-prompt/gitprompt.sh
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
