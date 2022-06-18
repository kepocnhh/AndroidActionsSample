#!/bin/bash

echo "GitHub release..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

. $SCRIPTS/util/require VCS_PAT VCS_DOMAIN REPOSITORY_OWNER REPOSITORY_NAME

SELECT_FILLED_STRING="select((.!=null)and(type==\"string\")and(.!=\"\"))"

if test $# -ne 1; then
 echo "Script needs for 1 argument but actual $#"; exit 11
fi

BODY="$1"

CODE=0
RELEASE_NAME="$(echo "$BODY" | jq -Mcer ".name|$SELECT_FILLED_STRING")"; CODE=$?
if test $CODE -ne 0; then
 echo "Get release name error $CODE!"; exit 12
fi

CODE=$(curl -w %{http_code} -o assemble/github/release.json -X POST \
 "$VCS_DOMAIN/repos/$REPOSITORY_OWNER/$REPOSITORY_NAME/releases" \
 -H "Authorization: token $VCS_PAT" \
 -d "$BODY")
if test $CODE -ne 201; then
 echo "GitHub release $RELEASE_NAME error!"
 echo "Request error with response code $CODE!"
 exit 31
fi

RELEASE_HTML_URL=$($SCRIPTS/util/jqx -sfs assemble/github/release.json .html_url) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"

echo "The release $RELEASE_HTML_URL is ready."

exit 0
