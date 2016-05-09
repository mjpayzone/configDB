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
--  Quantum
-------------------------------------------------------------------------------------------------------------------------------------
INSERT into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'Quantum%') --<PGXProds_ProdGKey>
    ,prod_key
    ,25  -- Quantum <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 5
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 5
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  Talexus
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'Talexus%') --<PGXProds_ProdGKey>
    ,prod_key
    ,26  -- Talx <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application] 
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 4
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 4
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  THL
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'THL%') --<PGXProds_ProdGKey>
    ,prod_key
    ,24  --THL <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 19
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 19
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
order by 2



-------------------------------------------------------------------------------------------------------------------------------------
--  NEXT returns
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'NEXT Returns%') --<PGXProds_ProdGKey>
    ,prod_key
    ,27  -- NEXT <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,(LTRIM(RTRIM(prod_description))) + ' Returns' 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 12
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 12
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
order by 2

-------------------------------------------------------------------------------------------------------------------------------------
--  Dartford Crossing - Tolling
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
     (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'Dart-Charge%') --<PGXProds_ProdGKey>
    ,prod_key
    ,37 -- DartCharge <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl
    ,LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 18
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 18
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
--and App_Key
--= 41
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  Keypad
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'KeyPad') --<PGXProds_ProdGKey>
    ,prod_key
    ,23 -- KeyPad <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    , LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 2
  and App_Key in
  (
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 2
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
  )
  and App_Key 
  in
  (247) -- Keypad
 ORDER by 2
 
 
-------------------------------------------------------------------------------------------------------------------------------------
--   Keypad NI
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'KeyPadNI%') --<PGXProds_ProdGKey>
    ,prod_key
    ,22 -- KeyPadNI <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    , LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 2
  and App_Key in
  (
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 2
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
  )
  and App_Key 
  in
  (27)  -- Keypad NI
order by 2


COMMIT TRANSACTION
