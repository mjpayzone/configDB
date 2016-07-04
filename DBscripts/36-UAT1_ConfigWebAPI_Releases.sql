USE [TerminalConfigs_V5_MJ]
--USE [TerminalConfigs_dev_new]
GO

---------------------------------------------------------------------------------------------
-- tmp hack to cater for tablet feed never having looked at qauntum feed, so second quantum
-- product has to be temporarily moved to same issuer.
-- This will have to be corrected when it comes to per terminal configuration
---------------------------------------------------------------------------------------------
select 'quantum product tablet hack'
begin transaction

update Issuer_Range
set IssuerRange_IssuerFormat_Key = 42 -- currently 1478
where IssuerRange_IssuerFormat = '0069999999999999'

--rollback transaction
commit transaction


---------------------------------------------------------------------------------------------
-- set MenuIndex for EV in order to group Orange products togetehr and order the different 
-- Orange issuer products 
--------------------------------------------------------------------------------------------
-- USE [TerminalConfig_V5_NEWMJ]
select 'set MenuIndex '
--USE [TerminalConfigs_V5_MJ]
GO
--execute setMenuIndexField 3
--
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'setMenuIndexField')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[setMenuIndexField]                 
GO


CREATE PROCEDURE [dbo].[setMenuIndexField] (@appType int, @catID int)
AS

DECLARE
	@ErrorNumber	INT,
	@ErrorMessage	NVARCHAR(4000)
DECLARE @issID      SMALLINT
DECLARE @issName    CHAR(24)
DECLARE @issMenuIdx INT
DECLARE @prodU32    SMALLINT
DECLARE @OTextID    SMALLINT
DECLARE @OTalkID    SMALLINT
DECLARE @idx        INT

SET @idx = 0

BEGIN TRY


select distinct issuer_key, issuer_name, Issuer_MenuIndex 
into #tmptbl
  FROM 
  [ProductGroups]
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  and App_Type = @appType
  and Prod_CategoryID = @catID
  and prod_U32 < 2
  order by 1
--   select * from #tmptbl

select distinct issuer_key, issuer_name, len(RTRIM(issuer_name)) as issnsize
into #tmptblOText
  FROM 
  [ProductGroups]
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  and App_Type = @appType
  and Prod_CategoryID = @catID
  and prod_U32 < 2
  and issuer_name like 'Orange Text%'
  order by issnsize, issuer_name

--  select * from #tmptblOText

select distinct issuer_key, issuer_name 
into #tmptblOTalk
  FROM 
  [ProductGroups]
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  and App_Type = @appType
  and Prod_CategoryID = @catID
  and prod_U32 < 2
  and issuer_name like 'Orange Talk%'
  order by issuer_name

--  select * from #tmptblOTalk
 
   DECLARE issC CURSOR LOCAL FORWARD_ONLY FOR 
   SELECT Issuer_Key, Issuer_Name, Issuer_MenuIndex 
   FROM #tmptbl
   
   DECLARE issOTextC CURSOR LOCAL FORWARD_ONLY FOR 
   SELECT Issuer_Key 
   FROM #tmptblOText

   DECLARE issOTalkC CURSOR LOCAL FORWARD_ONLY FOR 
   SELECT Issuer_Key 
   FROM #tmptblOTalk

BEGIN TRANSACTION  
   OPEN issC
   FETCH NEXT FROM issC into @issID, @issName, @issMenuIdx
   WHILE @@FETCH_STATUS = 0
   BEGIN
      SET @idx = @idx + 1
--      select  @issID, @issName, @issMenuIdx, @idx
      IF @issName like 'Orange T%'
      BEGIN
          if @issName like 'Orange Text%' 
          begin
            OPEN issOTextC
            FETCH NEXT FROM issOTextC into @OTextID
            WHILE @@FETCH_STATUS = 0
            BEGIN
               UPDATE issuer_Format
               SET Issuer_MenuIndex = @idx
               WHERE Issuer_Key = @OTextID
               set @idx = @idx + 1
--               select @OTextID, @idx
               delete from #tmptbl where issuer_key = @OTextID
               fetch next from issOTextC into @OTextID
            END
          end 
          if @issName like 'Orange Talk%' 
          begin
            OPEN issOTalkC
            FETCH NEXT FROM issOTalkC into @OTalkID
            WHILE @@FETCH_STATUS = 0
            BEGIN
               UPDATE issuer_Format
               SET Issuer_MenuIndex = @idx
               WHERE Issuer_Key = @OTalkID
               set @idx = @idx + 1
--               select @OTalkID, @idx
               delete from #tmptbl where issuer_key = @OTalkID
               fetch next from issOTalkC into @OTalkID
            END
          end 
      END
      ELSE
      BEGIN
--         select  @issID, @issName, @idx
         UPDATE issuer_Format
         SET Issuer_MenuIndex = @idx
         WHERE Issuer_Key = @issID
      END      
      FETCH NEXT FROM issC into @issID, @issName, @issMenuIdx 
   END
   
--COMMIT TRANSACTION   
   
   CLOSE issC
   DEALLOCATE issC
   CLOSE issOTextC
   DEALLOCATE issOTextC
   CLOSE issOTalktC
   DEALLOCATE issOTalkC
   
   DROP TABLE #tmptbl
   DROP TABLE #tmptblOTalk
   DROP TABLE #tmptblOText
   
END TRY
BEGIN CATCH
   SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrorMessage = ERROR_MESSAGE()
   select @ErrorNumber
   select @ErrorMessage
END CATCH


-- execute proc
GO
EXECUTE [setMenuIndexField] 3,6

commit transaction
--rollback transaction

GO
DROP PROCEDURE [setMenuIndexField] 

-----------------------------------------------
---- refresh stored proc getGenProductsCategory
-----------------------------------------------
--USE [TerminalConfigs_dev_new]
GO
/****** Object:  StoredProcedure [dbo].[getGenProductsCategory]    Script Date: 05/10/2016 14:52:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER  PROCEDURE [dbo].[getGenProductsCategory] (@catID int)
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
       ,Issuer_MenuIndex as idx  
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
    left join Strings s1 on s1.Strings_Key = Prod_Label_Display
    left join Strings s2 on s2.Strings_Key = Prod_Label_Print
    left join Strings s3 on s3.Strings_Key = Issuer_Receipt1
    left join Strings s4 on s4.Strings_Key = Issuer_Receipt2
    left join Strings s5 on s5.Strings_Key = Issuer_Receipt3
    left join Strings s6 on s6.Strings_Key = Issuer_Receipt4
    left join Strings s7 on s7.Strings_Key = Issuer_Receipt5
    left join Strings s8 on s8.Strings_Key = Issuer_Receipt6
   left join Draws on IssuerFormat_key = Issuer_Key 
  order by Issuer_MenuIndex, 1, 24 desc, 3, 13


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


--------------------------------------------------------------------------------------------
-- Change all display strings for ETU and Evoucher to be the issuer provider + ETU/EV
-- This was required for the basket affair in the tablet
--------------------------------------------------------------------------------------------
select 'update ETU and EV display string to <issuer> + ETU/EV '
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ChangeDisplayTextFields')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[ChangeDisplayTextFields]                 
GO

-- proc to enter new display string and update product
CREATE PROCEDURE [dbo].[ChangeDisplayTextFields] 
                (@appType int)
AS
BEGIN

DECLARE
	@ErrorNumber	INT,
	@ErrorMessage	NVARCHAR(4000)
DECLARE @issID      SMALLINT
DECLARE @issName    CHAR(24)
DECLARE @strID      SMALLINT
DECLARE @newName    CHAR(24)
DECLARE @currStr    CHAR(24)
DECLARE @ending     CHAR(4)
DECLARE @prodKey    SMALLINT

BEGIN TRY
 
   IF @appType = 1 
      SET @ending = ' ETU' 
   IF @appType = 3 
      SET @ending = ' EV' 
 
   DECLARE issC CURSOR LOCAL FORWARD_ONLY FOR 
   SELECT distinct Issuer_Key, rtrim(Issuer_Name)
   FROM Issuer_Format
        inner join [AppXref] on Issuer_key = AppXref_IssuerKey
        inner join [Application] on AppXref_AppKey = App_Key 
   WHERE App_Type = @appType
   and App_Key in
   (
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu]
    ,[Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = @appType
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
   )
   

BEGIN TRANSACTION

   OPEN issC
   FETCH NEXT FROM issC into @issID, @issName
   WHILE @@FETCH_STATUS = 0
   BEGIN 
     SET @strID  = 0
--     select @issID
     IF @issName like 'Mobile by Sainsbury%' 
        SET @issName = 'Mobile by Sainsbury'
     IF @issName like 'Talkmobile Pay As You Go%' 
        SET @issName = 'Talkmobile PAYG'
     IF @issName like 'EE ETU%' 
        SET @issName = 'EE'
     IF @issName like 'Boy Better Know Mobile%' 
        SET @issName = 'Boy Better Know'
     IF @issName like 'The Co-operative Mobile%' 
        SET @issName = 'The Co-operative'
     IF @issName like 'Virgin Mobile Evoucher%' 
        SET @issName = 'Virgin Mobile'
     IF @issName like 'Asda Mobile EVoucher%' 
        SET @issName = 'Asda Mobile'
     IF @issName like 'GT Mobile E-Voucher%' 
        SET @issName = 'GT Mobile'
     IF @issName like 'O2 E-Voucher%' 
        SET @issName = 'O2'
     IF @issName like 'Orange E-Voucher%' 
        SET @issName = 'Orange'
     IF @issName like 'T-Mobile E-Voucher%' 
        SET @issName = 'T-Mobile'
     IF @issName like 'Vodafone EVoucher%' 
        SET @issName = 'Vodafone'
        
     
     SET @newName = RTRIM(@issName) + @ending 
     
     DECLARE prodC CURSOR LOCAL FORWARD_ONLY FOR 
     SELECT Prod_Key, Strings_Text
     FROM Product
     left join Strings on Strings_Key = Prod_Label_Display
     WHERE Prod_Issuer_Format = @issID
     and Prod_U32 = 1
     
     OPEN prodC 
     FETCH NEXT FROM prodC into @prodKey, @currStr
     WHILE @@FETCH_STATUS = 0
     BEGIN 
         SET @strID  = 0
         IF @currStr like '%Value Bundle%' 
         BEGIN
            SET @newName = RTRIM(@issName) + ' ValueBundle' + @ending
         END   
         IF @currStr like '%Freedom Freebee%' 
         BEGIN
            SET @newName = RTRIM(@issName) + ' Freedom Freebee' + @ending
        END   
         IF @currStr like '%BLUEBERRY%' 
         BEGIN
            SET @newName = RTRIM(@issName) 
         END   
         IF @currStr like '%payment%' 
         BEGIN
            SET @newName = RTRIM(@issName)  
         END   
         IF @currStr like '%E-COUPON REDEMPTION%' 
         BEGIN
            SET @newName = RTRIM(@issName) + ' E-COUPON '
         END   
         IF @currStr like '%Next Bill Payment%' 
         BEGIN
            SET @newName = RTRIM(@issName) + ' Payment'
         END   
        
         IF NOT EXISTS (SELECT Strings_Key FROM Strings WHERE rtrim(Strings_Text) like rtrim(@newname) )
         BEGIN
             INSERT INTO Strings
             Values (rtrim(@newName), 0)
             SET @strID = SCOPE_IDENTITY()
         END
         ELSE
         BEGIN
             SELECT @strID = Strings_Key 
             FROM Strings WHERE rtrim(Strings_Text) like rtrim(@newname) 
         END

         UPDATE Product
         SET Prod_Label_Display = @strID
         WHERE Prod_Issuer_Format = @issID
         AND Prod_Key = @prodkey
    
         FETCH NEXT FROM prodC into @prodKey, @currStr 
     END
     CLOSE prodC
     DEALLOCATE prodC
     
  FETCH NEXT FROM issC into @issID, @issName 
  END
  
  CLOSE issC
  DEALLOCATE issC
  
commit transaction

END TRY
BEGIN CATCH
   SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrorMessage = ERROR_MESSAGE()
   select @ErrorNumber
   select @ErrorMessage
END CATCH

END


---- execute proc for EVoucher
GO
select 'execute proc for EVoucher'
EXECUTE [ChangeDisplayTextFields] 3

---- execute proc for ETU
GO
select 'execute proc for ETU'
EXECUTE [ChangeDisplayTextFields] 1

GO
DROP PROCEDURE [ChangeDisplayTextFields] 

-- check if inserted ok before doing commit
-- select * from Strings where Strings_Key = 2194
--EXECUTE [dbo].[getGenProductsCategory] 7

GO
-- now update Vodafone again, as it is the same issuer for both plain ETU and ValueBundle
-- the above would update to the last name, so correct this
select 'update vodafone'
DECLARE @StrID smallint
SELECT @StrID = Strings_Key FROM Strings WHERE Strings_Text like 'Vodafone ETU%'

BEGIN TRANSACTION
UPDATE product
SET  Prod_Label_Display  = @StrID
WHERE Prod_Key = 3311
--rollback transaction
COMMIT TRANSACTION



--------------------------------------------------------------------------------------------
-- Add ETU  issuer products
--------------------------------------------------------------------------------------------
select ' ETU Issuer products'
--USE [TerminalConfigs_dev_new]
GO


DECLARE @updCnt         INT
DECLARE @issID      SMALLINT
DECLARE @issName    CHAR(24)
DECLARE @strID      INT
DECLARE @issprod    INT
DECLARE @defprodID  INT
DECLARE @defprodgrpID  INT
DECLARE @defprodgrpKey INT
declare @catID int

set @catID = 7

begin transaction
   DECLARE issC CURSOR LOCAL FORWARD_ONLY FOR 
   SELECT  distinct Issuer_Key, Issuer_Name 
   --SELECT @issName = Issuer_Name
   FROM Issuer_Format
        inner join [AppXref] on Issuer_key = AppXref_IssuerKey
        inner join [Application] on AppXref_AppKey = App_Key 
   WHERE App_Type = 1 --@appType
   --and Issuer_Key = @issID
   and issuer_name not like '%Vodafone%'
  and App_Key in
   (
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu]
    ,[Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 1
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
      and app_key not in (244,245,246)  --  duplicate channel isles apps
   )

   OPEN issC
   FETCH NEXT FROM issC into @issID, @issName
   WHILE @@FETCH_STATUS = 0
   BEGIN 
   
      INSERT INTO Strings
      Values (rtrim(@issName), 0)
      SET @strID = SCOPE_IDENTITY()
       
      SELECT @defprodID = [Prod_Key]
      FROM Product
      WHERE [Prod_Issuer_Format] = @issID
      and [Prod_DefaultProduct] = 1

      SELECT @defprodgrpID = PGXProds_PGID, @defprodgrpKey = PGXProds_ProdGKey
      FROM ProdGroupXProds
      WHERE PGXProds_ProdKey = @defprodID

--      select @issID, @issName, @strID, @defprodID, @defprodgrpID
      
      INSERT INTO Product
      SELECT --[Prod_Key],
      [Prod_Issuer_Format]
      ,0 --[Prod_Fund_Type]
      ,0 --[Prod_Cash_Enable]
      ,0 --[Prod_PCheque_Enable]
      ,0 --[Prod_NoPayment_Enable]
      ,0 --[Prod_RefundCash_Enable]
      ,0 --[Prod_Amount_Type]
      ,0 --[Prod_Whole_Currency]
      ,0 --[Prod_Prompt1_Enable]
      ,0 --[Prod_Prompt2_Enable]
      ,0 --[Prod_Prompt3_Enable]
      ,0 --[Prod_Next_Product_Index]
      ,@defprodID --[Prod_Child_Products]
      ,0 --[Prod_Z_Totals_group]
      ,0 --[Prod_Default_Amount]
      ,0 --[Prod_Min_Amount]
      ,0 --[Prod_Max_Amount]
      ,@strID
      ,0 --[Prod_Label_Print]
      ,0 --[Prod_Prompt1_Display]
      ,0 --[Prod_Prompt1_Print]
      ,0 --[Prod_Prompt2_Display]
      ,0 --[Prod_Prompt2_Print]
      ,0 --[Prod_Prompt3_Display]
      ,0 --[Prod_Prompt3_Print]
      ,0 --[Prod_Confirmation_ReEntry1]
      ,0 --[Prod_AlphaNumeric1]
      ,0 --[Prod_Static_Text1]
      ,0 --[Prod_Prompt_Data_Length1]
      ,0 --[Prod_Confirmation_ReEntry2]
      ,0 --[Prod_AlphaNumeric2]
      ,0 --[Prod_Static_Text2]
      ,0 --[Prod_Prompt_Data_Length2]
      ,0 --[Prod_Confirmation_ReEntry3]
      ,0 --[Prod_AlphaNumeric3]
      ,0 --[Prod_Static_Text3]
      ,0 --[Prod_Prompt_Data_Length3]
      ,0 --[Prod_SelectorControl]
      ,0 --[Prod_SelectorIssuer]
      ,0 --[Prod_SelectorText]
      ,@issName --[Prod_Description]
      ,0 --[Prod_DefaultProduct]
      ,0 --[Prod_IssueDate]
      ,0 --[Prod_ExpDate]
      ,0 --[Prod_Amount]
      ,@catID --[Prod_CategoryID]
      ,0 --[Prod_U32]
      FROM [Product]
      where [Prod_Issuer_Format] = @issID
      and [Prod_DefaultProduct] = 1

      SET @issprod = SCOPE_IDENTITY()
--      select @issprod, 'issuer prod ID'
      -- insert the issuer product into the PGxProducts table
      INSERT INTO ProdGroupXProds 
      (PGXProds_ProdGKey, PGXProds_ProdKey, PGXProds_PGID, PGXProds_ProdName)
      values
      (@defprodgrpKey, @issprod, @defprodgrpID, rtrim(@issName) ) 

      FETCH NEXT FROM issC into @issID, @issName 
  END
  CLOSE issC
  DEALLOCATE issC
 
--execute getGenProductsCategory 7
 
commit transaction


--------------------------------------------------------------------------------------------
-- update the prod_U32 to U32 only for duplicate product set up for U32 display purposes
--------------------------------------------------------------------------------------------
select 'update duplucate products to ETU only'
--USE [TerminalConfigs_dev_new]
GO

begin transaction 
update product
set prod_U32 = 2
where prod_key 
in (
select distinct prod_key 
from product, issuer_format 
where 
[Prod_Issuer_Format] = issuer_key 
and prod_categoryID = 6
  and prod_U32 = 1
  and (issuer_name like 'Story Unl%')
  and Prod_DefaultProduct = 0 and Prod_Next_Product_Index = 0 
)     

--execute getGenProductsCategory 6
--rollback transaction
commit transaction

---------------------------------------------------------------------------------------------
-- PFS products appear similar after display strings update, so need to extract more info for
-- each product and add to the display string
--------------------------------------------------------------------------------------------
select 'add more info to PFS products display strings'
--USE [TerminalConfigs_dev_new]
GO

DECLARE @issID      smallint
DECLARE @issName    char(24)
DECLARE @strID      smallint
DECLARE @prodName   char(50)
DECLARE @NprodName  char(50)
DECLARE @prodKey    smallint
DECLARE @newStr     char(24)
DECLARE @brandkey   smallint
DECLARE @brandname  char(24)


DECLARE issC CURSOR LOCAL FORWARD_ONLY FOR 
SELECT distinct Issuer_Key, rtrim(Issuer_Name)
FROM Issuer_Format
    inner join [AppXref] on Issuer_key = AppXref_IssuerKey
    inner join [Application] on AppXref_AppKey = App_Key 
WHERE App_Type = 1
and App_Key in
(
SELECT distinct App_Key 
FROM [Menu_Applications], [Menu]
,[Application] 
where MenuApplications_MenuKey = menu_key
and MenuApplications_AppKey = App_Key
and app_type = 1
and menu_name in 
('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)
and issuer_Name like 'PFS Prepaid%'
   

BEGIN TRANSACTION

   OPEN issC
   FETCH NEXT FROM issC into @issID, @issName
   WHILE @@FETCH_STATUS = 0
   BEGIN 
     SET @strID  = 0

     DECLARE prodC CURSOR LOCAL FORWARD_ONLY FOR 
     SELECT Prod_Key, Prod_Description
     FROM Product
     WHERE Prod_Issuer_Format = @issID
     and Prod_U32 = 1
     
     OPEN prodC 
     FETCH NEXT FROM prodC into @prodKey, @prodName
     WHILE @@FETCH_STATUS = 0
     BEGIN 
         SET @strID  = 0
         SET @newStr = null

         IF @prodName like 'PFS Prepaid Cards Generic%' 
        AND @prodName not like 'PFS Prepaid Cards Generic Payroll Card%'  
        AND @prodName not like 'PFS Prepaid Cards Generic Gaming Card%'  
            SET @newStr = 'PFS Generic PrepaidCard'
         IF @prodName like 'PFS%Payroll%'
            SET @newStr = 'PFS Payroll PrepaidCard'
         IF @prodName like 'PFS%Gaming%' OR @prodName like 'PFS%Unibet%'   
            SET @newStr = 'PFS Gaming PrepaidCard'
         IF @prodName like 'PFS%Payment%'
         BEGIN    
            SELECT @brandName=strings_text
            FROM Issuer_Format
            INNER JOIN Strings ON Strings_Key = Issuer_Brand_Name
            WHERE Issuer_Key = @issID
            IF @brandName like 'Monobank%' 
            BEGIN
               SET @newStr = 'PFS Monobank PrepaidCard'
               SET @nprodName = 'PFS Prepaid Cards Payment Monobank'
            END   
            IF @brandName like 'Range%' 
            BEGIN
               SET @newStr = 'PFS Range PrepaidCard'
               SET @nprodName = 'PFS Prepaid Cards Payment Range'
            END
            BEGIN TRANSACTION
            UPDATE Product SET Prod_Description = @nprodName
            WHERE Prod_Key = @prodKey
            COMMIT TRANSACTION  
         END 
         
         IF NOT EXISTS (SELECT Strings_Key FROM Strings WHERE rtrim(Strings_Text) like rtrim(@newStr) )
         BEGIN
             INSERT INTO Strings
             Values (rtrim(@newStr), 0)
             SET @strID = SCOPE_IDENTITY()
         END
         ELSE
         BEGIN
             SELECT @strID = Strings_Key 
             FROM Strings WHERE rtrim(Strings_Text) like rtrim(@newStr) 
         END

         UPDATE Product
         SET Prod_Label_Display = @strID
         WHERE Prod_Issuer_Format = @issID
         AND Prod_Key = @prodKey
 
         FETCH NEXT FROM prodC into @prodKey, @prodName 
     END -- while loop prodC
     
     CLOSE prodC
     DEALLOCATE prodC
     FETCH NEXT FROM issC into @issID, @issName 
     
   END  -- while loop issC  

   CLOSE issC
   DEALLOCATE issC
   
COMMIT TRANSACTION   
--rollback transaction
   

---------------------------------------------------------------------------------------------
-- Spark products appear similar after display strings update, so need to extract more info for
-- each product and add to the display string
--------------------------------------------------------------------------------------------
select 'add more info to Spark products display strings'
--USE [TerminalConfigs_dev_new]
GO

DECLARE @strID      smallint
DECLARE @prodName   char(50)
DECLARE @prodKey    smallint
DECLARE @newStr     char(24)

 DECLARE prodC CURSOR LOCAL FORWARD_ONLY FOR 
 SELECT Prod_Key, Prod_Description
 FROM Product
 WHERE Prod_Description like 'Spark%'
 and Prod_U32 = 1
 
BEGIN TRANSACTION
 OPEN prodC 
 FETCH NEXT FROM prodC into @prodKey, @prodName
 WHILE @@FETCH_STATUS = 0
 BEGIN 
         SET @strID  = 0
         SET @newStr = @prodName
         
         IF NOT EXISTS (SELECT Strings_Key FROM Strings WHERE rtrim(Strings_Text) like rtrim(@newStr) )
         BEGIN
             INSERT INTO Strings
             Values (rtrim(@newStr), 0)
             SET @strID = SCOPE_IDENTITY()
         END
         ELSE
         BEGIN
             SELECT @strID = Strings_Key 
             FROM Strings WHERE rtrim(Strings_Text) like rtrim(@newStr) 
         END

         UPDATE Product
         SET Prod_Label_Display = @strID
         WHERE Prod_Key = @prodKey
 
         FETCH NEXT FROM prodC into @prodKey, @prodName 
 END -- while loop prodC
     
 CLOSE prodC
 DEALLOCATE prodC

--rollback transaction
COMMIT TRANSACTION
     
 
---------------------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------------------
