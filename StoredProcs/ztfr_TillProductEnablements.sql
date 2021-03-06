USE [TerminalConfig_V5_MJ]
GO

--------------------------------------------------
-- ztfr_TillProductEnablements
--------------------------------------------------
/****** Object:  StoredProcedure [dbo].[ztfr_TillProductEnablements]    Script Date: 12/07/2015 16:21:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ztfr_TillProductEnablements]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ztfr_TillProductEnablements]
GO

CREATE  PROCEDURE [dbo].[ztfr_TillProductEnablements]
                       (@TillID int, 
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
DECLARE @TermProfile smallint
DECLARE @tmpProfile smallint
DECLARE @rule varchar(200)
declare @dsql nvarchar(500)
declare @plist nvarchar(200) 


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
        ,@TermProfile = Term_Profile
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
          --SET @RtnCode = @RtnCode * -1
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
          --SET @RtnCode = @RtnCode * -1
          SET @ErrDesc = 'Could not insert into ProdsXTerminal for EnablementRules Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Erro Code: ' + CAST(@RtnCode as varchar(12));
          RAISERROR (@ErrDesc, 11,1)
        END
      END

      FETCH NEXT FROM SpecProdGroupsC into @prodGroupID 
   END
   CLOSE SpecProdGroupsC
   DEALLOCATE SpecProdGroupsC
   
  -- Profile Rules groups 
  CREATE TABLE #tmpProfilesTab 
  (
     ProdGrpID int
     ,Prule varchar(250)
  ) 
 
   INSERT INTO #tmpProfilesTab
   SELECT ER_ProductGroupID, ER_ProfileRule 
   FROM EnablementRules
   WHERE LEN(LTRIM(RTRIM(ER_ProfileRule))) > 0 and ER_ProfileRule is not null   
   
   DECLARE ProfileRC CURSOR LOCAL FORWARD_ONLY FOR 
   SELECT ProdGrpID, Prule FROM #tmpProfilesTab ORDER BY ProdGrpID

   OPEN ProfileRC
   FETCH NEXT FROM ProfileRC into @prodGroupID, @rule
   WHILE @@FETCH_STATUS = 0
   BEGIN  
       
      SET @plist = '@tmpProfile smallint output'                              
      --select @prodGroupID as pPGID, @rule as prule 
      SET @dsql = 'SELECT @tmpProfile = Term_Profile FROM Terminal WHERE Term_TillID = ' + CAST(@TermTillID as CHAR(8)) 
                    + ' AND Term_Profile ' + @rule
      --select @dsql 
      SET  @tmpProfile = null            
      EXECUTE sp_executesql @dsql , @plist, @tmpProfile = @tmpProfile  output
      IF @tmpProfile is not null 
      BEGIN
        IF NOT EXISTS (SELECT 1 FROM ProdsXTerminal 
                       WHERE ProdsXTerminal_ProdGKey = @prodGroupID
                       AND ProdsXTerminal_TermTillIDKey = @TermTillID)
        BEGIN               
           --select @tmpProfile, @prodGroupID as pPGID
           INSERT INTO ProdsXTerminal (ProdsXTerminal_ProdGKey, ProdsXTerminal_TermTillIDKey)
           VALUES (@prodGroupID, @TermTillID)
           select @RtnCode = @@ERROR
           IF @RtnCode <> 0
           BEGIN
             --SET @RtnCode = @RtnCode * -1
             SET @ErrDesc = 'Could not insert into profile group ProdsXTerminal for EnablementRules Zorin Till ' + CAST(@TillID as CHAR(8)) + 'Error Code: ' + CAST(@RtnCode as varchar(12));
             RAISERROR (@ErrDesc, 11,1)
           END
        END
      END

      FETCH NEXT FROM ProfileRC into @prodGroupID, @rule 
   END
   CLOSE ProfileRC
   DEALLOCATE ProfileRC
   
   commit transaction
   
   DROP TABLE #tmpProdsEnabldTab
   DROP TABLE #tmpGenProdsTab
   DROP TABLE #tmpProfilesTab
   
   RETURN @RtnCode

END TRY

BEGIN CATCH
	SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrDesc = ERROR_MESSAGE()
    RAISERROR (@ErrDesc, 11,1)
END CATCH	

END







