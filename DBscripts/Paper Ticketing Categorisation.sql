-- Modify to target required database
USE [TerminalConfig_V3]

begin transaction;
declare @catKey  INT;

-- CLEAR OUT TEMP TABLES IF NECESSARY
if OBJECT_ID('tempdb..#t1') is not null
  drop table #t1;

-- Create Paper Ticketing category if it doesn't already exist
if not exists (select [Cgr_Key ] from [Categories] where [Cgr_Name] like 'Paper Ticketing%')
begin
	INSERT INTO [dbo].[Categories] ([Cgr_Name] ,[Cgr_Parent] ,[Cgr_Visible] ,[Cgr_AppType] ,[Cgr_TxnType])
         VALUES                    ('Paper Ticketing' ,null, 0, 10, 0);
    set @catKey = @@IDENTITY;
end;
else
begin
	set @catKey = (select [Cgr_Key ] from [Categories] where [Cgr_Name] like 'Paper Ticketing%');
end;

-- List the products that will be changed
SELECT distinct [Prod_Key]
  into #t1
  FROM Menu
  JOIN menu_applications on Menuapplications_menukey = menu_key
  JOIN [AppXref] ON [AppXref_AppKey] = [MenuApplications_Appkey]
  JOIN [Application] ON [MenuApplications_Appkey] = [App_Key]
  JOIN [Issuer_Format] ON [AppXref_IssuerKey] = [Issuer_Key]
  LEFT JOIN [Product] ON Prod_Issuer_Format = Issuer_Key
 WHERE menu_name like 'PZ%'
   AND Prod_CategoryID is null
   AND App_Type = 10;

-- Show list of products to be changed
SELECT distinct 
       [App_Name] as App
      ,[AppXref_AppKey] as AppID
	  ,App_Type
      ,[AppXref_IssuerKey] as IssID
      ,[Issuer_Name] as Iss
      ,[Prod_Key] as ProdID
 	  ,[Prod_Description] as Prod
  FROM Menu
  JOIN menu_applications on Menuapplications_menukey = menu_key
  JOIN [AppXref] ON [AppXref_AppKey] = [MenuApplications_Appkey]
  JOIN [Application] ON [MenuApplications_Appkey] = [App_Key]
  JOIN [Issuer_Format] ON [AppXref_IssuerKey] = [Issuer_Key]
  LEFT JOIN [Product] ON Prod_Issuer_Format = Issuer_Key
 WHERE Prod_Key in
(select * from #t1);

-- Set all uncategorised Bill Payments to BillPay Utilities
update product
set Prod_CategoryID = @catKey
where Prod_Key in
(SELECT distinct [Prod_Key] FROM #t1);

-- Show list of products to be changed
SELECT distinct 
       [App_Name] as App
      ,[AppXref_AppKey] as AppID
	  ,App_Type
      ,[AppXref_IssuerKey] as IssID
      ,[Issuer_Name] as Iss
      ,[Prod_Key] as ProdID
 	  ,[Prod_Description] as Prod
	  ,[Prod_CategoryID]
  FROM Menu
  JOIN menu_applications on Menuapplications_menukey = menu_key
  JOIN [AppXref] ON [AppXref_AppKey] = [MenuApplications_Appkey]
  JOIN [Application] ON [MenuApplications_Appkey] = [App_Key]
  JOIN [Issuer_Format] ON [AppXref_IssuerKey] = [Issuer_Key]
  LEFT JOIN [Product] ON Prod_Issuer_Format = Issuer_Key
 WHERE Prod_Key in
(select * from #t1);

select * from Categories;

SELECT distinct 
	   App_Type
      ,[AppXref_IssuerKey] as IssID
      ,[Issuer_Name] as Iss
      ,[Prod_Key] as ProdID
 	  ,[Prod_Description] as Prod
  FROM Menu
 JOIN menu_applications on Menuapplications_menukey = menu_key
 JOIN [AppXref] ON [AppXref_AppKey] = [MenuApplications_Appkey]
 JOIN [Application] ON [MenuApplications_Appkey] = [App_Key]
 JOIN [Issuer_Format] ON [AppXref_IssuerKey] = [Issuer_Key]
LEFT JOIN [Product] ON Prod_Issuer_Format = Issuer_Key
WHERE menu_name like 'PZ%'
  AND Prod_CategoryID is null
order by App_Type, ProdID;

drop table #t1;

--rollback transaction;
commit transaction;
