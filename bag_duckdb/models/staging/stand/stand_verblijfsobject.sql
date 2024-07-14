select *
  from {{source('lz_bag', 'verblijfsobject_000001')}}
 union all
select *
  from {{source('lz_bag', 'verblijfsobject_000002')}}
 union all 
select *
  from {{source('lz_bag', 'verblijfsobject_000003')}}
 union all 
select *
  from {{source('lz_bag', 'verblijfsobject_000004')}}
 union all 
select *
  from {{source('lz_bag', 'verblijfsobject_000005')}}
 union all 
select *
  from {{source('lz_bag', 'verblijfsobject_000006')}}
 union all  
select *
  from {{source('lz_bag', 'verblijfsobject_inactief_000001')}}
 union all
select *
  from {{source('lz_bag', 'verblijfsobject_nietbag_000001')}}  