USE [TerminalConfigs_dev_new]
GO
/****** Object:  StoredProcedure [dbo].[ztfr_UpdateZorinData]    Script Date: 11/26/2015 12:33:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP PROCEDURE [dbo].[UpdateZorinData] 

ALTER PROCEDURE [dbo].[ztfr_UpdateZorinData]
                       (@TillID int, 
                        @TillApac int, 
                        @TillOp  char(1),
                        @TillSite int,
                        @Name char(24),
                        @Addr1 char(24),
                        @Addr1a char(24),
                        @Addr2 char(24),
                        @Addr3 char(24),
                        @Postcode char(10),
                        @Contact char(24),
                        @Tel char(16),
                        @SiteStatus char(3),
                        @CreditLimit int,
                        @ReceiptH1 char(24),
                        @ReceiptH2 char(24),
                        @ReceiptH3 char(24),
                        @ReceiptH4 char(24),
                        @Quantum smallint,
                        @Talexus smallint,
                        @PrintFiles smallint,
                        @SiteEnabled char(1),
                        @EnableMsg char(24),
                        @TilSignature char(24),
                        @TilClas char(6),
                        @TilServices smallint,
                        @HOID int,
                        @HOdesc char(35),
                        @Sponsor char(6),
                        @Profile smallint,
                        @RtnCode int OUTPUT
                        )
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @ErrorNumber int
DECLARE @key int
--DECLARE @RtnCode int
DECLARE @swVersion char(10)
DECLARE @Till_cID int
DECLARE @Terminal_cID int
DECLARE @Lcount int
DECLARE @NextReturns bit
DECLARE @Hermes bit
DECLARE @rowcount int



BEGIN TRY

    IF @TilServices = NULL OR @TilServices = 0
    BEGIN
       SET @TilServices = 0
       SET @NextReturns = 0 
       SET @Hermes = 0
    END       
       
    IF @TilServices > 0 
    BEGIN
       SET @NextReturns = @TilServices & 1 
       SET @Hermes = @TilServices & 2
    END
    IF @CreditLimit = null
    BEGIN
       SET @CreditLimit = 30000
    END

    IF @TillOp = 1
      BEGIN
      IF EXISTS(SELECT 1 FROM Till 
                WHERE Till_TerminalNo = @TillID)
	     SET @TillOp = 2 -- till exists, update instead
	  END
	ELSE IF @TillOp = 2
	   BEGIN
         IF NOT EXISTS(SELECT 1 FROM Till 
                       WHERE Till_TerminalNo = @TillID)
            SET @TillOp = 1 -- till doesn't exist, insert instead
	   END     
    IF @TillOp = 3
    BEGIN
      IF NOT EXISTS(SELECT 1 FROM Till 
                    WHERE Till_TerminalNo = @TillID)
      BEGIN              
        SET @ErrDesc = 'Till ID does not exists for delete op for Zorin Till ' + CAST(@TillID as CHAR(8));
	    RAISERROR (@ErrDesc, 11,1)	
	  END
	END   

    IF @TillOp > 1
    BEGIN
        SELECT @Till_cID = Till_ID 
        FROM Till WHERE Till_TerminalNo = @TillID
        IF @Till_cID = 0 OR @Till_cID = NULL
        BEGIN 
           SET @ErrDesc = 'Could not retrieve config Till_ID for Zorin Till ' + CAST(@TillID as CHAR(8)) + ' for till op ' + CAST(@TillOp as CHAR(1));
           RAISERROR (@ErrDesc, 11,1)	
        END
    END   
    
--    SELECT @Terminal_cID = Term_TillID 
--    FROM Terminal WHERE TERMINAL_ID = @TillApac
--    IF @Terminal_cID = 0 OR @Terminal_cID = NULL
--    BEGIN 
--        SET @ErrDesc = 'Could not retrieve config Terminal Apac for Zorin Till ' + CAST(@TillID as CHAR(8));
--	    RAISERROR (@ErrDesc, 11,1)	
--		RETURN -2
--    END
--   IF @Terminal_cID <> @Till_cID
--   BEGIN              
--      SET @ErrDesc = 'Till APAC does not belong to this Till ID on Config for Zorin Till ' 
--                     + CAST(@TillID as CHAR(8))
--                     + ' and till APAC ' + CAST(@TillApac as char(8));
--	    RAISERROR (@ErrDesc, 11,1)	
--	    RETURN -1
--	 END



    IF @TillOp = 1
    BEGIN
begin transaction
       --Till ID does not exists for Zorin Till, so insert
       INSERT INTO Till (Till_TerminalNo, Till_MerchantNumber, Till_MerchantName,
                         Till_StoreID, Till_TerminalSoftware, Till_Status)
       VALUES (@TillID, @TillSite, @Name, @TillSite, 14, @SiteStatus)
       SELECT @RtnCode = @@ERROR, @Till_cID = @@IDENTITY
       IF @RtnCode > 0 OR @Till_cID = 0
       BEGIN
          SELECT @RtnCode = @RtnCode * -1
          SET @ErrDesc = 'Could not insert into Till Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)	
       END   

       INSERT INTO Terminal 
       VALUES (@Till_cID, @PrintFiles, 0, @Quantum, 1, @Talexus, 0,0,0,0,0,0,0,0,0,0,0,0,1,2,
               @ReceiptH1, @ReceiptH2, @ReceiptH3, @ReceiptH4, 0,0,0,73,
               @TillApac,@TilSignature,NULL,NULL,NULL,NULL,@TilClas,0,NULL,NULL,NULL,6,NULL,NULL,
               0,0,0,0,0,0,0,0,0,NULL,@NextReturns,@Hermes,@Profile)
       SELECT @RtnCode = @@ERROR, @Lcount = @@ROWCOUNT
       IF @RtnCode > 0 OR @Lcount = 0
       BEGIN
          SET @RtnCode = @RtnCode * -1
          SET @ErrDesc = 'Could not insert into Terminal Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
       END  
       
       INSERT INTO MerchantSites (Site_ID, Site_Name, Site_Addr1, Site_Addr1a,
                                 Site_Addr2, Site_Addr3, Site_Postcode, Site_Tel,
                                 Site_Status, Site_Contact, Site_CreditLimit,
                                 Site_Enabled, Site_EnabledMsg,
                                 Site_HOID, Site_HOdesc, Site_Sponsor)
       VALUES (@TillSite, @Name, @Addr1, @Addr1a, @Addr2, @Addr3, @Postcode, @Tel,
               @SiteStatus, @Contact,@CreditLimit, @SiteEnabled, @EnableMsg,
               @HOID, @HOdesc, @Sponsor)
       SELECT @RtnCode = @@ERROR, @Lcount = @@ROWCOUNT
       IF @RtnCode > 0 OR @Lcount = 0
       BEGIN
          SET @RtnCode = @RtnCode * -1
          SET @ErrDesc = 'Could not insert into MerchantSites Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
       END  
commit transaction

    END

    
    IF @TillOp = 2
    BEGIN
begin transaction
       -- update
       UPDATE Till
       SET Till_TerminalNo = @TillID, Till_MerchantNumber = @TillSite,
           Till_MerchantName = @Name, Till_StoreID = @TillSite, Till_Status = @SiteStatus
       WHERE Till_TerminalNo = @TillID
       select @RtnCode = @@ERROR, @rowcount = @@ROWCOUNT
       IF @RtnCode <> 0 OR @rowcount = 0
       BEGIN
          select @RtnCode = @RtnCode * -1
rollback transaction
          SET @ErrDesc = 'Could not update Till for Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
       END
       
       UPDATE Terminal
       SET TERMINAL_ID = @TillApac,  --,  STATUS = 0 -- 0 live, 1 disabled 
           SIGNATURE = @TilSignature, TYPE = @TilClas, 
           Term_DownLoadPrintFileEnable = @PrintFiles, Term_QuantumEnable = @Quantum,
           Term_TalexusEnable = @Talexus, 
           Term_ReceiptHeader1 = @ReceiptH1, Term_ReceiptHeader2 = @ReceiptH2,
           Term_ReceiptHeader3 = @ReceiptH3, Term_ReceiptHeader4 = @ReceiptH4,
           Term_NextReturns = @NextReturns, Term_Hermes = @Hermes,
           Term_Profile = @Profile
       WHERE Term_TillID = @Till_cID
       select @RtnCode = @@ERROR, @rowcount = @@ROWCOUNT
       IF @RtnCode <> 0 OR @rowcount = 0
       BEGIN
          set @RtnCode = @RtnCode * -1
rollback transaction
          SET @ErrDesc = 'Could not update Terminal for Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Error Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
       END
       
       UPDATE MerchantSites
       SET Site_Name = @Name, Site_Addr1 = @Addr1, Site_Addr1a = @Addr1a,
           Site_Addr2 = @Addr2, Site_Addr3 = @Addr3, Site_Postcode = @Postcode,
           Site_Tel = @Tel,  Site_Status = @SiteStatus, Site_Contact = @contact,
           Site_CreditLimit = @CreditLimit, Site_Enabled = @SiteEnabled, Site_EnabledMsg = @EnableMsg,
           Site_HOID=@HOID, Site_HOdesc=@HOdesc, Site_Sponsor=@Sponsor
       WHERE Site_ID = @TillSite     
       select @RtnCode = @@ERROR, @rowcount = @@ROWCOUNT
       IF @RtnCode <> 0 OR @rowcount = 0 
       BEGIN
          set @RtnCode = @RtnCode * -1
rollback transaction
          SET @ErrDesc = 'Could not update MerchantSites for Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Error Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
       END

commit transaction       
       return @RtnCode   
    END

    IF @TillOp = 3
    BEGIN
begin transaction       
       DELETE FROM Terminal
       WHERE Term_TillID = @Till_cID
       SELECT @RtnCode = @@ERROR, @Lcount = @@ROWCOUNT 
       set @RtnCode = @RtnCode * -1
       IF @Lcount = 0 OR @RtnCode <> 0
       BEGIN 
         SET @ErrDesc = 'Error ' + CAST(@RtnCode as CHAR(8)) + ' deleting from Terminal for till ' + CAST(@TillID as CHAR(8)) + ', Config Till ' + CAST(@Till_cID AS CHAR(8));
	     RAISERROR (@ErrDesc, 11,1)	
       END
       
       DELETE FROM Till
       WHERE Till_ID  = @Till_cID  
       SELECT @RtnCode = @@ERROR, @Lcount = @@ROWCOUNT 
       IF @Lcount = 0 OR @RtnCode <> 0
       BEGIN 
         SET @ErrDesc = 'Error ' + CAST(@RtnCode as CHAR(8)) + ' deleting from Till for till ' + CAST(@TillID as CHAR(8)) + ', Config Till ' + CAST(@Till_cID AS CHAR(8));
	     RAISERROR (@ErrDesc, 11,1)	
       END
 
        -- delete merchant if no tills
       SELECT @Lcount = count(*)
       FROM Till
       WHERE  Till_MerchantNumber = @TillSite
       IF @Lcount = 0
       BEGIN
          DELETE FROM MerchantSites
          WHERE Site_ID = @TillSite
          SELECT @RtnCode = @@ERROR, @Lcount = @@ROWCOUNT 
          IF @Lcount = 0 OR @RtnCode <> 0
          BEGIN 
            SET @ErrDesc = 'Error ' + CAST(@RtnCode as CHAR(8)) + ' deleting from MerchantSites for site ' + CAST(@TillSite as CHAR(8)) + ', Config Till ' + CAST(@Till_cID AS CHAR(8));
	        RAISERROR (@ErrDesc, 11,1)	
          END
 commit transaction
       RETURN @RtnCode
       END
    END
    
    IF @TillOp > 3
    BEGIN
         SET @ErrDesc = 'Unknown Operation for till ' + CAST(@TillID as CHAR(8)) + ', Config Till ' + CAST(@Till_cID AS CHAR(8));
	     RAISERROR (@ErrDesc, 11,1)	
    END       
    
END TRY

BEGIN CATCH
	SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrDesc = ERROR_MESSAGE()
    RAISERROR (@ErrDesc, 11,1)
END CATCH	

END