#!/usr/bin/env bash

# check if all args have been parsed
if ! [ $3 ];then
    rofi -dmenu -mesg $0$': you need to parse 3 arguments\n\n    • $1: Path to your wallpaper directory\n    • $2: Path to the monitor menu rofi theme file\n    • $3: Path to the wallpaper menu rofi theme file'
    exit 1
fi


xrandr_info=$(xrandr --listmonitors) # Get monitors info
monitor_count=$(cat <<<$xrandr_info | head -1 | awk '{print $2}') # Get monitor count

if (( $monitor_count > 1 ));then # if more than 1 monitor
    monitor_ports=$(cat <<<$xrandr_info | tail -$monitor_count |  awk '{print $2}') # Get monitors port name
    chosen_monitor=$(echo -en "$monitor_ports" | rofi -config $2 -dmenu -i -p "Select a display") # Display them in a rofi menu
    chosen_monitor_index=$(cat <<<$xrandr_info | grep $chosen_monitor | awk '{print $1}') # Store the selected monitor index
    monitor=${chosen_monitor_index::-1} # Set selected monitor
else # Else default to monitor 0
    monitor=0
fi

# exit if no monitor is chosen
if ! [ $monitor ];then
    exit 1
fi


cd $1 # move wallpaper folder


# fetch all wallpapers
for w in *;do
    wallpaper_list=$wallpaper_list"$w\0icon\x1fthumbnail://$1/$w\n"
done

# Show rofi menu
wallpaper=$(echo -en "$wallpaper_list" | rofi -config $3 -dmenu -i -p "Wallpapers")

# exit if no wallpaper is chosen
if [ "$wallpaper" == "" ];then
   exit 1
fi

# set wallpaper using nitrogen
nitrogen --save --set-zoom-fill --head=$monitor $wallpaper