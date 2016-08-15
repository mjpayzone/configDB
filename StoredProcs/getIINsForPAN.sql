USE [TerminalConfigs_dev_new]
GO
/****** Object:  StoredProcedure [dbo].[getProductForTID]    Script Date: 08/05/2016 08:58:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getIINsForPAN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[getIINsForPAN]
GO

CREATE  PROCEDURE [dbo].[getIINsForPAN] (@terminalID int, @catID int, @panstart varchar(5))
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @appType int
DECLARE @txnType int
DECLARE @matchstr varchar(6)
  
BEGIN TRY

  set @matchstr = RTRIM(@panstart) + '%'
  SELECT distinct Issuer_Key as issuerID
         ,IssuerRange_IssuerFormat as prodIIN
         ,Issuer_Pan_Length_A as panRangeA
         ,Issuer_Pan_Length_B as panRangeB
         ,TxnType_CardSwipe as swipe
         ,TxnType_KeyEntry as keyed
         ,TxnType_BarCodeScanner as barcode
  FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join Till on Till_ID = Term_TillID  
  inner join ProductGroups on ProductGroup_ID = ProdsXTerminal_ProdGKey
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join TxnType on TxnType_AppKey = App_Key
  and Prod_CategoryID = @catID
  and TERMINAL_ID = @terminalID
  and prod_U32 = 1 
  and IssuerRange_IssuerFormat like RTRIM(@matchstr)
  order by 1,2 


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

