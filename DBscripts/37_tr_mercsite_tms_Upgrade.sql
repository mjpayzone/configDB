
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering trigger [dbo].[tr_mercsite_tms] on [dbo].[MerchantSites]'
GO


ALTER TRIGGER [dbo].[tr_mercsite_tms]
ON [dbo].[MerchantSites]
AFTER INSERT,UPDATE 
AS
BEGIN
	SET NOCOUNT ON;
	
	-- A change in site name/id/address info affects TMS configuration for all tids attached to the site - ensure rebuilds requested
	-- Note we use a cursor just in case multiple rows are affected by the one insert/update statement (e.g. support script)	
	IF (UPDATE (Site_ID) OR UPDATE(Site_Name) OR UPDATE(Site_Addr1) OR UPDATE(Site_Addr1a) OR UPDATE(Site_Addr2) OR UPDATE(Site_Addr3) OR UPDATE(Site_Postcode)OR UPDATE(Site_EFTmerchant) OR UPDATE(Site_AMEXmerchant))
	BEGIN
		DECLARE @tillID int
		DECLARE @resultCode int
		DECLARE myCursor CURSOR FOR

		-- Checks for a column value actually changing/being inserted!
		SELECT DISTINCT Till.Till_ID
		FROM
		(
			SELECT Site_Key, Site_ID, Site_Name, Site_Addr1, Site_Addr1a, Site_Addr2, Site_Addr3, Site_Postcode, Site_EFTmerchant, Site_AMEXmerchant
			FROM inserted
			EXCEPT
			SELECT Site_Key, Site_ID, Site_Name, Site_Addr1, Site_Addr1a, Site_Addr2, Site_Addr3, Site_Postcode, Site_EFTmerchant, Site_AMEXmerchant
		    FROM deleted
		) a, Till
		where a.Site_ID = Till.Till_MerchantNumber;
		
		OPEN myCursor
		FETCH NEXT FROM myCursor INTO @tillID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC dbo.requestTMSRebuild @tillID
			FETCH NEXT FROM myCursor INTO @tillID
		END
		CLOSE myCursor
		DEALLOCATE myCursor
	END
END


GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO