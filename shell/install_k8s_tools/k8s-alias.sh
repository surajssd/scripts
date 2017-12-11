#!/bin/bash

cat ~/.bashrc | grep 'k8s alias'
if [ $? -ne 0 ]; then

echo '
#=================================================================
# k8s alias

alias k=kubectl
alias kg="'"kubectl get"'"
alias kgp="'"kubectl get pods"'"
alias kgs="'"kubectl get services"'"
alias kge="'"kubectl get events"'"
alias kgpvc="'"kubectl get pvc"'"
alias kgpv="'"kubectl get pv"'"
alias kc="'"kubectl create -f "'"

function current-ns() {
	kubectl get secret $(kubectl get sa default -o jsonpath="'"{.secrets[0].name}"'") -o jsonpath="'"{.data.namespace}"'" | base64 -d
	echo
}

function change-ns() {
        kubectl config set-context $(kubectl config current-context) --namespace $1
}

#=================================================================
' | tee -a ~/.bashrc

fi
