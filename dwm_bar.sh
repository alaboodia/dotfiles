#!/bin/sh

audio(){
	SINK=$(pactl list short sinks | grep -n RUNNING | cut -d":"  -f1)
	if [ "$SINK" = "" ]; then
		SINK=1
	fi
	NOW=$( pactl list sinks | grep '^[[:space:]]Volume:' | head -n $SINK | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,' )
	MUTE=$(pactl list sinks | grep '^[[:space:]]Mute:'| head -n $SINK | tail -n 1 | awk -F ":" '{print $2}'| xargs)

	if [ "$MUTE" = "yes" ]; then
		echo "Muted"
	else
		echo "$NOW%"
	fi

	case $BLOCK_BUTTON in
		1) setsid -f st -c stpulse -n stpulse -e ncpamixer ;;
	esac
}

# Prints all batteries, their percentage remaining and an emoji corresponding
# to charge status (🔌 for plugged up, 🔋 for discharging on battery, etc.).
battery(){
# Loop through all attached batteries and format the info
	
	for battery in /sys/class/power_supply/BAT0; do
		# Sets up the status and capacity
		case "$(cat "$battery/status" 2>&1)" in
			"Full") status="Full" ;;
			"Discharging") status="Disconnected" ;;
			"Charging") status="Charging" ;;
			"Not charging") status="Not Charging" ;;
			"Unknown") status="Unkown?" ;;
			*) exit 1 ;;
		esac
		capacity="$(cat "$battery/capacity" 2>&1)"
		# Will make a warn variable if discharging and low
		[ "$status" = "Need Charging" ] && [ "$capacity" -le 25 ] && warn="Warning!"
		# Prints the info
		printf "%s %d%%" "$status" "$capacity"; unset warn
	done && printf "\\n"
}

time(){
	date "+%Y/%m/%d (%H:%M)"
}
while true; do     
	xsetroot -name "$(audio) | $(time) | $(battery)";
    sleep 60;
done  &

