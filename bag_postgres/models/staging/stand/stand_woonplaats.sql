select 
    {{ stg_bag_typed_vastevelden() }}

    naam,

    {{ stg_bag_typed_historievelden() }}
    {{ stg_bag_typed_auditvelden() }}
    
from {{ source('lz_typed', 'woonplaats')}}