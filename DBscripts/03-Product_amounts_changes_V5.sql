USE [TerminalConfig_V5_MJ]
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

GO

Begin Transaction

ALTER TABLE [Product] 
DROP CONSTRAINT [DF_Product_Prod_Min_Amount]  
  
  alter table [Product]
  ALTER COLUMN Prod_Min_Amount int not null
  
ALTER TABLE [Product] 
ADD  CONSTRAINT [DF_Product_Prod_Min_Amount]  DEFAULT ((0)) FOR [Prod_Min_Amount]

commit transaction  

GO

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
GO
ALTER TABLE [Product]
ADD 
Prod_Amount INT NOT NULL DEFAULT 0
GO

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

commit transaction
begin transaction

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

commit transaction
begin transaction
--rollback transaction

-- update in-between amounts

update [Product] 
set Prod_Amount = 
CAST(REPLACE((SUBSTRING( RTRIM(Prod_description), (CHARINDEX('£', Prod_description)+1), 5)), '.', '' )  as int) 
--set Prod_Amount = Prod_Max_Amount
where Prod_Key in
(
select distinct prod_key
from Product, Issuer_Format, AppXref, Application
where Prod_Issuer_Format = Issuer_Key
and AppXref_IssuerKey = Issuer_Key
and AppXref_AppKey = App_Key
and App_Type  = 1
and Prod_Max_Amount > 0
and Prod_Min_Amount <> Prod_Max_Amount
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
and prod_description like '%£%'
)

commit transaction
begin transaction


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

commit transaction
--rollback transaction
begin transaction

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

commit transaction
begin transaction

-- small update for the different amounts to work

update Product
set prod_description = 'Adult Weekly £17.30' 
where prod_description like 'Adult Weekly 17.30'  

commit transaction
begin transaction

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
and prod_description like '%£%'
)

commit transaction

----the next products amount were defaulted to 0, so needs correcting
-----

GO

BEGIN TRANSACTION  
 
 update Product 
 set Prod_Amount = 250
 where 
 Prod_Min_Amount <> Prod_Amount     
-- and Prod_Amount > 0 
 and Prod_description like '%£2.50%' 
 
 update Product 
 set Prod_Amount = 350
 where 
 Prod_Min_Amount <> Prod_Amount     
 --and Prod_Amount > 0 
 and Prod_description like '%£3.50%' 

 update Product 
 set Prod_Amount = 10
 where 
-- Prod_Min_Amount <> Prod_Amount     
 --and Prod_Amount > 0 
 Prod_description like '%10P%' 

 update Product 
 set Prod_Amount = 50
 where 
-- Prod_Min_Amount <> Prod_Amount     
 --and Prod_Amount > 0 
 Prod_description like '%50P%' 

 update Product 
 set Prod_Amount = 1250
 where 
 Prod_Min_Amount <> Prod_Amount     
 --and Prod_Amount > 0 
 and Prod_description like '%£12.50%' 

commit transaction


-- update billpay utilities amoounts to 1p where min = 0 and max > 0

--BEGIN TRANSACTION
--update Product
--set Prod_Min_Amount = 1
--where Prod_Key in
--(
--  
--  select prod_Key 
--  FROM Application
--  inner join AppXref on AppXref_AppKey = App_Key
--  inner join Issuer_Format on AppXref_IssuerKey = Issuer_Key
--  inner join Product on Prod_Issuer_Format  = issuer_Key
--  where app_Type = 8
--  and Prod_Min_Amount = 0
--  and Prod_Max_Amount > 0
--)  
----rollback transaction
--COMMIT TRANSACTION    
--


--  

-- UPDATE Product   
-- set  [Prod_Min_Amount] = [Prod_Amount],
--      [Prod_Max_Amount] = [Prod_Amount]
-- where [Prod_Min_Amount] <> Prod_Amount     
-- and Prod_Amount > 0 
---- rollback transaction

-- COMMIT TRANSACTION



