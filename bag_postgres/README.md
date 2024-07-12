# bag_postgres
Dit dbt-project bouwt via standen (extract landelijke voorziening) en mutaties (XML-berichten) een bronspiegel op van de BAG. De databaseobjecten bevinden zich in het databaseschema `bag`.

## Lagen (`models/`)

### Landing zone (source)
De landing zone is een model van het type 'source' in dbt en bevat de rauwe BAG-data. Er is een typed en untyped variant.
* de *untyped* variant bestaat uit een tabel met mutatieberichten (XML) die verderop in de staging geparsed worden
* de *typed* variant bestaat uit een tabel per BAG-objecttype met een kolom per attribuut

De typed variant zal normaalgesproken voor de standen worden gebruikt en de untyped variant voor de mutaties. Maar in principe maakt dit niet uit.

De landing zone bevindt zich in het databaseschema `lz_bag`. Omdat het een dbt-model van het type 'source' betreft wordt de DDL buiten dbt om gecreëerd. Daarvoor staan er SQL-scripts in de `scripts/`-folder.

Elke tabel in de landing zone kent een kolom `_etl_loaded_at`. Deze is van belang voor de auditeerbaarheid en voor het incrementeel laden.

Stand laden (volledige extract of proefbestand):

    cd scripts/loader/stand/
    ./load.sh

Mutaties laden (één XML-voorbeeldbericht):

    cd scripts/loader/mutatie
    cat insert_mutatiebericht.sql| psql bag

Het laden van de landing zone gebeurt met een loader, buiten dbt om, zie verderop.

In principe zou de landing zone leegemaakt kunnen worden nadat de bronspiegel (en/of snapshot) is bijgewerkt. We verwerken namelijk geen verwijderingen (deze komen immers niet voor in de BAG). De verwerking kijkt alleen naar regels in de landing zone die een nieuwere `_etl_loaded_at` hebben dan reeds aanwezig in de bronspiegel.

### Staging (views)
De staging-modellen zijn een viewlaag bovenop de landing zone waarin zich logica bevindt (o.a. datatypes en defaults).

De mutatieberichten worden hier ook gesplitst in een untyped mutatieregel per objecttype en daarna een typed mutatietabel per objecttype. Dit mappen gebeurt via XPath-queries op het de XML-inhoud van het mutatiebericht in een PostgreSQL XMLTABLE-functie.

### Bronspiegel (incremental)
De bronspiegel is een weergave van de actuele stand van de BAG nadat alle aanwezige standen en mutatieberichten zijn verwerkt en is geïmplementeerd als incremental table. Hierdoor is alleen de initiele run traag. In daaropvolgende runs worden alleen nieuwe stand- en mutatieregels (o.b.v. de `_etl_loaded_at`) verwerkt naar de bronspiegel. Incrementele runs kosten slechts enkele seconden.

De bronspiegel is in feite een `UNION` van de standen en de mutaties.

Vanwege een eigenaardigheidje in de manier waarop mutaties verwerkt dienen te worden in de BAG zit hier ook nog een stukje indikkingslogica. Deze wordt hieronder nader beschreven.

### Uitlever (views)
Hier komen de uitlevermodellen. Als voorbeeld is een uitlevermodel `locatie` opgenomen met een model/entiteit `adres`.

Als voorbeeld is ook een exposure met de naam `locatie_api` opgenomen met een afhankelijkheid naar het uitlevermodel `adres`. Zo kan straks de lineage naar een API vastgelegd worden.