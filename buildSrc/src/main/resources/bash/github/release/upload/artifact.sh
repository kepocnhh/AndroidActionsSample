#!/bin/bash

echo "GitHub release upload artifact..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

. $SCRIPTS/util/require VCS_PAT REPOSITORY_OWNER REPOSITORY_NAME

if test $# -ne 1; then
 echo "Script needs for 1 argument but actual $#"; exit 11
fi

ARTIFACTS="$1"

SELECT_FILLED_ARRAY="select((type==\"array\")and(.!=[]))"
SELECT_FILLED_STRING="select((.!=null)and(type==\"string\")and(.!=\"\"))"

RELEASE_ID=$($SCRIPTS/util/jqx -si assemble/github/release.json .id) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"

URL="https://uploads.github.com/repos/$REPOSITORY_OWNER/$REPOSITORY_NAME/releases/$RELEASE_ID/assets"

CODE=0
SIZE=$(echo "$ARTIFACTS" | jq -Mcer "$SELECT_FILLED_ARRAY|length") \
 || . $SCRIPTS/util/throw 12 "Get size of array $ARTIFACTS error!"
for ((i = 0; i < SIZE; i++)); do
 ARTIFACT="$(echo "$ARTIFACTS" | jq -Mce ".[$i]")" \
  || . $SCRIPTS/util/throw $((100+i)) "Get item #$i of array $ARTIFACTS error!"
 ARTIFACT_NAME="$(echo "$ARTIFACT" | jq -Mcer ".name|$SELECT_FILLED_STRING")" \
  || . $SCRIPTS/util/throw $((110+i)) "Get name of $ARTIFACT error!"
 ARTIFACT_LABEL="$(echo "$ARTIFACT" | jq -Mcer ".label|$SELECT_FILLED_STRING")" \
  || . $SCRIPTS/util/throw $((120+i)) "Get label of $ARTIFACT error!"
 ARTIFACT_PATH="$(echo "$ARTIFACT" | jq -Mcer ".path|$SELECT_FILLED_STRING")" \
  || . $SCRIPTS/util/throw $((130+i)) "Get path of $ARTIFACT error!"
 CODE=$(curl -w %{http_code} -o /tmp/artifact -X POST \
  "$URL?name=$ARTIFACT_NAME&label=$ARTIFACT_LABEL" \
  -H "Authorization: token $VCS_PAT" \
  -H "Content-Type: text/plain" \
  --data-binary "@$ARTIFACT_PATH")
 if test $CODE -ne 201; then
  echo "GitHub release upload artifact $ARTIFACT_NAME error!"
  echo "Request error with response code $CODE!"
  cat /tmp/artifact
  exit 31
 fi
done

exit 0
