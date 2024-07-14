select *
  from {{source('lz_bag', 'pand_000001')}}
 union all
select *
  from {{source('lz_bag', 'pand_000002')}}
 union all 
select *
  from {{source('lz_bag', 'pand_000003')}}
 union all 
select *
  from {{source('lz_bag', 'pand_000004')}}
 union all 
select *
  from {{source('lz_bag', 'pand_000005')}}
 union all 
select *
  from {{source('lz_bag', 'pand_000006')}}
 union all 
select *
  from {{source('lz_bag', 'pand_000007')}}
 union all   
select *
  from {{source('lz_bag', 'pand_inactief_000001')}}
 union all
select *
  from {{source('lz_bag', 'pand_nietbag_000001')}}  