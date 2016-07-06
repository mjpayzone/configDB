USE [TerminalConfig_v5_dev]
GO

declare @newID smallint
declare @newprod smallint

BEGIN TRANSACTION 

---- null out 50p game categoryIDs to exclude from feed
update product
set prod_categoryID = null 
where prod_key in 
(select prod_key 
from product
inner join AppXref on AppXref_IssuerKey = prod_issuer_format 
inner join Application on AppXref_AppKey = app_key
where app_name like '%50p%'
)
-- prod_key in (3903, 3904, 3905, 3906, 3907, 3908, 4018, 4019)


---- insert new issuer same as current issuer for 'Activate and Play'
INSERT INTO [Issuer_Format]
select 'Play With Card'
           ,[Issuer_PanLength]
           ,[Issuer_Luhn]
           ,[Issuer_ExpiryDate]
           ,[Issuer_StartDate]
           ,[Issuer_VISA]
           ,[Issuer_Switch]
           ,[Issuer_Access]
           ,[Issuer_110]
           ,[Issuer_KeyEntry]
           ,[Issuer_Hotlist]
           ,[Issuer_Specific]
           ,[Issuer_PoundsAmount]
           ,[Issuer_AreaCode]
           ,[Issuer_ExtendedService]
           ,[Issuer_CRNCheck]
           ,[Issuer_Pan_Length_A]
           ,[Issuer_Pan_Length_B]
           ,[Issuer_Expiry_Date_Offset]
           ,[Issuer_Start_Date_Offset]
           ,[Issuer_Fund_Type_Length]
           ,[Issuer_Fund_Type_Offset]
           ,[Issuer_Card_Issue_Length]
           ,[Issuer_Card_Issue_Offset]
           ,[Issuer_Bar_Code_Length]
           ,[Issuer_Bar_Code_Offset]
           ,[Issuer_Discretionary_Length]
           ,[Issuer_Discretionary_Offset]
           ,[Issuer_CRN_Offset]
           ,[Issuer_CRN_Length]
           ,[Issuer_CRN_Text]
           ,[Issuer_CRN_Format]
           ,[Issuer_PANFormat]
           ,[Issuer_AlternativeIssuer]
           ,[Issuer_NUA_1]
           ,[Issuer_NUA_2]
           ,[Issuer_Brand_Name]
           ,[Issuer_Auth_Text]
           ,[Issuer_Receipt1]
           ,[Issuer_Receipt2]
           ,[Issuer_Receipt3]
           ,[Issuer_Receipt4]
           ,[Issuer_Receipt5]
           ,[Issuer_Receipt6]
           ,[Issuer_Auth_Host_ID]
           ,[Issuer_FloorLimit]
           ,[Issuer_ConsecutiveTxn]
           ,[Issuer_SelectorCard]
           ,[Issuer_PChequeSignatureRequired]
           ,[Issuer_MinMaxLimit]
           ,[Issuer_TokenLowToken]
           ,[Issuer_TokenHighToken]
           ,[Issuer_Label_String]
           ,[Issuer_UtilityType]
           ,[Issuer_Logo]
           ,[Issuer_ExpiryDateFormat]
           ,[Issuer_MaxTimesPerDay]
           ,[Issuer_StartDateFormat]
           ,[Issuer_BarcodeScanFund]
           ,[Issuer_MenuIndex]
           from issuer_format 
           where issuer_key = 1114
           
-- select * from issuer_format
 SET @newID = SCOPE_IDENTITY()
 select @newID as newID
 
 
---- now link long activate and play IIN to this new iss
 update issuer_range
 set IssuerRange_IssuerFormat_Key = @newID
 where IssuerRange_IssuerFormat_Key = 1114
  and  IssuerRange_IssuerFormat = '98261650'

-- select IssuerRange_Issue_Key, IssuerRange_IssuerFormat_Key, IssuerRange_IssuerFormat
-- from issuer_range, issuer_format 
-- where IssuerRange_IssuerFormat_Key = issuer_key
-- and issuer_key in (1114)

---- now add new issuer to same app as iss 1114
insert into AppXref
values 
(@newID, (select app_key from application where app_name like 'Health Lotry $1') ) 
-- select * from AppXref where AppXref_AppKey = 28


---- add prod for play with card
insert into product
SELECT @newID
      ,[Prod_Fund_Type]
      ,[Prod_Cash_Enable]
      ,[Prod_PCheque_Enable]
      ,[Prod_NoPayment_Enable]
      ,[Prod_RefundCash_Enable]
      ,[Prod_Amount_Type]
      ,[Prod_Whole_Currency]
      ,[Prod_Prompt1_Enable]
      ,[Prod_Prompt2_Enable]
      ,[Prod_Prompt3_Enable]
      ,[Prod_Next_Product_Index]
      ,[Prod_Child_Products]
      ,[Prod_Z_Totals_group]
      ,[Prod_Default_Amount]
      ,[Prod_Min_Amount]
      ,[Prod_Max_Amount]
      ,(select top 1 strings_Key from Strings where strings_text like 'Play with Card%') --[Prod_Label_Display]
      ,(select top 1 strings_Key from Strings where strings_text like 'Play with Card%') --[Prod_Label_Print]
      ,[Prod_Prompt1_Display]
      ,[Prod_Prompt1_Print]
      ,[Prod_Prompt2_Display]
      ,[Prod_Prompt2_Print]
      ,[Prod_Prompt3_Display]
      ,[Prod_Prompt3_Print]
      ,[Prod_Confirmation_ReEntry1]
      ,[Prod_AlphaNumeric1]
      ,[Prod_Static_Text1]
      ,[Prod_Prompt_Data_Length1]
      ,[Prod_Confirmation_ReEntry2]
      ,[Prod_AlphaNumeric2]
      ,[Prod_Static_Text2]
      ,[Prod_Prompt_Data_Length2]
      ,[Prod_Confirmation_ReEntry3]
      ,[Prod_AlphaNumeric3]
      ,[Prod_Static_Text3]
      ,[Prod_Prompt_Data_Length3]
      ,[Prod_SelectorControl]
      ,[Prod_SelectorIssuer]
      ,[Prod_SelectorText]
      ,'Play with Card' --[Prod_Description]
      ,[Prod_DefaultProduct]
      ,[Prod_IssueDate]
      ,[Prod_ExpDate]
      ,[Prod_Amount]
      ,[Prod_CategoryID]
      ,[Prod_U32]
      ,[Prod_UI_Flow]
      ,[Prod_Ordinal]
  FROM [Product]
  where prod_key = 2730
  
  
 SET @newprod = SCOPE_IDENTITY()
 select @newprod as newprod

insert into ProdGroupXProds
values
((select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'THL%'), 
 @newprod, 
 (select ProductGroup_Key from ProductGroups where ProductGroup_Desc like 'THL%'), 
 'THL Play with Card')


----- this is for testing
EXECUTE [getGenProductsCategory] 
14

commit transaction 
-- rollback transaction          



           
