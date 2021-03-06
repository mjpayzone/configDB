USE [TerminalConfig_V5_MJ]
GO

-- The [ProductGroup_Key]  group is commented out in the below sql as it needs to be checked 
-- against the productgoups table in the req database. If the productgroups table was populated 
--using the file ProductGroupsData.unl then the uncommented values should be correct, but needs 
-- to be checked using:  SELECT * FROM ProductGroups
--They should be:
-- ( <ETU Key Entry> , <ETU Extended> , <ETUType> , <PrePaidCards> )

-- The commented out sql at the end of this file can be used to check this insert
-- before commiting the transaction


BEGIN TRANSACTION

-------------------------------------------------------------------------------------------------------------------------------------
--   update ETU CatIDs
-------------------------------------------------------------------------------------------------------------------------------------
  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'ETU%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (9,10,12,11) -- ( <ETU Key Entry> , <ETU Extended> , <ETUType> , <PrePaidCards> )
  )

--select Prod_Issuer_Format, Prod_Key, Prod_Description, Prod_Child_Products, Prod_DefaultProduct, Prod_CategoryID
--from Product
--where  Prod_CategoryID = 
-- (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'ETU%')
--order by 1


-------------------------------------------------------------------------------------------------------------------------------------
--   update EVoucher  CatIDs
-------------------------------------------------------------------------------------------------------------------------------------
  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'EVoucher%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (1,2,3,4,5,6,7,8)    -- ( <E-Voucher> , <Airtel Guernsey E-Voucher> , <Airtel Jersey E-Voucher> , <Sure Isle of Man E-Voucher> ,
                        --   <Sure Guernsey E-Voucher> ,<Sure Jersey E-Voucher> ,<JT Jersey E-Voucher> ,<JT Guernsey E-Voucher> )
  )

--select Prod_Issuer_Format, Prod_Key, Prod_Description, Prod_Child_Products, Prod_DefaultProduct, Prod_CategoryID
--from Product
--where  Prod_CategoryID = 
--(SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'EVoucher%')
--order by 1

-------------------------------------------------------------------------------------------------------------------------------------
--   update  BillPay Utilities CatIDs
-------------------------------------------------------------------------------------------------------------------------------------
--  UPDATE Product
--  SET Prod_CategoryID = 
--  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
 -- WHERE
--  Prod_Key in 
--  (SELECT Prod_Key 
 --  FROM ProdGroupXProds
--   , ProductGroups
 --  , Product
 --  WHERE[PGXProds_PGID] = ProductGroup_ID
 --  AND PGXProds_ProdKey = Prod_Key
--    AND [ProductGroup_Key] IN 
--   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'Billpay SantanderNI%') 
--  )
  -- AND [ProductGroup_Key] IN 
  -- (13,14,15,16,17,18,21)
--   ( <BillPay Utilities UK>, <BillPay Utilities NI>, <BillPay Utilities General>, <BillPay Santander Basic>,
--     <BillPay Santander Extended> , <BillPay Channel Islands> , <BillPay General> )
--  )

--set transaction isolation level read uncommitted
--select Prod_Issuer_Format, Prod_Key, Prod_Description, Prod_Child_Products, Prod_DefaultProduct, Prod_CategoryID
--          from Product
--          where  Prod_CategoryID = 
--            (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
--          order by 1


-------------------------------------------------------------------------------------------------------------------------------------
--   update  BillPay PZ Request CatIDs
-------------------------------------------------------------------------------------------------------------------------------------
  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay PZ Request%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
  (20) -- ( <BillPay PZ Request> )
   )

--select Prod_Issuer_Format, Prod_Key, Prod_Description, Prod_Child_Products, Prod_DefaultProduct, Prod_CategoryID
--from Product
--where  Prod_CategoryID = 
-- (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay PZ Request%%')
--order by 1


-------------------------------------------------------------------------------------------------------------------------------------
--   update  BillPay Stock CatIDs
-------------------------------------------------------------------------------------------------------------------------------------
  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Stock%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (19) --( <BillPay Stock> )
  )

--select Prod_Issuer_Format, Prod_Key, Prod_Description, Prod_Child_Products, Prod_DefaultProduct, Prod_CategoryID
--from Product
--where  Prod_CategoryID = 
-- (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Stock%')
--order by 1


-------------------------------------------------------------------------------------------------------------------------------------
--   update Quantum  CatIDs
-------------------------------------------------------------------------------------------------------------------------------------
  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'Quantum%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (25) -- ( <Quantum> )
  )

--select Prod_Issuer_Format, Prod_Key, Prod_Description, Prod_Child_Products, Prod_DefaultProduct, Prod_CategoryID
--from Product
--where  Prod_CategoryID = 
-- (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'Quantum')
--order by 1

-------------------------------------------------------------------------------------------------------------------------------------
--   update Talexus  CatIDs
-------------------------------------------------------------------------------------------------------------------------------------
 UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'Talexus%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (26) -- ( <Talexus> )
  )

--select Prod_Issuer_Format, Prod_Key, Prod_Description, Prod_Child_Products, Prod_DefaultProduct, Prod_CategoryID
--from Product
--where  Prod_CategoryID = 
-- (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'Talexus')
--order by 1


-------------------------------------------------------------------------------------------------------------------------------------
--   update THL  CatIDs
-------------------------------------------------------------------------------------------------------------------------------------
 UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'THL%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key  
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (24) -- ( <THL> )
  )

--select Prod_Issuer_Format, Prod_Key, Prod_Description, Prod_Child_Products, Prod_DefaultProduct, Prod_CategoryID
--from Product
--where  Prod_CategoryID = 
--(SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'THL')
--order by 1

-------------------------------------------------------------------------------------------------------------------------------------
--   update  NEXT Returns CatIDs
-------------------------------------------------------------------------------------------------------------------------------------
  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'NEXT Returns%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key  
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (27) -- ( <NEXT Returns> )
  )

--select Prod_Issuer_Format, Prod_Key, Prod_Description, Prod_Child_Products, Prod_DefaultProduct, Prod_CategoryID
--from Product
--where  Prod_CategoryID = 
--(SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'THL')
--order by 1


-------------------------------------------------------------------------------------------------------------------------------------
--   update  Dart-Charge CatIDs
-------------------------------------------------------------------------------------------------------------------------------------
  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'Tolling Dart Charge%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (37) -- ( <Dart-Charge> )
  )

--select Prod_Issuer_Format, Prod_Key, Prod_Description, Prod_Child_Products, Prod_DefaultProduct, Prod_CategoryID
--from Product
--where  Prod_CategoryID = 
-- (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'Tolling Dart Charge')
--order by 1

      
COMMIT TRANSACTION


-------------------------------------------------------------------------------------------------------------------------------------
--   update  BillPay Utilities CatIDs
-------------------------------------------------------------------------------------------------------------------------------------

--BEGIN TRANSACTION
--IF NOT EXISTS (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'Obsolete%')
--  INSERT INTO Categories
--  VALUES ('Obsolete Category', null, 0, 0, null)
---- select * from categories 
--COMMIT TRANSACTION
--
--
--BEGIN TRANSACTION
--
--  UPDATE Product
--  SET Prod_CategoryID = 
--  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
--  WHERE
--  Prod_Key in 
--  (SELECT Prod_Key 
--   FROM ProdGroupXProds
--   , ProductGroups
--   , Product
--   WHERE[PGXProds_PGID] = ProductGroup_ID
--   AND PGXProds_ProdKey = Prod_Key
--   AND [ProductGroup_Key] IN 
--   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'Billpay SantanderNI%') 
--  )
--  
--  
--  UPDATE Product
--  SET Prod_CategoryID = 
--  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
--  WHERE
--  Prod_Key in 
--  (SELECT Prod_Key 
--   FROM ProdGroupXProds
--   , ProductGroups
--   , Product
--   WHERE[PGXProds_PGID] = ProductGroup_ID
--   AND PGXProds_ProdKey = Prod_Key
--   AND [ProductGroup_Key] IN 
--   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Santander Basic%') 
--  )
--
--  UPDATE Product
--  SET Prod_CategoryID = 
--  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
--  WHERE
--  Prod_Key in 
--  (SELECT Prod_Key 
--   FROM ProdGroupXProds
--   , ProductGroups
--   , Product
--   WHERE[PGXProds_PGID] = ProductGroup_ID
--   AND PGXProds_ProdKey = Prod_Key
--   AND [ProductGroup_Key] IN 
--   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Santander Extended%') 
--  )
--
--  UPDATE Product
--  SET Prod_CategoryID = 
--  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
--  WHERE
--  Prod_Key in 
--  (SELECT Prod_Key 
--   FROM ProdGroupXProds
--   , ProductGroups
--   , Product
--   WHERE[PGXProds_PGID] = ProductGroup_ID
--   AND PGXProds_ProdKey = Prod_Key
--   AND [ProductGroup_Key] IN 
--   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Channel Islands%') 
--  )
--  
--    UPDATE Product
--  SET Prod_CategoryID = 
--  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
--  WHERE
--  Prod_Key in 
--  (SELECT Prod_Key 
--   FROM ProdGroupXProds
--   , ProductGroups
--   , Product
--   WHERE[PGXProds_PGID] = ProductGroup_ID
--   AND PGXProds_ProdKey = Prod_Key
--   AND [ProductGroup_Key] IN 
--   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Utilities UK%') 
--  )
--
--  UPDATE Product
--  SET Prod_CategoryID = 
--  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
--  WHERE
--  Prod_Key in 
--  (SELECT Prod_Key 
--   FROM ProdGroupXProds
--   , ProductGroups
--   , Product
--   WHERE[PGXProds_PGID] = ProductGroup_ID
--   AND PGXProds_ProdKey = Prod_Key
--   AND [ProductGroup_Key] IN 
--   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Utilities NI%') 
--  )
--
--  UPDATE Product
--  SET Prod_CategoryID = 
--  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
--  WHERE
--  Prod_Key in 
--  (SELECT Prod_Key 
--   FROM ProdGroupXProds
--   , ProductGroups
--   , Product
--   WHERE[PGXProds_PGID] = ProductGroup_ID
--   AND PGXProds_ProdKey = Prod_Key
--   AND [ProductGroup_Key] IN 
--   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Utilities General%') 
--  )
--
--  UPDATE Product
--  SET Prod_CategoryID = 
--  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
--  WHERE
--  Prod_Key in 
--  (SELECT Prod_Key 
--   FROM ProdGroupXProds
--   , ProductGroups
--   , Product
--   WHERE[PGXProds_PGID] = ProductGroup_ID
--   AND PGXProds_ProdKey = Prod_Key
--   AND [ProductGroup_Key] IN 
--   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay General%') 
--  )
--
--
---- un- categorised data, from menus not used anymore, ie obsolete products
--  UPDATE Product
--  SET Prod_CategoryID = 
--  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'Obsolete Category%')
--  WHERE
--  Prod_Key in 
--  ( select distinct prod_Key 
--    FROM Application
--    inner join AppXref on AppXref_AppKey = App_Key
--    inner join Issuer_Format on AppXref_IssuerKey = Issuer_Key
--    inner join Product on Prod_Issuer_Format  = issuer_Key
--    inner join Menu_Applications on MenuApplications_AppKey = App_Key
--    inner join Menu on MenuApplications_MenuKey = menu_key
--    where app_Type = 8
--    and Prod_CategoryID is null
--    and menu_name not in ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
--  )
-- 
--  
----rollback transaction
--commit transaction
--
----select Prod_Issuer_Format, Prod_Key, Prod_Description, Prod_Child_Products, Prod_DefaultProduct, Prod_CategoryID
----  from Product
----  where  Prod_CategoryID = 
----   (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
----  order by 1

