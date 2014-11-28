#!/bin/bash

set -e
set -u
set -x

# install server-config repo (needed for chef cookbooks)
RETURN_DIR=$(pwd)
mkdir -p /etc/lightdatasys
cd /etc/lightdatasys
git clone https://github.com/lightster/server-config.git server
cd server
chown -R vagrant:vagrant /etc/lightdatasys
git remote set-url origin git@github.com:lightster/server-config.git
cd $RETURN_DIR
