select 
    id as mutatiebericht_id, 
    xmltable.mutatieregel_id,
    xmltable.bagobject,
    xmltable.mutatiesoort,
    xmltable.waswordt,
    xmltable.mutatieregel_xml,
    _etl_loaded_at,
    '{{ invocation_id }}' as _invocation_id
from 
    {{ ref("mutatiebericht") }}, 
    XMLTABLE (
        '/bagMutaties/mutatieBericht/mutatieGroep/*/*/bagObject/*' PASSING mutatiebericht_xml
        COLUMNS
            mutatieregel_id FOR ORDINALITY,
            bagobject text PATH 'name(.)', 
            mutatiesoort text PATH 'name(../../..)',
            waswordt text PATH 'name(../..)',
            mutatieregel_xml xml PATH '.'
    )