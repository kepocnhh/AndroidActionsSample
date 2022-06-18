#!/bin/bash

echo "VCS pull request close..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

. $SCRIPTS/util/require VCS_DOMAIN VCS_PAT REPOSITORY_OWNER REPOSITORY_NAME PR_NUMBER

BODY="$(echo "{}" | jq -Mc ".state=\"close\"")"

CODE=0
CODE=$(curl -w %{http_code} -o /dev/null -X PATCH \
 "$VCS_DOMAIN/repos/$REPOSITORY_OWNER/$REPOSITORY_NAME/pulls/$PR_NUMBER" \
 -H "Authorization: token $VCS_PAT" \
 -d "$BODY")
if test $CODE -ne 200; then
 echo "Close pull request #$PR_NUMBER error!"
 echo "Request error with response code $CODE!"
 exit 31
fi

exit 0
