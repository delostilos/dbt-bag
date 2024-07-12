#! /bin/bash
database="bag"

echo "Loading to database $database..."

echo "verblijfsobject..."
unzip -p data/\*VBO\*.zip | bin/m1/xml-to-postgres conf/verblijfsobject.yaml | psql ${database}

echo "nummeraanduiding..."
unzip -p data/\*NUM\*.zip | bin/m1/xml-to-postgres conf/nummeraanduiding.yaml | psql ${database}

echo "woonplaats..."
unzip -p data/\*WPL\*.zip | bin/m1/xml-to-postgres conf/woonplaats.yaml | psql ${database}

echo "openbareruimte..."
unzip -p data/\*OPR\*.zip | bin/m1/xml-to-postgres conf/openbareruimte.yaml | psql ${database}

echo "pand..."
unzip -p data/\*PND\*.zip | bin/m1/xml-to-postgres conf/pand.yaml | psql ${database}

echo "ligplaats..."
unzip -p data/\*LIG\*.zip | bin/m1/xml-to-postgres conf/ligplaats.yaml | psql ${database}

echo "standplaats..."
unzip -p data/\*STA\*.zip | bin/m1/xml-to-postgres conf/standplaats.yaml | psql ${database}
