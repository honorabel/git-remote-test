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

UPSTREAM='@{u}'
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

E_OK=0
E_ERROR=1

git remote update

if [ $LOCAL = $REMOTE ]; then
    echo "Up-to-date"
    exit E_OK
elif [ $LOCAL = $BASE ]; then
    echo "Need to pull"
    exit E_ERROR
elif [ $REMOTE = $BASE ]; then
    echo "Local is ahead of remote"
    exit E_OK
else
    echo "Diverged"
    exit E_ERROR
fi

#
# START HERE
#
