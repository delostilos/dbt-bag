#!/bin/sh

### BAG Proefbestand
echo "Download BAG Proefbestand..."
wget wget "https://www.kadaster.nl/documents/1953498/2762071/Proefbestand+gemeente.zip/24446fad-f8a8-dec5-7745-f050d7c1976b?t=1639746514279" -O proefbestand.zip
echo "Unzip..."
unzip proefbestand.zip 0106GEM15112021.zip || exit
unzip 0106GEM15112021.zip || exit
unzip 0106Inactief15112021.zip || exit
unzip 0106InOnderzoek15112021.zip || exit
unzip 0106NietBag15112021.zip || exit