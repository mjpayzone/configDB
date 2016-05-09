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
--select * from prodgroupxprods where pgxprods_pgid =  1

BEGIN TRANSACTION

---------------------------------------------------------------------------------------------------------------------------------------------  
-- insert all EV products except the Channel Isles
---------------------------------------------------------------------------------------------------------------------------------------------  

insert into [ProdGroupXProds]
  SELECT distinct 
    (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'E-Voucher') --<PGXProds_ProdGKey>
    , prod_key
    ,1 --<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
    ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  FROM [Issuer_Format],  [AppXref],  [Application],  [Product]
  WHERE 
       AppXref_IssuerKey = Issuer_Key
       and AppXref_AppKey = App_Key
       and Prod_Issuer_Format = Issuer_Key
       and app_type = 3
       and App_Key in 
       (
        SELECT distinct MenuApplications_AppKey 
         FROM [Menu_Applications], [Menu], [Application] 
         where MenuApplications_MenuKey = menu_key
         and MenuApplications_AppKey = App_Key
         and App_Type = 3
         and menu_name in 
         ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE', 'PZSY')
       )
       and app_key not in (19,20,21,244,245,246)  --  these are the channel isles apps
  order by 2
  
  
---------------------------------------------------------------------------------------------------------------------------------------------  
-- insert Channel Isles EV products
---------------------------------------------------------------------------------------------------------------------------------------------  

-- Sure Isle of Mann
insert into [ProdGroupXProds]
select 
 (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'Sure Isle of Man E-Voucher')
, prod_key
, 4  --<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
, LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
from [Issuer_Format], [AppXref], [Application], [Product]
where AppXref_IssuerKey = Issuer_Key
 and AppXref_AppKey = App_Key
 and Prod_Issuer_Format = AppXref_IssuerKey
 and app_Key  = (select top(1) App_Key from Application where App_Name like 'Sure')
 and app_type = 3
 and issuer_Name like 'Isle of Man%'
 
--  Sure Guernsey 
 insert into [ProdGroupXProds]
  select 
  (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'Sure Guernsey E-Voucher')
, prod_key
, 5  --<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
, LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
from [Issuer_Format], [AppXref], [Application], [Product]
where AppXref_IssuerKey = Issuer_Key
 and AppXref_AppKey = App_Key
 and Prod_Issuer_Format = AppXref_IssuerKey
 and app_Key  = (select top(1) App_Key from Application where App_Name like 'Sure')
 and app_type = 3
 and issuer_Name like 'Sure Guernsey%'

-- Sure Jersey
insert into [ProdGroupXProds]
select 
  (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'Sure Jersey E-Voucher')
, prod_key
, 6  --<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
, LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
from [Issuer_Format], [AppXref], [Application], [Product]
where AppXref_IssuerKey = Issuer_Key
 and AppXref_AppKey = App_Key
 and Prod_Issuer_Format = AppXref_IssuerKey
 and app_Key  = (select top(1) App_Key from Application where App_Name like 'Sure')
 and app_type = 3
 and issuer_Name like 'Sure Jersey%'


-- JT  Jersey
INSERT into [ProdGroupXProds]
select 
  (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'JT Jersey E-Voucher')
  , prod_key
  , 7  --<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
  , LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  from [Issuer_Format], [AppXref], [Application], [Product]
  where AppXref_IssuerKey = Issuer_Key
  and AppXref_AppKey = App_Key
  and Prod_Issuer_Format = AppXref_IssuerKey
  and app_Key = (select top(1) App_Key from Application where App_Name like 'JT%')  
  and app_type = 3
  and issuer_Name like 'JT Jersey%'

-- JT  Guernsey
insert into [ProdGroupXProds]
select 
  (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'JT Guernsey E-Voucher')
  , prod_key
  , 8  --<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
  , LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
  from [Issuer_Format], [AppXref], [Application], [Product]
  where AppXref_IssuerKey = Issuer_Key
  and AppXref_AppKey = App_Key
  and Prod_Issuer_Format = AppXref_IssuerKey
  and app_Key = (select top(1) App_Key from Application where App_Name like 'JT%')  
  and app_type = 3
  and issuer_Name like 'JT Guernsey%'


-- Airtel Guernsey
INSERT into [ProdGroupXProds]
  select 
  (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'Airtel Guernsey E-Voucher')
  ,prod_key
  ,2 --<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
  ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
from [Issuer_Format], [AppXref], [Application], [Product]
where AppXref_IssuerKey = Issuer_Key
 and AppXref_AppKey = App_Key
 and Prod_Issuer_Format = AppXref_IssuerKey
 and app_Key  =  (select top(1) App_Key from Application where App_Name like 'Airtel%')  
 and issuer_Name like '%Guernsey%'
 
-- Airtel Jersey
insert into [ProdGroupXProds]
 SELECT 
 (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'Airtel Jersey E-Voucher')
 ,prod_key
 ,3 --<PGXProds_PGID - this will be correct when using the ProducGroupsData.unl file>
 ,LTRIM(RTRIM(issuer_Name)) + ' ' + LTRIM(RTRIM(prod_description)) 
 from [Issuer_Format], [AppXref], [Application], [Product]
 where AppXref_IssuerKey = Issuer_Key
 and AppXref_AppKey = App_Key
 and Prod_Issuer_Format = AppXref_IssuerKey
 and app_Key  =  (select top(1) App_Key from Application where App_Name like 'Airtel%') --21 -- Airtel 
 and issuer_Name like '%Jersey%'

COMMIT TRANSACTION


