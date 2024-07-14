select *
  from {{source('lz_bag', 'ligplaats_000001')}}
 union all
select *
  from {{source('lz_bag', 'ligplaats_inactief_000001')}}
 union all
select *
  from {{source('lz_bag', 'ligplaats_nietbag_000001')}}  