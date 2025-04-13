#!/bin/bash

echo Installing GrandOrgue + Huber Organ with all needed settings.
echo This installer is using sudo command.
echo Please provide your password whenever you are asked.
echo
sudo -v
cat <<EOF >/tmp/sudohelper
#!/bin/bash
while true; do
    sudo -v
    sleep 10
done
EOF
chmod +x /tmp/sudohelper
/tmp/sudohelper &

command -v yay >/dev/null
if [ $? -ne 0 ]; then
    echo Trying to install YAY
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -sri
    cd ..
    rm -rf yay-bin
fi
command -v yay >/dev/null
if [ $? -ne 0 ]; then
    echo YAY not installed. Please install it or run this installer again.
    exit 1
fi
echo Doing full system upgrade
yay -Syu --noconfirm --sudoloop
function check_or_install {
    ret=$(yay -Q $1)
    if [ -z "$ret" ]; then
        echo Installing $1
        yay -S --noconfirm --sudoloop $1
    fi
    ret=$(yay -Q $1)
    if [ -z "$ret" ]; then
        echo Failed to install package $1
        echo Please install the correct package manually
        exit 1
    fi
}
check_or_install openssh
check_or_install xlogin-git
check_or_install i3-wm
check_or_install rxvt-unicode
check_or_install unclutter
check_or_install xprintidle
check_or_install zip
check_or_install unzip
check_or_install nano
check_or_install grandorgue-git

echo Enabling SSH
sudo systemctl enable sshd

echo Setting up rights
sudo usermod -aG tty grandorgue
sudo systemctl enable xlogin@grandorgue
CMD="%wheel ALL=NOPASSWD: /sbin/halt, /sbin/reboot, /sbin/poweroff, /sbin/shutdown"
PO=$(sudo grep "$CMD" /etc/sudoers)
if [ -z "$PO" ]; then
    echo "$CMD" | sudo EDITOR='tee -a' visudo
fi

echo Writing config files
cat <<EOF >~/.xinitrc
#!/bin/bash
for sink in \`pactl list short sinks | cut -f 2\`; do
    pactl set-sink-volume \$sink 100%
done
unclutter &
~/autoshutdown &
exec i3
EOF

cat <<EOF >~/autoshutdown
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

cat <<EOF >~/save
#!/bin/bash
cp -f ~/GrandOrgueConfig ~/GrandOrgueConfig.default
cp -a ~/GrandOrgue/Data ~/GrandOrgue/Data.default
EOF
chmod +x ~/save

cat <<EOF >~/grandorgue
#!/bin/bash
if [ -f ~/GrandOrgueConfig.default ]; then
    cp -f ~/GrandOrgueConfig.default ~/GrandOrgueConfig
fi
if [ -d ~/GrandOrgue/Data.default ]; then
    cp -f ~/GrandOrgue/Data.default/* ~/GrandOrgue/Data/
fi
GrandOrgue
if [ ! -f ~/GrandOrgueConfig.default ]; then
    cp -f ~/GrandOrgueConfig ~/GrandOrgueConfig.default
fi
if [ ! -d ~/GrandOrgue/Data.default ]; then
    cp -f ~/GrandOrgue/Data/* ~/GrandOrgue/Data.default/
fi
EOF
chmod +x ~/grandorgue

if [ ! -f ~/.config/i3/config ]; then
    i3-config-wizard -m win
    sed -i '/^bar[[:space:]]*{/,/^}/d' ~/.config/i3/config
    echo default_border pixel 0 >> ~/.config/i3/config
    echo workspace_layout tabbed >> ~/.config/i3/config
    echo exec ~/grandorgue >> ~/.config/i3/config

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
    exit 1
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
    exit 1
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

reboot