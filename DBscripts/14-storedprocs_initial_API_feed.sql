USE [Terminal_config_MJ]
GO

-------------------------------------------------------------------------------------------------------------------------------------
--  getETUs
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getETUs]    Script Date: 10/21/2015 12:29:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getETUs] 
CREATE  PROCEDURE [dbo].[getETUs] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

SET @AppType = 1

BEGIN TRY

  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as panRangeA,
                   Issuer_Pan_Length_B as panRangeB,
                   TxnType_BarCodeScanner as canBarcodeScan,
                   TxnType_CardSwipe as canMsrScan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
           , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
           --, s2.Strings_Text as issuerBrandName  -- Issuer_Brand_Name
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
  and App_Type = 1
  and App_Key not in (157)
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getEVouchers
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getEVouchers]    Script Date: 10/20/2015 14:58:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[getEVouchers] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

SET @AppType = 3

BEGIN TRY

  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   IssuerRange_IssuerFormat as IIN ,
                   App_Type as applicationType,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as productAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
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
  and App_Type = 3
  --and Prod_U32 > 0
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1,15 desc,7

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
--  getBillPay
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getBillPay]    Script Date: 10/20/2015 14:51:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getBillPay] 
CREATE  PROCEDURE [dbo].[getBillPay] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

SET @AppType = 8

BEGIN TRY

  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as panRangeA,
                   Issuer_Pan_Length_B as panRangeB,
                   TxnType_BarCodeScanner as canBarcodeScan,
                   TxnType_CardSwipe as canMsrScan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
                   --,app_key
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
  and App_Type = 8
  and App_Key not in (77,79,82,85,86,91,98,103,116,128,137,144,145,146,147,149,162)
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getTalexus
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getTalexus]    Script Date: 10/20/2015 15:10:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getTalexus] 
CREATE PROCEDURE [dbo].[getTalexus] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

SET @AppType = 1

BEGIN TRY

  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as panRangeA,
                   Issuer_Pan_Length_B as panRangeB,
                   TxnType_BarCodeScanner as canBarcodeScan,
                   TxnType_CardSwipe as canMsrScan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
                   --,app_key
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
  and App_Type = 4
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getQuantum
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getQuantum]    Script Date: 10/20/2015 15:07:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getQuantum] 
CREATE PROCEDURE [dbo].[getQuantum] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

SET @AppType = 1

BEGIN TRY

  SELECT  distinct --app_Key, app_Name, 
                   Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as panRangeA,
                   Issuer_Pan_Length_B as panRangeB,
                   TxnType_BarCodeScanner as canBarcodeScan,
                   TxnType_CardSwipe as canMsrScan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
                   --,app_key
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
  and App_Type = 5
  and App_Key not in (26)
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getTHL
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getTHL]    Script Date: 10/20/2015 15:11:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getTHL] 
CREATE  PROCEDURE [dbo].[getTHL] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

BEGIN TRY

  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as panRangeA,
                   Issuer_Pan_Length_B as panRangeB,
                   TxnType_BarCodeScanner as canBarcodeScan,
                   TxnType_CardSwipe as canMsrScan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
                   --,app_key
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
  and App_Type = 19
  and Issuer_Key not in (1390,1391,1392,1522,1523,1524)
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getBusTickets
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getBusTickets]    Script Date: 10/21/2015 12:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getBusTickets] 
CREATE   PROCEDURE [dbo].[getBusTickets] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

BEGIN TRY


  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as panRangeA,
                   Issuer_Pan_Length_B as panRangeB,
                   TxnType_BarCodeScanner as canBarcodeScan,
                   TxnType_CardSwipe as canMsrScan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
                   --,app_key
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
  and App_Type = 10
  and App_Key not in (140, 190)
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11


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
--  getDartCharge
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getDartCharge]    Script Date: 10/20/2015 14:54:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getDartCharge] 
CREATE PROCEDURE [dbo].[getDartCharge] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int


BEGIN TRY


  SELECT  distinct --app_Key, app_Name, 
                   Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as panRangeA,
                   Issuer_Pan_Length_B as panRangeB,
                   TxnType_BarCodeScanner as canBarcodeScan,
                   TxnType_CardSwipe as canMsrScan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
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
  and App_Type = 18
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getKeyPads
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getKeyPads]    Script Date: 10/20/2015 15:04:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getKeyPads] 
CREATE  PROCEDURE [dbo].[getKeyPads] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

BEGIN TRY


  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as panRangeA,
                   Issuer_Pan_Length_B as panRangeB,
                   TxnType_BarCodeScanner as canBarcodeScan,
                   TxnType_CardSwipe as canMsrScan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
                   --,app_key
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
  and App_Type = 2
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    --left join Strings s2 on s2.Strings_Key = Issuer_Brand_Name
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getNEXTReturns
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getNEXTReturns]    Script Date: 10/20/2015 15:06:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getNEXTReturns] 
CREATE PROCEDURE [dbo].[getNEXTReturns] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

BEGIN TRY

  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as panRangeA,
                   Issuer_Pan_Length_B as panRangeB,
                   TxnType_BarCodeScanner as canBarcodeScan,
                   TxnType_CardSwipe as canMsrScan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
               , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
               , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
               , rtrim(s3.Strings_Text) as ReceiptText1
               , rtrim(s4.Strings_Text) as ReceiptText2
               , rtrim(s5.Strings_Text) as ReceiptText3
               , rtrim(s6.Strings_Text) as ReceiptText4
               , rtrim(s7.Strings_Text) as ReceiptText5
               , rtrim(s8.Strings_Text) as ReceiptText6
                   --,app_key
  FROM 
  [ProductGroups]
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join TxnType on TxnType_AppKey = App_Key
  and App_Type = 12
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getSmartTicket
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getSmartTicket]    Script Date: 10/20/2015 15:09:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getSmartTicket] 
CREATE  PROCEDURE [dbo].[getSmartTicket] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

BEGIN TRY

  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as panRangeA,
                   Issuer_Pan_Length_B as panRangeB,
                   TxnType_BarCodeScanner as canBarcodeScan,
                   TxnType_CardSwipe as canMsrScan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   --Prod_Next_Product_Index as nextProductID,
                   --Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
                   --,app_key
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
  and App_Type = 15
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 17 desc, 11


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
--  getBillPayForTid
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getBillPayForTid]    Script Date: 10/20/2015 14:52:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getBillPayForTid] 
CREATE  PROCEDURE [dbo].[getBillPayForTid] (@terminalID int )
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

SET @AppType = 8

BEGIN TRY


  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as pan_tange_a,
                   Issuer_Pan_Length_B as pan_range_b,
                   TxnType_BarCodeScanner as can_barcode_scan,
                   TxnType_CardSwipe as can_msr_scan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
                   --,app_key
           , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
           , rtrim(s3.Strings_Text) as ReceiptText1
           , rtrim(s4.Strings_Text) as ReceiptText2
           , rtrim(s5.Strings_Text) as ReceiptText3
           , rtrim(s6.Strings_Text) as ReceiptText4
           , rtrim(s7.Strings_Text) as ReceiptText5
           , rtrim(s8.Strings_Text) as ReceiptText6
 FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join Till on Till_ID = Term_TillID  
  inner join ProductGroups on ProductGroup_ID = ProdsXTerminal_ProdGKey
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join TxnType on TxnType_AppKey = App_Key
  and App_Type = 8
  and App_Key not in (77,79,82,85,86,91,98,103,116,128,137,144,145,146,147,149,162)
  and TERMINAL_ID = @terminalID
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getBusTicketsForTid
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getBusTicketsForTid]    Script Date: 10/20/2015 14:53:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getBusTicketsForTid] 
CREATE  PROCEDURE [dbo].[getBusTicketsForTid] (@terminalID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

SET @AppType = 8

BEGIN TRY


  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as pan_tange_a,
                   Issuer_Pan_Length_B as pan_range_b,
                   TxnType_BarCodeScanner as can_barcode_scan,
                   TxnType_CardSwipe as can_msr_scan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
                   --,app_key
           , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
           , rtrim(s3.Strings_Text) as ReceiptText1
           , rtrim(s4.Strings_Text) as ReceiptText2
           , rtrim(s5.Strings_Text) as ReceiptText3
           , rtrim(s6.Strings_Text) as ReceiptText4
           , rtrim(s7.Strings_Text) as ReceiptText5
           , rtrim(s8.Strings_Text) as ReceiptText6
  FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join Till on Till_ID = Term_TillID  
  inner join ProductGroups on ProductGroup_ID = ProdsXTerminal_ProdGKey
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join TxnType on TxnType_AppKey = App_Key
  and App_Type = 10
  and App_Key not in (140, 190)
  and TERMINAL_ID = @terminalID
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getETUsForTid
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getETUsForTid]    Script Date: 10/20/2015 14:57:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getETUsForTid] 
CREATE PROCEDURE [dbo].[getETUsForTid] (@terminalID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int


BEGIN TRY

  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as pan_tange_a,
                   Issuer_Pan_Length_B as pan_range_b,
                   TxnType_BarCodeScanner as can_barcode_scan,
                   TxnType_CardSwipe as can_msr_scan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
           , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
           , rtrim(s3.Strings_Text) as ReceiptText1
           , rtrim(s4.Strings_Text) as ReceiptText2
           , rtrim(s5.Strings_Text) as ReceiptText3
           , rtrim(s6.Strings_Text) as ReceiptText4
           , rtrim(s7.Strings_Text) as ReceiptText5
           , rtrim(s8.Strings_Text) as ReceiptText6
  FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join Till on Till_ID = Term_TillID  
  inner join ProductGroups on ProductGroup_ID = ProdsXTerminal_ProdGKey
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join TxnType on TxnType_AppKey = App_Key
  and App_Type = 1
  and App_Key not in (157)
  and TERMINAL_ID = @terminalID
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getEVouchersForTid
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getEVouchersForTid]    Script Date: 10/20/2015 15:03:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[getEVouchersForTid](@terminalID int) 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

SET @AppType = 3

BEGIN TRY

  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   IssuerRange_IssuerFormat as IIN ,
                   App_Type as applicationType,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as productAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
           , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
           , rtrim(s3.Strings_Text) as ReceiptText1
           , rtrim(s4.Strings_Text) as ReceiptText2
           , rtrim(s5.Strings_Text) as ReceiptText3
           , rtrim(s6.Strings_Text) as ReceiptText4
           , rtrim(s7.Strings_Text) as ReceiptText5
           , rtrim(s8.Strings_Text) as ReceiptText6
  FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join Till on Till_ID = Term_TillID  
  inner join ProductGroups on ProductGroup_ID = ProdsXTerminal_ProdGKey
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join TxnType on TxnType_AppKey = App_Key
  and App_Type = 3
  and TERMINAL_ID = @terminalID
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1,15 desc,7

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
--  getQuantumForTid
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getQuantumForTid]    Script Date: 10/20/2015 15:08:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getQuantumForTid] 
CREATE PROCEDURE [dbo].[getQuantumForTid] (@terminalID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

SET @AppType = 1

BEGIN TRY


  SELECT  distinct --app_Key, app_Name, 
                   Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as appType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as pan_tange_a,
                   Issuer_Pan_Length_B as pan_range_b,
                   TxnType_BarCodeScanner as can_barcode_scan,
                   TxnType_CardSwipe as can_msr_scan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
                   --,app_key
           , rtrim(s1.Strings_Text) as pisplayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as drintText  -- Prod_Label_Print
           , rtrim(s3.Strings_Text) as ReceiptText1
           , rtrim(s4.Strings_Text) as ReceiptText2
           , rtrim(s5.Strings_Text) as ReceiptText3
           , rtrim(s6.Strings_Text) as ReceiptText4
           , rtrim(s7.Strings_Text) as ReceiptText5
           , rtrim(s8.Strings_Text) as ReceiptText6
FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join Till on Till_ID = Term_TillID  
  inner join ProductGroups on ProductGroup_ID = ProdsXTerminal_ProdGKey
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join TxnType on TxnType_AppKey = App_Key
  and App_Type = 5
  and App_Key not in (26)
  and TERMINAL_ID = @terminalID
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getTalexusForTid
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getTalexusForTid]    Script Date: 10/20/2015 15:11:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getTalexusForTid] 
CREATE PROCEDURE [dbo].[getTalexusForTid] (@terminalID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int


BEGIN TRY


  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as appType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as pan_tange_a,
                   Issuer_Pan_Length_B as pan_range_b,
                   TxnType_BarCodeScanner as can_barcode_scan,
                   TxnType_CardSwipe as can_msr_scan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
                   --,app_key
           , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
           , rtrim(s3.Strings_Text) as ReceiptText1
           , rtrim(s4.Strings_Text) as ReceiptText2
           , rtrim(s5.Strings_Text) as ReceiptText3
           , rtrim(s6.Strings_Text) as ReceiptText4
           , rtrim(s7.Strings_Text) as ReceiptText5
           , rtrim(s8.Strings_Text) as ReceiptText6
  FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join Till on Till_ID = Term_TillID  
  inner join ProductGroups on ProductGroup_ID = ProdsXTerminal_ProdGKey
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join TxnType on TxnType_AppKey = App_Key
  and App_Type = 4
  and TERMINAL_ID = @terminalID
  --and App_Key not in ()
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getTHLforTid
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getTHLforTid]    Script Date: 10/20/2015 15:12:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getTHLforTid] 
CREATE  PROCEDURE [dbo].[getTHLforTid] (@terminalID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

BEGIN TRY

  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as appType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as pan_tange_a,
                   Issuer_Pan_Length_B as pan_range_b,
                   TxnType_BarCodeScanner as can_barcode_scan,
                   TxnType_CardSwipe as can_msr_scan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
                   --,app_key
           , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
           , rtrim(s3.Strings_Text) as ReceiptText1
           , rtrim(s4.Strings_Text) as ReceiptText2
           , rtrim(s5.Strings_Text) as ReceiptText3
           , rtrim(s6.Strings_Text) as ReceiptText4
           , rtrim(s7.Strings_Text) as ReceiptText5
           , rtrim(s8.Strings_Text) as ReceiptText6
  FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join Till on Till_ID = Term_TillID  
  inner join ProductGroups on ProductGroup_ID = ProdsXTerminal_ProdGKey
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join TxnType on TxnType_AppKey = App_Key
  and App_Type = 19
  and Issuer_Key not in (1390,1391,1392,1522,1523,1524)
  and TERMINAL_ID = @terminalID
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getKeyPadForTid
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getKeyPadForTid]    Script Date: 10/20/2015 15:05:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getKeyPadForTid] 
CREATE PROCEDURE [dbo].[getKeyPadForTid] (@terminalID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

SET @AppType = 8

BEGIN TRY


  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as pan_tange_a,
                   Issuer_Pan_Length_B as pan_range_b,
                   TxnType_BarCodeScanner as can_barcode_scan,
                   TxnType_CardSwipe as can_msr_scan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
                   --,app_key
           , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
           , rtrim(s3.Strings_Text) as ReceiptText1
           , rtrim(s4.Strings_Text) as ReceiptText2
           , rtrim(s5.Strings_Text) as ReceiptText3
           , rtrim(s6.Strings_Text) as ReceiptText4
           , rtrim(s7.Strings_Text) as ReceiptText5
           , rtrim(s8.Strings_Text) as ReceiptText6
  FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join Till on Till_ID = Term_TillID  
  inner join ProductGroups on ProductGroup_ID = ProdsXTerminal_ProdGKey
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join TxnType on TxnType_AppKey = App_Key
  and App_Type = 2
  and TERMINAL_ID = @terminalID
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getDartChargeForTid
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getDartChargeForTid]    Script Date: 10/20/2015 14:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getDartChargeForTid] 
CREATE PROCEDURE [dbo].[getDartChargeForTid] (@terminalID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int


BEGIN TRY


  SELECT  distinct --app_Key, app_Name, 
                   Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as appType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as pan_tange_a,
                   Issuer_Pan_Length_B as pan_range_b,
                   TxnType_BarCodeScanner as can_barcode_scan,
                   TxnType_CardSwipe as can_msr_scan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
           , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
           , rtrim(s3.Strings_Text) as ReceiptText1
           , rtrim(s4.Strings_Text) as ReceiptText2
           , rtrim(s5.Strings_Text) as ReceiptText3
           , rtrim(s6.Strings_Text) as ReceiptText4
           , rtrim(s7.Strings_Text) as ReceiptText5
           , rtrim(s8.Strings_Text) as ReceiptText6
  FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join Till on Till_ID = Term_TillID  
  inner join ProductGroups on ProductGroup_ID = ProdsXTerminal_ProdGKey
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join TxnType on TxnType_AppKey = App_Key
  and App_Type = 18
  and TERMINAL_ID = @terminalID
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
--  getNEXTReturnsForTid
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getNEXTReturnsForTid]    Script Date: 10/20/2015 15:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getNEXTReturnsForTid] 
CREATE  PROCEDURE [dbo].[getNEXTReturnsForTid] @terminalID int
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @AppType int

BEGIN TRY

  SELECT  distinct Issuer_Key as issuerID,
                   rtrim(Issuer_Name) as IssuerName,
                   Issuer_NUA_1 as issuerNUA,
                   TxnType_Code as txnType,
                   App_Type as applicationType,
                   IssuerRange_IssuerFormat as IIN ,
                   Issuer_Pan_Length_A as panRangeA,
                   Issuer_Pan_Length_B as panRangeB,
                   TxnType_BarCodeScanner as canBarcodeScan,
                   TxnType_CardSwipe as canMsrScan,
                   Prod_Key as productID,
                   rtrim(Prod_Description) as productName,
                   Prod_Amount as prodAmount,
                   Prod_Min_Amount as prodMinAmount,
                   Prod_Max_Amount as prodMaxAmount,
                   Prod_Fund_Type as fundtype,
                   Prod_Next_Product_Index as nextProductID,
                   Prod_Child_Products as childProductID,
                   Prod_DefaultProduct as defaultProduct  
                   --,app_key
               , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
               , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
               , rtrim(s3.Strings_Text) as ReceiptText1
               , rtrim(s4.Strings_Text) as ReceiptText2
               , rtrim(s5.Strings_Text) as ReceiptText3
               , rtrim(s6.Strings_Text) as ReceiptText4
               , rtrim(s7.Strings_Text) as ReceiptText5
               , rtrim(s8.Strings_Text) as ReceiptText6
  FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join Till on Till_ID = Term_TillID  
  inner join ProductGroups on ProductGroup_ID = ProdsXTerminal_ProdGKey
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join TxnType on TxnType_AppKey = App_Key
  and App_Type = 12
  and TERMINAL_ID = @terminalID
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
  order by 1, 19 desc, 11

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
