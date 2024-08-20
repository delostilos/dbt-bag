#!/bin/sh

# Tabel 33 Gemeenten (gesorteerd op code)
wget https://publicaties.rvig.nl/dsresource?objectid=86360a47-728a-4c10-9b95-a4ea9fcaf680 -O gemeenten_tabel_utf16le.csv
iconv -f UTF-16LE -t UTF-8 gemeenten_tabel_utf16le.csv > gemeenten_tabel_utf8.csv