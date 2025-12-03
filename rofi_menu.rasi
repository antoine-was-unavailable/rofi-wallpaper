#!/usr/bin/env bash


options=$(ls $HOME/.dotfiles/themes --format=single-column)

# Show the menu and store the user’s choice
choice=$(echo -e "$options" | rofi -config $HOME/.dotfiles/theme_switcher.rasi -dmenu -i -p "Themes")


bash $HOME/.dotfiles/switch.sh $choice