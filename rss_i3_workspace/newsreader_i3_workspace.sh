#! /bin/bash

# Set variables
BROWSER_FOR_NEWSREADER=/usr/bin/firefox
NEWSREADER=/usr/bin/newsboat
TERMINAL=/usr/bin/uxterm
WORKSPACE_NAME="rss"

# If workspace already exists, move to it and do nothing
for WORKSPACE in $(lsws); do
  if [[ $WORKSPACE =~ $WORKSPACE_NAME ]]; then
    i3-msg workspace $WORKSPACE_NAME
    # TODO: Focus on BROWSER, the on NEWSREADER
    exit -1
  fi
done

# Open newsreader in workspace $WORKSPACE_NAME
i3-msg "workspace $WORKSPACE_NAME; exec nohup $TERMINAL $NEWSREADER > /dev/null &"

# Open browser in workspace $WORKSPACE_NAME
i3-msg "workspace $WORKSPACE_NAME; exec nohup $BROWSER_FOR_NEWSREADER > /dev/null &"

# Deactivate switching to window when opening newsreader link
# ACTIVE_WINDOW_ID=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2)
# xprop -id $ACTIVE_WINDOW_ID -set WM_NAME NewsreaderBrowser
