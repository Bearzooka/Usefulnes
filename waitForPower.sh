#!/bin/bash

# WaitForPower is a function that blocks the screen, if minimum battery charge is not
# present, and holds it blocked until the user connects AC power.

# USAGE:
# Insert the following function, configure the logo [optional] and the minimum charge
# then invoke the function in your code, where you need to be sure power is present
# e.g. before starting a big installation

# Path to jamfHelper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Path to a logo that will be used in the lock screen. Can be png, jpg or icns.
LOGO="/Path/To/Company/Logo.png"

# Text for the heading of the blocked screen
HEADING="Your installation will begin shortly…"

# Minimum charge the battery should have to not block the screen.
MIN_BAT=80

waitForPower(){

  battCharge=$(pmset -g batt | grep "Internal" | awk -F\t '{print $2}' | awk -F'%' '{print $1}')
  powerStatus=$(pmset -g batt | grep "AC")

  if [[ "$battCharge" -lt $MIN_BAT && -z "$powerStatus" ]]; then
    
    echo "Not enough battery… Asking to connect AC"
    
    jh=$("$jamfHelper" \
    -icon "$LOGO" \
    -heading "$HEADING" \
    -windowType fs \
    -description "Please connect your device to AC power to continue")&

    while [[ "$powerStatus" == " " || -z "$powerStatus" ]]; do
      powerStatus=$(pmset -g batt | grep "AC")
      sleep 2
    done
    echo "Power was connected. Killing jamfHelper"
    killall jamfHelper 2>/dev/null
  else
    echo "Enough power, continue."
  fi
}
