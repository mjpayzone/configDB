USE [TerminalConfig_V5_MJ]
GO

/****** Object:  StoredProcedure [dbo].[getSiteDetails]    Script Date: 04/01/2016 12:28:55 ******/
-------------------------------
---- getSiteDetails
-------------------------------

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
 
IF EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getSiteDetails')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getSiteDetails]                 
GO

CREATE   PROCEDURE [dbo].[getSiteDetails] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

  SELECT Site_ID as SiteID, Site_Name as SiteName, 
         Site_Addr1 as SiteAddr1, Site_Addr1a as SiteAddr2, Site_Addr2 as SiteAddr3, Site_Addr3 as SiteAddr4, 
         Site_Postcode as SitePostcode, Site_Contact as SiteContact, Site_Tel as SiteTel, 
         Site_Status as SiteStatus, Site_CreditLimit as SiteCreditLimit, Site_Enabled as SiteEnabledStatus, 
         CASE WHEN LEN(RTRIM(Site_EnabledMsg)) = 0 THEN NULL ELSE RTRIM(Site_EnabledMsg) END as EnablementMsg , 
         Site_MonOpen as MonOpen, Site_MonClose as MonClose,
         Site_TueOpen as TueOpen, Site_TueClose as TueClose,
         Site_WedOpen as WedOpen, Site_WedClose as WedClose,
         Site_ThuOpen as ThuOpen, Site_ThuClose as ThuClose,
         Site_FriOpen as FriOpen, Site_FriClose as FriClose,
         Site_SatOpen as SatOpen, Site_SatClose as SatClose,
         Site_SunOpen as SunOpen, Site_SunClose as SunClose,
		 Site_TransientCreditLimit as SiteTransientCreditLimit,
		 Site_TransientCreditLimitExpiry as SiteTransientCreditLimitExpiry
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


-------------------------------
---- getSiteDetailsForTid
-------------------------------

GO
/****** Object:  StoredProcedure [dbo].[getSiteDetailsForTid]    Script Date: 04/01/2016 12:04:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getSiteDetailsForTid')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getSiteDetailsForTid]                 
GO

CREATE   PROCEDURE [dbo].[getSiteDetailsForTid] (@terminalID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

  SELECT Site_ID as SiteID, Site_Name as SiteName, 
         Site_Addr1 as SiteAddr1, Site_Addr1a as SiteAddr2, Site_Addr2 as SiteAddr3, Site_Addr3 as SiteAddr4, 
         Site_Postcode as SitePostcode, Site_Contact as SiteContact, Site_Tel as SiteTel, 
         Site_Status as SiteStatus, Site_CreditLimit as SiteCreditLimit, Site_Enabled as SiteEnabledStatus, 
         CASE WHEN LEN(RTRIM(Site_EnabledMsg)) = 0 THEN NULL ELSE RTRIM(Site_EnabledMsg) END as EnablementMsg , 
         Site_MonOpen as MonOpen, Site_MonClose as MonClose,
         Site_TueOpen as TueOpen, Site_TueClose as TueClose,
         Site_WedOpen as WedOpen, Site_WedClose as WedClose,
         Site_ThuOpen as ThuOpen, Site_ThuClose as ThuClose,
         Site_FriOpen as FriOpen, Site_FriClose as FriClose,
         Site_SatOpen as SatOpen, Site_SatClose as SatClose,
         Site_SunOpen as SunOpen, Site_SunClose as SunClose,
		 Site_TransientCreditLimit as SiteTransientCreditLimit,
		 Site_TransientCreditLimitExpiry as SiteTransientCreditLimitExpiry
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

------------------------
-- getTillDetails
------------------------
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


-------------------------------
-- getTillDetailsForTid
-------------------------------
GO
/****** Object:  StoredProcedure [dbo].[getTillDetailsForTid]    Script Date: 03/30/2016 12:02:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getTillDetailsForTid')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getTillDetailsForTid]                 
GO

CREATE   PROCEDURE [dbo].[getTillDetailsForTid] (@terminalID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

  SELECT TERMINAL_ID as TID, 
         Till_TerminalNo as TermTillID, 
         Till_MerchantNumber as TerminalSite, 
         Till_Status as TerminalStatus, 
         -- SIGNATURE as TerminalSignature, TYPE as TerminalType,
         Term_ReceiptHeader1 as ReceiptHeader1, Term_ReceiptHeader2 as ReceiptHeader2,
         Term_ReceiptHeader3 as ReceiptHeader3, Term_ReceiptHeader4 as ReceiptHeader4
         --Term_QuantumEnable as QuantumEnabled, Term_TalexusEnable as TalexusEnabled,
         --Term_DownLoadPrintFileEnable as PrintFilesEnabled,
         --Site_Enabled, Site_EnabledMsg as EnabledMessage
  FROM [Terminal]
  inner join [Till] on Till_ID = Term_TillID 
  WHERE TERMINAL_ID = @terminalID --CAST(@terminalID as INT)

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


-----------------------------------------
--getTerminalProductGroups
----------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[getTerminalProductGroups]    Script Date: 03/31/2016 12:34:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getTerminalProductGroups')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getTerminalProductGroups]                 
GO

CREATE   PROCEDURE [dbo].[getTerminalProductGroups] 
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
  where TERMINAL_ID is not null
  and TERMINAL_ID > 0
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




--------------------------------------
-- getProductDisablements
--------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[getProductDisablements]    Script Date: 04/04/2016 15:08:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getProductDisablements')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getProductDisablements]                 
GO

CREATE  PROCEDURE [dbo].[getProductDisablements] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

SELECT TERMINAL_ID as TerminalID, 
       PD_ProdKey as ProductID
  FROM [ProductDisablements]
  INNER JOIN Till on Till_ID = PD_TillID
  INNER JOIN Terminal on Term_TillID = Till_ID
  WHERE TERMINAL_ID is not null AND TERMINAL_ID > 0
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

---------------------------
--   getCategories
---------------------------
GO
/****** Object:  StoredProcedure [dbo].[getCategories]    Script Date: 10/21/2015 11:20:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getCategories')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getCategories]                 
GO

CREATE  PROCEDURE [dbo].[getCategories] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

  SELECT  distinct Cgr_Key as categoryID, 
                   Cgr_Name as categoryName,
                   ISNULL(Cgr_Parent, 0) as categoryParent,
                   Cgr_Visible as categoryVisible
  FROM Categories
  ORDER BY Cgr_Key

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


-------------------------------------
-- getCategoryTypeReq
-------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[getCategoryTypeReq]    Script Date: 04/27/2016 12:29:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getCategoryTypeReq')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getCategoryTypeReq]                 
GO

CREATE  PROCEDURE [dbo].[getCategoryTypeReq] (@catID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @catParent smallint
DECLARE @parentName varchar(50)
  

BEGIN TRY
  
  SELECT @catParent = Cgr_Parent 
  FROM Categories
  where Cgr_Key = @catID
  
  IF (@catParent is not null)
  BEGIN
    SELECT @parentName = Cgr_Name
    FROM Categories
    where Cgr_Key = @catParent

    SELECT CAST(Cgr_AppType AS int) as catApptype, 
         RTRIM(@parentName) + ' ' + RTRIM(Cgr_Name) as catDesc
    FROM Categories
    where Cgr_Key = @catID
  END
  ELSE
  BEGIN
    SELECT CAST(Cgr_AppType AS int) as catApptype, 
         Cgr_Name as catDesc
    FROM Categories
    where Cgr_Key = @catID
  END 

  if @@ROWCOUNT = 0
  begin
     set @ErrStatus = -1
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





-------------------------------------
-- getGenProductsCategory
-------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[getGenProductsCategory]    Script Date: 04/15/2016 14:35:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects
            WHERE object_id = OBJECT_ID(N'getGenProductsCategory')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getGenProductsCategory]                 
GO


CREATE  PROCEDURE [dbo].[getGenProductsCategory] (@catID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
--DECLARE @catID smallint
DECLARE @appType int
DECLARE @txnType int
DECLARE @defprod smallint
  
--SET @catID = 4

BEGIN TRY
  
  SELECT @appType = Cgr_AppType, @txnType = Cgr_TxnType
  FROM [Categories]
  where Cgr_Key = @catID
  
  SELECT  distinct 
       Issuer_Key as issuerID
       ,rtrim(Issuer_Name) as issuerName
       ,CASE WHEN Prod_Child_Products > 0 THEN Prod_Key ELSE 0 END as nodeproductID
       ,CASE WHEN Prod_Child_Products > 0 THEN rtrim(Prod_Description) else null END as nodeproductName
       ,Issuer_NUA_1 as issuerNUA,
       CASE WHEN TxnType_Code is null THEN 0 ELSE TxnType_Code END as txnType,
       App_Type as applicationType,
       CASE WHEN IssuerRange_IssuerFormat is null then null else IssuerRange_IssuerFormat END as IIN ,
       Issuer_Pan_Length_A as panRangeA,
       Issuer_Pan_Length_B as panRangeB,
       TxnType_BarCodeScanner as canBarcodeScan,
       TxnType_CardSwipe as canMsrScan,
       --Prod_Key as productID,
       --rtrim(Prod_Description) as productName,
       CASE WHEN Prod_Child_Products = 0 THEN Prod_Key ELSE 0 END as productID,
       CASE WHEN Prod_Child_Products = 0 THEN rtrim(Prod_Description) ELSE NULL END as productName,
       Prod_Amount as prodAmount,
--       Prod_Min_Amount as prodMinAmount,
--       Prod_Max_Amount as prodMaxAmount,
       CASE WHEN Prod_Max_Amount > Prod_Min_Amount THEN Prod_Min_Amount ELSE NULL END as prodMinAmount,
       CASE WHEN Prod_Max_Amount > Prod_Min_Amount THEN Prod_Max_Amount ELSE NULL END as prodMaxAmount,
       CASE WHEN (Issuer_FloorLimit > 0 AND Prod_Amount_Type > 0) THEN Issuer_FloorLimit * 100 ELSE NULL END as floorlimitAmount,
       CASE WHEN (Prod_Amount_Type = 2 OR Prod_Whole_Currency = 1) THEN Prod_Min_Amount ELSE NULL END as incrementsAmount,
       CASE WHEN TxnType_EnterTxnAmount = 1 THEN NULL  ELSE TxnType_EnterTxnAmount END as amountEntryEnabled,
       Prod_Fund_Type as fundtype,
       Prod_Next_Product_Index as nextProductID,
       Prod_Child_Products as childProductID,
       CAST(Prod_DefaultProduct AS SMALLINT) as defaultProduct  
--       ,app_key
           , rtrim(s1.Strings_Text) as displayText  -- Prod_Label_Display
           , rtrim(s2.Strings_Text) as printText  -- Prod_Label_Print
           , rtrim(s3.Strings_Text) as ReceiptText1
           , rtrim(s4.Strings_Text) as ReceiptText2
           , rtrim(s5.Strings_Text) as ReceiptText3
           , rtrim(s6.Strings_Text) as ReceiptText4
           , rtrim(s7.Strings_Text) as ReceiptText5
           , rtrim(s8.Strings_Text) as ReceiptText6
       ,AppType_MsgType as messageType 
         ,Start_Date as startDate
         ,Expiry_Date as expiryDate
         ,Fund_Type as drawFundType
         ,Price as price
         ,CAST(Saturday AS SMALLINT) as saturday
         ,CAST(Sunday AS SMALLINT) as sunday
         ,CAST(Monday AS SMALLINT) as monday
         ,CAST(Tuesday AS SMALLINT) as tuesday
         ,CAST(Wednesday AS SMALLINT) as wednesday
         ,CAST(Thursday AS SMALLINT) as thursday
         ,CAST(Friday AS SMALLINT) as friday
  FROM 
  [ProductGroups]
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join AppTypeDesc on App_Type = AppType_Type
--  inner join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
--  inner join TxnType on TxnType_AppKey = App_Key
  and App_Type = @appType 
  and Prod_CategoryID in
  ( SELECT Cgr_Key FROM Categories
    WHERE Cgr_Key = @catID OR (Cgr_Parent = @catID and Cgr_Key > 0 )
  )
  and prod_U32 < 2
  left join Issuer_Range on IssuerRange_IssuerFormat_Key = Issuer_Key
  left join TxnType on TxnType_AppKey = App_Key
  left join Fee on Fee_ProdKey = Prod_Key
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
   left join Draws on IssuerFormat_key = Issuer_Key 
  order by 1, 24 desc, 3, 13


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

---------------------------------------
--   getProductEnablement
---------------------------------------
GO



/****** Object:  StoredProcedure [dbo].[getProductEnablement]    Script Date: 10/20/2015 14:45:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects
            WHERE object_id = OBJECT_ID(N'getProductEnablement')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getProductEnablement]                 
GO

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


--------------------------------------------------
--- PrintFiles stored procs
--------------------------------------------------

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
PRINT N'Creating [dbo].[GetMsgPrintFiles]'
GO
SET ANSI_NULLS OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMsgPrintFiles]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[GetMsgPrintFiles]
GO

CREATE PROCEDURE [dbo].[GetMsgPrintFiles]
                       (
                          @FileType varchar(5)
--                        @RtnCode int OUTPUT
                        )
AS
BEGIN

SET DATEFORMAT dmy 

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @ErrorNumber int


BEGIN TRY
--  SET @RtnCode = 0

IF rtrim(@FileType) LIKE 'print' 
BEGIN
  SELECT  distinct ddf_Site as SiteID, 
                   convert(varchar(10), ddf_Date) as FileDate,
                   ddf_FileString as FileString
  FROM DDlineFiles
  ORDER BY ddf_Site
END

IF rtrim(@FileType) LIKE 'stm' 
BEGIN
  SELECT  distinct stmf_Site as SiteID, 
                   convert(varchar(10), stmf_Date) as FileDate,
                   stmf_FileString as FileString
  FROM StatementFiles
  ORDER BY stmf_Site
END
  
IF rtrim(@FileType) LIKE 'inv' 
BEGIN
  SELECT  distinct invf_Site as SiteID, 
                   convert(varchar(10), invf_Date) as FileDate,
                   invf_FileString as FileString
  FROM InvoiceFiles
  ORDER BY invf_Site
END
 

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
	SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrDesc = ERROR_MESSAGE()
    RAISERROR (@ErrDesc, 11,1)
END CATCH	

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
SET ANSI_NULLS ON
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


-------------------------------------------
-- GetProductGroupsByMerchant
--------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProductGroupsByMerchant]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[GetProductGroupsByMerchant]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetProductGroupsByMerchant]

	@site_id char(8)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT DISTINCT [ProductGroup_Desc]
FROM
(
SELECT pg.*
	FROM [dbo].[ProductGroups] pg
	JOIN [dbo].[ProdsXTerminal] pxt
		on pg.[ProductGroup_Key] = pxt.[ProdsXTerminal_ProdGKey]
	JOIN [dbo].[Terminal] tml
		on pxt.[ProdsXTerminal_TermTillIDKey] = tml.[Term_TillID]
	JOIN [dbo].[Till] tl		
		on tml.[Term_TillID] = tl.[Till_ID]
	WHERE tl.[Till_MerchantNumber] = @site_id
) p
ORDER BY 1 ASC
END
GO






-------------------------------
--
-------------------------------
