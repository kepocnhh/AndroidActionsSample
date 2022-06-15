#!/bin/bash

echo "Workflow verify start..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

mkdir -p assemble/vcs
/bin/bash $SCRIPTS/assemble/vcs/repository.sh || exit 11
/bin/bash $SCRIPTS/assemble/vcs/worker.sh || exit 12
/bin/bash $SCRIPTS/assemble/vcs/commit.sh || exit 13

mkdir -p assemble/project
/bin/bash $SCRIPTS/project/prepare.sh || exit 21
/bin/bash $SCRIPTS/assemble/project/common.sh || exit 22

CODE=0

/bin/bash $SCRIPTS/project/verify.sh; CODE=$?
if test $CODE -ne 0; then
 mkdir -p diagnostics
 /bin/bash $SCRIPTS/project/diagnostics.sh && \
  /bin/bash $SCRIPTS/vcs/diagnostics/report.sh && \
  /bin/bash $SCRIPTS/workflow/verify/on_failed.sh || exit 1 # todo
 exit 31
fi

/bin/bash $SCRIPTS/workflow/verify/on_success.sh || exit 41

echo "Workflow verify finish."

exit 0
