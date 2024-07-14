select *
  from {{source('lz_bag', 'standplaats_000001')}}
 union all
select *
  from {{source('lz_bag', 'standplaats_inactief_000001')}}
 union all
select *
  from {{source('lz_bag', 'standplaats_nietbag_000001')}}  