USE [TerminalConfig_V5_MJ]
GO 


---------------------------
-- TMS Triggers 
---------------------------

CREATE TRIGGER dbo.tr_terminal_tms
ON dbo.Terminal
AFTER INSERT,UPDATE 
AS
BEGIN
	SET NOCOUNT ON;
	
	-- A change in TID or receipt headers affects TMS configuration - ensure rebuild requested
	-- Note we use a cursor just in case multiple rows are affected by the one insert/update statement (e.g. support script)
	IF (UPDATE (TERMINAL_ID) OR UPDATE(Term_ReceiptHeader1) OR UPDATE(Term_ReceiptHeader2) OR UPDATE(Term_ReceiptHeader3) OR UPDATE(Term_ReceiptHeader4))
	BEGIN
		DECLARE @tillID int
		DECLARE @resultCode int
		DECLARE myCursor CURSOR FOR

		-- Checks for a column value actually changing/being inserted!
		SELECT DISTINCT a.Term_TillID
		FROM
		(
			SELECT Term_TillID, TERMINAL_ID, Term_ReceiptHeader1, Term_ReceiptHeader2, Term_ReceiptHeader3, Term_ReceiptHeader4
			FROM inserted
			EXCEPT
			SELECT Term_TillID, TERMINAL_ID, Term_ReceiptHeader1, Term_ReceiptHeader2, Term_ReceiptHeader3, Term_ReceiptHeader4
		    FROM deleted
		) a;
		
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

CREATE TRIGGER dbo.tr_mercsite_tms
ON dbo.MerchantSites
AFTER INSERT,UPDATE 
AS
BEGIN
	SET NOCOUNT ON;
	
	-- A change in site name/id/address info affects TMS configuration for all tids attached to the site - ensure rebuilds requested
	-- Note we use a cursor just in case multiple rows are affected by the one insert/update statement (e.g. support script)	
	IF (UPDATE (Site_ID) OR UPDATE(Site_Name) OR UPDATE(Site_Addr1) OR UPDATE(Site_Addr1a) OR UPDATE(Site_Addr2) OR UPDATE(Site_Addr3) OR UPDATE(Site_Postcode))
	BEGIN
		DECLARE @tillID int
		DECLARE @resultCode int
		DECLARE myCursor CURSOR FOR

		-- Checks for a column value actually changing/being inserted!
		SELECT DISTINCT Till.Till_ID
		FROM
		(
			SELECT Site_Key, Site_ID, Site_Name, Site_Addr1, Site_Addr1a, Site_Addr2, Site_Addr3, Site_Postcode
			FROM inserted
			EXCEPT
			SELECT Site_Key, Site_ID, Site_Name, Site_Addr1, Site_Addr1a, Site_Addr2, Site_Addr3, Site_Postcode
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

CREATE TRIGGER dbo.tr_till_tms
ON dbo.Till
AFTER INSERT,UPDATE 
AS
BEGIN
	SET NOCOUNT ON;
	
	-- A change in merchant number (site id) affects TMS configuration for the till - ensure rebuilds requested
	-- Note we use a cursor just in case multiple rows are affected by the one insert/update statement (e.g. support script)
	IF (UPDATE (Till_MerchantNumber))
	BEGIN
		DECLARE @tillID int
		DECLARE @resultCode int
		DECLARE myCursor CURSOR FOR

		-- Checks for a column value actually changing/being inserted!
		SELECT DISTINCT a.Till_ID
		FROM
		(
			SELECT Till_ID, Till_MerchantNumber
			FROM inserted
			EXCEPT
			SELECT Till_ID, Till_MerchantNumber
		    FROM deleted
		) a;
		
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

CREATE TRIGGER dbo.tr_tmsdata_tms
ON dbo.TMSdata
AFTER INSERT,UPDATE 
AS
BEGIN
	SET NOCOUNT ON;
	
	-- A change in pretty much every column affects TMS configuration - ensure rebuild requested
	-- Note we use a cursor just in case multiple rows are affected by the one insert/update statement (e.g. support script)
	IF (UPDATE (TMS_MA_SystemPwd) OR UPDATE(TMS_PA_AdminPwd) OR UPDATE(TMS_MA_DloadStart) OR UPDATE(TMS_MA_DloadEnd) OR UPDATE(TMS_MA_DloadInt)
		OR UPDATE(TMS_MA_Wifi) OR UPDATE(TMS_PA_IP) OR UPDATE(TMS_PA_DialBackup) OR UPDATE(TMS_MA_PBXaccess) OR UPDATE(TMS_PA_ClerkPrcsing)
		OR UPDATE(TMS_AppProfileCode) OR UPDATE(TMS_PaymentEnabled))
	BEGIN
		DECLARE @tillID int
		DECLARE @resultCode int
		DECLARE myCursor CURSOR FOR

		-- Checks for a column value actually changing/being inserted!
		SELECT DISTINCT a.TMS_TillID
		FROM
		(
			SELECT TMS_TillID, TMS_MA_SystemPwd, TMS_PA_AdminPwd, TMS_MA_DloadStart, TMS_MA_DloadEnd, TMS_MA_DloadInt,
			       TMS_MA_Wifi, TMS_PA_IP, TMS_PA_DialBackup, TMS_MA_PBXaccess, TMS_PA_ClerkPrcsing, TMS_AppProfileCode, TMS_PaymentEnabled 
			FROM inserted
			EXCEPT
			SELECT TMS_TillID, TMS_MA_SystemPwd, TMS_PA_AdminPwd, TMS_MA_DloadStart, TMS_MA_DloadEnd, TMS_MA_DloadInt,
			       TMS_MA_Wifi, TMS_PA_IP, TMS_PA_DialBackup, TMS_MA_PBXaccess, TMS_PA_ClerkPrcsing, TMS_AppProfileCode, TMS_PaymentEnabled 
		    FROM deleted
		) a;
		
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






