USE [TerminalConfig_V5_MJ]
GO

/****** Object:  StoredProcedure [dbo].[getTillDetails]    Script Date: 04/18/2016 13:36:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getTillDetails')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getTillDetails]                 
GO

CREATE   PROCEDURE [dbo].[getTillDetails] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

  SELECT TERMINAL_ID as TID,  
         Till_TerminalNo as TermTillID,
         Till_MerchantNumber as TerminalSite, Till_Status as TerminalStatus, 
         Term_ReceiptHeader1 as ReceiptHeader1, Term_ReceiptHeader2 as ReceiptHeader2,
         Term_ReceiptHeader3 as ReceiptHeader3, Term_ReceiptHeader4 as ReceiptHeader4
         --Term_QuantumEnable as QuantumEnabled, Term_TalexusEnable as TalexusEnabled,
         --Term_DownLoadPrintFileEnable as PrintFilesEnabled,
  FROM [Terminal]
  inner join [Till] on Till_ID = Term_TillID 
  inner join [MerchantSites] on Site_ID = Till_MerchantNumber
  -- WHERE TERMINAL_ID is not null
  order by 1,2

  if @@ROWCOUNT = 0
  begin
     set @ErrStatus = 100
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

