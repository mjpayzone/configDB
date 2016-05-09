USE [Terminal_config_MJ]
GO
-- NOTE
-- the data filepath will need to be changed depending in the second part as it depends on 
-- where the datafile is located on the required server


-------------------------------------------------------------------------------------------------------------------------------------
--   new table EnablementRules
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  TABLE [dbo].[EnablementRules]    Script Date: 09/24/2015 14:21:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
--drop table [EnablementRules]
CREATE TABLE [dbo].[EnablementRules](
	[ER_Key] [int] IDENTITY(1,1) NOT NULL,
	[ER_ProductGroupID] [int] NULL,
	[ER_PostCode] [varchar](9) NULL,
 CONSTRAINT [PK_ER_Key] PRIMARY KEY CLUSTERED 
(
	[ER_Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key for this table. Identity column incremented by 1 for every new row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EnablementRules', @level2type=N'COLUMN',@level2name=N'ER_Key'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key to AppXref table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EnablementRules', @level2type=N'COLUMN',@level2name=N'ER_ProductGroupID'


-------------------------------------------------------------------------------------------------------------------------------------
--   lstored proc ztfr_TillProductEnablements
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[ztfr_TillProductEnablements]    Script Date: 09/28/2015 15:02:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP PROCEDURE [dbo].[ztfr_TillProductEnablements] 
CREATE PROCEDURE [dbo].[ztfr_TillProductEnablements]
                       (@TillID int, 
--                        @TillApac int, 
--                        @TillSite int,
                        @RtnCode int OUTPUT
                        )
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @ErrorNumber int
DECLARE @key int
--DECLARE @RtnCode int
DECLARE @Till_cID int
DECLARE @Terminal_cID int
DECLARE @Lcount int
DECLARE @rowcount int
DECLARE @TermNextParcels smallint
DECLARE @TermTillID int
DECLARE @TermPostcode char(10)
DECLARE @TermSite int
DECLARE @prodGroupID int


BEGIN TRY
  SET @RtnCode = 0

  IF NOT EXISTS(SELECT 1 FROM Till 
                WHERE Till_TerminalNo = @TillID)
  BEGIN              
    SET @ErrDesc = 'Till ID does not exists for till enablements op for Zorin Till ' + CAST(@TillID as CHAR(8));
    RAISERROR (@ErrDesc, 11,1)	
    SET @RtnCode = -1
    RETURN @RtnCode
  END
 
  SELECT @TermTillID = Term_TillID, @TermNextParcels = Term_NextReturns 
        ,@TermSite = Site_ID, @TermPostcode = REPLACE(LTRIM(RTRIM(Site_Postcode)),' ','')
  FROM Terminal, Till, MerchantSites
  WHERE Till_TerminalNo = @TillID
  AND Term_TillID = Till_ID
  AND Site_ID = Till_MerchantNumber
 
  IF @TermTillID = 0 OR @TermTillID = NULL
  BEGIN 
    SET @ErrDesc = 'Could not retrieve config Terminal Till ID for Zorin Till ' + CAST(@TillID as CHAR(8));
    RAISERROR (@ErrDesc, 11,1)
    SET @RtnCode = -2	
    RETURN @RtnCode
  END
  
   SELECT ProductGroup_ID
   INTO #tmpGenProdsTab
   FROM ProductGroups
   WHERE ProductGroup_IsGeneric = 1

   DECLARE GenProdGroupsC CURSOR LOCAL FORWARD_ONLY FOR 
   SELECT ProductGroup_ID FROM #tmpGenProdsTab 
   
begin transaction

   OPEN GenProdGroupsC
   FETCH NEXT FROM GenProdGroupsC into @prodGroupID 
   WHILE @@FETCH_STATUS = 0
   BEGIN  
      -- insert all generic groups for this till into table 
      IF NOT EXISTS (SELECT 1 FROM ProdsXTerminal 
                     WHERE ProdsXTerminal_ProdGKey = @prodGroupID
                     AND ProdsXTerminal_TermTillIDKey = @TermTillID)
      BEGIN               
      INSERT INTO ProdsXTerminal (ProdsXTerminal_ProdGKey, ProdsXTerminal_TermTillIDKey)
      VALUES (@prodGroupID, @TermTillID)
        select @RtnCode = @@ERROR
        IF @RtnCode <> 0 
        BEGIN
          SET @RtnCode = @RtnCode * -1
          SET @ErrDesc = 'Could not insert into ProdsXTerminal for Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
        END
      END  

      FETCH NEXT FROM GenProdGroupsC into @prodGroupID 
   END
   CLOSE GenProdGroupsC
   DEALLOCATE GenProdGroupsC

  CREATE TABLE #tmpProdsEnabldTab 
  (
     ProdGrpID int
  ) 
 
   INSERT INTO #tmpProdsEnabldTab
   SELECT ER_ProductGroupID 
   FROM EnablementRules
   WHERE LTRIM(RTRIM(ER_PostCode)) LIKE SUBSTRING( LTRIM(RTRIM(@TermPostcode)),1,5)   
  
   INSERT INTO #tmpProdsEnabldTab
   SELECT ER_ProductGroupID 
   FROM EnablementRules
   WHERE LTRIM(RTRIM(ER_PostCode)) LIKE SUBSTRING( LTRIM(RTRIM(@TermPostcode)),1,4)   

   INSERT INTO #tmpProdsEnabldTab
   SELECT ER_ProductGroupID 
   FROM EnablementRules
   WHERE LTRIM(RTRIM(ER_PostCode)) LIKE SUBSTRING( LTRIM(RTRIM(@TermPostcode)),1,3)   

   INSERT INTO #tmpProdsEnabldTab
   SELECT ER_ProductGroupID 
   FROM EnablementRules
   WHERE LTRIM(RTRIM(ER_PostCode)) LIKE SUBSTRING( LTRIM(RTRIM(@TermPostcode)),1,2)   

   DECLARE SpecProdGroupsC CURSOR LOCAL FORWARD_ONLY FOR 
   SELECT DISTINCT(ProdGrpID) FROM #tmpProdsEnabldTab 

   OPEN SpecProdGroupsC
   FETCH NEXT FROM SpecProdGroupsC into @prodGroupID 
   WHILE @@FETCH_STATUS = 0
   BEGIN  
      IF NOT EXISTS (SELECT 1 FROM ProdsXTerminal 
                     WHERE ProdsXTerminal_ProdGKey = @prodGroupID
                     AND ProdsXTerminal_TermTillIDKey = @TermTillID)
      BEGIN               
      INSERT INTO ProdsXTerminal (ProdsXTerminal_ProdGKey, ProdsXTerminal_TermTillIDKey)
      VALUES (@prodGroupID, @TermTillID)
        select @RtnCode = @@ERROR
        IF @RtnCode <> 0
        BEGIN
          SET @RtnCode = @RtnCode * -1
          SET @ErrDesc = 'Could not insert into ProdsXTerminal for EnablementRules Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
        END
      END

      FETCH NEXT FROM SpecProdGroupsC into @prodGroupID 
   END
   CLOSE SpecProdGroupsC
   DEALLOCATE SpecProdGroupsC
   commit transaction
   
   
   DROP TABLE #tmpProdsEnabldTab
   DROP TABLE #tmpGenProdsTab
   
   RETURN @RtnCode

END TRY

BEGIN CATCH
	SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrDesc = ERROR_MESSAGE()
    RAISERROR (@ErrDesc, 11,1)
END CATCH	

END
