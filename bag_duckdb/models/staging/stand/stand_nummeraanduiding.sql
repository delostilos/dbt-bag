select *
  from {{source('lz_bag', 'nummeraanduiding_000001')}}
 union all
select *
  from {{source('lz_bag', 'nummeraanduiding_000002')}}
 union all 
select *
  from {{source('lz_bag', 'nummeraanduiding_000003')}}
 union all 
select *
  from {{source('lz_bag', 'nummeraanduiding_000004')}}
 union all 
select *
  from {{source('lz_bag', 'nummeraanduiding_000005')}}
 union all 
select *
  from {{source('lz_bag', 'nummeraanduiding_inactief_000001')}}
 union all
select *
  from {{source('lz_bag', 'nummeraanduiding_nietbag_000001')}}  