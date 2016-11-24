#!/bin/bash

set -x

mkdir -p ~/.local/bin
cat > ~/.local/bin/shorturl <<EOF
#!/bin/env python
import sys
import requests
URL = 'http://api.bit.ly/v3/shorten'
data = {
    "login": "",
    "apiKey": "",
    "longURL": sys.argv[1],
    "format": "txt"
}
response = requests.get(URL, data)
print response.text
EOF
chmod a+x ~/.local/bin/shorturl
echo ">>>>> Goto https://bitly.com/a/settings/advanced"
echo ">>>>> and copy Login and API Key and put in "
echo ">>>>> ~/.local/bin/shorturl "
