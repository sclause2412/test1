# Virtual Pipe Organ Extension - Huber Orgel Deutsch Kaltenbrunn

## Organ

This virtual pipe organ is not a full organ but is very limited because it is only an extension for a real pneumatic pipe organ in Deutsch Kaltenbrunn.

The target of this project is to add reed registers to the existing organ without modifying the organ itself. If GrandOrgue is not started the organ should still be fully functional.

The UI is optimized for a small touch screen which is mounted on the console with a fixed resolution of 1024x600 px. It is not needed to show the manuals but instead big buttons for the registers.
The original organ has some couplers. Currently I cannot read the state of those couplers, therefore the couplers are reproduced on the virtual organ.

Additionally, there is a tuning button direclty on the main interface because the virtual organ needs to be retuned after starting to match the real organs tune (or better "out of tune").

Compared to a typical virtual pipe organ this organ does not have (on the main view):

* Tremulants
* Generals
* Manuals
* Pedal

For debugging purposes the manuals and pedals can be switched on with a second view. The keys are very big because otherwise you cannot touch them on the small screen.

## Environment

This organ is intended to be used with GrandOrgue software on a PC which is mounted inside the organ with a remote on/off switch and a touch screen mounted on the organ console.
In final state there is no keyboard or mouse attached.

The PC runs with Arch Linux. This project is also used for documenting the installation process of the whole system.

# Installation

## Full installation

For installation use an installation medium containing Arch Linux. This can be a DVD or a USB stick. Manuals for creating the installation medium can be found in the [Arch Linux Wiki](https://wiki.archlinux.org/).

After booting from the installation medium run `archinstall` command to use the installation assistant.
For most settings like language and region settings, hard drive partitioning, etc. you can follow the official guide.
Don't forget to connect to the network during installation and organ setup. Network can be disconnected once the installation is done.

Important (recommended) settings for GrandOrgue:

* Hostname: grandorgue
* Users: Add a user with username grandorgue and password of your choice. Add user to sudo group.
* Profile: xorg
* Audio: Pulseaudio
* Network: Copy from ISO
* Additional packages: git

After installation reboot the system and log in with grandorgue user.

Now you can install everything with:

```shell
git clone https://github.com/sclause2412/grandorgue-organ-huber
cd grandorgue-organ-huber
chmod +x install.sh
./install.sh
```

After installation the PC should automatically restart and GrandOrgue is loaded.

Make all your organ settings you need and then exit GrandOrgue with the menu. The settings will automatically be saved in a permanent space. The next time you restart the PC the settings will be restored. With this technique the organ is save from accidential reconfigurations.

To save new settings just make your changes in GrandOrgue, close it and then run `./save` in your home folder.

To access a console press `Win+Enter` on the PC or connect via ssh.

If there is no need to change settings it is recommended to disconnect any keyboard, mouse or network for security reasons.

## Organ only

If you have already an existing system running GrandOrge you can use the following commands to create the Organ package:

```shell
git clone https://github.com/sclause2412/grandorgue-organ-huber
cd grandorgue-organ-huber
chmod +x pack.sh
./pack.sh
```

This will give you a file huber.orgue which you then can install with the GrandOrgue UI.

If you are running a Windows machine then simply use a ZIP program and pack all the files from the Organ folder into a ZIP archive with **no compression**. Rename that ZIP file to huber.orgue and install it using GrandOrgue UI.

To see the correct font install the font file from the Fowviel.zip archive.

# License

This organ and the installation script is licensed under the CC BY-SA 4.0 International license. See more details in the [LICENSE](LICENSE) file or on the [Creative Commons Website](https://creativecommons.org/licenses/by-sa/4.0/).

Attention: Only the organ definition, structure, images and installation script are affected by this license. The samples and font are taken over from other projects and have different licenses (see below).

# Thanks

I do not have any own recordings of existing organgs and I do not have the knowledge to create those.

Therefore, I'm using samples from other samplesets (which are of course free).
The samples are quite "dry" which is needed because I have the acoustic from the real church and do not want to add too much artificial acoustic.

## A big thank you to:

**Lars Palo**

Im using the registers Basun 16' (Posaune 16'), Trumpet 8' (Trompete 8') and Skalmeja 8' (Schalmei 8') from his beautiful sampleset "Bureå Church, Sweden" recorded / reworked in 2023. This sampleset is licensed under CC BY-SA 2.5 Sweden. More information on Lars' website: [Lars Virtual Pipe Organs](https://familjenpalo.se/vpo/)

**Dominique Lacaud**

He has created two samplesets:
* Celeste F from year 2020 which I use for Celesta
* Steinway Model B from year 2017 which I use for Klavier

Both samplesets are licensed under GPLv2. Please have a look on his website for much more very beautiful small samplesets of different instruments: [OdfGrandOrgue](http://orgues-dominiquelacaud.fr/)

**Dmitry Barsukov**

Thank you for the beautiful font which fits perfectly to our existing organ. The font is free to use and can be found here: [dafont.com](https://www.dafont.com/fowviel.font)
