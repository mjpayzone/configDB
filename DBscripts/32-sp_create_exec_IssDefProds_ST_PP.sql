--USE [Terminal_config_MJ]
USE [TerminalConfigs_dev_new]
GO
/****** Object:  StoredProcedure [dbo].[createIssDefProds_ST]    Script Date: 12/03/2015 11:03:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[createIssDefProds_ST_PP] 
                (@PPcatID int, @EntcatID int, @STRcatID int, @CcatID int, 
                 @appType int)
AS

DECLARE @updCnt         INT
DECLARE
	@ErrorNumber	INT,
	@ErrorMessage	NVARCHAR(4000)
DECLARE @issID      SMALLINT
DECLARE @issName    CHAR(24)
DECLARE @strID      INT
DECLARE @issprodPP  INT
DECLARE @issprodEnt INT
DECLARE @issprodSTR INT
DECLARE @defprodID  INT
DECLARE @defprodgrpID  INT
DECLARE @defprodgrpKey INT

BEGIN TRY

begin transaction
   DECLARE issC CURSOR LOCAL FORWARD_ONLY FOR 
   SELECT Issuer_Key, Issuer_Name 
   --SELECT @issName = Issuer_Name
   FROM Issuer_Format
   WHERE Issuer_Key in 
   (1461,1462,1463,1464,1465,1466,1468,1493,1494,1508,1514,1525,1526,1531,1532,1533,1534,1537)


   OPEN issC
   FETCH NEXT FROM issC into @issID, @issName
   WHILE @@FETCH_STATUS = 0
   BEGIN 

  
  -- insert name as string into Strings table
  INSERT INTO Strings
  Values (rtrim(@issName), 0)
  SET @strID = SCOPE_IDENTITY()

  SELECT @defprodID = [Prod_Key]
  FROM Product
  WHERE [Prod_Issuer_Format] = @issID
  and [Prod_DefaultProduct] = 1
  
  IF @defprodID is null
  BEGIN
  set @defprodID = 0
--  SELECT TOP 1 @defprodID = [Prod_Key]
--  FROM Product
--  WHERE [Prod_Issuer_Format] = @issID
  END
   
  SELECT @defprodgrpID = PGXProds_PGID, @defprodgrpKey = PGXProds_ProdGKey
  FROM ProdGroupXProds
  WHERE PGXProds_ProdKey = @defprodID
  select @defprodID, @defprodgrpID

 
 IF @PPcatID > 0 
 BEGIN
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
          ,[Prod_Key] as Prod_Child_Products --[Prod_Child_Products]
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
          ,SUBSTRING(rtrim(@issName) + ' PP', 1,25)
          ,0 --[Prod_DefaultProduct]
          ,0 --[Prod_IssueDate]
          ,0 --[Prod_ExpDate]
          ,0 --[Prod_Amount]
          ,@PPcatID --[Prod_CategoryID]
          ,0 --[Prod_U32]
      FROM [TerminalConfig].[dbo].[Product]
      where [Prod_Issuer_Format] = @issID
      --and [Prod_DefaultProduct] = 1
      and [Prod_Key] = @defprodID
   
      SET @issprodPP = SCOPE_IDENTITY()
      -- insert the issuer product into the PGxProducts table
      INSERT INTO ProdGroupXProds 
                 (PGXProds_ProdGKey, PGXProds_ProdKey, PGXProds_PGID, PGXProds_ProdName)
      values
      (@defprodgrpKey, @issprodPP, @defprodgrpID, rtrim(@issName) + ' ' + 'PP IssProd') 

   END

 IF @EntcatID > 0 
 BEGIN
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
          ,0 --NB!! this must be updated manually  --[Prod_Child_Products]
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
          ,SUBSTRING(rtrim(@issName) + ' Entl', 1,25)
          --,rtrim(@issName) + ' ' + 'Ent IssProd'
          ,0 --[Prod_DefaultProduct]
          ,0 --[Prod_IssueDate]
          ,0 --[Prod_ExpDate]
          ,0 --[Prod_Amount]
          ,@EntcatID --[Prod_CategoryID]
          ,0 --[Prod_U32]
      FROM [TerminalConfig].[dbo].[Product]
      where [Prod_Issuer_Format] = @issID
      --and [Prod_DefaultProduct] = 1
      and [Prod_Key] = @defprodID
   
      SET @issprodEnt = SCOPE_IDENTITY()
      -- insert the issuer product into the PGxProducts table
      INSERT INTO ProdGroupXProds 
                 (PGXProds_ProdGKey, PGXProds_ProdKey, PGXProds_PGID, PGXProds_ProdName)
      values
      (@defprodgrpKey, @issprodEnt, @defprodgrpID, rtrim(@issName) + ' ' + 'Ent IssProd') 
   END
          
 IF @STRcatID > 0 
 BEGIN
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
          ,0 --NB!! this must be updated manually  --[Prod_Child_Products]
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
          --,rtrim(@issName) + ' ' + 'STR IssProd'
          ,SUBSTRING(rtrim(@issName) + ' STR', 1,25)
         ,0 --[Prod_DefaultProduct]
          ,0 --[Prod_IssueDate]
          ,0 --[Prod_ExpDate]
          ,0 --[Prod_Amount]
          ,@STRcatID --[Prod_CategoryID]
          ,0 --[Prod_U32]
      FROM [TerminalConfig].[dbo].[Product]
      where [Prod_Issuer_Format] = @issID
      --and [Prod_DefaultProduct] = 1
      and [Prod_Key] = @defprodID
   
      SET @issprodSTR = SCOPE_IDENTITY()
      -- insert the issuer product into the PGxProducts table
      INSERT INTO ProdGroupXProds 
                 (PGXProds_ProdGKey, PGXProds_ProdKey, PGXProds_PGID, PGXProds_ProdName)
      values
      (@defprodgrpKey, @issprodSTR, @defprodgrpID, rtrim(@issName) + ' ' + 'STR IssProd') 
   END

 IF @CcatID > 0 
 BEGIN
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
          ,0 --NB!! this must be updated manually  --[Prod_Child_Products]
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
--          ,rtrim(@issName) + ' ' + 'Carnet IssProd'
          ,SUBSTRING(rtrim(@issName) + ' Carnet', 1,25)
          ,0 --[Prod_DefaultProduct]
          ,0 --[Prod_IssueDate]
          ,0 --[Prod_ExpDate]
          ,0 --[Prod_Amount]
          ,@CcatID --[Prod_CategoryID]
          ,0 --[Prod_U32]
      FROM [TerminalConfig].[dbo].[Product]
      where [Prod_Issuer_Format] = @issID
      --and [Prod_DefaultProduct] = 1
      and [Prod_Key] = @defprodID
   
      SET @issprodSTR = SCOPE_IDENTITY()
      -- insert the issuer product into the PGxProducts table
      INSERT INTO ProdGroupXProds 
                 (PGXProds_ProdGKey, PGXProds_ProdKey, PGXProds_PGID, PGXProds_ProdName)
      values
      (@defprodgrpKey, @issprodSTR, @defprodgrpID, rtrim(@issName) + ' ' + 'Carnet IssProd') 
   END
   
   
  FETCH NEXT FROM issC into @issID, @issName 
  END
  CLOSE issC
  DEALLOCATE issC



END TRY
BEGIN CATCH
   SELECT	@ErrorNumber = ERROR_NUMBER(),
			@ErrorMessage = ERROR_MESSAGE()
   select @ErrorNumber
   select @ErrorMessage
   --IF @@TRANCOUNT > 0
   --   ROLLBACK 
END CATCH


GO
execute [createIssDefProds_ST_PP] 3, 0, 0, 0, 15
--                (@PPcatID int, @EntcatID int, @STRcatID int, @CcatID int, @appType int)

--select prod_Key, Prod_description, Prod_CategoryID, Prod_U32 from Product

Go 
DROP PROCEDURE [dbo].[createIssDefProds_ST_PP] 

GO
commit transaction
