#!/bin/bash
#
#<UDF name="keeper_password" label="Password for keeper">

if [ "$LINODE_ID" != "" ] ; then
    # prevent the script from running multiple times
    # (a workaround for Linode StackScript bug with CentOS 7 image)
    [ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -en "$0" "$0" "$@" || :

    # redirect stdout and stderr to a log file
    exec >>/var/log/stackscript.log 2>&1
fi

set -e
set -u
set -x

KEEPER_USERNAME="boxkeeper"
KEEPER_HOMEDIR="/home/$KEEPER_USERNAME"
KEEPER_SSHDIR="$KEEPER_HOMEDIR/.ssh"
KEEPER_KEYS="$KEEPER_SSHDIR/authorized_keys"

if id -u "$KEEPER_USERNAME" >/dev/null 2>&1 ; then
    echo -n "User '$KEEPER_USERNAME' already exists... skipping"
else
    echo -n "Creating '$KEEPER_USERNAME' user..."
    useradd -G wheel $KEEPER_USERNAME
fi

if [ ! -z ${KEEPER_PASSWORD:+x} ]; then
    # disable command tracing
    set +x
    echo "$KEEPER_USERNAME:$KEEPER_PASSWORD" | chpasswd
    # re-enable tracing
    set -x
fi

echo "%$KEEPER_USERNAME ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/$KEEPER_USERNAME
echo " done"

mkdir -p $KEEPER_SSHDIR
chmod 0700 $KEEPER_SSHDIR
touch $KEEPER_KEYS
chmod 0600 $KEEPER_KEYS
curl -sS https://raw.githubusercontent.com/lightster/.ssh/master/id_rsa.lightster-air.pub \
    https://raw.githubusercontent.com/lightster/.ssh/master/id_rsa.lightster-mbpr.pub \
    > $KEEPER_KEYS
chown -R $KEEPER_USERNAME:$KEEPER_USERNAME $KEEPER_SSHDIR
