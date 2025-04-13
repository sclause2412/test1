#!/bin/bash

echo Installing GrandOrgue + Huber Organ with all needed settings.
echo This installer is using sudo command.
echo Please provide your password whenever you are asked
echo
sleep 10
command -v yay >/dev/null
if [ $? -ne 0 ]; then
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -sri
    cd ..
    rm -rf yay-bin
fi
command -v yay >/dev/null
if [ $? -ne 0 ]; then
    echo yay not installed. Please install it or run this installer again.
    exit 1
fi
yay -Syu --noconfirm --sudoloop
yay -S --noconfirm --sudoloop openssh xlogin-git i3-wm rxvt-unicode rofi unclutter xprintidle zip unzip nano
# grandorgue-git
sudo systemctl enable sshd

echo <<EOF >~/.xinitrc
#!/bin/bash
for sink in \`pactl list short sinks | cut -f 2\`; do
    pactl set-sink-volume \$sink 100%
done
unclutter &
~/autoshutdown &
cp -f ~/GrandOrgueConfig.default ~/GrandOrgueConfig
cp -f ~/GrandOrgue/Data.default/* ~/GrandOrgue/Data/
exec i3
EOF

sudo usermod -aG tty grandorgue
sudo systemctl enable xlogin@grandorgue
CMD="%wheel ALL=NOPASSWD: /sbin/halt, /sbin/reboot, /sbin/poweroff, /sbin/shutdown"
PO=$(sudo grep "$CMD" /etc/sudoers)
if [ -z "$PO" ]; then
    sudo echo "$CMD" >>/etc/sudoers
fi
    
echo <<EOF >~/autoshutdown
#!/bin/bash
idletime=$((1000*60*60*2)) # 2 hours in milliseconds
while true; do
    idle=\`xprintidle\`
    echo \$idle
    if (( \$idle > \$idletime )); then
        sudo shutdown
    fi
    sleep 60
done
EOF
chmod +x ~/autoshutdown

mkdir -p ~/.config/i3
cp /etc/i3/config ~/.config/i3/config


exit


Create config for i3, use Win-Key as modifier
Win + Enter = Console
nano .config/i3/config
remove: bar {} section
change: {mod}+d behavior to rofi
add: default_border pixel 0
add: workspace_layout tabbed
#add: for_window [all] fullscreen enable
add: exec GrandOrgue




git clone https://github.com/sclause2412/grandorgue-organ-huber
cd grandorgue-organ-huber
chmod +x install.sh
./install.sh





sudo reboot

reboot


Set Organ settings as needed (MIDI settings, 50ms Release, -10dB Volume)
Close GrandOrgue to save settings
Win + Enter = Console
cp -f ~/GrandOrgueConfig ~/GrandOrgueConfig.default
cp -a ~/GrandOrgue/Data ~/GrandOrgue/Data.default
reboot





sudo -s systemctl enable sshd







command -v zip > /dev/null
if [ $? -ne 0 ]; then
    echo Command zip not found. Please make sure zip package is installed.
    exit 1
fi

command -v unzip > /dev/null
if [ $? -ne 0 ]; then
    echo Command unzip not found. Please make sure zip package is installed.
    exit 1
fi

CURDIR="$(pwd)"
cd ~
USERDIR="$(pwd)"
cd "${CURDIR}"


FILENAME=huber.orgue
if [ -f "${FILENAME}" ]; then
    rm -f "${FILENAME}"
fi
cd Organ
zip -0 -r "../${FILENAME}" *
cd ..
TARGET="${USERDIR}/GrandOrgue/Organ packages/"
if [ ! -d "${TARGET}" ]; then
    echo
    echo "Organ packages directory not found. Do you have GrandOrgue installed?"
    echo "If yes, please move the file huber.orgue manually to the organ packages"
    echo "directory or use the install menu from GrandOrgue"
    echo
else
    if [ -f "${TARGET}${FILENAME}" ]; then
        rm -f "${TARGET}${FILENAME}"
    fi
    mv "${FILENAME}" "${TARGET}${FILENAME}"
fi
unzip -o fowviel.zip
TARGET="${USERDIR}/.local/share/fonts/"
if [ ! -d "${TARGET}" ]; then
    mkdir -p "${TARGET}"
fi
if [ ! -d "${TARGET}" ]; then
    echo
    echo "Local font directory not found."
    echo "Please copy the font file Fowviel.ttf to your local font directory"
    echo
else
    FILENAME=Fowviel.ttf
    if [ -f "${TARGET}${FILENAME}" ]; then
        rm -f "${TARGET}${FILENAME}"
    fi
    mv "${FILENAME}" "${TARGET}${FILENAME}"
fi

echo
echo DONE
echo