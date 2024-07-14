select *
  from {{source('lz_bag', 'woonplaats_000001')}}
 union all
select *
  from {{source('lz_bag', 'woonplaats_inactief_000001')}}
 union all
select *
  from {{source('lz_bag', 'woonplaats_nietbag_000001')}}  