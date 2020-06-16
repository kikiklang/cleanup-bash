#!/bin/bash

# ----------------------------------
# User info
# ----------------------------------
USER='your_username'
DISK='your_diskanme' 

# ----------------------------------
# Variables
# ----------------------------------
NOCOLOR='\033[0m'
GREEN='\033[1;33m'

# ----------------------------------
# Fonctions
# ----------------------------------
current_task_title () {
  echo -e "${GREEN}-------------------------------------------------${NOCOLOR}"
  echo -e "${GREEN}$1${NOCOLOR}"
  echo -e "${GREEN}-------------------------------------------------${NOCOLOR}"
}

# ----------------------------------
# Disk space before
# ----------------------------------
current_task_title "Taille du disque avant nettoyage"
df /dev/${DISK} -h --output=source,size,used,pcent

# ----------------------------------
# Clear systemd journal logs
# ----------------------------------
current_task_title "Nettoyage des logs du system"
sudo journalctl --vacuum-time=3d

# ----------------------------------
# List of installed snap and remove older versions 
# ----------------------------------
current_task_title "Liste les snap et supprime les vieilles versions"
snap list
set -eu
snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done

# ----------------------------------
# Clean the thumbnail cache
# ----------------------------------
current_task_title "Supprime le cache des vignettes system"
rm -rf ~/.cache/thumbnails/*
echo -e "${GREEN}ok${NOCOLOR}"

# ----------------------------------
# Empty trash bin
# ----------------------------------
current_task_title "vidage de la corbeille"
rm -rf ~/.local/share/Trash/*
echo -e "${GREEN}ok${NOCOLOR}"

# ----------------------------------
# Gest disk usage on home user folders
# ----------------------------------
current_task_title "Tailles des dossiers de home"
sudo du -shc /home/${USER}/* | sort -rh

# ----------------------------------
# Update packages
# ----------------------------------
current_task_title "Update"
while true; do
    read -p "Est-ce qu'on ferait pas une MAJ des paquets? (y / n)" yn
    case $yn in
        [Yy]* ) sudo apt update -y; break;;
        [Nn]* ) exit;;
        * ) echo "il faut repondre quelque chose bondieu";;
    esac
done

# ----------------------------------
# Upgrade packages
# ----------------------------------
current_task_title "Upgrade"
while true; do
    read -p "Est-ce qu'on ferait pas un upgrade? (y / n)" yn
    case $yn in
        [Yy]* ) sudo apt upgrade -y; break;;
        [Nn]* ) exit;;
        * ) echo "il faut repondre quelque chose bondieu";;
    esac
done

# ----------------------------------
# Clean apt package and cache
# ----------------------------------
current_task_title "Nettoyage des paquets et du cache"
apt-get -y autoremove --purge
apt-get -y clean
apt-get -y autoclean

# ----------------------------------
# Disk space after
# ----------------------------------
current_task_title "Taille du disque apres nettoyage"
df /dev/${DISK} -h --output=source,size,used,pcent

