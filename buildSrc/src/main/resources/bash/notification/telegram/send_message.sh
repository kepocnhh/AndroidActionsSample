#!/bin/bash

echo "Notification telegram send message..."

if test $# -ne 1; then
 echo "Script needs for 1 argument but actual $#"; exit 11
fi

MESSAGE="$1"

for it in TELEGRAM_BOT_ID TELEGRAM_BOT_TOKEN TELEGRAM_CHAT_ID MESSAGE; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 21; fi; done

MESSAGE=${MESSAGE//"#"/"%23"}
MESSAGE=${MESSAGE//$'\n'/"%0A"}
MESSAGE=${MESSAGE//$'\r'/""}

CODE=$(curl -w %{http_code} -G -o /dev/null \
 "https://api.telegram.org/bot${TELEGRAM_BOT_ID}:${TELEGRAM_BOT_TOKEN}/sendMessage" \
 -d chat_id=$TELEGRAM_CHAT_ID \
 -d text="$MESSAGE" \
 -d parse_mode=markdown)

if test $CODE -ne 200; then
 echo "Send message error!"
 echo "Request error with response code $CODE!"
 exit 31
fi

exit 0
