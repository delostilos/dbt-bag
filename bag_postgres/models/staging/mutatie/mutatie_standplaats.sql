select 
    {{ stg_bag_typed_vastevelden() }}
    
    hoofdadres,
    xpath('list/NummeraanduidingRef/text()', 
        ('<list>'||nevenadres::text||'</list>')::xml)::text[] as nevenadres,  
    
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
        '/Standplaats' PASSING mutatieregel_xml
        COLUMNS
            {{ stg_bag_parsed_vastevelden() }}

            hoofdadres text PATH 'hoofdadres',
            nevenadres text PATH 'heeftAlsNevenadres/NummeraanduidingRef',

            {{ stg_bag_parsed_historievelden() }}
    )
where bagobject='Standplaats' 
    and waswordt='wordt'