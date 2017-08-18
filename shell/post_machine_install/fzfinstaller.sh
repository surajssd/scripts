#!/bin/bash

cd

ls ~/.fzf
if [ $? -ne 0 ]; then
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	yes | ~/.fzf/install
fi
