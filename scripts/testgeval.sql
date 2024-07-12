-- Testgeval voor het indikken van de historie (wijziging op enddate vorige voorkomen + inleg nieuw voorkomen)
-- verblijfsobject 0106010000027057

-- stand
select voorkomenidentificatie,begingeldigheid,eindgeldigheid,tijdstipregistratielv from bag.stand_verblijfsobject where identificatie='0106010000027057';

-- mutatie
select voorkomenidentificatie,begingeldigheid,eindgeldigheid,tijdstipregistratielv from bag.mutatie_verblijfsobject where identificatie='0106010000027057';

-- bronspiegel
select voorkomenidentificatie,begingeldigheid,eindgeldigheid,tijdstipregistratielv from bag.verblijfsobject where identificatie='0106010000027057';

-- snapshot
select identificatie,voorkomenidentificatie,begingeldigheid,eindgeldigheid,tijdstipregistratielv,dbt_valid_from,dbt_valid_to from bag.snapshot_verblijfsobject where identificatie='0106010000027057';
