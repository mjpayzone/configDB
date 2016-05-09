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
--  BusTickets Arriva Midlands
-------------------------------------------------------------------------------------------------------------------------------------
INSERT into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BusTickets Arriva Midlands%') --<PGXProds_ProdGKey>
    ,prod_key
   ,30 -- Arriva Midlands <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING((LTRIM(RTRIM(App_Name))) + ' ' + LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 10
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 10
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key
= 141 --Arriva Midlands 
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  BusTickets Arriva NorthEast
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BusTickets Arriva NorthEast%') --<PGXProds_ProdGKey>
    ,prod_key
    ,32 -- Arriva NorthEast-- <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING((LTRIM(RTRIM(App_Name))) + ' ' + LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 10
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 10
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key
= 191 --Arriva NorthEast
ORDER by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  BusTickets Arriva NW & Wales
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BusTickets Arriva NW & Wales%') --<PGXProds_ProdGKey>
    ,prod_key
    ,34 -- Arriva NW & Wales <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING((LTRIM(RTRIM(App_Name))) + ' ' + LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 10
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 10
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key
= 193 --BusTickets Arriva NW & Wales
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  BusTickets Arriva Southern Counties
-------------------------------------------------------------------------------------------------------------------------------------
INSERT into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BusTickets Arriva Southern Counties%') --<PGXProds_ProdGKey>
    ,prod_key
    ,35 --  Arriva Southern Counties<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING((LTRIM(RTRIM(App_Name))) + ' ' + LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 10
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 10
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key
= 194 --BusTickets Arriva Southern Counties
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  BusTickets Arriva Shires
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BusTickets Arriva Shires%') --<PGXProds_ProdGKey>
    ,prod_key
   ,31 --Arriva Shires <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING((LTRIM(RTRIM(App_Name))) + ' ' + LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 10
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 10
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key
= 142 --BusTickets Arriva Shires
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  BusTickets Arriva Yorkshire
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BusTickets Arriva Yorkshire%') --<PGXProds_ProdGKey>
    ,prod_key
    ,33 -- Arriva Yorkshire <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING((LTRIM(RTRIM(App_Name))) + ' ' + LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 10
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 10
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key
=
192 --BusTickets Arriva Yorkshire
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  BusTickets North Staffs SMART  
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BusTickets North Staffs%') --<PGXProds_ProdGKey>
    ,prod_key
    , 28 -- North Staffs <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    --, LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
    --,REPLACE((LTRIM(RTRIM(App_Name)) + ' ' + LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description))), '£%', '')
    --,SUBSTRING((LTRIM(RTRIM(App_Name)) + ' ' + LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description))), 1, 50)
    --,SUBSTRING((LTRIM(RTRIM(App_Name))) + ' ' + LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
    ,SUBSTRING((LTRIM(RTRIM(App_Name)) + ' ' + LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description))), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 10
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 10
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key
= 130 -- N Staffs SMART  
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  BusTickets Centrebus 
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BusTickets Centrebus%') --<PGXProds_ProdGKey>
    ,prod_key
    ,29 -- Centrebus <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING((LTRIM(RTRIM(App_Name)) + ' ' + LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description))), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 10
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 10
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key
= 135 --Centrebus       
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  BusTickets nBus
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BusTickets nBus%') --<PGXProds_ProdGKey>
    ,prod_key
    ,36 -- nBus <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,SUBSTRING((LTRIM(RTRIM(App_Name))) + ' ' + LTRIM(RTRIM(issuer_Name)) + ' ' + REPLACE(prod_description,SUBSTRING(prod_description, CHARINDEX('£', prod_description), 6),''), 1, 50)
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  , [Issuer_Range]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and IssuerRange_IssuerFormat_Key = issuer_key
  and App_Type = 10
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 10
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and App_Key
= 139 -- BusTickets nBus
order by 2
 
COMMIT TRANSACTION
