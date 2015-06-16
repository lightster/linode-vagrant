#!/bin/bash

set -e
set -u
set -x

mkdir -p /var/www/html

ln -sfn /vagrant/codebase/lidsys-web /var/www/html/lidsys-web
