/*
    This script recreates the source models (landing zone typed and untyped) in the database

    Run as
        cat lz_ddl.sql | psql <databasename> 

*/

DROP SCHEMA IF EXISTS lz_bag CASCADE;
CREATE SCHEMA lz_bag;

CREATE TABLE lz_bag.mutatiebericht(
        id serial, 
        mutatiebericht_xml xml NOT NULL, 
        --is_xml_document boolean GENERATED ALWAYS AS (inhoud IS DOCUMENT) STORED,
        _etl_loaded_at timestamp DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX ON lz_bag.mutatiebericht (_etl_loaded_at);

/*
    verblijfsobject (1/7)
*/
\echo verblijfsobject

CREATE UNLOGGED TABLE lz_bag.verblijfsobject (
    identificatie text,
    status text,
    gebruiksdoel text,
    oppervlakte text,
    hoofdadres text,
    nevenadres text,
    geconstateerd text,
    pand text,
    documentdatum text,
    documentnummer text,
    voorkomenidentificatie integer,
    begingeldigheid date,
    eindgeldigheid date,
    tijdstipregistratie timestamp(3) without time zone,
    eindregistratie timestamp(3) without time zone,
    tijdstipinactief timestamp(3) without time zone,
    tijdstipregistratielv timestamp(3) without time zone,
    tijdstipeindregistratielv timestamp(3) without time zone,
    tijdstipinactieflv timestamp(3) without time zone,
    tijdstipnietbaglv timestamp(3) without time zone,
    _etl_loaded_at timestamp DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE ONLY lz_bag.verblijfsobject
    ADD CONSTRAINT u_verblijfsobject 
    UNIQUE NULLS NOT DISTINCT (
            identificatie, 
            voorkomenidentificatie, 
            begingeldigheid, 
            tijdstipnietbaglv
            );
CREATE INDEX ON lz_bag.verblijfsobject (_etl_loaded_at);

/*
    nummeraanduiding (2/7)
*/
\echo nummeraanduiding

CREATE UNLOGGED TABLE lz_bag.nummeraanduiding (
    identificatie text,
    type text,
    status text,
    huisnummer text,
    huisletter text,
    huisnummertoevoeging text,
    postcode text,
    geconstateerd text,
    ligtaan text,
    ligtin text,
    documentdatum text,
    documentnummer text,
    voorkomenidentificatie integer,
    begingeldigheid date,
    eindgeldigheid date,
    tijdstipregistratie timestamp(3) without time zone,
    eindregistratie timestamp(3) without time zone,
    tijdstipinactief timestamp(3) without time zone,
    tijdstipregistratielv timestamp(3) without time zone,
    tijdstipeindregistratielv timestamp(3) without time zone,
    tijdstipinactieflv timestamp(3) without time zone,
    tijdstipnietbaglv timestamp(3) without time zone,
    _etl_loaded_at timestamp DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE ONLY lz_bag.nummeraanduiding
    ADD CONSTRAINT u_nummeraanduiding 
    UNIQUE NULLS NOT DISTINCT (
            identificatie, 
            voorkomenidentificatie, 
            begingeldigheid, 
            tijdstipnietbaglv
            );
CREATE INDEX ON lz_bag.nummeraanduiding (_etl_loaded_at);

/*
    openbareruimte (3/7)
*/
\echo openbareruimte

CREATE UNLOGGED TABLE lz_bag.openbareruimte (
    identificatie text,
    naam text,
    type text,
    status text,
    geconstateerd text,
    ligtin text,
    documentdatum text,
    documentnummer text,
    voorkomenidentificatie integer,
    begingeldigheid date,
    eindgeldigheid date,
    tijdstipregistratie timestamp(3) without time zone,
    eindregistratie timestamp(3) without time zone,
    tijdstipinactief timestamp(3) without time zone,
    tijdstipregistratielv timestamp(3) without time zone,
    tijdstipeindregistratielv timestamp(3) without time zone,
    tijdstipinactieflv timestamp(3) without time zone,
    tijdstipnietbaglv timestamp(3) without time zone,
    _etl_loaded_at timestamp DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE ONLY lz_bag.openbareruimte
    ADD CONSTRAINT u_openbareruimte 
    UNIQUE NULLS NOT DISTINCT (
            identificatie, 
            voorkomenidentificatie, 
            begingeldigheid, 
            tijdstipnietbaglv
            );
CREATE INDEX ON lz_bag.openbareruimte (_etl_loaded_at);

/*
    woonplaats (4/7)
*/
\echo woonplaats

CREATE UNLOGGED TABLE lz_bag.woonplaats (
    identificatie text,
    naam text,
    status text,
    geconstateerd text,
    documentdatum text,
    documentnummer text,
    voorkomenidentificatie integer,
    begingeldigheid date,
    eindgeldigheid date,
    tijdstipregistratie timestamp(3) without time zone,
    eindregistratie timestamp(3) without time zone,
    tijdstipinactief timestamp(3) without time zone,
    tijdstipregistratielv timestamp(3) without time zone,
    tijdstipeindregistratielv timestamp(3) without time zone,
    tijdstipinactieflv timestamp(3) without time zone,
    tijdstipnietbaglv timestamp(3) without time zone,
    _etl_loaded_at timestamp DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE ONLY lz_bag.woonplaats
    ADD CONSTRAINT u_woonplaats 
    UNIQUE NULLS NOT DISTINCT (
            identificatie, 
            voorkomenidentificatie, 
            begingeldigheid, 
            tijdstipnietbaglv
            );
CREATE INDEX ON lz_bag.woonplaats (_etl_loaded_at);

/*
    ligplaats (5/7)
*/
\echo ligplaats

CREATE UNLOGGED TABLE lz_bag.ligplaats (
    identificatie text,
    status text,
    hoofdadres text,
    nevenadres text,
    geconstateerd text,
    documentdatum text,
    documentnummer text,
    voorkomenidentificatie integer,
    begingeldigheid date,
    eindgeldigheid date,
    tijdstipregistratie timestamp(3) without time zone,
    eindregistratie timestamp(3) without time zone,
    tijdstipinactief timestamp(3) without time zone,
    tijdstipregistratielv timestamp(3) without time zone,
    tijdstipeindregistratielv timestamp(3) without time zone,
    tijdstipinactieflv timestamp(3) without time zone,
    tijdstipnietbaglv timestamp(3) without time zone,
    _etl_loaded_at timestamp DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE ONLY lz_bag.ligplaats
    ADD CONSTRAINT u_ligplaats 
    UNIQUE NULLS NOT DISTINCT (
            identificatie, 
            voorkomenidentificatie, 
            begingeldigheid, 
            tijdstipnietbaglv
            );
CREATE INDEX ON lz_bag.ligplaats (_etl_loaded_at);

/*
    standplaats (6/7)
*/
\echo standplaats

CREATE UNLOGGED TABLE lz_bag.standplaats (
    identificatie text,
    status text,
    hoofdadres text,
    nevenadres text,
    geconstateerd text,
    documentdatum text,
    documentnummer text,
    voorkomenidentificatie integer,
    begingeldigheid date,
    eindgeldigheid date,
    tijdstipregistratie timestamp(3) without time zone,
    eindregistratie timestamp(3) without time zone,
    tijdstipinactief timestamp(3) without time zone,
    tijdstipregistratielv timestamp(3) without time zone,
    tijdstipeindregistratielv timestamp(3) without time zone,
    tijdstipinactieflv timestamp(3) without time zone,
    tijdstipnietbaglv timestamp(3) without time zone,
    _etl_loaded_at timestamp DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE ONLY lz_bag.standplaats
    ADD CONSTRAINT u_standplaats 
    UNIQUE NULLS NOT DISTINCT (
            identificatie, 
            voorkomenidentificatie, 
            begingeldigheid, 
            tijdstipnietbaglv
            );
CREATE INDEX ON lz_bag.standplaats (_etl_loaded_at);

/*
    pand (7/7)
*/
\echo pand

CREATE UNLOGGED TABLE lz_bag.pand (
    identificatie text,
    oorspronkelijkbouwjaar text,
    status text,
    geconstateerd text,
    documentdatum text,
    documentnummer text,
    voorkomenidentificatie integer,
    begingeldigheid date,
    eindgeldigheid date,
    tijdstipregistratie timestamp(3) without time zone,
    eindregistratie timestamp(3) without time zone,
    tijdstipinactief timestamp(3) without time zone,
    tijdstipregistratielv timestamp(3) without time zone,
    tijdstipeindregistratielv timestamp(3) without time zone,
    tijdstipinactieflv timestamp(3) without time zone,
    tijdstipnietbaglv timestamp(3) without time zone,
    _etl_loaded_at timestamp DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE ONLY lz_bag.pand
    ADD CONSTRAINT u_pand 
    UNIQUE NULLS NOT DISTINCT (
            identificatie, 
            voorkomenidentificatie, 
            begingeldigheid, 
            tijdstipnietbaglv
            );
CREATE INDEX ON lz_bag.pand (_etl_loaded_at);

