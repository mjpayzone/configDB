USE [TerminalConfigs_dev_new]
GO
/****** Object:  StoredProcedure [dbo].[getProductForTID]    Script Date: 08/05/2016 08:58:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getProductForID]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[getProductForID]
GO

CREATE  PROCEDURE [dbo].[getProductForID] (@prodID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @appType int
DECLARE @txnType int
  
BEGIN TRY
  
  SELECT  distinct 
       Issuer_Key as issuerID 
       ,rtrim(Issuer_Name) as issuerName
       ,Prod_Key  as productID
       ,Prod_Description as productName
       ,Prod_Fund_Type as fundType
       ,Prod_Amount as prodAmount
       ,CASE WHEN Prod_Max_Amount > Prod_Min_Amount THEN Prod_Min_Amount ELSE NULL END as prodMinAmount
       ,CASE WHEN Prod_Max_Amount > Prod_Min_Amount THEN Prod_Max_Amount ELSE NULL END as prodMaxAmount
       ,CASE WHEN (Prod_Amount_Type = 2 OR Prod_Whole_Currency = 1) THEN Prod_Min_Amount ELSE NULL END as incrementsAmount
       ,CASE WHEN TxnType_Code is null THEN 0 ELSE TxnType_Code END as txnType
       ,Issuer_NUA_1 as issuerNUA
       ,App_Type as applicationType
       ,CASE WHEN TxnType_EnterTxnAmount = 1 THEN NULL  ELSE TxnType_EnterTxnAmount END as amountEntryEnabled
       ,Prod_Next_Product_Index as nextProductID
       ,Prod_Child_Products as childProductID
       ,CAST(Prod_DefaultProduct AS SMALLINT) as defaultProduct  
           , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
           , rtrim(s3.Strings_Text) as ReceiptText1
           , rtrim(s4.Strings_Text) as ReceiptText2
           , rtrim(s5.Strings_Text) as ReceiptText3
           , rtrim(s6.Strings_Text) as ReceiptText4
           , rtrim(s7.Strings_Text) as ReceiptText5
           , rtrim(s8.Strings_Text) as ReceiptText6
       ,AppType_MsgType as messageType 
       ,Issuer_Luhn as luhnCheck
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
  and prod_U32 = 1
  and prod_key = @prodID    
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
  order by 3 


  if @@ROWCOUNT = 0
     set @ErrStatus = 100
  else 
     set @ErrStatus = @@ERROR
  
  RETURN @ErrStatus
    
END TRY

BEGIN CATCH
    SELECT ERROR_NUMBER(),ERROR_MESSAGE()
    RETURN @ErrStatus
END CATCH

END

