--USE [TerminalConfigs_dev_new]
USE [TerminalConfig_v5_dev]
GO
/****** Object:  StoredProcedure [dbo].[getProductGroupProducts]    Script Date: 07/22/2016 14:38:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getProductGroupProductsForTID]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[getProductGroupProductsForTID]
GO

CREATE  PROCEDURE [dbo].[getProductGroupProductsForTID] (@terminalID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

SELECT ProductGroup_Key as ProductGroupID
      ,PGXProds_ProdKey as ProductID
  FROM [ProductGroups]
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join ProdsXTerminal on ProdsXTerminal_ProdGKey = ProductGroup_Key
  inner join Terminal on Term_TillID = ProdsXTerminal_TermTillIDKey 
  where TERMINAL_ID = @terminalID --63324210 --63378135
  order by 1,2


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