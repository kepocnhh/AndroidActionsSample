#!/bin/bash

echo "Project prepare..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

gradle -p repository clean || . $SCRIPTS/util/throw 11 "Gradle clean error $?!"

exit 0
