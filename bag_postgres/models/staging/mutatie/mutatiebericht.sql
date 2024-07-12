select
    id,
    mutatiebericht_xml,
    _etl_loaded_at
from {{ source('lz_untyped', 'mutatiebericht') }}