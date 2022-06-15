#!/bin/bash

echo "Assemble VCS worker..."

for it in VCS_DOMAIN VCS_PAT; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 11; fi; done

CODE=0
CODE=$(curl -w %{http_code} -o assemble/vcs/worker.json \
 "$VCS_DOMAIN/user" \
 -H "Authorization: token $VCS_PAT")
if test $CODE -ne 200; then
 echo "Get worker error!"
 echo "Request error with response code $CODE!"
 exit 22
fi

REQUIRE_FILLED_STRING="select((.!=null)and(type==\"string\")and(.!=\"\"))"
REQUIRE_INT="select((.!=null)and(type==\"number\"))"

WORKER_ID="$(jq -cerM ".id|$REQUIRE_INT" assemble/vcs/worker.json)" || exit 31 # todo
WORKER_LOGIN="$(jq -cerM ".login|$REQUIRE_FILLED_STRING" assemble/vcs/worker.json)" || exit 32 # todo

for it in WORKER_ID WORKER_LOGIN; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 11; fi; done

WORKER_VCS_EMAIL="${WORKER_ID}+${WORKER_LOGIN}@users.noreply.github.com"

echo "$(jq ".vcs_email=\"$WORKER_VCS_EMAIL\"" assemble/vcs/worker.json)" > assemble/vcs/worker.json

WORKER_HTML_URL="$(jq -cerM ".html_url|$REQUIRE_FILLED_STRING" assemble/vcs/worker.json)" || exit 33 # todo

for it in WORKER_HTML_URL; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 11; fi; done

echo "The worker $WORKER_HTML_URL is ready."

exit 0
