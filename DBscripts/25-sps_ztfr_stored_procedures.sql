USE [TerminalConfig_V5_MJ]
GO

DECLARE @tabletmasterconf INTEGER
DECLARE @tabletMenu INTEGER

begin transaction

-------------------------------------------------------------------------------------------------------------------------------------
--   insert a dummy entry for the terminal master config for tablets
--  this is required as any insert into the Terminals table need a master app config ID,
--  which is not relevant for the tablet terminals
-------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [Master_Config]
           ([MA_GEMSTelephoneNumber]
           ,[MA_GeneralHelpDeskPhoneNumber2]
           ,[MA_ErrorCorrection]
           ,[MA_Compression]
           ,[MA_V42Handshake]
           ,[MA_V25AnswerTone]
           ,[MA_IDLEText]
           ,[MA_NumberOfRings]
           ,[MA_SecurityManagementSystem]
           ,[MA_Description])
     VALUES
           (NULL
           ,NULL
           ,0
           ,0
           ,0
           ,0
           ,NULL
           ,0
           ,0
           ,'Tablet')

 SET @tabletmasterconf = SCOPE_IDENTITY()

 select @tabletmasterconf
 
 commit transaction

----------------------------------------
--ztfr_UpdateZorinData
----------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[ztfr_UpdateZorinData]    Script Date: 04/12/2016 14:57:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ztfr_UpdateZorinData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ztfr_UpdateZorinData]
GO

CREATE  PROCEDURE [dbo].[ztfr_UpdateZorinData]
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
                        @TilClas char(6),
                        @Profile smallint,
                        @TilSerial char(15),
                        @TilPart char(15),
                        @T103Serial varchar(15),
                        @T103Part varchar(15),
                        @TilServices smallint,
                        @HOID int,
                        @HOdesc char(35),
                        @Sponsor char(6),
                        @TilEFT char(1),
                        @EFTMerc char(16),
                        @AmexMerc char(16),
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
DECLARE @tmsStartTime char(4)
DECLARE @insertTill bit
DECLARE @insertTerminal bit

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

    -- since we can't guarentee that records exists or not due to GUI inserts
    SET @insertTill = 0
    SET @insertTerminal = 0
    IF @TillOp < 3
    BEGIN
      IF NOT EXISTS(SELECT 1 FROM Till 
                    WHERE Till_TerminalNo = @TillID)
         SET @insertTill = 1 -- till exists, update 
      IF NOT EXISTS(SELECT 1 FROM Terminal, Till
                    WHERE Term_TillID = Till_ID
                    AND Till_TerminalNo = @TillID)
         SET @insertTerminal = 1 -- terminal exists, update
    END  
	     
    IF @TillOp = 3
    BEGIN
      IF NOT EXISTS(SELECT 1 FROM Till 
                    WHERE Till_TerminalNo = @TillID)
      BEGIN              
        SET @ErrDesc = '100: Till ID does not exists for delete op for Zorin Till ' + CAST(@TillID as CHAR(8));
	    RAISERROR (@ErrDesc, 11,11)	
	    RETURN 
	  END
	END   

    IF @insertTill = 0 
    BEGIN
        SELECT @Till_cID = Till_ID 
        FROM Till WHERE Till_TerminalNo = @TillID
        IF @Till_cID = 0 OR @Till_cID = NULL
        BEGIN 
           SET @ErrDesc = 'Could not retrieve config Till_ID for Zorin Till ' + CAST(@TillID as CHAR(8)) + ' for till op ' + CAST(@TillOp as CHAR(1));
           RAISERROR (@ErrDesc, 11,1)	
           RETURN
        END
        
        IF NOT EXISTS (SELECT 1 FROM Terminal
                       WHERE Term_TillID = @Till_cID)
           SET @insertTerminal = 1            
    END   


    IF @TillOp < 3
    BEGIN
begin transaction
       IF @insertTill = 1
       BEGIN
         --Till ID does not exists for Zorin Till, so insert
         INSERT INTO Till (Till_TerminalNo, Till_MerchantNumber, Till_MerchantName,
                           Till_StoreID, Till_TerminalSoftware, Till_Status, Till_EFT)
         VALUES (@TillID, @TillSite, @Name, @TillSite, 14, @SiteStatus, @TilEFT)
         SELECT @RtnCode = @@ERROR, @Till_cID = @@IDENTITY
         IF @RtnCode > 0 OR @Till_cID = 0
         BEGIN
           SELECT @RtnCode = @RtnCode * -1
           SET @ErrDesc = 'Could not insert into Till Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
           rollback transaction       
           RAISERROR (@ErrDesc, 11,1)	
           RETURN
         END
       END 
       ELSE  -- insertTill = 0 and till_op insert/update
       BEGIN 
         UPDATE Till
         SET Till_TerminalNo = @TillID, Till_MerchantNumber = @TillSite,
             Till_MerchantName = @Name, Till_StoreID = @TillSite, Till_Status = @SiteStatus,
             Till_EFT = @TilEFT
         WHERE Till_TerminalNo = @TillID
         select @RtnCode = @@ERROR, @rowcount = @@ROWCOUNT
         IF @RtnCode <> 0 OR @rowcount = 0
         BEGIN
            select @RtnCode = @RtnCode * -1
            SET @ErrDesc = 'Could not update Till for Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
            rollback transaction
            RAISERROR (@ErrDesc, 11,1)
            RETURN
         END
       END   
        
       IF @TillApac = 0 
          SET @TillApac = null
           
       IF @insertTerminal = 1
       BEGIN 
           INSERT INTO [Terminal]
               ( Term_TillID,Term_DownLoadPrintFileEnable,Term_SmartPowerEnable,Term_QuantumEnable,
                 Term_QuantumDebtEnable,Term_TalexusEnable,Term_HotCardsEnabled,Term_TalexusRegionID,
                 Term_SPKeySet,Term_NumTalexusTariffs,Term_NumTalexusSAs,Term_NumQuantumRegions,
                 Term_NumQuantumCommands,Term_NumSPTariffs,Term_NumSPCommands,Term_NumHotCards,
                 Term_NumSPRECIDs,Term_CurrencySymbol,Term_CurrencyCode,Term_CurrencyPlaces,
                 Term_ReceiptHeader1,Term_ReceiptHeader2,Term_ReceiptHeader3,Term_ReceiptHeader4,
                 Term_StockDayOfWeek,Term_StockDaysToAudit,Term_PaperType,Term_MenuKey,
                 TERMINAL_ID,Term_Clas,STATUS,
                 Term_MasterConfig,Term_Hour,Term_RefreshTalexus,Term_RefreshQuantum,Term_RefreshSmartpower,
                 Term_RefreshHotList,Term_RefreshPrintFile,Term_TxnUpload,Term_MASoftware,Term_EFTSoftware,
                 Term_StockGroup,Term_EFTConfig,Term_NextReturns,Term_Hermes,Term_Profile,
                 Term_SerialNr,Term_PartNr,Term_AddSerialNr,Term_AddPartNr)
           VALUES (@Till_cID, @PrintFiles, 0, @Quantum, 1, @Talexus, 0,0,0,0,0,0,0,0,0,0,0,0,1,2,
                   @ReceiptH1, @ReceiptH2, @ReceiptH3, @ReceiptH4, 0,0,0,35,
                   @TillApac,@TilClas,0,6, NULL,
                   0,0,0,0,0,0,0,0,0,NULL,@NextReturns,@Hermes,@Profile,
                   @TilSerial, @TilPart, @T103Serial, @T103Part
                   )
           SELECT @RtnCode = @@ERROR, @Lcount = @@ROWCOUNT
           IF @RtnCode > 0 OR @Lcount = 0
           BEGIN
              SET @RtnCode = @RtnCode * -1
              SET @ErrDesc = 'Could not insert into Terminal Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
              rollback transaction       
              RAISERROR (@ErrDesc, 11,1)
              RETURN
           END  
       END
       ELSE
       BEGIN
         UPDATE Terminal
         SET TERMINAL_ID = @TillApac,  --,  STATUS = 0 -- 0 live, 1 disabled 
             Term_Clas = @TilClas, 
             Term_DownLoadPrintFileEnable = @PrintFiles, Term_QuantumEnable = @Quantum,
             Term_TalexusEnable = @Talexus, 
             Term_ReceiptHeader1 = @ReceiptH1, Term_ReceiptHeader2 = @ReceiptH2,
             Term_ReceiptHeader3 = @ReceiptH3, Term_ReceiptHeader4 = @ReceiptH4,
             Term_NextReturns = @NextReturns, Term_Hermes = @Hermes,
             Term_Profile = @Profile, 
             Term_SerialNr = @TilSerial, Term_PartNr = @TilPart, 
             Term_AddSerialNr = @T103Serial, Term_AddPartNr = @T103Part
         WHERE Term_TillID = @Till_cID
         select @RtnCode = @@ERROR, @rowcount = @@ROWCOUNT
         IF @RtnCode <> 0 OR @rowcount = 0
         BEGIN
            set @RtnCode = @RtnCode * -1
            SET @ErrDesc = 'Could not update Terminal for Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Error Code: ' + CAST(@RtnCode as varchar(12));
            rollback transaction
            RAISERROR (@ErrDesc, 11,1)
            RETURN
         END	   	   
       END
       
       IF NOT EXISTS (SELECT 1 FROM MerchantSites
                      WHERE Site_ID = @TillSite)
       BEGIN               
          INSERT INTO MerchantSites (Site_ID, Site_Name, Site_Addr1, Site_Addr1a,
                                    Site_Addr2, Site_Addr3, Site_Postcode, Site_Tel,
                                    Site_Status, Site_Contact, Site_CreditLimit,
                                    Site_Enabled, Site_EnabledMsg,
                                    Site_HOID, Site_HOdesc, Site_Sponsor,
                                    Site_EFTmerchant, Site_AMEXmerchant)
          VALUES (@TillSite, @Name, @Addr1, @Addr1a, @Addr2, @Addr3, @Postcode, @Tel,
                  @SiteStatus, @Contact,@CreditLimit, @SiteEnabled, @EnableMsg,
                  @HOID, @HOdesc, @Sponsor, @EFTmerc, @AMEXmerc)
          SELECT @RtnCode = @@ERROR, @Lcount = @@ROWCOUNT
          IF @RtnCode > 0 OR @Lcount = 0
          BEGIN
             SET @RtnCode = @RtnCode * -1
             SET @ErrDesc = 'Could not insert into MerchantSites Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
             rollback transaction
             RAISERROR (@ErrDesc, 11,1)
             RETURN
          END  
       END
       ELSE 
       BEGIN
          UPDATE MerchantSites
          SET Site_Name = @Name, Site_Addr1 = @Addr1, Site_Addr1a = @Addr1a,
              Site_Addr2 = @Addr2, Site_Addr3 = @Addr3, Site_Postcode = @Postcode,
              Site_Tel = @Tel,  Site_Status = @SiteStatus, Site_Contact = @contact,
              Site_CreditLimit = @CreditLimit, Site_Enabled = @SiteEnabled, Site_EnabledMsg = @EnableMsg,
              Site_HOID=@HOID, Site_HOdesc=@HOdesc, Site_Sponsor=@Sponsor,
              Site_EFTmerchant = @EFTmerc, Site_AMEXmerchant = @AMEXmerc
          WHERE Site_ID = @TillSite     
          select @RtnCode = @@ERROR, @rowcount = @@ROWCOUNT
          IF @RtnCode <> 0 OR @rowcount = 0 
          BEGIN
             set @RtnCode = @RtnCode * -1
             SET @ErrDesc = 'Could not update MerchantSites for Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Error Code: ' + CAST(@RtnCode as varchar(12));
             rollback transaction
             RAISERROR (@ErrDesc, 11,1)
             RETURN
          END	   	  
       END
	   
       -- Create TMS Data RECORD
       IF NOT EXISTS (SELECT 1 FROM TMSdata
                      WHERE TMS_TillID = @Till_cID)
       BEGIN
           EXEC [dbo].[calcRandomTime] 22, 0, 5,30, @tmsStartTime OUTPUT
           INSERT INTO TMSdata (TMS_TillID, TMS_MA_SystemPwd, TMS_PA_AdminPwd, TMS_MA_DloadStart, TMS_MA_DloadEnd, TMS_MA_DloadInt,
                                TMS_MA_WiFi, TMS_PA_IP, TMS_PA_DialBackup, TMS_MA_PBXaccess, TMS_PA_ClerkPrcsing,
                                TMS_AppProfileCode, TMS_PaymentEnabled)
           VALUES
              (@Till_cID, '13579', '12345678', @tmsStartTime, '0600', 1440, 1, 1, 1, '', 0, 'S-PZ-CONV', 0)
           
           SELECT @RtnCode = @@ERROR, @Lcount = @@ROWCOUNT
           IF @RtnCode > 0 OR @Lcount = 0
           BEGIN
              SET @RtnCode = @RtnCode * -1
              SET @ErrDesc = 'Could not insert into TMSdata for Till ' + CAST(@TillID as CHAR(8)) + 'Error Code: ' + CAST(@RtnCode as varchar(12));
              rollback transaction
              RAISERROR (@ErrDesc, 11,1)
              RETURN
           END 
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
         rollback transaction       
	     RETURN
       END
	   
       DELETE FROM TMSdata
       WHERE TMS_TillID = @Till_cID
       SELECT @RtnCode = @@ERROR, @Lcount = @@ROWCOUNT 
       set @RtnCode = @RtnCode * -1
       IF @Lcount = 0 OR @RtnCode <> 0
       BEGIN 
          SET @ErrDesc = 'Error ' + CAST(@RtnCode as CHAR(8)) + ' deleting from TMSdata for till ' + CAST(@TillID as CHAR(8)) + ', Config Till ' + CAST(@Till_cID AS CHAR(8));
          RAISERROR (@ErrDesc, 11,1)	
          rollback transaction       
          RETURN
       END	   
	          
       DELETE FROM Till
       WHERE Till_ID  = @Till_cID  
       SELECT @RtnCode = @@ERROR, @Lcount = @@ROWCOUNT 
       IF @Lcount = 0 OR @RtnCode <> 0
       BEGIN 
         SET @ErrDesc = 'Error ' + CAST(@RtnCode as CHAR(8)) + ' deleting from Till for till ' + CAST(@TillID as CHAR(8)) + ', Config Till ' + CAST(@Till_cID AS CHAR(8));
	     RAISERROR (@ErrDesc, 11,1)	
         rollback transaction       
	     RETURN
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
          IF @RtnCode <> 0
          BEGIN 
            SET @ErrDesc = 'Error ' + CAST(@RtnCode as CHAR(8)) + ' deleting from MerchantSites for site ' + CAST(@TillSite as CHAR(8)) + ', Config Till ' + CAST(@Till_cID AS CHAR(8));
            rollback transaction       
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
         rollback transaction       
    END       
    
END TRY

BEGIN CATCH
	SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrDesc = ERROR_MESSAGE()
    RAISERROR (@ErrDesc, 11,10)
END CATCH	

END




-----------------------------------------
---ztfr_UpdateZorinStoreData
-----------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[ztfr_UpdateZorinStoreData]    Script Date: 04/21/2016 14:55:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ztfr_UpdateZorinStoreData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ztfr_UpdateZorinStoreData]
GO

CREATE  PROCEDURE [dbo].[ztfr_UpdateZorinStoreData]
                      (@TillSite int,
                       @MonOpen char(4),
                       @MonClose char(4),
                       @TueOpen char(4),
                       @TueClose char(4),
                       @WedOpen char(4),
                       @WedClose char(4),
                       @ThuOpen char(4),
                       @ThuClose char(4),
                       @FriOpen char(4),
                       @FriClose char(4),
                       @SatOpen char(4),
                       @SatClose char(4),
                       @SunOpen char(4),
                       @SunClose char(4),
                       @RtnCode int OUTPUT
                       )
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @ErrorNumber int
DECLARE @key int
DECLARE @Lcount int


BEGIN TRY


      IF NOT EXISTS(SELECT 1 FROM MerchantSites 
                    WHERE Site_ID = @TillSite)
      BEGIN      
         SET @RtnCode = -100
         SET @ErrDesc = 'MerchantSite does not exist for site ID ' + CAST(@TillSite as CHAR(8));
	     RAISERROR (@ErrDesc, 11,1)
	  END  
	  ELSE 
	  BEGIN
      begin transaction
        UPDATE MerchantSites
        SET [Site_MonOpen] = @MonOpen
            ,[Site_MonClose] = @MonClose
            ,[Site_TueOpen] = @TueOpen
            ,[Site_TueClose] = @TueClose
            ,[Site_WedOpen] = @WedOpen
            ,[Site_WedClose] = @WedClose
            ,[Site_ThuOpen] = @ThuOpen
            ,[Site_ThuClose] = @ThuClose
            ,[Site_FriOpen] = @FriOpen
            ,[Site_FriClose] = @FriClose
            ,[Site_SatOpen] = @SatOpen
            ,[Site_SatClose] = @SatClose
            ,[Site_SunOpen] = @SunOpen
            ,[Site_SunClose] = @SunClose
        WHERE Site_ID = @TillSite     
        select @RtnCode = @@ERROR, @Lcount = @@ROWCOUNT
        IF @RtnCode <> 0 OR @Lcount = 0
        BEGIN
          rollback transaction
          select @RtnCode = @RtnCode * -1
          return @RtnCode
        END

        commit transaction
       
        return @RtnCode   
      END
        
    
END TRY

BEGIN CATCH
--rollback transaction
	SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrDesc = ERROR_MESSAGE()
    RAISERROR (@ErrDesc, 11,1)
	RETURN -5
END CATCH	

END



--------------------------------------------------
-- ztfr_TillProductEnablements
--------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[ztfr_TillProductEnablements]    Script Date: 12/07/2015 16:21:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ztfr_TillProductEnablements]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ztfr_TillProductEnablements]
GO

CREATE  PROCEDURE [dbo].[ztfr_TillProductEnablements]
                       (@TillID int, 
                        @RtnCode int OUTPUT
                        )
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @ErrorNumber int
DECLARE @key int
--DECLARE @RtnCode int
DECLARE @Till_cID int
DECLARE @Terminal_cID int
DECLARE @Lcount int
DECLARE @rowcount int
DECLARE @TermNextParcels smallint
DECLARE @TermTillID int
DECLARE @TermPostcode char(10)
DECLARE @TermSite int
DECLARE @prodGroupID int
DECLARE @TermProfile smallint
DECLARE @tmpProfile smallint
DECLARE @rule varchar(200)
declare @dsql nvarchar(500)
declare @plist nvarchar(200) 


BEGIN TRY
  SET @RtnCode = 0

  IF NOT EXISTS(SELECT 1 FROM Till 
                WHERE Till_TerminalNo = @TillID)
  BEGIN              
    SET @ErrDesc = 'Till ID does not exists for till enablements op for Zorin Till ' + CAST(@TillID as CHAR(8));
    RAISERROR (@ErrDesc, 11,1)	
    SET @RtnCode = -1
    RETURN @RtnCode
  END
 
  SELECT @TermTillID = Term_TillID, @TermNextParcels = Term_NextReturns 
        ,@TermSite = Site_ID, @TermPostcode = REPLACE(LTRIM(RTRIM(Site_Postcode)),' ','')
        ,@TermProfile = Term_Profile
  FROM Terminal, Till, MerchantSites
  WHERE Till_TerminalNo = @TillID
  AND Term_TillID = Till_ID
  AND Site_ID = Till_MerchantNumber
 
  IF @TermTillID = 0 OR @TermTillID = NULL
  BEGIN 
    SET @ErrDesc = 'Could not retrieve config Terminal Till ID for Zorin Till ' + CAST(@TillID as CHAR(8));
    RAISERROR (@ErrDesc, 11,1)
    SET @RtnCode = -2	
    RETURN @RtnCode
  END
  
   SELECT ProductGroup_ID
   INTO #tmpGenProdsTab
   FROM ProductGroups
   WHERE ProductGroup_IsGeneric = 1

   DECLARE GenProdGroupsC CURSOR LOCAL FORWARD_ONLY FOR 
   SELECT ProductGroup_ID FROM #tmpGenProdsTab 
   
begin transaction

   OPEN GenProdGroupsC
   FETCH NEXT FROM GenProdGroupsC into @prodGroupID 
   WHILE @@FETCH_STATUS = 0
   BEGIN  
      -- insert all generic groups for this till into table 
      IF NOT EXISTS (SELECT 1 FROM ProdsXTerminal 
                     WHERE ProdsXTerminal_ProdGKey = @prodGroupID
                     AND ProdsXTerminal_TermTillIDKey = @TermTillID)
      BEGIN               
      INSERT INTO ProdsXTerminal (ProdsXTerminal_ProdGKey, ProdsXTerminal_TermTillIDKey)
      VALUES (@prodGroupID, @TermTillID)
        select @RtnCode = @@ERROR
        IF @RtnCode <> 0 
        BEGIN
          --SET @RtnCode = @RtnCode * -1
          SET @ErrDesc = 'Could not insert into ProdsXTerminal for Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
        END
      END  

      FETCH NEXT FROM GenProdGroupsC into @prodGroupID 
   END
   CLOSE GenProdGroupsC
   DEALLOCATE GenProdGroupsC

  CREATE TABLE #tmpProdsEnabldTab 
  (
     ProdGrpID int
  ) 
 
   INSERT INTO #tmpProdsEnabldTab
   SELECT ER_ProductGroupID 
   FROM EnablementRules
   WHERE LTRIM(RTRIM(ER_PostCode)) LIKE SUBSTRING( LTRIM(RTRIM(@TermPostcode)),1,5)   
  
   INSERT INTO #tmpProdsEnabldTab
   SELECT ER_ProductGroupID 
   FROM EnablementRules
   WHERE LTRIM(RTRIM(ER_PostCode)) LIKE SUBSTRING( LTRIM(RTRIM(@TermPostcode)),1,4)   

   INSERT INTO #tmpProdsEnabldTab
   SELECT ER_ProductGroupID 
   FROM EnablementRules
   WHERE LTRIM(RTRIM(ER_PostCode)) LIKE SUBSTRING( LTRIM(RTRIM(@TermPostcode)),1,3)   

   INSERT INTO #tmpProdsEnabldTab
   SELECT ER_ProductGroupID 
   FROM EnablementRules
   WHERE LTRIM(RTRIM(ER_PostCode)) LIKE SUBSTRING( LTRIM(RTRIM(@TermPostcode)),1,2)   

   DECLARE SpecProdGroupsC CURSOR LOCAL FORWARD_ONLY FOR 
   SELECT DISTINCT(ProdGrpID) FROM #tmpProdsEnabldTab 

   OPEN SpecProdGroupsC
   FETCH NEXT FROM SpecProdGroupsC into @prodGroupID 
   WHILE @@FETCH_STATUS = 0
   BEGIN  
      IF NOT EXISTS (SELECT 1 FROM ProdsXTerminal 
                     WHERE ProdsXTerminal_ProdGKey = @prodGroupID
                     AND ProdsXTerminal_TermTillIDKey = @TermTillID)
      BEGIN               
      INSERT INTO ProdsXTerminal (ProdsXTerminal_ProdGKey, ProdsXTerminal_TermTillIDKey)
      VALUES (@prodGroupID, @TermTillID)
        select @RtnCode = @@ERROR
        IF @RtnCode <> 0
        BEGIN
          --SET @RtnCode = @RtnCode * -1
          SET @ErrDesc = 'Could not insert into ProdsXTerminal for EnablementRules Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
        END
      END

      FETCH NEXT FROM SpecProdGroupsC into @prodGroupID 
   END
   CLOSE SpecProdGroupsC
   DEALLOCATE SpecProdGroupsC
   
  -- Profile Rules groups 
  CREATE TABLE #tmpProfilesTab 
  (
     ProdGrpID int
     ,Prule varchar(250)
  ) 
 
   INSERT INTO #tmpProfilesTab
   SELECT ER_ProductGroupID, ER_ProfileRule 
   FROM EnablementRules
   WHERE LEN(LTRIM(RTRIM(ER_ProfileRule))) > 0 and ER_ProfileRule is not null   
   
   DECLARE ProfileRC CURSOR LOCAL FORWARD_ONLY FOR 
   SELECT ProdGrpID, Prule FROM #tmpProfilesTab ORDER BY ProdGrpID

   OPEN ProfileRC
   FETCH NEXT FROM ProfileRC into @prodGroupID, @rule
   WHILE @@FETCH_STATUS = 0
   BEGIN  
       
      SET @plist = '@tmpProfile smallint output'                              
      --select @prodGroupID as pPGID, @rule as prule 
      SET @dsql = 'SELECT @tmpProfile = Term_Profile FROM Terminal WHERE Term_TillID = ' + CAST(@TermTillID as CHAR(8)) 
                    + ' AND Term_Profile ' + @rule
      --select @dsql 
      SET  @tmpProfile = null            
      EXECUTE sp_executesql @dsql , @plist, @tmpProfile = @tmpProfile  output
      IF @tmpProfile is not null 
      BEGIN
        IF NOT EXISTS (SELECT 1 FROM ProdsXTerminal 
                       WHERE ProdsXTerminal_ProdGKey = @prodGroupID
                       AND ProdsXTerminal_TermTillIDKey = @TermTillID)
        BEGIN               
           --select @tmpProfile, @prodGroupID as pPGID
           INSERT INTO ProdsXTerminal (ProdsXTerminal_ProdGKey, ProdsXTerminal_TermTillIDKey)
           VALUES (@prodGroupID, @TermTillID)
           select @RtnCode = @@ERROR
           IF @RtnCode <> 0
           BEGIN
             --SET @RtnCode = @RtnCode * -1
             SET @ErrDesc = 'Could not insert into profile group ProdsXTerminal for EnablementRules Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Error Code: ' + CAST(@RtnCode as varchar(12));
             RAISERROR (@ErrDesc, 11,1)
           END
        END
      END

      FETCH NEXT FROM ProfileRC into @prodGroupID, @rule 
   END
   CLOSE ProfileRC
   DEALLOCATE ProfileRC
   
   commit transaction
   
   DROP TABLE #tmpProdsEnabldTab
   DROP TABLE #tmpGenProdsTab
   DROP TABLE #tmpProfilesTab
   
   RETURN @RtnCode

END TRY

BEGIN CATCH
	SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrDesc = ERROR_MESSAGE()
    RAISERROR (@ErrDesc, 11,1)
END CATCH	

END














---------------------------------------------------------------
---Statement, Invoice and DD files stored procs
---------------------------------------------------------------

---------------------------------
--- ztfr_StorePrintlinesFile
---------------------------------
GO
/****** Object:  StoredProcedure [dbo].[ztfr_StorePrintlinesFile]    Script Date: 11/11/2015 14:52:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ztfr_StorePrintlinesFile]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ztfr_StorePrintlinesFile]
GO

CREATE  PROCEDURE [dbo].[ztfr_StorePrintlinesFile]
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



-----------------------------------------
--ztfr_StoreInvoiceFile
------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[ztfr_StoreInvoiceFile]    Script Date: 11/11/2015 14:50:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ztfr_StoreInvoiceFile]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ztfr_StoreInvoiceFile]
GO

CREATE  PROCEDURE [dbo].[ztfr_StoreInvoiceFile]
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