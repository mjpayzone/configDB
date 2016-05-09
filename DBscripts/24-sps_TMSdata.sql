USE [TerminalConfig_V5_MJ]
GO

--
--  TMSdata access stored PROCEDURE
--
IF EXISTS ( SELECT * FROM sys.objects
            WHERE object_id = OBJECT_ID(N'getTMSdata')
            AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getTMSdata]                 
GO

CREATE PROCEDURE [dbo].[getTMSdata] (@terminalID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY
   
  SELECT distinct Site_Name as SiteName,
         Site_ID as SiteID,  
         Site_Addr1 as SiteAddr1, 
         CASE WHEN Site_Addr1a IS NULL THEN Site_Addr2 ELSE Site_Addr1a END as SiteAddr2, 
         CASE WHEN Site_Addr1a IS NULL THEN Site_addr3 ELSE Site_Addr2 END as SiteAddr3, 
         Site_Postcode as Postcode,
         Term_ReceiptHeader1 as ReceiptMessage1,
         Term_ReceiptHeader2 as ReceiptMessage2,
         Term_ReceiptHeader3 as ReceiptMessage3,
         Term_ReceiptHeader4 as ReceiptMessage4,
         TMS_MA_SystemPwd as SystemPassword,
         TMS_MA_WiFi as WiFiEnabled,
         TMS_MA_DloadStart as DownloadStart,
         TMS_MA_DloadEnd as DownloadEnd,
         TMS_MA_DloadInt as DownloadInterval,
         TMS_PA_AdminPwd as AdminPassword,
         Site_EFTmerchant as Host1ID,
         Site_AMEXmerchant as Host2ID,
         TMS_MA_PBXaccess as PBXaccess,
         TMS_PA_IP as IPenabled,
         TMS_PA_DialBackup as DialBackupEnabled,
         TMS_PA_ClerkPrcsing as ClerkProcessingEnabled,
         TMS_AppProfileCode as AppProfileCode,
         TMS_PaymentEnabled as PaymentAppEnabled
  FROM  TMSdata
  inner join [Till] on TMS_TillID = Till_ID
  inner join [Terminal] on Term_TillID = Till_ID
  inner join [MerchantSites] on Site_ID = Till_MerchantNumber
  WHERE 
  TERMINAL_ID = @terminalID  and TMS_TillID = Till_ID 

  if @@ROWCOUNT = 0
  begin
     set @ErrStatus = -100
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



---- requestTMSRebuild
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.requestTMSRebuild'))
   exec('CREATE PROCEDURE [dbo].[requestTMSRebuild] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE dbo.requestTMSRebuild
	@tillID int
AS
BEGIN

	DECLARE @tid int = NULL
	DECLARE @resultCode int

	BEGIN TRY

		-- Get TID for the till, ensuring that an entry for the till also exists in TMSData 
		-- (otherwise the rebuild isnt going to do much, as that is where TMS gets its data from)
		SELECT @tid = Terminal.TERMINAL_ID
		FROM Terminal, Till, TMSData
		WHERE Terminal.Term_TillID = Till.Till_ID
		AND Till.Till_ID = TMSData.TMS_TillID
		AND Till.Till_ID = @tillID
	
		IF @@ROWCOUNT = 1
		BEGIN
			-- if a tid has been found, then insert a record for the tid into TMSRebuilds
			-- Treat 0 as an invalid tid. This is a workaround for an issue with the Zorin Transfer Service
			-- which currently transfers null tids from zorin by inserting them (wrongly) into the Config DB with the
			-- value 0.
			IF @tid IS NOT NULL AND @tid <> 0
			BEGIN
				INSERT INTO TMSRebuilds (TR_TerminalID, TR_Date)
				VALUES (@tid, GETDATE())
					
				SET @resultCode = 0
			END		
			ELSE
				SET @resultCode = -101
		END
		ELSE
			SET @resultCode = -100
    
		RETURN @resultCode
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER(),ERROR_MESSAGE()
		SET @resultCode = -200
		RETURN @resultCode
	END CATCH

END




--- [getNextTMSRebuildRequest]
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.getNextTMSRebuildRequest'))
   exec('CREATE PROCEDURE [dbo].[getNextTMSRebuildRequest] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[getNextTMSRebuildRequest]
	@requestId int OUTPUT,
	@tid int OUTPUT
AS
BEGIN
	
	DECLARE @resultCode int

	SET @resultCode = -1
	SET @requestId = null
	SET @tid = null
	
	BEGIN TRY
	
		-- get lowest (and oldest) request ID
		SELECT @requestId = MIN(TR_ID)
		FROM TMSRebuilds
	
		IF @requestId IS NOT NULL
		BEGIN
		
			-- Get the tid for the record we just found, along with its highest (and newest) request ID. We only need to process the rebuild request once, no
			-- matter how many requests were previously made. After processing, a call will be made to another stored procedure (finishTMSRebuildRequest) to
			-- remove all requests for the tid up to and including this highest request ID.
			SELECT @tid = TR_TerminalID, @requestId = MAX(TR_ID)
			FROM TMSRebuilds
			WHERE TR_TerminalID =
				(SELECT TR_TerminalID
				FROM TMSRebuilds
				WHERE TR_ID = @requestId)
			GROUP BY TR_TerminalID;
		
			-- check just one row
			IF @@ROWCOUNT = 1
				SET @resultCode = 0
			ELSE
				SET @resultCode = -100
		END
		
		RETURN @resultCode
	
	END TRY
	
	BEGIN CATCH
		SELECT ERROR_NUMBER(),ERROR_MESSAGE()
		SET @resultCode = -200
		RETURN @resultCode
	END CATCH
		
END



--- finishTMSRebuildRequest

GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.finishTMSRebuildRequest'))
   exec('CREATE PROCEDURE [dbo].[finishTMSRebuildRequest] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[finishTMSRebuildRequest]
	@requestId int,
	@tid int,
	@deleted int OUTPUT
AS
BEGIN
	
	DECLARE @resultCode int

	SET @resultCode = 0
	SET @deleted = 0
	
	BEGIN TRY
	
		IF @tid IS NULL
			DELETE FROM TMSRebuilds
			WHERE TR_ID = @requestId
		ELSE
			DELETE FROM TMSRebuilds
			WHERE TR_ID <= @requestId
			AND TR_TerminalID = @tid
			
		SET @deleted = @@ROWCOUNT

		RETURN @resultCode
			
	END TRY
	
	BEGIN CATCH
		SELECT ERROR_NUMBER(),ERROR_MESSAGE()
		SET @resultCode = -200
		RETURN @resultCode
	END CATCH
		
END



--==========================================================================
--
-- Filename    : calcRandomTime.sql
-- Description : Procedure to calculate a random 'download interval start time' for the TMSData
-- table (in the format HHmm). A random time will be generated over the midnight boundary as required.
-- 
-- All input values are INCLUSIVE.
--
-- Input:
--     startHour (int) : Start hour of range in which the random time must exist.
--     startMin (int): Start minutes of range in which the random time must exist.
--     endHour (int): End hour of range in which the random time must exist.
--     endMin (int): End minutes of range in which the random time must exist.
-- Return Status:
--     Not Used.
-- Output:
--     randomTime (char(4)): Random time in 'HHmm' format.
--             
--==========================================================================

GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[calcRandomTime]

	@startHour int,
	@startMin int,
	@endHour int,
	@endMin int,
	@randomTime CHAR(4) OUTPUT
AS

BEGIN
	DECLARE @startAsMins INT
	DECLARE @endAsMins INT
	DECLARE @startDate DATETIME
	DECLARE @endDate DATETIME
	DECLARE @diffInMinutes INT
	DECLARE @randomMinutes INT
	DECLARE @timeString CHAR(5)
		
	-- pull in invalid values
	IF (@startHour < 0)
		SET @startHour = 0

	IF (@startHour > 23)
		SET @startHour = 23

	IF (@startMin < 0)
		SET @startMin = 0

	IF (@startMin > 59)
		SET @startMin = 59

	IF (@endHour < 0)
		SET @endHour = 0

	IF (@endHour > 23)
		SET @endHour = 23

	IF (@endMin < 0)
		SET @endMin = 0

	IF (@endMin > 59)
		SET @endMin = 59

	-- get start & end ranges as the amount of minutes since midnight
	SET @startAsMins = (@startHour * 60) + @startMin
	SET @endAsMins = (@endHour * 60) + @endMin

	-- add a day of minutes onto the end date if it is 
	IF (@endAsMins <= @startAsMins)
		SET @endAsMins = @endAsMins + (24 * 60)

	-- use a base date for our calculation - using CONVERT with style '120' ensures format is read as yyyy-MM-dd
	SET @startDate = CONVERT(datetime, '2000-01-01 00:00:00', 120)
	SET @endDate = CONVERT(datetime, '2000-01-01 00:00:00', 120)

	-- add minutes as provided by input parameters
	SET @startDate = DATEADD(mi, @startAsMins, @startDate)	
	SET @endDate = DATEADD(mi, @endAsMins, @endDate)

	-- generate random amount of minutes between the two dates
	SET @diffInMinutes = DATEDIFF(mi, @startDate, @endDate)
	SET @randomMinutes = RAND()*(@diffInMinutes + 1);

	-- add this random amount onto our start window
	SET @startDate = DATEADD(mi, @randomMinutes, @startDate);

	-- gets the time portion in hh:mm:ss format
	SET @timeString = CONVERT(CHAR(5), @startDate, 108)
		
	-- and remove the :
	SET @randomTime = REPLACE(@timeString, ':', '')
END
