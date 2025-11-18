echo "Loading to database bag..."

echo "verblijfsobject..."
unzip -p data/*VBO*.zip | bin/windows/xml-to-postgres.exe conf/verblijfsobject.yaml | psql postgres://<user>:<password>@localhost:5432/bag

echo "nummeraanduiding..."
unzip -p data/*NUM*.zip | bin/windows/xml-to-postgres.exe conf/nummeraanduiding.yaml | psql postgres://<user>:<password>@localhost:5432/bag

echo "woonplaats..."
unzip -p data/*WPL*.zip | bin/windows/xml-to-postgres.exe conf/woonplaats.yaml | psql postgres://<user>:<password>@localhost:5432/bag

echo "openbareruimte..."
unzip -p data/*OPR*.zip | bin/windows/xml-to-postgres.exe conf/openbareruimte.yaml | psql postgres://<user>:<password>@localhost:5432/bag

echo "pand..."
unzip -p data/*PND*.zip | bin/windows/xml-to-postgres.exe conf/pand.yaml | psql postgres://<user>:<password>@localhost:5432/bag

echo "ligplaats..."
unzip -p data/*LIG*.zip | bin/windows/xml-to-postgres.exe conf/ligplaats.yaml | psql postgres://<user>:<password>@localhost:5432/bag

echo "standplaats..."
unzip -p data/*STA*.zip | bin/windows/xml-to-postgres.exe conf/standplaats.yaml | psql postgres://<user>:<password>@localhost:5432/bag
