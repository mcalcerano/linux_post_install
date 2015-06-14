#!/bin/bash

############################################################################
###SCRIPT   After a fresh installation, this script first runs the default
###         cb-welcome script, which updates package list, and gives options
###         to dist-upgrade, and install various packages.
###         It then gives the option to replace the default sources.list;
###         reinstalls powersave and startup/shutdown sounds;
###         installs various preferred apps;
###         removes unwanted default apps;
###         finally sets the switched backgrounds.
###
###
#############First, run cb-welcome after fresh install #####################
    echo "Running cb-welcome post-install script..."
    sleep 1s
    echo ""
    cb-welcome
    echo ""
    echo "Now run demo's setup..."

###INTRO
echo "This script installs a number of additional packages and restores"
echo "some configuration and system tweaks"
echo "apt sources.list is replaced from backup, and apt updates and"
echo "apt keys added"
echo ""
echo "Many thanks to OMNS for his post-install script that this script"
echo "draws its inspiration from."
echo ""
echo "Before continuing some things to note:"
echo "1) Please edit the script as necessary--removing packages or adding"
echo "2) Note that you must run this script as root or via sudo."
echo "3) Have any config files you'd like to use mounted / accessible."
echo ""
echo -n "Run installer now? (y/n) > "
read a
if [ "$a" = "y" ] || [ "$a" = "Y" ] || [ "$a" = "" ]
then
  :
else
  { echo "bye"; exit 0; }
fi

##Updating and upgrading #####################################
    FPATH=/media/home/crunchbang-configuration/config-bkp/
    echo "Updating repositories and upgrading..."
    echo ""
    ## restore sources.list
    sudo cp $FPATH"sources.list" /etc/apt/sources.list
    sudo apt-get update
    sleep 2s
    echo "Getting virtualbox keyring..."
    wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | apt-key add -
    echo "Getting WINE keyring..."
    wget -O - http://www.lamaresh.net/apt/key.gpg | apt-key add -
    echo "Getting grub-customizer keyring"
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3F055C03
    apt-get update
##    apt-get dist-upgrade
    echo ""
    echo "Updating complete..."
    echo ""

#####Installing stuff ####################################
    echo "Package installations:"
    echo ""
    sleep 1s
    echo "Install preferred apps..."
## grub-customizer has no public key, so use --force-yes, else none will be installed
########### Add PROG to list if required ##################
    echo "Installing feh
    htop
    ffmpeg
    mlocate
    iceweasel
    orage
    gcalctool
    lm-sensors
    python3
    idle3
    echo ""
    sleep 1s
for PROG in "feh"\
            "htop"\
            "ffmpeg"\
            "iceweasel"\
            "mlocate"\
            "orage"\
            "gcalctool"\
            "lm-sensors"

do
    echo "Installing "$PROG
    sudo apt-get install -y --force-yes $PROG
    sleep 1s
    echo "Done"
    echo ""
done
echo "All installed..."
##Install guake terminal...
    #echo "Installing guake terminal"
    #echo ""
    #sleep 1s
    #apt-get install -y guake
    #echo ""
    #echo "Done..."
    #echo ""
##Install python3, tkinter, idle IDE and personal pymodules
    echo "Installing python3"
    echo ""
    sleep 1s
    sudo apt-get install -y python3
    echo ""
    echo "Done..."
    echo ""
    echo "Installing idle IDE"
    echo ""
    sleep 1s
    sudo apt-get install -y idle3
    echo "Done..."
    echo "Restoring personal pymodules"
    echo ""
    sudo cp /home/damo/crunchbang-configuration/config-bkp/pymodules/* /usr/lib/python3/dist-packages/
    echo "Done..."
    echo ""

###Stuff to remove ######################################
########### Add PROG to list if required ##################
    echo "Removing unwanted apps..."
    sleep 1s
    echo ""
for PROG in "gvfs-backends"\
			"parcellite"\
            "gftp"\
            "xchat"\
            "gigolo"\
            "gnumeric"
do
    echo $PROG" is being removed...."
    sudo apt-get remove -y $PROG
    sleep 1s
    echo "Done"
    echo ""
done
echo "All removed..."
##Cleanup time ############################################
    echo "Cleaning up packages..."
    sleep 1s
    sudo apt-get autoclean
    sudo apt-get autoremove
    echo ""
    echo "Packages cleaned up..."
    echo ""
## Reinstall scripts ######################################

## Install powersave
    echo "Installing powersave script..."
    sleep 1s
    sudo cp $FPATH"powersave" /etc/pm/power.d/
    echo "Done"
    echo ""
## Restore cb-exit
    echo "Restoring cb-exit configuration"
    sleep 1s
    sudo cp $FPATH"cb-exit" /usr/bin/
    echo "Done"
    echo ""
### Set up wallpaper
    echo "Setting wallpaper..."
    sleep 1s
    bin/switchbg.py "/home/damo/crunchbang-configuration/openbox/wallpaper/" -s 0.2 &
    echo "Done"
    echo ""
    echo "All done..... :)"
## Restore personal configs
	CNFGPATH=$FPATH/configs
	echo ""
	echo "Restoring tint2, conky, openbox settings, terminal prompts"
	cp $CNFGPATH/.conkyrc $HOME/
	cp $CNFGPATH/tint2rc $HOME/.config/tint2
	cp $CNFGPATH/menu.xml $HOME/.config/openbox
	cp $CNFGPATH/rc.xml $HOME/.config/openbox
	cp $CNFGPATH/autostart $HOME/.config/openbox
	cp $CNFGPATH/dmenu-bind.sh $HOME/.config/dmenu
	cp -r $CNFGPATH/.themes $HOME
	cp $FPATH".bashrc" $HOME/
	echo ""
	echo "Restoring .config, .conky, .themes, bashrc's"
	sudo cp $FPATH".bashrc-rootprompt" /root/.bashrc
    echo "Done..."
    echo ""

exit
