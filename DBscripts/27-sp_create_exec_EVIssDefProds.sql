USE [TerminalConfig_V5_MJ]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[createEVIssDefProds] 
                (@catID int, @appType int)
AS

DECLARE @updCnt         INT
DECLARE
	@ErrorNumber	INT,
	@ErrorMessage	NVARCHAR(4000)
DECLARE @issID      SMALLINT
DECLARE @issName    CHAR(24)
DECLARE @strID      INT
DECLARE @issprod    INT
DECLARE @defprodID  INT
DECLARE @defprodgrpID  INT
DECLARE @defprodgrpKey INT

BEGIN TRY

begin transaction
   DECLARE issC CURSOR LOCAL FORWARD_ONLY FOR 
   SELECT Issuer_Key, Issuer_Name 
   FROM Issuer_Format
        inner join [AppXref] on Issuer_key = AppXref_IssuerKey
        inner join [Application] on AppXref_AppKey = App_Key 
   WHERE App_Type = 3   --@appType
   and App_Key in
   (
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu]
    ,[Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 3
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

  --select @issID, @issName, @strID, @defprodID, @defprodgrpID
  
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
   -- insert the issuer product into the PGxProducts table
   INSERT INTO ProdGroupXProds 
             (PGXProds_ProdGKey, PGXProds_ProdKey, PGXProds_PGID, PGXProds_ProdName)
   values
   (@defprodgrpKey, @issprod, @defprodgrpID, rtrim(@issName) ) 

 

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
END CATCH



-- execute proc
GO
EXECUTE [createEVIssDefProds] 
6,3


-- check if inserted ok before doing commit
--select prod_key, prod_description, prod_categoryID, Prod_U32 from product

GO
DROP PROCEDURE [createEVIssDefProds] 

commit transaction
--rollback transaction



