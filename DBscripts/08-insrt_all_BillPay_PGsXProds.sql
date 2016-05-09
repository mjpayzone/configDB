USE [TerminalConfig_V5_MJ]
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
--  BillPay UK utilities
-------------------------------------------------------------------------------------------------------------------------------------
INSERT into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Utilities UK%') --<PGXProds_ProdGKey>
    ,prod_key
    ,13  -- utilities UK <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [Issuer_Format], [AppXref], [Application]
  where Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 8
  and App_Key in
(
  SELECT distinct App_Key 
  FROM [Menu_Applications], [Menu], [Application] 
  where MenuApplications_MenuKey = menu_key
  and MenuApplications_AppKey = App_Key
  and app_type = 8
  and menu_name in 
  ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
 and App_Key 
 in
(75)  -- utilities billpay uk 
order by 2

-------------------------------------------------------------------------------------------------------------------------------------
--  BillPay general utilities
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Utilities Gen%') --<PGXProds_ProdGKey>
    ,prod_key
   , 15 -- utilities UK <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 8
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 8
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
 and App_Key 
 in
 (102, 225, 199)  -- utilities billpay general 
 ORDER by 2

-------------------------------------------------------------------------------------------------------------------------------------
--  BillPay Channel Isles
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Channel Islands%') --<PGXProds_ProdGKey>
    ,prod_key
    ,18 -- BillPay Channel Islands <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 8
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 8
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
 and App_Key 
 in
 (32)  -- BillPay Channel Islands
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  BillPay NI
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Utilities NI%') --<PGXProds_ProdGKey>
    ,prod_key
    ,14  -- BillPay utilities NI <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 8
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 8
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
 and App_Key 
 in
(76)  -- utilities billpay ni 
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  BillPay Santander basic
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Santander Basic%') --<PGXProds_ProdGKey>
    ,prod_key
   , 16  -- BillPay Santander Basic <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 8
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 8
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
 and App_Key 
 in
 (112)  -- BillPay Santander Basic 
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  BillPay Santander extended
-------------------------------------------------------------------------------------------------------------------------------------
INSERT into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Santander Extended%') --<PGXProds_ProdGKey>
    ,prod_key
   , 17 -- BillPay Santander Extended <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 8
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 8
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
 and App_Key 
 in
(143) -- Billpay Santander Extended 
and prod_key not in
(select prod_key 
   FROM [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Key = 148
  )
ORDER by 2  


-------------------------------------------------------------------------------------------------------------------------------------
--  BillPay Santander NI
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Santander NI%') --<PGXProds_ProdGKey>
    ,prod_key
   , 38 -- BillPay Santander NI <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 8
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 8
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
 and App_Key 
 in
(148)  -- BillPay Santander NI
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  BillPay general
-------------------------------------------------------------------------------------------------------------------------------------
INSERT into [ProdGroupXProds]
   SELECT distinct 
    --app_Key, app_name, issuer_key , issuer_name, prod_key, Prod_description,
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay General%') --<PGXProds_ProdGKey>
    ,prod_key
    ,21 -- BillPay General <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 8
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 8
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
 and App_Key 
 in
   (173,168) -- BillPay General (all other billpay) 
 ORDER by 2
 
 
 -------------------------------------------------------------------------------------------------------------------------------------
--  BillPay PZ Requests
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay PZ Request%') --<PGXProds_ProdGKey>
    ,prod_key
    ,20 -- BillPay PZ Request <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 8
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 8
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
 and App_Key 
 in
(187)  -- PZ request billpay 
order by 2


-------------------------------------------------------------------------------------------------------------------------------------
--  BillPay Stock
-------------------------------------------------------------------------------------------------------------------------------------
insert into [ProdGroupXProds]
   SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Stock%') --<PGXProds_ProdGKey>
    ,prod_key
    ,19 -- BillPay Stock <PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 8
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 8
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
 and App_Key 
 in
 (35,36,171,229)  -- stock billpay 
order by 2


COMMIT TRANSACTION
