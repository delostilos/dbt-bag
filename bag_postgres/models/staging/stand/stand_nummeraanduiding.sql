select 
    {{ stg_bag_typed_vastevelden() }}
    
    type,
    huisnummer,
    huisletter,
    huisnummertoevoeging,
    postcode,
    ligtaan,
    ligtin,

    {{ stg_bag_typed_historievelden() }}
    {{ stg_bag_typed_auditvelden() }}

from {{ source('lz_typed', 'nummeraanduiding')}}