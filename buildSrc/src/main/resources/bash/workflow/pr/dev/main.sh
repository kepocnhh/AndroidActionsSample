#!/bin/bash

echo "Workflow pull request dev start..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

mkdir -p assemble/vcs
/bin/bash $SCRIPTS/assemble/vcs/repository.sh || exit 11
/bin/bash $SCRIPTS/assemble/vcs/worker.sh || exit 12
/bin/bash $SCRIPTS/assemble/vcs/pr.sh || exit 13
/bin/bash $SCRIPTS/assemble/vcs/pr/commit.sh || exit 13

/bin/bash $SCRIPTS/vcs/pr/merge.sh || exit 21

mkdir -p assemble/project
/bin/bash $SCRIPTS/project/prepare.sh || exit 31
/bin/bash $SCRIPTS/assemble/project/common.sh || exit 32

/bin/bash $SCRIPTS/workflow/pr/dev/project/verify.sh || exit 81

/bin/bash $SCRIPTS/workflow/pr/dev/vcs/tag/test.sh || exit 41
/bin/bash $SCRIPTS/workflow/pr/dev/vcs/push.sh || exit 42
/bin/bash $SCRIPTS/workflow/pr/dev/vcs/release.sh || exit 43
/bin/bash $SCRIPTS/vcs/pr/check_state.sh "closed" || exit 44

/bin/bash $SCRIPTS/workflow/pr/dev/on_success.sh || exit 91

echo "Workflow pull request dev finish."

exit 0
