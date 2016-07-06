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


