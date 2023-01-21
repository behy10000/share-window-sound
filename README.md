# share-window-sound
You can use this script to select a window (or use its program name) and connect its sound output to another program which has a sound input.
For example you can connect your video player's sound output to your discord's sound input.

The script was designed to make sharing screen with sound easier on linux, but it can be used outside of that as well.

Note that others will hear the sounds from YOU as if it is coming from your microphone, not the stream. This can theoretically be fixed by using [this](https://github.com/edisionnano/Screenshare-with-audio-on-Discord-with-Linux) method and some changes to the script.

This more a proof of concept than a fully fledged solution. I made this since I didn't find anyone talking about this method. Maybe this will help a third-party client for discord to finally have a somewhat normal sharescreen, and implement a more robust way to achieve all this.

Also I have very limited experience with shell scripting as I have only made very short scripts.

# Requirements
- xprop (for selecting window)
- jq
- pipwire
  - pw-cli
  - pw-dump
  - pw-link


# How to use this for discord

### Vanilla discord

0. Make sure you have the dependencies.
1. Download the script and save it somewhere. for example /home/user/
    - Add hotkeys (optional)
      - Go to your Desktop Environment settings or your window manager config and add a hotkey for each of the following commands (first one for connecting sound, second one for disconnecting it):
      ```
      /home/user/sws.sh c Discord
      /home/user/sws.sh d Discord
      ```
2. Share a window or your screen as you normally would
3. use your first hotkey and click on the window that you want to share it's sound (or use the first command in a terminal)
4. When you are done, don't forget to use the second hotkey to disconnect the window sound (or use the second command in a terminal)

### Other Versions (Canary, Third-party clients, etc.)

you can find the name of the binary using
```
/home/user/sws.sh find-name destinations
```
Discord is usually listed as "WEBRTC VoiceEngine", select it and replace "Discord" in the original commands with the name that you found. Follow the same steps.

# Usage
the syntax is:
```
./sws.sh <connect|disconnect> <destination program name> [source program name]
```

You can also use "c" and "d" instead of "connect" and "disconnect".

If there is no source program specified, you will need to left click on a window to select it as your source.

You should use the name of the executable binary of your program for both the source and destination program name, if you are unsure what it is then
```
 ./sws.sh f <s|d>
 or
 ./sws.sh find-name <sources|destinations>
```
Will help you find what it is. use "find-name source" to get a list of all available sound outputs and "find-name destinations" for sound inputs.
then enter the id of each of the ports that are shown and you will get the name of the application.

# How does it work?
The script uses xprop to find the PID of the program owning the window (not sure if there is an alternative in wayland), uses pw-dump to get all nodes and filters them with jq to get the nodes related to the program, uses the same technique to find the nodes of the destination program using program name instead of PID and connects all the output ports of the source program to all the input ports of the destination program.

You can also give the program name for source as well instead of clicking on its window, this should work in wayland since you won't be needing xprop.
