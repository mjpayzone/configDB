USE [TerminalConfig_V5_MJ]
GO

--- finishTMSRebuildRequest
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



