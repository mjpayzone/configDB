USE [Terminal_config_MJ]
GO
-- this script will contain some constants as follows:
-- productgroup_id
-- the productgroup id in line 3 of the initial select statement  will be as in the productsgroupsdata.unl file.
-- if that file is not used to populate the productgroups table, ensure that the id is 
-- correct as populated in the productgroups table
-- app_key
-- the app_keys at the end to extract the correct products are as the application table is on current live database.
--  if the application table is also getting rebuilt for the release, then the app_key should be checked 
-- to ensure it is the correct application

-- the sql below can be uncommented and used to check the insert before running the commit at the end
--select * from prodgroupxprods where pgxprods_pgid =  ?


BEGIN TRANSACTION

-------------------------------------------------------------------------------------------------------------------------------------
--  ST Yorcard
-------------------------------------------------------------------------------------------------------------------------------------
INSERT into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'SmartTicketing Yorcard') --<PGXProds_ProdGKey>
    ,prod_key
    ,42  -- ST Yorcard<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING('Yorcard ' + LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 15
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 15
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key in
(233, 234, 241) -- Yorcard
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  ST Yorcard TravelMaster
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'SmartTicketing Yorcard TravelMaster%') --<PGXProds_ProdGKey>
    ,prod_key
    ,41  -- ST Yorcard TravelMaster  <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING('Yorcard ' + LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 15
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 15
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key in
(49,51) -- Yorcard TravelMaster
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  ST Centro
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'SmartTicketing Centro%') --<PGXProds_ProdGKey>
    ,prod_key
    ,45  -- ST Centro<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,'Centro ' +SUBSTRING(LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 15
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 15
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key in
(37,38,39,52,59,81) -- Centro
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  ST Nexus
-------------------------------------------------------------------------------------------------------------------------------------
INSERT into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'SmartTicketing Nexus') --<PGXProds_ProdGKey>
    ,prod_key
    ,44  -- ST Nexus <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,'Nexus ' + SUBSTRING(LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 15
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 15
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key in
(211, 235, 248, 249, 253) -- Nexus
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  ST Nexus U of Sunderland
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'SmartTicketing Nexus UofSunderland%') --<PGXProds_ProdGKey>
    ,prod_key
    ,43  -- ST Nexus UofSunderland <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING('Nexus ' + ' ' + LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 15
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 15
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key in
(232) -- Nexus U of Sunderland
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  ST NOTT01
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
   (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'SmartTicketing Nottingham%') --<PGXProds_ProdGKey>
    ,prod_key
    ,39  -- ST Nottingham <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING('NOTT ' + LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 15
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 15
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key in
(24) -- Kangaroo NOTT01
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  ST Centrbus LEIS01
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'SmartTicketing CentreBus%') --<PGXProds_ProdGKey>
    ,prod_key
    ,40  -- ST CentreBus <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING('Leicester ' + LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
--  and ProdId = Prod_Key
  and App_Type = 15
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 15
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key in
(25) -- Centrbus LEIS01
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  ST Arriva
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'SmartTicketing Arriva%') --<PGXProds_ProdGKey>
    ,prod_key
    ,47  -- ST Arriva<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING(LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 15
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 15
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key in
(50)  -- Arriva
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  ST SPT
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'SmartTicketing SPT%') --<PGXProds_ProdGKey>
    ,prod_key
    ,46  -- ST SPT <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING(LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 15
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 15
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key in
(44,45) -- SPT
order by 2


COMMIT TRANSACTION


