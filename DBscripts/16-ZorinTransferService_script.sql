USE [Terminal_config_MJ]
GO

-------------------------------------------------------------------------------------------------------------------------------------
--   table MerchantSites
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  Table [dbo].[MerchantSites]    Script Date: 05/20/2015 16:33:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MerchantSites](
	[Site_Key] [int] IDENTITY(1,1) NOT NULL,
	[Site_ID] [int] NOT NULL,
	[Site_Name] [char](24) NOT NULL,
	[Site_Addr1] [char](24) NOT NULL,
	[Site_Addr1a] [char](24) NULL,
	[Site_Addr2] [char](24) NOT NULL,
	[Site_Addr3] [char](24) NULL,
	[Site_Postcode] [char](10) NULL,
	[Site_Tel] [char](16) NULL,
	[Site_Status] [char](3) NOT NULL,
	[Site_Contact] [char](24) NULL,
	[Site_CreditLimit] [int] NOT NULL DEFAULT ((30000)),
	[Site_Enabled] [char](1) NULL,
	[Site_EnabledMsg] [char](24) NULL,
	[Site_MonOpen] [char](4) NULL,
	[Site_MonClose] [char](4) NULL,
	[Site_TueOpen] [char](4) NULL,
	[Site_TueClose] [char](4) NULL,
	[Site_WedOpen] [char](4) NULL,
	[Site_WedClose] [char](4) NULL,
	[Site_ThuOpen] [char](4) NULL,
	[Site_ThuClose] [char](4) NULL,
	[Site_FriOpen] [char](4) NULL,
	[Site_FriClose] [char](4) NULL,
	[Site_SatOpen] [char](4) NULL,
	[Site_SatClose] [char](4) NULL,
	[Site_SunOpen] [char](4) NULL,
	[Site_SunClose] [char](4) NULL,
 CONSTRAINT [PK_MerchantSites] PRIMARY KEY CLUSTERED 
(
	[Site_Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key for this table. Identity column increments by 1 for every new record.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MerchantSites', @level2type=N'COLUMN',@level2name=N'Site_Key'

-------------------------------------------------------------------------------------------------------------------------------------
--   add services enabled to Terminal table
-------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE [dbo].[Terminal]
ADD Term_NextReturns bit not null default 0

ALTER TABLE [dbo].[Terminal]
ADD Term_Hermes bit not null default 0


-------------------------------------------------------------------------------------------------------------------------------------
--   insert a dummy entry for the terminal master config for tablets
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
           
-------------------------------------------------------------------------------------------------------------------------------------
--   stored procedure ztfr_UpdateZorinData
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[ztfr_UpdateZorinData]    Script Date: 10/21/2015 15:23:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP PROCEDURE [dbo].[ztfr_UpdateZorinData] 
CREATE PROCEDURE [dbo].[ztfr_UpdateZorinData]
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
               0,0,0,0,0,0,0,0,0,NULL,@NextReturns,@Hermes)
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
                                 Site_Enabled, Site_EnabledMsg)
       VALUES (@TillSite, @Name, @Addr1, @Addr1a, @Addr2, @Addr3, @Postcode, @Tel,
               @SiteStatus, @Contact,@CreditLimit, @SiteEnabled, @EnableMsg)
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
           Term_NextReturns = @NextReturns, Term_Hermes = @Hermes
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
           Site_CreditLimit = @CreditLimit, Site_Enabled = @SiteEnabled, Site_EnabledMsg = @EnableMsg
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


-------------------------------------------------------------------------------------------------------------------------------------
--   stored procedure ztfr_UpdateZorinStoreData
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[ztfr_UpdateZorinStoreData]    Script Date: 10/01/2015 14:15:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

-- DROP PROCEDURE [dbo].[UpdateZorinStoreData]
CREATE PROCEDURE [dbo].[ztfr_UpdateZorinStoreData]
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
	SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrDesc = ERROR_MESSAGE()
    RAISERROR (@ErrDesc, 11,1)
	RETURN -5
END CATCH	

END

