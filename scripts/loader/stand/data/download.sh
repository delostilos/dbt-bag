#!/bin/sh

### BAG Extract
echo "Download BAG Extract..."
wget https://service.pdok.nl/kadaster/adressen/atom/v1_0/downloads/lvbag-extract-nl.zip || exit
echo "Unzip..."
unzip lvbag-extract-nl.zip \*.zip Leveringsdocument-BAG-Extract.xml
unzip 9999Inactief\*.zip
unzip 9999NietBag\*.zip
unzip 9999InOnderzoek\*.zip
