select 
    {{ stg_bag_typed_vastevelden() }}

    hoofdadres,
    -- nevenadres komt door de loader binnen als comma seperated list in een textveld; vertalen naar array
    string_to_array(nevenadres, ',') as nevenadres,

    {{ stg_bag_typed_historievelden() }}
    {{ stg_bag_typed_auditvelden() }}

from {{ source('lz_typed', 'standplaats')}}