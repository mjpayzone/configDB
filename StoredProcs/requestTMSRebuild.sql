USE [TerminalConfig_V5_MJ]
GO

---- requestTMSRebuild

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


