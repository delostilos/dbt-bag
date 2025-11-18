### BAG Proefbestand
echo "Download BAG Proefbestand..."
Invoke-WebRequest -Uri "https://www.kadaster.nl/documents/1953498/2762071/Proefbestand+gemeente.zip/24446fad-f8a8-dec5-7745-f050d7c1976b?t=1639746514279" -Outfile proefbestand.zip
echo "Unzip..."
unzip proefbestand.zip 0106GEM15112021.zip GEM-WPL-RELATIE-15112021.zip Leveringsdocument-BAG-Extract.xml
unzip 0106GEM15112021.zip 
unzip 0106Inactief15112021.zip 
unzip 0106InOnderzoek15112021.zip 
unzip 0106NietBag15112021.zip 