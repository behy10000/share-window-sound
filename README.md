# share-window-sound
You can use this script to select a window (or its program name) and connect its sound output to another program which has a sound input.
For example you can connect your video player's sound output to your discord's sound input.

Selecting a window requires xprop, which isn't available on wayland.

The script was designed to make sharing screen with sound easier on linux. First you add a hotkey for connecting and disconnecting the window sound to your window manager, then whenever you want to share a window, first select the window in the sharescreen dialog in discord, then use the hotkey, then left click on the window and you're done! just remember to disconnect that window using your disconnect hotkey whenever you are done sharing.

Note that others will hear the sounds from YOU as if it is coming from your microphone, not the stream. This can theoretically be fixed by using [this](https://github.com/edisionnano/Screenshare-with-audio-on-Discord-with-Linux) method and some changes to the script.

This more a proof of concept than a fully fledged solution. I made this since it seemed no one had thought about this method. Maybe this will help a third-party client for discord to finally have a somewhat normal sharescreen.

Also I have very limited experience with shell scripting as I have only made very short scripts.

# Requirements
- xprop (for selecting window)
- jq
- pipwire
  - pw-cli
  - pw-dump
  - pw-link

# Usage
the syntax is:
```
./sws.sh <connect|disconnect> <destination program name> [source program name]
```

You can also use "c" and "d" instead of "connect" and "disconnect".

If there is no source program specified, you will need to left click on a window to select it as your source

You should use the name of the executable binary of your program for both the source and destination program name, if you are unsure what it is then
```
 ./sws.sh f <s|d>
 or
 ./sws.sh find-name <sources|destinations>
```
Will help you find what it is. use "find-name source" to get a list of all available sound outputs and "find-name destinations" for sound inputs.
then enter the id of each of the ports that are shown and you will get the name of the application.

# How does it work?
The script uses xprop to find the PID of the program owning the window (not sure if there is an alternative in wayland), uses pw-dump to get all nodes and filters then with jq to get the nodes related to the program, uses the same technique to find the nodes of the destination program using program name instead of PID and connects all the output ports of the source program to all the input ports of the destination program.

You can also give the program name for source as well instead of clicking on its window, this should work in wayland as well since you won't be needing xprop.
