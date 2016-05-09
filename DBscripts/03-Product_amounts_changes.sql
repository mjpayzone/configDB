USE [Terminal_config_MJ]
GO
-------------------------------------------------------------------------------------------------------------------------------
-- change amounts fields TO INT rather than SMALLINT 
-------------------------------------------------------------------------------------------------------------------------------

Begin Transaction

ALTER TABLE [Product] 
DROP CONSTRAINT [DF_Product_Prod_Default_Amount]  
  
  alter table [Product]
  ALTER COLUMN Prod_Default_Amount int not null
  
ALTER TABLE [Product] 
ADD  CONSTRAINT [DF_Product_Prod_Default_Amount]  DEFAULT ((0)) FOR [Prod_Default_Amount]

commit transaction  



Begin Transaction

ALTER TABLE [Product] 
DROP CONSTRAINT [DF_Product_Prod_Min_Amount]  
  
  alter table [Product]
  ALTER COLUMN Prod_Min_Amount int not null
  
ALTER TABLE [Product] 
ADD  CONSTRAINT [DF_Product_Prod_Min_Amount]  DEFAULT ((0)) FOR [Prod_Min_Amount]

commit transaction  


Begin Transaction

ALTER TABLE [Product] 
DROP CONSTRAINT [DF_Product_Prod_Max_Amount]  
  
  alter table [Product]
  ALTER COLUMN Prod_Max_Amount int not null
  
ALTER TABLE [Product] 
ADD  CONSTRAINT [DF_Product_Prod_Max_Amount]  DEFAULT ((0)) FOR [Prod_Max_Amount]

commit transaction  


-------------------------------------------------------------------------------------------------------------------------------
-- add new field Prod_Amount
-------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE [Product]
ADD 
Prod_Amount INT NOT NULL DEFAULT 0


-------------------------------------------------------------------------------------------------------------------------------
-- start transation for big bundle of updates
-------------------------------------------------------------------------------------------------------------------------------
BEGIN TRANSACTION

-------------------------------------------------------------------------------------------------------------------------------
-- update amounts to all be in pence
-------------------------------------------------------------------------------------------------------------------------------

UPDATE [Product]
SET [Prod_Default_Amount] = [Prod_Default_Amount] * 100
      ,[Prod_Min_Amount] = [Prod_Min_Amount] * 100
      ,[Prod_Max_Amount] = [Prod_Max_Amount] * 100
WHERE 1=1

--set transaction isolation level READ UNCOMMITTED 
--select [Prod_Key] , Prod_Description, [Prod_Default_Amount], [Prod_Min_Amount], [Prod_Max_Amount]
--from [Product]


-------------------------------------------------------------------------------------------------------------------------------
-- updates the new fields Prod_Amount to try get the amounts accurate
-------------------------------------------------------------------------------------------------------------------------------

-- ETU amounts
update [Product] 
set Prod_Amount = Prod_Max_Amount
where Prod_Key in
(
select distinct prod_key
from Product, Issuer_Format, AppXref, Application
where Prod_Issuer_Format = Issuer_Key
and AppXref_IssuerKey = Issuer_Key
and AppXref_AppKey = App_Key
and App_Type  = 1
and Prod_Max_Amount > 0
and Prod_Min_Amount = Prod_Max_Amount
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
)
-----

-- Orange 10p and 50p updates - wrong in DB

UPDATE Product
SET Prod_Amount = 10,
    Prod_Min_Amount = 10,
    Prod_Max_Amount = 10
WHERE Prod_Key = 2918 

UPDATE Product
SET Prod_Amount = 50,
    Prod_Min_Amount = 50,
    Prod_Max_Amount = 50
WHERE Prod_Key =2919

-- EV amounts, set to max amount
update [Product] 
set Prod_Amount = Prod_Max_Amount
where Prod_Key in
(
select prod_key
from Product, Issuer_Format, AppXref, Application
where Prod_Issuer_Format = Issuer_Key
and AppXref_IssuerKey = Issuer_Key
and AppXref_AppKey = App_Key
AND App_Type  = 3
and Prod_Max_Amount > 0
  and App_Key in
(
SELECT  distinct App_Key
  FROM [Menu_Applications], [Menu], [Application] 
  where MenuApplications_MenuKey = menu_key
  and MenuApplications_AppKey = App_Key
  and app_type = 3
  and menu_name in 
  ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
)

-- update some bus tickets to max
update [Product] 
set Prod_Amount = Prod_Max_Amount
where Prod_Key in
(
select prod_key
from Product, Issuer_Format, AppXref, Application
where Prod_Issuer_Format = Issuer_Key
and AppXref_IssuerKey = Issuer_Key
and AppXref_AppKey = App_Key
and App_Type  = 10
and Prod_Max_Amount > 0
and Prod_Max_Amount = Prod_Min_Amount
and App_Key in
(
SELECT  distinct App_Key
  FROM [Menu_Applications], [Menu], [Application] 
  where MenuApplications_MenuKey = menu_key
  and MenuApplications_AppKey = App_Key
  and app_type = 10
  and menu_name in 
  ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
)

-- small update for the different amounts to work

update Product
set prod_description = 'Adult Weekly £17.20' 
where prod_key = 4026  

update Product
set prod_description = 'child weekly £11.50       ' 
where prod_key = 4093  

-- extract rest of bustickets amount from description
update [Product] 
set Prod_Amount = 
CAST(REPLACE((SUBSTRING( RTRIM(Prod_description), (CHARINDEX('£', Prod_description)+1), 6)), '.', '' )  as int) 
where Prod_Key in
(
select prod_key
from Product, Issuer_Format, AppXref, Application
where Prod_Issuer_Format = Issuer_Key
and AppXref_IssuerKey = Issuer_Key
and AppXref_AppKey = App_Key
and App_Type  = 10
and Prod_Max_Amount > 0
and Prod_Min_Amount !=  Prod_Max_Amount 
and App_Key in
(
SELECT  distinct App_Key
  FROM [Menu_Applications], [Menu], [Application] 
  where MenuApplications_MenuKey = menu_key
  and MenuApplications_AppKey = App_Key
  and app_type = 10
  and menu_name in 
  ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
)

--the next products amount were defaulted to 0, so needs correcting
update product
set prod_amount = 250
where prod_key in (2464, 2468, 2611, 3170, 3174, 3343)
-- (ie IDT Europe, IDT Africa, White Card, IDT 893530403 and 893530405, IDT 893530404, IDT 893530402)

-- 5 strange valued SIMPLECALL products
update product 
set prod_amount = 410
where prod_key = 2587
--
update product 
set prod_amount = 450
where prod_key = 2588
--
update product 
set prod_amount = 475
where prod_key = 2589
--
update product 
set prod_amount = 950
where prod_key = 2590
--
update product 
set prod_amount = 4750
where prod_key = 2592


--COMMIT TRANSACTION





