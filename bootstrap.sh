#!/bin/bash

set -e
set -u
set -x

KEEPER_USERNAME="boxkeeper"
KEEPER_HOMEDIR="/home/$KEEPER_USERNAME"
KEEPER_SSHDIR="$KEEPER_HOMEDIR/.ssh"
KEEPER_KEYS="$KEEPER_SSHDIR/authorized_keys"

RETURN_DIR=$(pwd)

if id -u "$KEEPER_USERNAME" >/dev/null 2>&1; then
    echo -n "User '$KEEPER_USERNAME' already exists... skipping"
else
    echo -n "Creating '$KEEPER_USERNAME' user..."
    useradd -G wheel $KEEPER_USERNAME
    echo "$KEEPER_USERNAME:vagrant" | chpasswd
    echo " done"
fi

mkdir -p $KEEPER_SSHDIR
chmod 0700 $KEEPER_SSHDIR
touch $KEEPER_KEYS
chmod 0600 $KEEPER_KEYS
curl -sS https://raw.githubusercontent.com/lightster/.ssh/master/id_rsa.lightster-air.pub \
    https://raw.githubusercontent.com/lightster/.ssh/master/id_rsa.lightster-air.pub \
    > $KEEPER_KEYS
chown -R $KEEPER_USERNAME:$KEEPER_USERNAME $KEEPER_SSHDIR

cd $RETURN_DIR
