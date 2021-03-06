USE [TerminalConfig_v5_dev]
--USE [TerminalConfigs_dev_new]
GO
/****** Object:  StoredProcedure [dbo].[getProductGroupProducts]    Script Date: 07/22/2016 11:20:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getProductGroupProducts] 
CREATE  PROCEDURE [dbo].[getProductGroupProducts] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY


SELECT ProductGroup_Key as ProductGroupID
      ,PGXProds_ProdKey as ProductID
  FROM [ProductGroups]
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
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