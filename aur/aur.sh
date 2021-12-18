#!/bin/bash

pull="git pull"
install_upgrade="makepkg -si"
remove_files="rm -v *.tar.xz *.zst *.deb 2>/dev/null"


function update {
	for folder in /home/$USER/builds/*; do
		if [ -d "$folder" ]; then
			echo $folder
			cd $folder
			output=$(eval "$pull")
			if [[ $output != "Already up to date." ]]; then
				eval "$install_upgrade"
				echo -e "\r"
			fi;
		fi
	done;
}

function install {
	cd /home/$USER/builds;
	git clone https://aur.archlinux.org/$1.git;
	cd $1
	eval "$install_upgrade"
}

function cleanup {
	for folder in /home/$USER/builds/*; do
		if [ -d "$folder" ]; then
			echo $folder
			cd $folder
			output=$(eval "$remove_files")
		fi
	done;
}

case "$1" in
	"update"|-u|--update)
		update
		;;
	"install"|-i|--install)
		if [ -z "$2" ]; then
			echo "no package selected"
		else
			install $2
		fi
		;;
	"cleanup"|-c|--cleanup)
		cleanup
		;;
	*)
	echo "Usage: $0"
	echo "	install | -i | --install [aur git link] : Install AUR Package"
	echo "	update | -u | --update : Updates all AUR Packages"
	echo "	cleanup | -c | --cleanup : Remove all .tar.xz .zst .deb files"
	;;
esac
