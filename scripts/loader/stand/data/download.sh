#!/bin/sh

### BAG Extract
# echo "Download BAG Extract..."
# wget https://service.pdok.nl/kadaster/adressen/atom/v1_0/downloads/lvbag-extract-nl.zip || exit
# echo "Unzip..."
# unzip lvbag-extract-nl.zip 9999VBO\*.zip 9999NUM\*.zip 9999WPL\*.zip 9999OPR\*.zip 9999PND\*.zip 9999LIG\*.zip 9999STA\*.zip 9999Inactief\*.zip 9999NietBag\*.zip || exit
# unzip 9999Inactief\*.zip
# unzip 9999NietBag\*.zip

### BAG Proefbestand
echo "Download BAG Proefbestand..."
wget wget "https://www.kadaster.nl/documents/1953498/2762071/Proefbestand+gemeente.zip/24446fad-f8a8-dec5-7745-f050d7c1976b?t=1639746514279" -O proefbestand.zip
echo "Unzip..."
unzip proefbestand.zip 0106GEM15112021.zip || exit
unzip 0106GEM15112021.zip || exit
