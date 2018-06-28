#!/bin/bash
 
set -e
# Target directory
PREFIX="/usr/local"
 
# List of the needed packages
# To adapt to your needs
PROJECTS="efl emotion_generic_players evas_generic_loaders enlightenment"
ENAPPS="terminology rage ephoto ecrire empc enjoy equate eve" 
# Download url
SITE=" http://git.enlightenment.org/core/"
SITEAPP=" http://git.enlightenment.org/apps/"
OPT="--prefix=$PREFIX"
 
PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
PATH="$PREFIX/bin:$PATH"
LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"
LOG="installe.log"
rm -f $LOG      # Delete precedent log file
touch $LOG      # Create a log file
date >> $LOG    # Add current date
 
# Download and compile each module
for PROJ in $PROJECTS; do
    # Cloning
    if [ ! -d $PROJ ]; then
        git clone $SITE$PROJ.git $PROJ
    fi
    # Go building and installing
    cd $PROJ*
    make clean distclean || true
    ./autogen.sh $OPT
    make
    sudo make install
    cd ..
    sudo ldconfig
    echo $PROJ" is installed" >> $LOG
done

echo "Installing Applications" >> $LOG

for ENAPP in $ENAPPS; do
    # Cloning
    if [ ! -d $ENAPP ]; then
        git clone $SITEAPP$ENAPP.git 
    fi
    # Go building and installing
    cd $ENAPP*
    #make clean distclean || true
    echo -ne $ENAPP"Installation..." >> $LOG	
    ./autogen.sh $OPT
    make
    echo -ne "..." >> $LOG
	sudo make all install
    cd ..
    echo -ne "..." >> $LOG
    sudo ldconfig
    echo "...Done" >> $LOG
done


 
#Optionnal Terminology
#git clone http://git.enlightenment.org/apps/terminology.git
#cd terminology
#./autogen.sh $OPT
#make
#sudo make all install
#cd ..
#sudo ldconfig
 
# Delete all downloaded files and compile traces
#rm -rf e*
 
# Create the menu entry of Enlightenment for gdm, kdm or liqhtdm
sudo ln -s /usr/local/share/xsessions/enlightenment.desktop /usr/share/xsessions/
