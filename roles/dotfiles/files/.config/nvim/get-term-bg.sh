#!/bin/bash
# prints RGB value of background color in xterm compatible terminal

success=false

exec < /dev/tty

oldstty=$(stty -g)
stty raw -echo min 0

echo -en "\033]11;?\033\\" >/dev/tty

result=
if IFS=';' read -r -d '\' color ; then
    result=$(echo $color | sed 's/^.*\;//;s/[^rgb:0-9a-f/]//g')
    success=true
fi

# restore tty
stty $oldstty

# print results
echo $result
$success

