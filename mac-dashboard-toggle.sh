#!/usr/bin/env bash
#
# Toggledashboard
# Dave Eddy <dave@daveeddy.com>
# BSD 3 clause
#

display_alert() {
	/usr/bin/osascript <<- EOF | cut -d ":" -f 2
	tell application "System Events"
	        activate
	        display dialog "$1" \
		with icon 1 \
		buttons {"OK"} \
		with title "$2"
	end tell
	EOF
}

display_dialog() {
	/usr/bin/osascript <<- EOF | cut -d ":" -f 2
	tell application "System Events"
		activate
		display dialog "$1" \
		with icon 1 \
		buttons {"Toggle","Close"} \
		with title "$2"
	end tell
	EOF
}

gen_notice() {
	printf 'Dashboard is currently %s. Press Toggle to %s dashboard or Close to exit\n\n' "$1" "$2"
	echo 'Note: Toggling the dashboard will result in a restart of \"Dock\" which will cause all minimized programs to be restored.'
}

toggle_dashboard() {
	defaults write com.apple.dashboard mcx-disabled -boolean "$1"
	killall Dock
}

status=$(defaults read com.apple.dashboard mcx-disabled)
if (( status == 0 )); then
	answer=$(display_dialog "$(gen_notice enabled disable)" "Toggle Dashboard")

	if [[ "$answer" == "Toggle" ]]; then
		toggle_dashboard YES
		display_alert "Dashboard has been disabled." "Toggle Dashboard"
	fi
else
	answer=$(display_dialog "$(gen_notice disabled enable)" "Toggle Dashboard")

	if [[ "$answer" == "Toggle" ]]; then
		toggle_dashboard NO
		display_alert "Dashboard has been enabled." "Toggle Dashboard"
	fi
fi
