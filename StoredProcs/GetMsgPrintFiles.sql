USE [TerminalConfig_V5_MJ]
GO


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


