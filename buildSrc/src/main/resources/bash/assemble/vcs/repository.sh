#!/bin/bash

echo "Assemble VCS repository..."

for it in REPOSITORY_OWNER REPOSITORY_NAME VCS_DOMAIN VCS_PAT; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 11; fi; done

CODE=0
CODE=$(curl -w %{http_code} -o assemble/vcs/repository.json \
 "$VCS_DOMAIN/repos/$REPOSITORY_OWNER/$REPOSITORY_NAME" \
 -H "Authorization: token $VCS_PAT")
if test $CODE -ne 200; then
 echo "Get repository ${GITLAB_PROJECT} error!"
 echo "Request error with response code $CODE!"
 exit 21
fi

echo "The repository $(jq -r .html_url assemble/vcs/repository.json) is ready."

exit 0
