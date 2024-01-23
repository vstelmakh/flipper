# Play video on mouse move
This script downloading provided video to target PC and playing it when mouse moved. Video is open in full screen without any controls. All the execution traces as well as downloaded files are removed after video is closed.

## Target
- Windows 10
- Windows 11

## Setup
1. Provide a valid link for video in [script.txt](./script.txt#L11).
2. Rename `script.txt` to any desired script name. Remeber `.txt` extension is required.
3. Upload `%any-name%.txt` to Flipper `badusb` dir.

> Keep in mind video will be downloaded on target. Smaller size - faster setup time.

## Run
Once execution complete - download and setup process starting.
On setup complete - script is presing `Caps Lock` button to indicate that process is complete.
As soon as mouse will change position video will start playing in full screen.
