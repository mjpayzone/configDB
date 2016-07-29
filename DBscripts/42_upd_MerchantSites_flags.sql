--USE [TerminalConfigs_dev_new]
GO


BEGIN TRANSACTION
--rollback transaction

ALTER TABLE [dbo].[MerchantSites]
ADD 
Site_PrintFilesEnable CHAR(1) NOT NULL DEFAULT 'Y',
Site_QuantumEnable CHAR(1) NOT NULL DEFAULT 'Y',
Site_TalexusEnable CHAR(1) NOT NULL DEFAULT 'Y'

GO

declare @till integer
declare @site integer
declare @npfiles char(1)
declare @nquant char(1)
declare @ntalx char(1)


BEGIN TRANSACTION

DECLARE flagsC CURSOR LOCAL FORWARD_ONLY FOR 
SELECT [Term_TillID]
      ,CASE WHEN Term_DownLoadPrintFileEnable = 1 THEN 'Y' ELSE 'N' END --as DDenable
      ,CASE WHEN Term_QuantumEnable = 1 THEN 'Y' ELSE 'N' END --as quantum
      ,CASE WHEN Term_TalexusEnable = 1 THEN 'Y' ELSE 'N' END --as talx
      ,Till_MerchantNumber
  FROM [Terminal]
  inner join Till on  [Term_TillID] = Till_ID
  order by Till_MerchantNumber
  
OPEN flagsC
FETCH NEXT FROM flagsC into @till, @npfiles, @nquant, @ntalx, @site 
WHILE @@FETCH_STATUS = 0
BEGIN 
--  select @till, @npfiles, @nquant, @ntalx, @site
  UPDATE MerchantSites
  SET Site_PrintFilesEnable = @npfiles,
      Site_QuantumEnable = @nquant,
      Site_TalexusEnable = @ntalx
  WHERE  Site_ID = @site   

  FETCH NEXT FROM flagsC into  @till, @npfiles, @nquant, @ntalx, @site 
END
CLOSE flagsC
DEALLOCATE flagsC


select Site_ID, Site_PrintFilesEnable, Site_QuantumEnable, 
Site_TalexusEnable 
from MerchantSites order by Site_ID

--rollback transaction
commit transaction