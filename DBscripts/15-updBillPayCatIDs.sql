USE [TerminalConfig_V5_MJ]
GO

BEGIN TRANSACTION
IF NOT EXISTS (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'Obsolete%')
  INSERT INTO Categories
  VALUES ('Obsolete Category', null, 0, 0, null)
-- select * from categories 
COMMIT TRANSACTION


BEGIN TRANSACTION

  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'Billpay Santander NI%') 
  )
  
  
  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Santander Basic%') 
  )

  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Santander Extended%') 
  )

  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Channel Islands%') 
  )
  
    UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Utilities UK%') 
  )

  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Utilities NI%') 
  )

  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay Utilities General%') 
  )

  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'BillPay Utilities%')
  WHERE
  Prod_Key in 
  (SELECT Prod_Key 
   FROM ProdGroupXProds
   , ProductGroups
   , Product
   WHERE[PGXProds_PGID] = ProductGroup_ID
   AND PGXProds_ProdKey = Prod_Key
   AND [ProductGroup_Key] IN 
   (select  ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'BillPay General%') 
  )
commit  transaction


begin transaction
-- un- categorised data, from menus not used anymore, ie obsolete products
  UPDATE Product
  SET Prod_CategoryID = 
  (SELECT Cgr_Key FROM Categories WHERE LTRIM(Cgr_Name) LIKE 'Obsolete Category%')
  WHERE
  Prod_Key in 
  ( select distinct prod_Key 
    FROM Application
    inner join AppXref on AppXref_AppKey = App_Key
    inner join Issuer_Format on AppXref_IssuerKey = Issuer_Key
    inner join Product on Prod_Issuer_Format  = issuer_Key
    inner join Menu_Applications on MenuApplications_AppKey = App_Key
    inner join Menu on MenuApplications_MenuKey = menu_key
    where app_Type = 8
    and Prod_CategoryID is null
    and menu_name not in ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
  )
 
  
--rollback transaction
commit transaction


