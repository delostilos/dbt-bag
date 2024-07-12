select 
    {{ stg_bag_typed_vastevelden() }}

    oorspronkelijkbouwjaar,

    {{ stg_bag_typed_historievelden() }}
    {{ stg_bag_typed_auditvelden() }}

from {{ source('lz_typed', 'pand')}}