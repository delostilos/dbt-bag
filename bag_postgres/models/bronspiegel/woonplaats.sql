{{ config(
    materialized='incremental',
    unique_key=['identificatie', 'voorkomenidentificatie', 'begingeldigheid', 'tijdstipnietbaglv'],
    on_schema_change='fail',
    indexes=[{'columns': ['identificatie','voorkomenidentificatie','begingeldigheid','tijdstipnietbaglv'], 'unique': True},
             {'columns': ['_etl_loaded_at']},
            ],
    post_hook=["{{ bag_tijdreizen(this) }}", ]          
    )
}}

with
u as (
    -- union typed (stand) & parsed (untyped/mutatie)
    select * from {{ ref('stand_woonplaats') }}
    {% if is_incremental() %}
        where _etl_loaded_at > (select coalesce(max(_etl_loaded_at), '-infinity') from {{ this }})
    {% endif %}
    union all
    select * from {{ ref('mutatie_woonplaats')  }}
    {% if is_incremental() %}
        where _etl_loaded_at > (select coalesce(max(_etl_loaded_at), '-infinity') from {{ this }})
    {% endif %}
),
d as (
    -- distinct maken voor de gevallen waar eenzelfde voorkomen een toevoeging en een mutatie heeft; dan moeten we de mutatie hebben
    -- de mutatie bevat namelijk ook de vorige versie van het voorkomen plus de juiste einddatum
    select distinct on (identificatie, voorkomenidentificatie, begingeldigheid, tijdstipnietbaglv) * 
    from u 
    order by identificatie, voorkomenidentificatie, begingeldigheid, tijdstipnietbaglv, tijdstipeindregistratielv ASC
)
select * from d
