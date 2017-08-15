#!/bin/bash

which nvim
if [ $? -ne 0 ]; then
	sudo dnf -y install nvim ctags-etags
fi

echo '
alias vim=nvim
' | tee -a ~/.bashrc

