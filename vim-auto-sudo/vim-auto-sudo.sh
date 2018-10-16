#! /bin/bash

file=$1
EDITOR="/usr/bin/vim"

if [[ -f $file ]]; then # If file exists
  if [[ -w $file ]]; then # If user has write access
    $EDITOR $*;
  else # User doesn't have write access
    sudo -nv 2> /dev/null # Used to check if sudo credentials are cached
    if [[ $? -eq 0 ]]; then # If sudo credentials are cached
      # Hit enter to edit the file, hit Ctrl+C to open the file read-only
      echo You don\'t have the rights to modify this file. Executing "sudo $0 $*".
      read -p "Sudo credentials are cached, hit ENTER to edit the file with sudo access, or hit Ctrl+C to exit"
      sudo $EDITOR $*;
    else # Sudo credentials are not cached
      echo You don\'t have the rights to modify this file. Executing "sudo $0 $*". Hit Ctrl+C if you want to open the file read-only.
      sudo $EDITOR $*;
    fi
    if [[ $? -eq 1 ]]; then # If user hit Ctrl+C, open file read-only (reads output from previous command)
      $EDITOR $*;
    fi
  fi
else # If file doesn't exist
  # Check if you can write in this folder
  # if [[ -w ]]

  $EDITOR $*;
fi
