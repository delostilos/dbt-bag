select 
    xmltable.*,
    _etl_loaded_at,
    mutatiebericht_id,
    mutatieregel_id,
    '{{ invocation_id }}' as _invocation_id
from {{ ref("mutatieregel") }}, XMLTABLE 
    (
        '/Woonplaats' PASSING mutatieregel_xml
        COLUMNS
            {{ stg_bag_parsed_vastevelden() }}

        naam text PATH 'naam',

            {{ stg_bag_parsed_historievelden() }}
    )
where bagobject='Woonplaats' 
    and waswordt='wordt'
