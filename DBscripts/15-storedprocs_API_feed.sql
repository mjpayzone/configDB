USE [Terminal_config_MJ]
GO

-------------------------------------------------------------------------------------------------------------------------------------
--   getSiteDetails
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getSiteDetails]    Script Date: 10/20/2015 14:42:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getSiteDetails] 
CREATE  PROCEDURE [dbo].[getSiteDetails] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

  SELECT Site_ID as SiteID, Site_Name as SiteName, 
         Site_Addr1 as SiteAddr1, Site_Addr1a as SiteAddr2, Site_Addr2 as SiteAddr3, Site_Addr3 as SiteAddr4, 
         Site_Postcode as SitePostcode, Site_Contact as SiteContact, Site_Tel as SiteTel, 
         Site_Status as SiteStatus, Site_CreditLimit as SiteCreditLimit, Site_Enabled as SiteEnabledStatus, 
         Site_EnabledMsg as EnablementMsg, 
         Site_MonOpen as MonOpen, Site_MonClose as MonClose,
         Site_TueOpen as TueOpen, Site_TueClose as TueClose,
         Site_WedOpen as WedOpen, Site_WedClose as WedClose,
         Site_ThuOpen as ThuOpen, Site_ThuClose as ThuClose,
         Site_FriOpen as FriOpen, Site_FriClose as FriClose,
         Site_SatOpen as SatOpen, Site_SatClose as SatClose,
         Site_SunOpen as SunOpen, Site_SunClose as SunClose
  FROM   [MerchantSites]
  order by 1

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


-------------------------------------------------------------------------------------------------------------------------------------
--   getTillDetails
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getTillDetails]    Script Date: 10/20/2015 14:38:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getTillDetails] 
CREATE  PROCEDURE [dbo].[getTillDetails] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

  SELECT TERMINAL_ID as TID,  
         Till_MerchantNumber as TerminalSite, Till_Status as TerminalStatus, 
         SIGNATURE as TerminalSignature, TYPE as TerminalType,
         Term_ReceiptHeader1 as ReceiptHeader1, Term_ReceiptHeader2 as ReceiptHeader2,
         Term_ReceiptHeader3 as ReceiptHeader3, Term_ReceiptHeader4 as ReceiptHeader4
         --Term_QuantumEnable as QuantumEnabled, Term_TalexusEnable as TalexusEnabled,
         --Term_DownLoadPrintFileEnable as PrintFilesEnabled,
         --Site_Enabled, Site_EnabledMsg as EnabledMessage
  FROM [Terminal]
  inner join [Till] on Till_ID = Term_TillID 
  WHERE TERMINAL_ID is not null
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


-------------------------------------------------------------------------------------------------------------------------------------
--   insertConfigError
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[insertConfigError]    Script Date: 01/12/2015 17:01:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[insertConfigError](@tid int,
                                           @errNumber int, 
                                           @errDesc char(250))
AS
BEGIN


INSERT INTO [ConfigErrors]
           (ConfigErr_Tid,
            ConfigErr,
            ConfigErr_Desc)
     VALUES
           (@tid, 
            @errNumber, 
            @ErrDesc)
           
END


-------------------------------------------------------------------------------------------------------------------------------------
--   getProductGroupProducts
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getProductGroupProducts]    Script Date: 10/20/2015 14:44:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getProductGroupProducts] 
CREATE  PROCEDURE [dbo].[getProductGroupProducts] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

SELECT ProductGroup_Key as ProductGroupID
      ,PGXProds_ProdKey as ProductID
  FROM [ProductGroups]
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
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


-------------------------------------------------------------------------------------------------------------------------------------
--   getTerminalProductGroups
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getTerminalProductGroups]    Script Date: 10/20/2015 14:41:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getTerminalProductGroups] 
CREATE  PROCEDURE [dbo].[getTerminalProductGroups] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

SELECT TERMINAL_ID as TerminalID,
       --[ProdsXTerminal_TermTillIDKey] as TillID
       [ProdsXTerminal_ProdGKey] as ProductgroupID
  FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join ProductGroups on ProdsXTerminal_ProdGKey = ProductGroup_Key
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


-------------------------------------------------------------------------------------------------------------------------------------
--   getProductDisablements
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getProductDisablements]    Script Date: 10/20/2015 14:49:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getProductDisablements] 
CREATE PROCEDURE [dbo].[getProductDisablements] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

SELECT PD_TID as terminalID,
       PD_ProdKey as ProductID
  FROM [ProductDisablements]
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


-------------------------------------------------------------------------------------------------------------------------------------
--   getProductEnablement
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getProductEnablement]    Script Date: 10/20/2015 14:45:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getProductEnablement] 
CREATE  PROCEDURE [dbo].[getProductEnablement] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY


  SELECT  distinct TERMINAL_ID as terminalID, 
                   --Term_TillID,
                   PGXProds_ProdKey as productID
                   --,rtrim(Prod_Description) as productName
  FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join Till on Till_ID = Term_TillID  
  inner join ProductGroups on ProductGroup_ID = ProdsXTerminal_ProdGKey
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  --inner join Product on Prod_Key = PGXProds_ProdKey
  except
     select TERMINAL_ID, 
     --Term_TillID, 
     PD_ProdKey --,rtrim(Prod_Description) as productName--, PD_TillID 
     from ProductDisablements 
     inner join Product on Prod_Key = PD_ProdKey
     inner join Terminal on Term_TillID = PD_TillID
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


-------------------------------------------------------------------------------------------------------------------------------------
--   getSiteDetailsForTid
-------------------------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getSiteDetailsForTid] 
CREATE  PROCEDURE [dbo].[getSiteDetailsForTid] (@terminalID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

  SELECT Site_ID as SiteID, Site_Name as SiteName, 
         Site_Addr1 as SiteAddr1, Site_Addr1a as SiteAddr2, Site_Addr2 as SiteAddr3, Site_Addr3 as SiteAddr4, 
         Site_Postcode as SitePostcode, Site_Contact as SiteContact, Site_Tel as SiteTel, 
         Site_Status as SiteStatus, Site_CreditLimit as SiteCreditLimit, Site_Enabled as SiteEnabledStatus, 
         Site_EnabledMsg as EnablementMsg, 
         Site_MonOpen as MonOpen, Site_MonClose as MonClose,
         Site_TueOpen as TueOpen, Site_TueClose as TueClose,
         Site_WedOpen as WedOpen, Site_WedClose as WedClose,
         Site_ThuOpen as ThuOpen, Site_ThuClose as ThuClose,
         Site_FriOpen as FriOpen, Site_FriClose as FriClose,
         Site_SatOpen as SatOpen, Site_SatClose as SatClose,
         Site_SunOpen as SunOpen, Site_SunClose as SunClose
  FROM  [MerchantSites]
  inner join [Till] on Till_MerchantNumber = Site_ID
  inner join [Terminal] on Term_TillID = Till_ID
  WHERE TERMINAL_ID = @terminalID 

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


-------------------------------------------------------------------------------------------------------------------------------------
--   getTillDetailsForTid
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[getTillDetailsForTid]    Script Date: 10/20/2015 14:40:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP  PROCEDURE [dbo].[getTillDetailsForTid] 
CREATE  PROCEDURE [dbo].[getTillDetailsForTid] (@terminalID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

  SELECT TERMINAL_ID as TID,  
         Till_MerchantNumber as MerchantSite, Till_Status as TerminalStatus, 
         SIGNATURE as TerminalSignature, TYPE as TerminalType,
         Term_ReceiptHeader1 as ReceiptHeader1, Term_ReceiptHeader2 as ReceiptHeader2,
         Term_ReceiptHeader3 as ReceiptHeader3, Term_ReceiptHeader4 as ReceiptHeader4
         --Term_QuantumEnable as QuantumEnabled, Term_TalexusEnable as TalexusEnabled,
         --Term_DownLoadPrintFileEnable as PrintFilesEnabled,
         --Site_Enabled, Site_EnabledMsg as EnabledMessage
  FROM [Terminal]
  inner join [Till] on Till_ID = Term_TillID 
  WHERE TERMINAL_ID = CAST(@terminalID as INT)

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


-------------------------------------------------------------------------------------------------------------------------------------
--   
-------------------------------------------------------------------------------------------------------------------------------------
