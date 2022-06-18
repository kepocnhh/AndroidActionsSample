#!/bin/bash

echo "VCS push..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

REPOSITORY=repository
. $SCRIPTS/util/assert -d $REPOSITORY

git -C $REPOSITORY push \
 || . $SCRIPTS/util/throw 41 "Git push error!"

exit 0
