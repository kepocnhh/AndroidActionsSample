#!/bin/bash

echo "Workflow pull request unstable VCS push..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

/bin/bash $SCRIPTS/vcs/pr/commit.sh || exit 12
/bin/bash $SCRIPTS/workflow/pr/unstable/assemble/project/artifact.sh || exit 13
/bin/bash $SCRIPTS/vcs/push.sh || exit 14
/bin/bash $SCRIPTS/assemble/vcs/commit.sh || exit 15

exit 0
