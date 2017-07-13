#!/usr/bin/env bash
set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x
APP="$1"; IMAGE="dokku/$APP"
echo "-----> Installing google-chrome ..."
COMMAND=$(cat <<EOF
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
apt-get update
apt-get install google-chrome-beta
sleep 1 # wait so
that docker run has not exited before docker attach
EOF
)
id=$(docker run -d $IMAGE /bin/bash -e -c "$COMMAND")
#enable logs
docker attach $id
test $(docker wait $id) -eq 0
docker commit $id $IMAGE > /dev/null
