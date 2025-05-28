#!/bin/bash

# Determine the user's home directory dynamically
if [ -n "$SUDO_USER" ]; then
  USER_HOME="/home/$SUDO_USER"
else
  USER_HOME="$HOME"
fi
CONFIG_FILE="$USER_HOME/.config/kdeglobals"
SECTION="[General]"
KEY1="TerminalApplication"
VALUE1="ghostty"
KEY2="TerminalService"
VALUE2="ghostty.desktop"

# Ensure the file exists
touch "$CONFIG_FILE"

# Check if the section exists
if ! grep -q "^\[General\]" "$CONFIG_FILE"; then
  echo -e "\n$SECTION" >> "$CONFIG_FILE"
fi

# Add or update the keys
if grep -q "^$KEY1=" "$CONFIG_FILE"; then
  sed -i "s|^$KEY1=.*|$KEY1=$VALUE1|" "$CONFIG_FILE"
else
  sed -i "/^\[General\]/a $KEY1=$VALUE1" "$CONFIG_FILE"
fi

if grep -q "^$KEY2=" "$CONFIG_FILE"; then
  sed -i "s|^$KEY2=.*|$KEY2=$VALUE2|" "$CONFIG_FILE"
else
  sed -i "/^\[General\]/a $KEY2=$VALUE2" "$CONFIG_FILE"
fi

echo "Configuration updated in $CONFIG_FILE"
