#!/bin/bash

currentUser=$(ls -l /dev/console | awk '{ print $3 }')

createOpenSSLList (){
    # Setting IFS Env to only use new lines as field seperator 
    IFS=$'\n'
    installs=$(su - "$currentUser" -c "type -a openssl")
    for line in $installs; do
        path=$(echo "$line" | awk -F"is " '{print $2}')
        version=$($path version)
        echo "$i;$path;$version"
        ((i++))
    done
}
result="$(createOpenSSLList)"

echo "<result>$result</result>"

exit 0
