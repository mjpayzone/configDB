USE [TerminalConfig_V5_MJ]
GO
--- [getNextTMSRebuildRequest]

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



