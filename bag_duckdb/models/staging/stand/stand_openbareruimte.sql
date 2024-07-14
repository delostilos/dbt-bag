select *
  from {{source('lz_bag', 'openbareruimte_000001')}}
 union all
select *
  from {{source('lz_bag', 'openbareruimte_inactief_000001')}}
 union all
select *
  from {{source('lz_bag', 'openbareruimte_nietbag_000001')}}  