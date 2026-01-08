# dbt-bag
Demo dbt oplossing met de openbare BAG (basisadministratie adressen en gebouwen) data.

* bag_duckdb de DuckDB oplossing die python modules gebruikt om de BAG data te laden
* bag_postgres de PostgreSQL oplossing die via xml-to-postgres de data laadt en daarbovenop een tijdreis-API in GraphQL

Het data model van de aanlevering: https://www.kadaster.nl/documents/1953498/2762071/BAG+2.0+Extract+koppelvlak.pdf/81c56965-492b-6525-007a-f264a76f9e7d?t=1644408988653

Het conceptuele model van de BAG in UML:
https://imbag.github.io/catalogus/hoofdstukken/conceptueelmodel

Het fysieke data model van de BAG in ERD:
https://imbag.github.io/praktijkhandleiding/objecttypen

