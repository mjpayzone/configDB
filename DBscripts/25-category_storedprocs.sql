USE [Terminal_config_MJ]
GO

-------------------------------------------------------------------------------------------------------------------------------------
--   getCategories
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getCategories]    Script Date: 10/21/2015 11:20:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getCategories] 
CREATE  PROCEDURE [dbo].[getCategories] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

  SELECT  distinct Cgr_Key as categoryID, 
                   Cgr_Name as categoryName,
                   ISNULL(Cgr_Parent, 0) as categoryParent,
                   Cgr_Visible as categoryVisible
  FROM Categories
  ORDER BY Cgr_Key

  if @@ROWCOUNT = 0
  begin
     set @ErrStatus = 100
     RETURN @ErrStatus
  end   
  else 
     set @ErrStatus = @@ERROR
  
  RETURN @ErrStatus
    
END TRY

BEGIN CATCH
    SELECT ERROR_NUMBER(),ERROR_MESSAGE()
    RETURN @ErrStatus
END CATCH

END

-------------------------------------------------------------------------------------------------------------------------------------
--   getCategoryTypeReq
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getCategoryTypeReq]    Script Date: 10/21/2015 11:21:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getCategoryTypeReq] 
CREATE  PROCEDURE [dbo].[getCategoryTypeReq] (@catID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @catParent smallint
DECLARE @parentName varchar(50)
  

BEGIN TRY
  
  SELECT @catParent = Cgr_Parent 
  FROM Categories
  where Cgr_Key = @catID
  
  IF (@catParent is not null)
  BEGIN
    SELECT @parentName = Cgr_Name
    FROM Categories
    where Cgr_Key = @catParent

    SELECT CAST(Cgr_AppType AS int) as catApptype, 
         RTRIM(@parentName) + ' ' + RTRIM(Cgr_Name) as catDesc
    FROM Categories
    where Cgr_Key = @catID
  END
  ELSE
  BEGIN
    SELECT CAST(Cgr_AppType AS int) as catApptype, 
         Cgr_Name as catDesc
    FROM Categories
    where Cgr_Key = @catID
  END 

  if @@ROWCOUNT = 0
  begin
     set @ErrStatus = -1
     RETURN @ErrStatus
  end   
  else 
     set @ErrStatus = @@ERROR
  
  RETURN @ErrStatus
    
END TRY

BEGIN CATCH
    SELECT ERROR_NUMBER(),ERROR_MESSAGE()
    RETURN @ErrStatus
END CATCH

END

-------------------------------------------------------------------------------------------------------------------------------------
--   getGenProductsCategory
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getGenProductsCategory]    Script Date: 10/21/2015 11:22:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getGenProductsCategory] 
CREATE  PROCEDURE [dbo].[getGenProductsCategory] (@catID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
--DECLARE @catID smallint
DECLARE @appType int
DECLARE @txnType int
DECLARE @defprod smallint
  
--SET @catID = 4

BEGIN TRY
  
  SELECT @appType = Cgr_AppType, @txnType = Cgr_TxnType
  FROM [Categories]
  where Cgr_Key = @catID
  
    SELECT  distinct 
       Issuer_Key as issuerID
       ,rtrim(Issuer_Name) as issuerName
       ,CASE WHEN Prod_Child_Products > 0 THEN Prod_Key ELSE 0 END as nodeproductID
       ,CASE WHEN Prod_Child_Products > 0 THEN rtrim(Prod_Description) else null END as nodeproductName
       ,Issuer_NUA_1 as issuerNUA,
       CASE WHEN TxnType_Code is null THEN 0 ELSE TxnType_Code END as txnType,
       App_Type as applicationType,
       CASE WHEN IssuerRange_IssuerFormat is null then null else IssuerRange_IssuerFormat END as IIN ,
       Issuer_Pan_Length_A as panRangeA,
       Issuer_Pan_Length_B as panRangeB,
       TxnType_BarCodeScanner as canBarcodeScan,
       TxnType_CardSwipe as canMsrScan,
       --Prod_Key as productID,
       --rtrim(Prod_Description) as productName,
       CASE WHEN Prod_Child_Products = 0 THEN Prod_Key ELSE 0 END as productID,
       CASE WHEN Prod_Child_Products = 0 THEN rtrim(Prod_Description) ELSE NULL END as productName,
       Prod_Amount as prodAmount,
       Prod_Min_Amount as prodMinAmount,
       Prod_Max_Amount as prodMaxAmount,
       Prod_Fund_Type as fundtype,
       Prod_Next_Product_Index as nextProductID,
       Prod_Child_Products as childProductID,
       CAST(Prod_DefaultProduct AS SMALLINT) as defaultProduct  
--       ,app_key
           , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
           , rtrim(s3.Strings_Text) as ReceiptText1
           , rtrim(s4.Strings_Text) as ReceiptText2
           , rtrim(s5.Strings_Text) as ReceiptText3
           , rtrim(s6.Strings_Text) as ReceiptText4
           , rtrim(s7.Strings_Text) as ReceiptText5
           , rtrim(s8.Strings_Text) as ReceiptText6
       ,AppType_MsgType as messageType 
         ,Start_Date as startDate
         ,Expiry_Date as expiryDate
         ,Fund_Type as drawFundType
         ,Price as price
         ,CAST(Saturday AS SMALLINT) as saturday
         ,CAST(Sunday AS SMALLINT) as sunday
         ,CAST(Monday AS SMALLINT) as monday
         ,CAST(Tuesday AS SMALLINT) as tuesday
         ,CAST(Wednesday AS SMALLINT) as wednesday
         ,CAST(Thursday AS SMALLINT) as thursday
         ,CAST(Friday AS SMALLINT) as friday
  FROM 
  [ProductGroups]
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join AppTypeDesc on App_Type = AppType_Type
--  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
--  inner join TxnType on TxnType_AppKey = App_Key
  and App_Type = @appType 
  and Prod_CategoryID in
  ( SELECT Cgr_Key FROM Categories
    WHERE Cgr_Key = @catID OR (Cgr_Parent = @catID and Cgr_Key > 0 )
  )
  left join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  left join TxnType on TxnType_AppKey = App_Key
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
   left join Draws on IssuerFormat_key = Issuer_Key 
  order by 1, 21 desc, 3, 13



  if @@ROWCOUNT = 0
  begin
     set @ErrStatus = 100
     RETURN @ErrStatus
  end   
  else 
     set @ErrStatus = @@ERROR
  
  RETURN @ErrStatus
    
END TRY

BEGIN CATCH
    SELECT ERROR_NUMBER(),ERROR_MESSAGE()
    RETURN @ErrStatus
END CATCH

END


-------------------------------------------------------------------------------------------------------------------------------------
--   getEVouchersCategory
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getEVouchersCategory]    Script Date: 10/21/2015 11:25:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP PROCEDURE [dbo].[getEVouchersCategory] 
CREATE PROCEDURE [dbo].[getEVouchersCategory] (@catID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @appType int
DECLARE @txnType int


BEGIN TRY

  SELECT @appType = Cgr_AppType, @txnType = Cgr_TxnType
  FROM [Categories]
  where Cgr_Key = @catID
  

  SELECT  distinct 
       Issuer_Key as issuerID
       ,rtrim(Issuer_Name) as issuerName
       ,CASE WHEN Prod_Child_Products > 0 THEN Prod_Key ELSE 0 END as nodeproductID
       ,CASE WHEN Prod_Child_Products > 0 THEN rtrim(Prod_Description) else null END as nodeproductName
       ,Issuer_NUA_1 as issuerNUA,
       TxnType_Code as txnType,
       App_Type as applicationType,
       IssuerRange_IssuerFormat as IIN ,
       Issuer_Pan_Length_A as panRangeA,
       Issuer_Pan_Length_B as panRangeB,
       TxnType_BarCodeScanner as canBarcodeScan,
       TxnType_CardSwipe as canMsrScan,
       --Prod_Key as productID,
       --rtrim(Prod_Description) as productName,
       CASE WHEN Prod_Child_Products = 0 THEN Prod_Key ELSE 0 END as productID,
       CASE WHEN Prod_Child_Products = 0 THEN rtrim(Prod_Description) ELSE NULL END as productName,
       Prod_Amount as prodAmount,
       Prod_Min_Amount as prodMinAmount,
       Prod_Max_Amount as prodMaxAmount,
       Prod_Fund_Type as fundType,
       Prod_Next_Product_Index as nextProductID,
       Prod_Child_Products as childProductID,
       CAST(Prod_DefaultProduct AS SMALLINT) as defaultProduct  
--       ,app_key
           , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
           , rtrim(s3.Strings_Text) as ReceiptText1
           , rtrim(s4.Strings_Text) as ReceiptText2
           , rtrim(s5.Strings_Text) as ReceiptText3
           , rtrim(s6.Strings_Text) as ReceiptText4
           , rtrim(s7.Strings_Text) as ReceiptText5
           , rtrim(s8.Strings_Text) as ReceiptText6
  FROM 
  [ProductGroups]
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join TxnType on TxnType_AppKey = App_Key
  and App_Type = @appType --15
  --and TxnType_Code = @TxnType --2
  and ((@txnType > 0 AND TxnType_Code = @txnType ) OR
       (@txnType = 0 AND TxnType_Code > 0))
  and Prod_CategoryID = @catID
  --and Issuer_Key = 1533
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 21 desc, 3, 13

  if @@ROWCOUNT = 0
  begin
     set @ErrStatus = 100
     RETURN @ErrStatus
  end   
  else 
     set @ErrStatus = @@ERROR
  
  RETURN @ErrStatus
    
END TRY

BEGIN CATCH
    SELECT ERROR_NUMBER(),ERROR_MESSAGE()
    RETURN @ErrStatus
END CATCH

END

-------------------------------------------------------------------------------------------------------------------------------------
--   getSmartTicketCategory
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getSmartTicketCategory]    Script Date: 10/21/2015 11:26:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[getSmartTicketCategory] (@catID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
--DECLARE @catID smallint
DECLARE @appType int
DECLARE @txnType int
DECLARE @defprod smallint
  
--SET @catID = 4

BEGIN TRY
  
  SELECT @appType = Cgr_AppType, @txnType = Cgr_TxnType
  FROM [Categories]
  where Cgr_Key = @catID
  
  SELECT  distinct 
       Issuer_Key as issuerID
       ,rtrim(Issuer_Name) as issuerName
       ,CASE WHEN Prod_Child_Products > 0 THEN Prod_Key ELSE 0 END as nodeproductID
       ,CASE WHEN Prod_Child_Products > 0 THEN rtrim(Prod_Description) else null END as nodeproductName
       ,Issuer_NUA_1 as issuerNUA,
       TxnType_Code as txnType,
       App_Type as applicationType,
       IssuerRange_IssuerFormat as IIN ,
       Issuer_Pan_Length_A as panRangeA,
       Issuer_Pan_Length_B as panRangeB,
       TxnType_BarCodeScanner as canBarcodeScan,
       TxnType_CardSwipe as canMsrScan,
       CASE WHEN Prod_Child_Products = 0 THEN Prod_Key ELSE 0 END as productID,
       CASE WHEN Prod_Child_Products = 0 THEN rtrim(Prod_Description) ELSE NULL END as productName,
       --Prod_Amount as prodAmount,
       ISNULL(ITSO_amount,0) as prodAmount,
       Prod_Min_Amount as prodMinAmount,
       Prod_Max_Amount as prodMaxAmount,
       Prod_Fund_Type as fundtype,
       Prod_Next_Product_Index as nextProductID,
       Prod_Child_Products as childProductID,
       --Prod_DefaultProduct as defaultProduct  
       --CASE WHEN Prod_DefaultProduct = 1 THEN 1 ELSE 0 END as defaultProduct  
       CAST(Prod_DefaultProduct AS SMALLINT) as defaultProduct  
--       ,app_key
           , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
           , rtrim(s3.Strings_Text) as ReceiptText1
           , rtrim(s4.Strings_Text) as ReceiptText2
           , rtrim(s5.Strings_Text) as ReceiptText3
           , rtrim(s6.Strings_Text) as ReceiptText4
           , rtrim(s7.Strings_Text) as ReceiptText5
           , rtrim(s8.Strings_Text) as ReceiptText6
  FROM 
  [ProductGroups]
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join TxnType on TxnType_AppKey = App_Key
  --inner join ITSO on ITSO_Prod_Key = Prod_Key
  and App_Type = @appType --15
  --and TxnType_Code = @TxnType --2
  and ((@txnType > 0 AND TxnType_Code = @txnType ) OR
       (@txnType = 0 AND TxnType_Code > 0))
--  and Prod_CategoryID = @catID
  and Prod_CategoryID in
  ( SELECT Cgr_Key FROM Categories
    WHERE Cgr_Parent = @catID  OR (Cgr_Key = @catID and Cgr_Parent > 0 )
  )
  --and Issuer_Key = 1533
  left join ITSO on ITSO_Prod_Key = Prod_Key
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 21 desc, 3, 13


  if @@ROWCOUNT = 0
  begin
     set @ErrStatus = 100
     RETURN @ErrStatus
  end   
  else 
     set @ErrStatus = @@ERROR
  
  RETURN @ErrStatus
    
END TRY

BEGIN CATCH
    SELECT ERROR_NUMBER(),ERROR_MESSAGE()
    RETURN @ErrStatus
END CATCH

END


