select 
    xmltable.*,
    _etl_loaded_at,
    mutatiebericht_id,
    mutatieregel_id,
    '{{ invocation_id }}' as _invocation_id
from {{ ref("mutatieregel") }}, XMLTABLE 
    (
        '/OpenbareRuimte' PASSING mutatieregel_xml
        COLUMNS
            {{ stg_bag_parsed_vastevelden() }}

            naam text PATH 'naam',
            type text PATH 'type',
            ligtin text PATH 'ligtin',

            {{ stg_bag_parsed_historievelden() }}
    )
where bagobject='OpenbareRuimte' 
    and waswordt='wordt'
