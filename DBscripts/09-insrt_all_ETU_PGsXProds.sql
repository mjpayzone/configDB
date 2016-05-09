USE [Terminal_config_MJ]
GO
-- this script will contain some constants as follows:
-- productgroup_id
-- the productgroup id in line 3 of the initial select statement  will be as in the productsgroupsdata.unl file.
-- if that file is not used to populate the productgroups table, ensure that the id is 
-- correct as populated in the productgroups table

-- the sql below can be uncommented and used to check the insert before running the commit at the end
--select * from prodgroupxprods where pgxprods_pgid =  ?

BEGIN TRANSACTION

-------------------------------------------------------------------------------------------------------------------------------------
--  basic ETU products
-------------------------------------------------------------------------------------------------------------------------------------

insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'ETU Key Entry%') --<PGXProds_ProdGKey>
    ,prod_key
    ,9 --<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM [Product], [issuer_Format], [AppXref], [Application]
  where Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 1
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 1
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and app_Key not in --(226)
 (select distinct app_key from [Product], [issuer_Format], [AppXref], [Application]
  where Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and app_name like 'Prepaid%'
  and app_type = 1)
  order by 2

-------------------------------------------------------------------------------------------------------------------------------------
--  extended ETU products
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'ETU Extended%') --<PGXProds_ProdGKey>
    ,prod_key
    ,10 --<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 1
  and App_Key  in
(SELECT  distinct App_Key
  FROM [Menu_Applications], [Menu], [Application] 
  where MenuApplications_MenuKey = menu_key
  and MenuApplications_AppKey = App_Key
  and app_type = 1
  and menu_name IN 
  ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and app_key = 23 
and prod_key not in 
(select prod_key 
   FROM [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Key = 109
  )
order by 2

-------------------------------------------------------------------------------------------------------------------------------------
--  ETU prepaid products
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'Prepaid%') --<PGXProds_ProdGKey>
    ,prod_key
    ,11 --<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 1  
  and App_Key in
(
 SELECT  distinct App_Key
  FROM [Menu_Applications], [Menu], [Application] 
  where MenuApplications_MenuKey = menu_key
  and MenuApplications_AppKey = App_Key
  and app_type = 1
  and menu_name in 
  ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and app_key in 
 (select distinct app_key from [Product], [issuer_Format], [AppXref], [Application]
  where Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and app_name like 'Prepaid%'
  and app_type = 1)
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  misc ETU LIKE products
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'ETUType%') --<PGXProds_ProdGKey>
    ,prod_key
    ,12 --<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 1
  and App_Key in
  (
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 1
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
  )
  and app_key in (238, 242)  -- ETU misc, these are odd apps bundled into ETU, they are 
                             -- actually Next Bill Payment and I-Movo vouchers
order by 2

COMMIT TRANSACTION



