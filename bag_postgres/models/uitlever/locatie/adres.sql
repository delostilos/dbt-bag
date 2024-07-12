{{ config(
    post_hook=["-- tijdreis functie die is samengesteld uit de onderliggende tijdreis functies uit het bag schema.
drop function if exists {{this.schema}}.{{this.identifier}}_tijdreizen(date, timestamp);
;",
"
create or replace function {{this.schema}}.{{this.identifier}}_tijdreizen (materiele_datum date default current_date, formeel_tijdstip timestamp default current_timestamp)
returns setof {{this}} 
language sql STABLE
as $$
select coalesce(nwp.naam, wpl.naam) as woonplaats
     , opr.naam as straatnaam
     , num.huisnummer
     , num.huisnummertoevoeging
     , num.postcode
     , vbo.oppervlakte     
  from {{target.schema}}.nummeraanduiding_tijdreizen(materiele_datum,formeel_tijdstip) num
  join {{target.schema}}.verblijfsobject_tijdreizen(materiele_datum,formeel_tijdstip) vbo
    on num.identificatie = vbo.hoofdadres
  join {{target.schema}}.openbareruimte_tijdreizen(materiele_datum,formeel_tijdstip) as opr
    on num.ligtaan = opr.identificatie
  join {{target.schema}}.woonplaats_tijdreizen(materiele_datum,formeel_tijdstip) wpl 
    on opr.ligtin = wpl.identificatie
  left
  join {{target.schema}}.woonplaats_tijdreizen(materiele_datum,formeel_tijdstip) nwp
    on num.ligtin = nwp.identificatie      
$$
;
",
"
comment on function {{this.schema}}.{{this.identifier}}_tijdreizen is E'@filterable\n@sortable'
; 
", 
"
comment on view {{this}} is E'@filterable\n@sortable\n@name adresActual'
;
"
]           
    )
}}
select coalesce(nwp.naam, wpl.naam) as woonplaats
     , opr.naam as straatnaam
     , num.huisnummer
     , num.huisnummertoevoeging
     , num.postcode
     , vbo.oppervlakte
    -- {{ ref('nummeraanduiding') }}
  from {{target.schema}}.nummeraanduiding_tijdreizen() num
    -- {{ ref('verblijfsobject') }}
  join {{target.schema}}.verblijfsobject_tijdreizen() vbo
    on num.identificatie = vbo.hoofdadres
    -- {{ ref('openbareruimte') }}
  join {{target.schema}}.openbareruimte_tijdreizen() as opr
    on num.ligtaan = opr.identificatie
    -- {{ ref('woonplaats') }}
  join {{target.schema}}.woonplaats_tijdreizen() wpl 
    on opr.ligtin = wpl.identificatie
    -- {{ ref('woonplaats') }}
  left
  join {{target.schema}}.woonplaats_tijdreizen() nwp
    on num.ligtin = nwp.identificatie  

