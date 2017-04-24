#!/bin/bash

#
# GOOD: local master is up to date
#  * (origin/master, master)
#  *
#
# BAD: local master diverged from remote
#  * (origin/master)
#  *
#  | * (master)
#  | *
#  |/
#  *
#
# BAD: local master is behind upstream
#  * (origin/master)
#  *
#  * (master)
#
#
# OK: local master is ahead of up-to-date upstream/master
#  * (master)
#  *
#  * (origin/master)
#

E_OK=0
E_ERROR=1

echo "Pulling latest from remote..."
git remote update

UPSTREAM='@{u}'
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

echo "Checking if upstream has been updated..."
if [ $LOCAL = $REMOTE ]; then
    echo "Up-to-date"
    exit $E_OK
elif [ $LOCAL = $BASE ]; then
    echo "Need to pull"
    exit $E_ERROR
elif [ $REMOTE = $BASE ]; then
    echo "Local is ahead of remote"
    exit $E_OK
else
    echo "Diverged"
    exit $E_ERROR
fi

#
# START HERE
#
