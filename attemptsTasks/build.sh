#!/bin/bash

# Remve GNOME stuff
for pkg in gnome-calculator gnome-calendar \
gnome-characters gnome-control-center gnome-control-center-data \
gnome-control-center-faces gnome-desktop3-data \
gnome-font-viewer gnome-getting-started-docs \
gnome-initial-setup gnome-keyring gnome-keyring-pkcs11 gnome-logs \
gnome-mahjongg gnome-menus gnome-mines gnome-online-accounts \
gnome-power-manager gnome-screenshot gnome-session-bin gnome-session-canberra \
gnome-session-common gnome-settings-daemon gnome-settings-daemon-common \
gnome-shell gnome-shell-common gnome-shell-extension-appindicator \
gnome-shell-extension-desktop-icons gnome-shell-extension-ubuntu-dock \
gnome-startup-applications gnome-sudoku gnome-system-monitor gnome-terminal \
gnome-terminal-data gnome-themes-extra gnome-themes-extra-data gnome-todo \
gnome-todo-common gnome-user-docs gnome-video-effects \
nautilus-extension-gnome-terminal pinentry-gnome3 yaru-theme-gnome-shell;
do apt-get purge -y $pkg; done
apt autoremove
apt-get install -y software-properties-gtk

# Run the remix script
bash remix.sh && apt-get autoremove -y --purge

#mkdir newkernel && cd newkernel
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.1.4/amd64/linux-image-unsigned-6.1.4-060104-generic_6.1.4-060104.202301071207_amd64.deb
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.1.4/amd64/linux-modules-6.1.4-060104-generic_6.1.4-060104.202301071207_amd64.deb
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.1.4/amd64/linux-headers-6.1.4-060104-generic_6.1.4-060104.202301071207_amd64.deb
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.1.4/amd64/linux-headers-6.1.4-060104_6.1.4-060104.202301071207_all.deb
#dpkg -i *.deb
#cd ..
#rm -r newkernel
#from https://9to5linux.com/you-can-now-install-linux-kernel-6-1-on-ubuntu-heres-how

apt upgrade
apt-get autoremove
apt-get autoclean
apt dist-upgrade
apt-get autoremove
apt-get autoclean
#-from https://elias.praciano.com/2014/08/apt-get-quais-as-diferencas-entre-autoremove-autoclean-e-clean/
apt --fix-broken install

echo "- Installing the broken packages, efibootmgr and grub..."
apt-get install efibootmgr grub-efi-amd64-bin grub-efi-amd64-signed

# Clean up
update-initramfs -k all -u
apt-get clean
#rm -f /var/lib/apt/lists/*_Packages
#rm -f /var/lib/apt/lists/*_Sources
#rm -f /var/lib/apt/lists/*_Translation-*
#rm -rf /tmp/* ~/.bash_history
