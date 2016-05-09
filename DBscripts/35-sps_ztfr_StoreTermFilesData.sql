USE [Terminal_config_MJ]
GO
/****** Object:  StoredProcedure [dbo].[ztfr_StoreStatementFile]    Script Date: 11/11/2015 14:51:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP PROCEDURE [dbo].[ztfr_StoreStatementFile] 
CREATE PROCEDURE [dbo].[ztfr_StoreStatementFile]
                       (@SiteID int,
                        @FileString varchar(max), 
                        @FileDate datetime,
                        @RtnCode int OUTPUT
                        )
AS
BEGIN

SET DATEFORMAT dmy 

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @ErrorNumber int
DECLARE @TillSignature varchar(50)
DECLARE @Till_cID int
DECLARE @Terminal_cID int
DECLARE @TermTillID int
DECLARE @TermTID int


BEGIN TRY
  SET @RtnCode = 0

  IF NOT EXISTS (SELECT 1 FROM MerchantSites WHERE Site_ID = @SiteID)
  BEGIN              
    SET @ErrDesc = 'Site does not yet exists for Zorin site ' + CAST(@SiteID as CHAR(8));
    RAISERROR (@ErrDesc, 11,1)	
    SET @RtnCode = -1
    RETURN @RtnCode
  END
 
--begin transaction

      IF EXISTS (SELECT 1 FROM StatementFiles 
                 WHERE stmf_Site = @SiteID)
      BEGIN
        DELETE FROM StatementFiles
        WHERE stmf_Site = @SiteID   
        select @RtnCode = @@ERROR
        IF @RtnCode <> 0 
        BEGIN
          --SET @RtnCode = @RtnCode * -1
          SET @ErrDesc = 'Could not delete existing statement file for site ' + CAST(@SiteID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
        END
      END            
      INSERT INTO StatementFiles (stmf_Site, stmf_FileString, stmf_Date)
      VALUES (@SiteID, @FileString, @FileDate)
        select @RtnCode = @@ERROR
        IF @RtnCode <> 0 
        BEGIN
          --SET @RtnCode = @RtnCode * -1
          SET @ErrDesc = 'Could not insert into StatementFiles for site ' + CAST(@SiteID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
        END

   RETURN @RtnCode

END TRY

BEGIN CATCH
	SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrDesc = ERROR_MESSAGE()
    RAISERROR (@ErrDesc, 11,1)
END CATCH	

END



GO

--DROP PROCEDURE [dbo].[ztfr_StoreInvoiceFile] 
CREATE PROCEDURE [dbo].[ztfr_StoreInvoiceFile]
                       (@SiteID integer,
                        @FileDate datetime,
                        @FileString varchar(max), 
                        @RtnCode int OUTPUT
                        )
AS
BEGIN

SET DATEFORMAT dmy 

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @ErrorNumber int
DECLARE @TillSignature varchar(50)
DECLARE @Till_cID int
DECLARE @Terminal_cID int
DECLARE @TermTillID int
DECLARE @TermTID int


BEGIN TRY
  SET @RtnCode = 0

  SELECT @SiteID = Site_ID
  FROM MerchantSites
  WHERE Site_ID = @siteID
  IF @siteID IS NULL 
  BEGIN              
    SET @ErrDesc = 'Site does not yet exists for Zorin Site ' + CAST(@SiteID as CHAR(8));
    RAISERROR (@ErrDesc, 11,1)	
    SET @RtnCode = -1
    RETURN @RtnCode
  END
 
--begin transaction

      IF EXISTS (SELECT 1 FROM InvoiceFiles 
                 WHERE invf_Site = @SiteID)
      BEGIN
        DELETE FROM InvoiceFiles
        WHERE invf_Site = @SiteID   
        select @RtnCode = @@ERROR
        IF @RtnCode <> 0 
        BEGIN
          SET @RtnCode = @RtnCode * -1
          SET @ErrDesc = 'Could not delete existing statment file for TID ' + CAST(@SiteID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
        END
      END            
      INSERT INTO InvoiceFiles (invf_Site, invf_FileString, invf_Date)
      VALUES (@SiteID, @FileString, @FileDate)
        select @RtnCode = @@ERROR
        IF @RtnCode <> 0 
        BEGIN
          SET @RtnCode = @RtnCode * -1
          SET @ErrDesc = 'Could not insert into InvoiceFiles for Site ' + CAST(@SiteID as CHAR(8)) + 'Error Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
        END

   RETURN @RtnCode

END TRY

BEGIN CATCH
	SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrDesc = ERROR_MESSAGE()
    RAISERROR (@ErrDesc, 11,1)
END CATCH	

END


GO

--DROP PROCEDURE [dbo].[ztfr_StorePrintlinesFile] 
CREATE PROCEDURE [dbo].[ztfr_StorePrintlinesFile]
                       (@ZtillID int,
                        @SiteID int, 
                        @TillApac int,
                        @FileDate datetime,
                        @FileString varchar(max), 
                        @RtnCode int OUTPUT
                        )
AS
BEGIN

SET DATEFORMAT dmy 

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @ErrorNumber int
DECLARE @TillSignature varchar(50)
DECLARE @TillID int
DECLARE @Terminal_cID int
DECLARE @TermTillID int
DECLARE @TermTID int


BEGIN TRY
  SET @RtnCode = 0

  IF NOT EXISTS (SELECT 1 FROM MerchantSites WHERE Site_ID = @SiteID)
  BEGIN              
    SET @ErrDesc = 'Site does not yet exists for Zorin Site ' + CAST(@SiteID as CHAR(8));
    RAISERROR (@ErrDesc, 11,1)	
    SET @RtnCode = -1
    RETURN @RtnCode
  END
 
--begin transaction

      IF EXISTS (SELECT 1 FROM DDlineFiles 
                 WHERE ddf_Site = @SiteID)
      BEGIN
        DELETE FROM DDlineFiles
        WHERE ddf_Site = @SiteID   
        select @RtnCode = @@ERROR
        IF @RtnCode <> 0 
        BEGIN
          --SET @RtnCode = @RtnCode * -1
          SET @ErrDesc = 'Could not delete existing dd lines file for site ' + CAST(@SiteID as CHAR(8)) + 'Error Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
        END
      END            
      INSERT INTO DDlineFiles (ddf_Site, ddf_Date, ddf_FileString )
      VALUES (@SiteID, @FileDate, @FileString)
        select @RtnCode = @@ERROR
        IF @RtnCode <> 0 
        BEGIN
          --SET @RtnCode = @RtnCode * -1
          SET @ErrDesc = 'Could not insert into DDlineFiles for Site ' + CAST(@SiteID as CHAR(8)) + 'Error Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
        END

   RETURN @RtnCode

END TRY

BEGIN CATCH
	SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrDesc = ERROR_MESSAGE()
    RAISERROR (@ErrDesc, 11,1)
END CATCH	

END