#!/bin/bash

url=$1
if [ -z $url ]; then
    echo "Please provide the URL!"
    exit -1
fi;

RANDOM=$$
rand=${RANDOM}
curl -o /tmp/diff-${rand} ${url}/raw

git checkout .
git apply /tmp/diff-${rand}

