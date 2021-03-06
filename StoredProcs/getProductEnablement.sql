USE [TerminalConfig_V5_MJ]
GO

/****** Object:  StoredProcedure [dbo].[getProductEnablement]    Script Date: 10/20/2015 14:45:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects
            WHERE object_id = OBJECT_ID(N'getProductEnablement')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getProductEnablement]                 
GO

CREATE  PROCEDURE [dbo].[getProductEnablement] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY


  SELECT  distinct TERMINAL_ID as terminalID, 
                   --Term_TillID,
                   PGXProds_ProdKey as productID
                   --,rtrim(Prod_Description) as productName
  FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join Till on Till_ID = Term_TillID  
  inner join ProductGroups on ProductGroup_ID = ProdsXTerminal_ProdGKey
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  --inner join Product on Prod_Key = PGXProds_ProdKey
  except
     select TERMINAL_ID, 
     --Term_TillID, 
     PD_ProdKey --,rtrim(Prod_Description) as productName--, PD_TillID 
     from ProductDisablements 
     inner join Product on Prod_Key = PD_ProdKey
     inner join Terminal on Term_TillID = PD_TillID
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


--------------------------------------------------
--- PrintFiles stored procs
--------------------------------------------------

SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetMsgPrintFiles]'
GO
SET ANSI_NULLS OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMsgPrintFiles]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[GetMsgPrintFiles]
GO

CREATE PROCEDURE [dbo].[GetMsgPrintFiles]
                       (
                          @FileType varchar(5)
--                        @RtnCode int OUTPUT
                        )
AS
BEGIN

SET DATEFORMAT dmy 

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @ErrorNumber int


BEGIN TRY
--  SET @RtnCode = 0

IF rtrim(@FileType) LIKE 'print' 
BEGIN
  SELECT  distinct ddf_Site as SiteID, 
                   convert(varchar(10), ddf_Date) as FileDate,
                   ddf_FileString as FileString
  FROM DDlineFiles
  ORDER BY ddf_Site
END

IF rtrim(@FileType) LIKE 'stm' 
BEGIN
  SELECT  distinct stmf_Site as SiteID, 
                   convert(varchar(10), stmf_Date) as FileDate,
                   stmf_FileString as FileString
  FROM StatementFiles
  ORDER BY stmf_Site
END
  
IF rtrim(@FileType) LIKE 'inv' 
BEGIN
  SELECT  distinct invf_Site as SiteID, 
                   convert(varchar(10), invf_Date) as FileDate,
                   invf_FileString as FileString
  FROM InvoiceFiles
  ORDER BY invf_Site
END
 

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
	SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrDesc = ERROR_MESSAGE()
    RAISERROR (@ErrDesc, 11,1)
END CATCH	

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
SET ANSI_NULLS ON
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO


-------------------------------------------
-- GetProductGroupsByMerchant
--------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProductGroupsByMerchant]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[GetProductGroupsByMerchant]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetProductGroupsByMerchant]

	@site_id char(8)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT DISTINCT [ProductGroup_Desc]
FROM
(
SELECT pg.*
	FROM [dbo].[ProductGroups] pg
	JOIN [dbo].[ProdsXTerminal] pxt
		on pg.[ProductGroup_Key] = pxt.[ProdsXTerminal_ProdGKey]
	JOIN [dbo].[Terminal] tml
		on pxt.[ProdsXTerminal_TermTillIDKey] = tml.[Term_TillID]
	JOIN [dbo].[Till] tl		
		on tml.[Term_TillID] = tl.[Till_ID]
	WHERE tl.[Till_MerchantNumber] = @site_id
) p
ORDER BY 1 ASC
END
GO






-------------------------------
--
-------------------------------
