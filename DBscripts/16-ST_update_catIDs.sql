USE [TerminalConfig_V5_MJ]
GO

-- update Entitlements CategoryIDs
begin transaction
UPDATE  Product
set Prod_CategoryID = (select Cgr_Key from categories where Cgr_Name like '%Entitlement%')
where Prod_Key in
(
  SELECT  distinct   Prod_Key 
  FROM 
  [ProductGroups]
  inner join [ProdGroupXProds] on PGXProds_ProdGKey = ProductGroup_Key 
  inner join [Product] on Prod_Key = PGXProds_ProdKey
  inner join [Issuer_Format] on Prod_Issuer_Format = Issuer_key
  inner join [AppXref] on Issuer_key = AppXref_IssuerKey
  inner join [Application] on AppXref_AppKey = App_Key 
  inner join [Issuer_Range] on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join [TxnType] on TxnType_AppKey = App_Key
  inner join [ITSO] on ITSO_Prod_Key = Prod_Key
  and App_Type = 15 
  and issuer_Key  
  in (1461,1462,1463,1464,1465,1466,1467,1468,1493,1494,
      1503,1508,1514,1515,1525,1526,1531,1532,1533,1534,1537 )
  and (Prod_Next_Product_Index = 0 and Prod_Child_Products = 0)
  and ITSO_typ <> 2
  and ITSO_CarnetID = 0
  and Prod_Key not in 
(
     select Prod_Next_Product_Index 
     from Product
     inner join [Issuer_Format] on Prod_Issuer_Format = Issuer_key
     where issuer_Key  
     in (1461,1462,1463,1464,1465,1466,1467,1468,1493,1494,
         1503,1508,1514,1515,1525,1526,1531,1532,1533,1534,1537 )
)
  and Prod_Key not in 
(
     select Prod_Child_Products 
     from Product
     inner join [Issuer_Format] on Prod_Issuer_Format = Issuer_key
     where issuer_Key  
     in (1461,1462,1463,1464,1465,1466,1467,1468,1493,1494,
         1503,1508,1514,1515,1525,1526,1531,1532,1533,1534,1537 )
)
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu]
    ,[Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 15
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
)
commit transaction



-- update Carnet CategoryIDs
begin transaction
UPDATE  Product
set Prod_CategoryID = (select Cgr_Key from categories where Cgr_Name like '%Carnet%')
where Prod_Key in
(
  SELECT  distinct   Prod_Key 
  FROM 
  [ProductGroups]
  inner join [ProdGroupXProds] on PGXProds_ProdGKey = ProductGroup_Key 
  inner join [Product] on Prod_Key = PGXProds_ProdKey
  inner join [Issuer_Format] on Prod_Issuer_Format = Issuer_key
  inner join [AppXref] on Issuer_key = AppXref_IssuerKey
  inner join [Application] on AppXref_AppKey = App_Key 
  inner join [Issuer_Range] on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join [TxnType] on TxnType_AppKey = App_Key
  inner join [ITSO] on ITSO_Prod_Key = Prod_Key
  and App_Type = 15 
   and issuer_Key  
  in (1461,1462,1463,1464,1465,1466,1467,1468,1493,1494,
      1503,1508,1514,1515,1525,1526,1531,1532,1533,1534,1537 )
  and ITSO_CarnetID > 0
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu]
    ,[Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 15
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
)
commit transaction


-- update STR CategoryIDs

begin transaction
UPDATE  Product 
set Prod_CategoryID = (select Cgr_Key from categories where Cgr_Name like '%STR TopUp%')
where Prod_Key in
(
  SELECT  DISTINCT   Prod_Key 
  FROM 
  [ProductGroups]
  inner join [ProdGroupXProds] on PGXProds_ProdGKey = ProductGroup_Key 
  inner join [Product] on Prod_Key = PGXProds_ProdKey
  inner join [Issuer_Format] on Prod_Issuer_Format = Issuer_key
  inner join [AppXref] on Issuer_key = AppXref_IssuerKey
  inner join [Application] on AppXref_AppKey = App_Key 
  inner join [Issuer_Range] on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join [TxnType] on TxnType_AppKey = App_Key
  inner join [ITSO] on ITSO_Prod_Key = Prod_Key
  and App_Type = 15 
  and issuer_Key  
  in (1461,1462,1463,1464,1465,1466,1467,1468,1493,1494,
      1503,1508,1514,1515,1525,1526,1531,1532,1533,1534,1537 )
  and (Prod_Next_Product_Index = 0 and Prod_Child_Products = 0)
  and ITSO_typ = 2
  and ITSO_CarnetID = 0
  and Prod_Key not in 
(
     select Prod_Next_Product_Index 
     from Product
     inner join [Issuer_Format] on Prod_Issuer_Format = Issuer_key
     where issuer_Key  
     in (1461,1462,1463,1464,1465,1466,1467,1468,1493,1494,
         1503,1508,1514,1515,1525,1526,1531,1532,1533,1534,1537 )
)
  and Prod_Key not in 
(
     select Prod_Child_Products 
     from Product
     inner join [Issuer_Format] on Prod_Issuer_Format = Issuer_key
     where issuer_Key  
     in (1461,1462,1463,1464,1465,1466,1467,1468,1493,1494,
         1503,1508,1514,1515,1525,1526,1531,1532,1533,1534,1537 )
)
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu]
    ,[Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 15
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
)

commit transaction


-- update PP CategoryIDs

begin transaction
UPDATE Product
set Prod_CategoryID = (select Cgr_Key from categories where Cgr_Name like '%Product Purchase%')
where Prod_Key in
(
  SELECT  DISTINCT  p1.Prod_Key
  FROM [ProductGroups]
  inner join [ProdGroupXProds] on PGXProds_ProdGKey = ProductGroup_Key 
  inner join [Product]p1 on p1.Prod_Key = PGXProds_ProdKey
  inner join [Issuer_Format] on Prod_Issuer_Format = Issuer_key
  inner join [AppXref] on Issuer_key = AppXref_IssuerKey
  inner join [Application] on AppXref_AppKey = App_Key 
  inner join [Issuer_Range] on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join [TxnType] on TxnType_AppKey = App_Key
  inner join [ITSO] on ITSO_Prod_Key = p1.Prod_Key
  and App_Type = 15 
  and ( (p1.Prod_Next_Product_Index > 0 or p1.Prod_Child_Products > 0)
         or Prod_Key in (select Prod_Next_Product_Index from Product, Issuer_Format
                         where issuer_Key in 
                         (1461,1462,1463,1464,1465,1466,1467,1468,1493,1494,
                          1503,1508,1514,1515,1525,1526,1531,1532,1533,1534,1537 ) )
         or Prod_Key in (select Prod_Child_Products from Product, Issuer_Format
                         where issuer_Key in 
                         (1461,1462,1463,1464,1465,1466,1467,1468,1493,1494,
                          1503,1508,1514,1515,1525,1526,1531,1532,1533,1534,1537 ) )
       )                          
   and ITSO_typ <> 2
  and ITSO_CarnetID = 0
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu]
    ,[Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 15
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
)

 COMMIT transaction
 

-- check if all ok 
--   SELECT  distinct 
--       Prod_Key --as prodID
--       ,rtrim(Prod_Description) as productName
--       ,Prod_Next_Product_Index as nextP
--       ,Prod_Child_Products as childP
--       ,Prod_DefaultProduct as defaultP  
--       ,ITSO_typ, ITSO_carnetID as carnetID
--       ,Issuer_Key as issuerID
--       ,rtrim(Issuer_Name) as IssuerName
--       ,Prod_CategoryID as catID
--  FROM 
--  [ProductGroups]
--  inner join [ProdGroupXProds] on PGXProds_ProdGKey = ProductGroup_Key 
--  inner join [Product] on Prod_Key = PGXProds_ProdKey
--  inner join [Issuer_Format] on Prod_Issuer_Format = Issuer_key
--  inner join [AppXref] on Issuer_key = AppXref_IssuerKey
--  inner join [Application] on AppXref_AppKey = App_Key 
--  inner join [Issuer_Range] on IssuerRange_IssuerFormat_Key = Issuer_Key
--  inner join [TxnType] on TxnType_AppKey = App_Key
--  inner join [ITSO] on ITSO_Prod_Key = Prod_Key
--  and App_Type = 15 
--  and issuer_Key  
--  in (1461,1462,1463,1464,1465,1466,1467,1468,1493,1494,
--      1503,1508,1514,1515,1525,1526,1531,1532,1533,1534,1537 )
--










