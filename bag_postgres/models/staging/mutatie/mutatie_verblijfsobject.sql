select 
    {{ stg_bag_typed_vastevelden() }}
    
    oppervlakte,
    hoofdadres,
    xpath('list/NummeraanduidingRef/text()', 
        ('<list>'||nevenadres::text||'</list>')::xml)::text[] as nevenadres,
    xpath('list/gebruiksdoel/text()', 
        ('<list>'||gebruiksdoel::text||'</list>')::xml)::text[] as gebruiksdoel,
    xpath('list/PandRef/text()', 
        ('<list>'||pand::text||'</list>')::xml)::text[] as pand,
    
    voorkomenidentificatie,
    begingeldigheid,
    eindgeldigheid,
    tijdstipregistratie,
    eindregistratie,
    tijdstipinactief,
    tijdstipregistratielv,
    tijdstipeindregistratielv,
    tijdstipinactieflv,
    tijdstipnietbaglv,
  
    _etl_loaded_at,
    mutatiebericht_id,
    mutatieregel_id,
    '{{ invocation_id }}' as _invocation_id
from {{ ref("mutatieregel") }}, XMLTABLE 
    (
        '/Verblijfsobject' PASSING mutatieregel_xml
        COLUMNS
            {{ stg_bag_parsed_vastevelden() }}

            oppervlakte text PATH 'oppervlakte',
            hoofdadres text PATH 'heeftAlsHoofdadres/NummeraanduidingRef',
            nevenadres text PATH 'heeftAlsNevenadres/NummeraanduidingRef',
            gebruiksdoel xml PATH 'gebruiksdoel',
            pand xml PATH 'maaktDeelUitVan/PandRef',

            {{ stg_bag_parsed_historievelden() }}
    )
where bagobject='Verblijfsobject' 
    and waswordt='wordt'
