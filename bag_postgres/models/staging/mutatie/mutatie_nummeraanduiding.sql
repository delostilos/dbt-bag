select 
    xmltable.*,
    _etl_loaded_at,
    mutatiebericht_id,
    mutatieregel_id,
    '{{ invocation_id }}' as _invocation_id
from {{ ref("mutatieregel") }}, XMLTABLE 
    (
        '/Nummeraanduiding' PASSING mutatieregel_xml
        COLUMNS
            {{ stg_bag_parsed_vastevelden() }}

            type text PATH 'type',
            huisnummer text PATH 'huisnummer',
            huisletter text PATH 'huisletter',
            huisnummertoevoeging text PATH 'huisnummertoevoeging',
            postcode text PATH 'postcode',
            ligtaan text PATH 'ligtaan',
            ligtin text PATH 'ligtin',

            {{ stg_bag_parsed_historievelden() }}
    )
where bagobject='Nummeraanduiding' 
    and waswordt='wordt'
