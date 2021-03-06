USE [TerminalConfigs_dev_new]
--USE [TerminalConfig_v5_dev]
GO
/****** Object:  StoredProcedure [dbo].[getGenProductsCategoryForTID]    Script Date: 08/05/2016 08:58:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getGenProductsCategoryForTID]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[getGenProductsCategoryForTID]
GO

CREATE PROCEDURE [dbo].[getGenProductsCategoryForTID] (@catID int, @terminalID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
--DECLARE @catID smallint
DECLARE @appType int
DECLARE @txnType int
  
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
       ,Issuer_NUA_1 as issuerNUA
       ,CASE WHEN TxnType_Code is null THEN 0 ELSE TxnType_Code END as txnType
       ,App_Type as applicationType
       ,CASE WHEN IssuerRange_IssuerFormat is null then null else IssuerRange_IssuerFormat END as IIN 
       ,Issuer_Pan_Length_A as panRangeA
       ,Issuer_Pan_Length_B as panRangeB
       ,TxnType_BarCodeScanner as canBarcodeScan
       ,TxnType_CardSwipe as canMsrScan
       ,TxnType_KeyEntry as canKeyEntry
       ,CASE WHEN Prod_Child_Products = 0 THEN Prod_Key ELSE 0 END as productID
       ,CASE WHEN Prod_Child_Products = 0 THEN rtrim(Prod_Description) ELSE NULL END as productName
       ,Prod_Amount as prodAmount
       ,CASE WHEN Prod_Max_Amount > Prod_Min_Amount THEN Prod_Min_Amount ELSE NULL END as prodMinAmount
       ,CASE WHEN Prod_Max_Amount > Prod_Min_Amount THEN Prod_Max_Amount ELSE NULL END as prodMaxAmount
       ,CASE WHEN (Issuer_FloorLimit > 0 AND Prod_Amount_Type > 0) THEN Issuer_FloorLimit * 100 ELSE NULL END as floorlimitAmount
       ,CASE WHEN (Prod_Amount_Type = 2 OR Prod_Whole_Currency = 1) THEN Prod_Min_Amount ELSE NULL END as incrementsAmount
       ,CASE WHEN TxnType_EnterTxnAmount = 1 THEN NULL  ELSE TxnType_EnterTxnAmount END as amountEntryEnabled
       ,Prod_Fund_Type as fundtype
       ,Prod_Next_Product_Index as nextProductID
       ,Prod_Child_Products as childProductID
       ,CAST(Prod_DefaultProduct AS SMALLINT) as defaultProduct  
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
         ,CAST(NextAvailable AS SMALLINT) as nextAvailableDraw
       ,Issuer_MenuIndex as idx
       ,Issuer_Luhn as luhnCheck
	   ,Prod_UI_Flow as uiFlow  
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
  inner join AppTypeDesc on App_Type = AppType_Type
  and App_Type = @appType 
  and TERMINAL_ID = @terminalID
  and Prod_CategoryID in
  ( SELECT Cgr_Key FROM Categories
    WHERE Cgr_Key = @catID OR (Cgr_Parent = @catID and Cgr_Key > 0 )
  )
  and prod_U32 < 2
  and prod_key NOT IN 
     (select PD_ProdKey from [ProductDisablements] 
      inner join Terminal on Term_TillID = PD_TillID
      where TERMINAL_ID = @terminalID)
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
   left join Draws on Product_key = Prod_Key 
  order by Issuer_MenuIndex, 1, 25 desc, 3, 14


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

