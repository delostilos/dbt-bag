{% macro stg_bag_parsed_vastevelden() %}
        identificatie text PATH 'identificatie',
        status text PATH 'status',
        geconstateerd text PATH 'geconstateerd',
        documentdatum text PATH 'documentdatum',
        documentnummer text PATH 'documentnummer',
{% endmacro %}

{% macro stg_bag_parsed_historievelden() %}
        voorkomenidentificatie integer PATH 'voorkomen/Voorkomen/voorkomenidentificatie',
        begingeldigheid date PATH 'voorkomen/Voorkomen/beginGeldigheid',
        eindgeldigheid date DEFAULT 'infinity' PATH 'voorkomen/Voorkomen/eindGeldigheid',
        tijdstipregistratie timestamp(3) PATH 'voorkomen/Voorkomen/tijdstipRegistratie',
        eindregistratie timestamp(3) DEFAULT 'infinity' PATH 'voorkomen/Voorkomen/eindRegistratie',
        tijdstipinactief timestamp(3) DEFAULT 'infinity' PATH 'voorkomen/Voorkomen/tijdstipInactief',
        tijdstipregistratielv timestamp(3) PATH 'voorkomen/Voorkomen/BeschikbaarLV/tijdstipRegistratieLV',
        tijdstipeindregistratielv timestamp(3) DEFAULT 'infinity' PATH 'voorkomen/Voorkomen/BeschikbaarLV/tijdstipEindRegistratieLV',
        tijdstipinactieflv timestamp(3) DEFAULT 'infinity' PATH 'voorkomen/Voorkomen/BeschikbaarLV/tijdstipInactiefLV',
        tijdstipnietbaglv timestamp(3) DEFAULT 'infinity' PATH 'voorkomen/Voorkomen/BeschikbaarLV/tijdstipNietBagLV'
        
        --mutatiesoort text PATH 'name(text()/parent::*/parent::*/parent::*/parent::*)'
        --mutatiesoort text PATH 'name(text()/parent::*)'
        
{% endmacro %}

{% macro stg_bag_typed_vastevelden() %}
    identificatie,
    status,
    geconstateerd,
    documentdatum,
    documentnummer,
{% endmacro %}

{% macro stg_bag_typed_historievelden() %}
    voorkomenidentificatie,
    begingeldigheid,
    COALESCE(eindgeldigheid, 'infinity') AS eindgeldigheid,
    tijdstipregistratie,
    COALESCE(eindregistratie, 'infinity') AS eindregistratie,
    COALESCE(tijdstipinactief, 'infinity') AS tijdstipinactief,
    tijdstipregistratielv,
    COALESCE(tijdstipeindregistratielv, 'infinity') AS tijdstipeindregistratielv,
    COALESCE(tijdstipinactieflv, 'infinity') AS tijdstipinactieflv,
    COALESCE(tijdstipnietbaglv, 'infinity') AS tijdstipnietbaglv,
{% endmacro %}

{% macro stg_bag_typed_auditvelden() %}    
    --'toevoeging' as mutatiesoort,
    _etl_loaded_at,
    null::integer as mutatiebericht_id,
    null::integer as mutatieregel_id,
    '{{ invocation_id }}' as _invocation_id
{% endmacro %}

{% macro bag_tijdreizen(relation) %}
    -- We gebruiken de tabel definitie als type.
    create or replace function {{relation.schema}}.{{relation.identifier}}_tijdreizen (materiele_datum date default current_date, formeel_tijdstip timestamp default current_timestamp)
    returns setof {{ relation }}
    language sql STABLE
    as $$
    select *
      from {{ relation }}
     where begingeldigheid <= materiele_datum and materiele_datum < coalesce(eindgeldigheid, date '9999-12-31')
       and tijdstipregistratielv <= formeel_tijdstip  
       and coalesce(tijdstipinactieflv, timestamp '9999-12-31 23:59:59.999') > formeel_tijdstip
       and coalesce(tijdstipnietbaglv , timestamp '9999-12-31 23:59:59.999') > formeel_tijdstip
    $$
    ;
{% endmacro %}