#!/bin/bash

echo "Assemble VCS commit..."

REQUIRE_FILLED_STRING="select((.!=null)and(type==\"string\")and(.!=\"\"))"

GIT_COMMIT_SHA="$(git -C repository rev-parse HEAD)" || exit 1 # todo

for it in VCS_DOMAIN REPOSITORY_OWNER REPOSITORY_NAME GIT_COMMIT_SHA; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 11; fi; done

CODE=0
CODE=$(curl -w %{http_code} -o assemble/vcs/commit.json \
 "$VCS_DOMAIN/repos/$REPOSITORY_OWNER/$REPOSITORY_NAME/commits/$GIT_COMMIT_SHA")
if test $CODE -ne 200; then
 echo "Get commit $GIT_COMMIT_SHA info error!"
 echo "Request error with response code $CODE!"
 exit 32
fi
COMMIT_HTML_URL="$(jq -cerM ".html_url|$REQUIRE_FILLED_STRING" assemble/vcs/commit.json)" || exit 1 # todo
AUTHOR_LOGIN="$(jq -cerM ".author.login|$REQUIRE_FILLED_STRING" assemble/vcs/commit.json)" || exit 1 # todo
for it in COMMIT_HTML_URL AUTHOR_LOGIN; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 11; fi; done
echo "The commit $COMMIT_HTML_URL is ready."

mkdir -p assemble/vcs/commit || exit 1 # todo
CODE=0
CODE=$(curl -w %{http_code} -o assemble/vcs/commit/author.json \
 "$VCS_DOMAIN/users/$AUTHOR_LOGIN")
if test $CODE -ne 200; then
 echo "Get author info error!"
 echo "Request error with response code $CODE!"
 exit 42
fi
AUTHOR_HTML_URL="$(jq -cerM ".html_url|$REQUIRE_FILLED_STRING" assemble/vcs/commit/author.json)" || exit 1 # todo
echo "The author $AUTHOR_HTML_URL is ready."

exit 0
