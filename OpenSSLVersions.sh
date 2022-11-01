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

    brew_path="$(/usr/bin/find /usr/local/bin /opt -maxdepth 3 -name brew 2>/dev/null)"
    if [[ -x $brew_path   ]]; then
        brew_installs=$(su - "$currentUser" -c "brew list openssl 2>/dev/null | grep '/bin/openssl'")
        for brew_line in $brew_installs; do
            version=$($brew_line version)
            echo "$i;$brew_line;$version"
            ((i++))
        done
    fi
}
result="$(createOpenSSLList)"

echo "<result>$result</result>"

exit 0
