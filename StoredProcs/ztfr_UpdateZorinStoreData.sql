USE [TerminalConfig_V5_MJ]
GO
-----------------------------------------
---ztfr_UpdateZorinStoreData
-----------------------------------------
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


