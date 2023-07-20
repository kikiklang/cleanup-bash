#!/bin/bash

# User info
USER='vinz'
DISK='nvme0n1p2'

# Colors for formatting output
NOCOLOR='\033[0m'
GREEN='\033[1;33m'

# Function to print section headers
current_task_title () {
  echo -e "${GREEN}-------------------------------------------------${NOCOLOR}"
  echo -e "${GREEN}$1${NOCOLOR}"
  echo -e "${GREEN}-------------------------------------------------${NOCOLOR}"
}

# Function to clean various logs
clean_logs() {
  current_task_title "Nettoyage des logs"
  sudo journalctl --vacuum-time=3d
  sudo rm -f /var/log/*g
}

# Function to list installed snaps and remove older versions
remove_old_snaps() {
  current_task_title "Liste les snaps et supprime les vieilles versions"
  snap list
  set -eu
  snap list --all | awk '/disabled/{print $1, $3}' |
    while read -r snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done
}

# Function to clean the thumbnail cache
clean_thumbnail_cache() {
  current_task_title "Supprime le cache des vignettes system"
  rm -rf ~/.cache/thumbnails/*
  echo -e "${GREEN}ok${NOCOLOR}"
}

# Function to remove old kernels
remove_old_kernels() {
  current_task_title "Supprime les kernels obsolètes"
	current_kernel="$(uname -r | sed 's/\(.*\)-\([^0-9]\+\)/\1/')"
	current_ver=${current_kernel/%-generic}

	echo "La version courante est : ${current_kernel}"
	# uname -a

	function xpkg_list() {
		  dpkg -l 'linux-*' | sed '/^ii/!d;/linux-libc-dev/d;/'${current_ver}'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d'
	}

	echo "Les noyaux suivants (désormais inutilisés) vont être supprimés"
	xpkg_list

	read -p '-- On continue?  (y / n) --' -n 1 -r
	printf "\n"
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		  xpkg_list | xargs sudo apt-get -y purge
	else
		  echo 'Operation a été annulée - aucun changement effectué'
	fi
}

# Function to empty trash bin
empty_trash_bin() {
  current_task_title "Vidage de la corbeille"
  rm -rf ~/.local/share/Trash/*
  echo -e "${GREEN}ok${NOCOLOR}"
}

# Function to remove residual configurations
remove_residual_config() {
  current_task_title "Suppression des résidus de configuration logiciels"
  sudo apt purge ~c
  echo -e "${GREEN}ok${NOCOLOR}"
}

# Function to check disk usage on home user folders
check_home_disk_usage() {
  current_task_title "Tailles des dossiers de home"
  sudo du -shc /home/${USER}/* | sort -rh
}

# Function to perform system update
system_update() {
  current_task_title "Mise à jour des paquets"
  while true; do
    read -p "Voulez-vous faire une mise à jour des paquets? (y/n) " yn
    case $yn in
      [Yy]* ) sudo apt update -y; break;;
      [Nn]* ) break;;
      * ) echo "Veuillez répondre par 'y' ou 'n'.";;
    esac
  done
}

# Function to perform system upgrade
system_upgrade() {
  current_task_title "Mise à niveau des paquets"
  while true; do
    read -p "Voulez-vous faire une mise à niveau des paquets? (y/n) " yn
    case $yn in
      [Yy]* ) sudo apt upgrade -y; break;;
      [Nn]* ) break;;
      * ) echo "Veuillez répondre par 'y' ou 'n'.";;
    esac
  done
}

# Function to clean apt packages and cache
clean_apt_packages() {
  current_task_title "Nettoyage des paquets et du cache"
  apt-get -y autoremove --purge
  apt-get -y clean
  apt-get -y autoclean
}

# Function to check disk space after cleaning
check_disk_space() {
  current_task_title "Taille du disque après nettoyage"
  df /dev/${DISK} -h --output=source,size,used,pcent
}

# Main function to execute all cleaning tasks
main() {
  clean_logs
  remove_old_snaps
  clean_thumbnail_cache
  remove_old_kernels
  empty_trash_bin
  remove_residual_config
  check_home_disk_usage
  system_update
  system_upgrade
  clean_apt_packages
  check_disk_space
}

# Run the main function
main

