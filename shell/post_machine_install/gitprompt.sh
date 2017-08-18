#!/bin/bash

cd

cat ~/.bashrc | grep 'gitprompt'
if [ $? -ne 0 ]; then

git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt
echo '
#=================================================================
# Bash Git Prompt

source ~/.bash-git-prompt/gitprompt.sh
GIT_PROMPT_ONLY_IN_REPO=1
#=================================================================
' | tee -a ~/.bashrc

fi

