--USE [TerminalConfigs_dev_new]
USE [TerminalConfig_v5_dev]
GO
/****** Object:  StoredProcedure [dbo].[GetMsgPrintFilesForSite]    Script Date: 07/25/2016 16:06:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMsgPrintFilesForSite]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[GetMsgPrintFilesForSite]
GO

CREATE PROCEDURE [dbo].[GetMsgPrintFilesForSite]  (@FileType varchar(5), @siteID int)
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
  WHERE ddf_Site = @siteID
  ORDER BY ddf_Site
END

IF rtrim(@FileType) LIKE 'stm' 
BEGIN
  SELECT  distinct stmf_Site as SiteID, 
                   convert(varchar(10), stmf_Date) as FileDate,
                   stmf_FileString as FileString
  FROM StatementFiles
  WHERE stmf_Site = @siteID
  ORDER BY stmf_Site
END
  
IF rtrim(@FileType) LIKE 'inv' 
BEGIN
  SELECT  distinct invf_Site as SiteID, 
                   convert(varchar(10), invf_Date) as FileDate,
                   invf_FileString as FileString
  FROM InvoiceFiles
  WHERE invf_Site = @siteID
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
