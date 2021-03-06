USE [TerminalConfigs_dev_new]
GO
/****** Object:  StoredProcedure [dbo].[getSiteDetails]    Script Date: 05/18/2016 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
 
ALTER  PROCEDURE [dbo].[getSiteDetails] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

  SELECT Site_ID as SiteID, Site_Name as SiteName, 
         Site_Addr1 as SiteAddr1, Site_Addr1a as SiteAddr2, Site_Addr2 as SiteAddr3, Site_Addr3 as SiteAddr4, 
         Site_Postcode as SitePostcode, 
         Site_Contact as SiteContact, Site_Tel as SiteTel, 
         Site_Status as SiteStatus, 
         Site_CreditLimit*100 as SiteCreditLimit, 
         Site_Enabled as SiteEnabledStatus, 
         CASE WHEN LEN(RTRIM(Site_EnabledMsg)) = 0 THEN NULL ELSE RTRIM(Site_EnabledMsg) END as EnablementMsg , 
         Site_MonOpen as MonOpen, Site_MonClose as MonClose,
         Site_TueOpen as TueOpen, Site_TueClose as TueClose,
         Site_WedOpen as WedOpen, Site_WedClose as WedClose,
         Site_ThuOpen as ThuOpen, Site_ThuClose as ThuClose,
         Site_FriOpen as FriOpen, Site_FriClose as FriClose,
         Site_SatOpen as SatOpen, Site_SatClose as SatClose,
         Site_SunOpen as SunOpen, Site_SunClose as SunClose,
		 Site_TransientCreditLimit*100 as SiteTransientCreditLimit,
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

