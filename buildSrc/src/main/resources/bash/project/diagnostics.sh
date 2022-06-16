#!/bin/bash

echo "Project diagnostics..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

. $SCRIPTS/util/require BUILD_VARIANT

echo "{}" > diagnostics/summary.json

CODE=0

ENVIRONMENT=repository/buildSrc/src/main/resources/json/verify.json
ARRAY=($(jq -Mcer "keys|.[]" $ENVIRONMENT))
SIZE=${#ARRAY[*]}
for ((i=0; i<SIZE; i++)); do
 TYPE="${ARRAY[i]}"
 BY_VARIANT=$($SCRIPTS/util/jqx -sb $ENVIRONMENT ".${TYPE}.byVariant") \
  || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
 TASK=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.task") \
  || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
 test "$BY_VARIANT" == "true" && TASK=${TASK//"?"/"${BUILD_VARIANT^}"}
 gradle -p repository "$TASK"; CODE=$?
 if test $CODE -ne 0; then
  RELATIVE=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.path") \
   || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
  test "$BY_VARIANT" == "true" && RELATIVE=${RELATIVE//"?"/"$BUILD_VARIANT"}
  TITLE=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.title") \
   || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
  mkdir -p diagnostics/report/$RELATIVE
  REPORT=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.report") \
   || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
  test "$BY_VARIANT" == "true" && REPORT=${REPORT//"?"/"$BUILD_VARIANT"}
  cp -r repository/$REPORT/* diagnostics/report/$RELATIVE || exit 1 # todo
  echo "$(jq -Mc ".$TYPE.path=\"$RELATIVE\"" diagnostics/summary.json)" > diagnostics/summary.json \
   && echo "$(jq -Mc ".$TYPE.title=\"$TITLE\"" diagnostics/summary.json)" > diagnostics/summary.json \
   || exit $((100+i))
 fi
done

ENVIRONMENT=repository/buildSrc/src/main/resources/json/unit_test.json
TYPE="UNIT_TEST"
TASK=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.task") \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
TASK=${TASK//"?"/"${BUILD_VARIANT^}"}
gradle -p repository "$TASK"; CODE=$?
if test $CODE -ne 0; then
 RELATIVE=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.path") \
  || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
 RELATIVE=${RELATIVE//"?"/"$BUILD_VARIANT"}
 TITLE=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.title") \
  || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
 mkdir -p diagnostics/report/$RELATIVE
 REPORT=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.report") \
  || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
 REPORT=${REPORT//"?"/"${BUILD_VARIANT^}"}
 cp -r repository/$REPORT/* diagnostics/report/$RELATIVE || exit 1 # todo
 echo "$(jq -Mc ".$TYPE.path=\"$RELATIVE\"" diagnostics/summary.json)" > diagnostics/summary.json \
  && echo "$(jq -Mc ".$TYPE.title=\"$TITLE\"" diagnostics/summary.json)" > diagnostics/summary.json \
  || exit 121
else
 TYPE="TEST_COVERAGE"
 TASK=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.task") \
  || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
 TASK=${TASK//"?"/"$BUILD_VARIANT"}
 gradle -p repository "$TASK" || exit 1 # todo
 TASK=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.verification.task") \
  || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
 TASK=${TASK//"?"/"$BUILD_VARIANT"}
 gradle -p repository "$TASK"; CODE=$?
 if test $CODE -ne 0; then
  RELATIVE=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.path") \
   || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
  RELATIVE=${RELATIVE//"?"/"$BUILD_VARIANT"}
  TITLE=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.title") \
   || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
  mkdir -p diagnostics/report/$RELATIVE
  REPORT=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.report") \
   || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
  REPORT=${REPORT//"?"/"${BUILD_VARIANT^}"}
  cp -r repository/$REPORT/* diagnostics/report/$RELATIVE || exit 1 # todo
  echo "$(jq -Mc ".$TYPE.path=\"$RELATIVE\"" diagnostics/summary.json)" > diagnostics/summary.json \
   && echo "$(jq -Mc ".$TYPE.title=\"$TITLE\"" diagnostics/summary.json)" > diagnostics/summary.json \
   || exit 122
 fi
fi

TYPES="$(jq -Mcer "keys" diagnostics/summary.json)" || exit 1 # todo
if test "$TYPES" == "[]"; then
 echo "Diagnostics should have determined the cause of the failure!"; exit 1
fi

echo "Diagnostics have determined the cause of the failure - this is: $TYPES."

exit 0
