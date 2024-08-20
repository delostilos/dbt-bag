select "92.10 Gemeentecode" as gemeente_code
     , "92.11 Omschrijving" as omschrijving
     , "92.12 Nieuwe code"  as nieuwe_code
     , strptime("99.98 Datum ingang"::varchar,'%Y%m%d')::date as datum_ingang
     , strptime("99.99 Datum einde"::varchar,'%Y%m%d')::date as datum_einde
  from {{ source('lz_bag','gemeente_tabel')}}
