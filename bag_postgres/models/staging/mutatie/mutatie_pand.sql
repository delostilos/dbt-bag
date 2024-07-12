select 
    xmltable.*,
    _etl_loaded_at,
    mutatiebericht_id,
    mutatieregel_id,
    '{{ invocation_id }}' as _invocation_id
from {{ ref("mutatieregel") }}, XMLTABLE 
    (
        '/Pand' PASSING mutatieregel_xml
        COLUMNS
            {{ stg_bag_parsed_vastevelden() }}

        bouwjaar text PATH 'oorspronkelijkBouwjaar',

            {{ stg_bag_parsed_historievelden() }}
    )
where bagobject='Pand' 
    and waswordt='wordt'
