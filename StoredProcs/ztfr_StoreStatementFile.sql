USE [TerminalConfig_V5_MJ]
GO


----------------------------------------------------
--- ztfr_StoreStatementFile
----------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[ztfr_StoreStatementFile]    Script Date: 11/11/2015 14:51:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ztfr_StoreStatementFile]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ztfr_StoreStatementFile]
GO

CREATE  PROCEDURE [dbo].[ztfr_StoreStatementFile]
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