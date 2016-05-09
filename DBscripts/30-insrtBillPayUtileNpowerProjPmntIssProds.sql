USE [Terminal_config_MJ]
GO

DECLARE @issID smallint
DECLARE @strID int
DECLARE @appID int
DECLARE @catID int
DECLARE @prodID int
DECLARE @PDID int
DECLARE @defID smallint

BEGIN TRANSACTION
--rollback transaction

SELECT @catID = Cgr_Key  FROM Categories
WHERE Cgr_Name LIKE 'BillPay Utilities%'
select @catID as catID

INSERT INTO [Strings]
VALUES
  ('BillPayUtilities NPOWER' , 0)
SET @strID = SCOPE_IDENTITY()
-- select @strID as strID

-- More than one issuer named NPOWER, so can only use the below to get all of them.  
-- Of the 3, one the ones with multiple products get issuer products
-- So choose the 2 with multiple product, one will have Projetc Paymenet as Produc Name,
-- the other will have multiple product names
--
--for issuer 110
SET @issID = 110

 
 SELECT @defID = Prod_Key FROM Product
 WHERE Prod_Issuer_Format = @issID
 AND Prod_DefaultProduct = 1
 select @defID as defID

 INSERT INTO Product
 VALUES(
      @issID --[Prod_Issuer_Format]
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
      ,@defID --[Prod_Child_Products] => [Prod_Key] of default prod
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
      ,'BillPayUtils NPOWER ProjP' -- defprodname for issuer with Project Payment name
      ,0 --[Prod_DefaultProduct]
      ,0 --[Prod_IssueDate]
      ,0 --[Prod_ExpDate]
      ,0 --[Prod_Amount]
      ,@catID --[Prod_CategoryID]
      ,0 --[Prod_U32]
      )
          
SET @prodID = SCOPE_IDENTITY()
select @prodID as ProdID

-- insert into ProdGroupXProds table 
INSERT INTO [ProdGroupXProds]
           ([PGXProds_ProdGKey], [PGXProds_ProdKey],[PGXProds_PGID],[PGXProds_ProdName])
     VALUES
           (13 -- 
            ,@prodID -- ProductGroup_Key for 'BillPay Utilities UK'
            ,13 -- ProductGroup_ID for 'BillPay Utilities UK'  
            ,'BillPayUtilities NPOWER PPIssProd')

select * from [ProdGroupXProds] where PGXProds_ProdKey = @prodID


Commit Transaction
--Rollback Transaction
