#!/bin/sh

### BAG Extract
echo "Download BAG Extract..."
wget https://service.pdok.nl/kadaster/adressen/atom/v1_0/downloads/lvbag-extract-nl.zip || exit
echo "Unzip..."
unzip lvbag-extract-nl.zip 9999VBO\*.zip 9999NUM\*.zip 9999WPL\*.zip 9999OPR\*.zip 9999PND\*.zip 9999LIG\*.zip 9999STA\*.zip 9999Inactief\*.zip 9999NietBag\*.zip 9999InOnderzoek\*.zip|| exit
unzip 9999Inactief\*.zip
unzip 9999NietBag\*.zip
#unzip 9999InOnderzoek\*.zip

