#!/bin/bash

set -e
set -u
set -x

KEEPER_USERNAME="boxkeeper"

RETURN_DIR=$(pwd)

if id -u "$KEEPER_USERNAME" >/dev/null 2>&1; then
    echo -n "User '$KEEPER_USERNAME' already exists... skipping"
else
    echo -n "Creating '$KEEPER_USERNAME' user..."
    useradd -G wheel $KEEPER_USERNAME
    echo "$KEEPER_USERNAME:vagrant" | chpasswd
    echo " done"
fi

cd $RETURN_DIR
