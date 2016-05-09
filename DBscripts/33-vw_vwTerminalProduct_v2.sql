USE [Terminal_config_MJ]
GO
drop view [vwTerminalProduct]
/****** Object:  View [dbo].[vwTerminalProduct]    Script Date: 11/19/2015 12:22:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwTerminalProduct]
as
SELECT term_tillid, issuer_key, 
--product.*
[Prod_Key]
      ,[Prod_Issuer_Format]
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
      ,[Prod_Default_Amount]/100 as Prod_Default_Amount
      ,[Prod_Min_Amount]/100 as Prod_Min_Amount
      ,[Prod_Max_Amount]/100 as Prod_Max_Amount
      ,[Prod_Label_Display]
      ,[Prod_Label_Print]
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
      ,[Prod_Description]
      ,[Prod_DefaultProduct]
      ,[Prod_IssueDate]
      ,[Prod_ExpDate]
FROM Menu_Applications
inner join terminal on term_menukey = MenuApplications_MenuKey
inner join appxref on MenuApplications_AppKey = appxref_appkey
inner join issuer_format on appxref_issuerkey = issuer_key
inner join product on prod_issuer_format = issuer_key
WHERE Prod_U32 = 1




GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A view of terminal products, grouped by till id

SELECT term_tillid, issuer_key, 
--product.*
[Prod_Key]
      ,[Prod_Issuer_Format]
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
      ,[Prod_Default_Amount]/100 as Prod_Default_Amount
      ,[Prod_Min_Amount]/100 as Prod_Min_Amount
      ,[Prod_Max_Amount]/100 as Prod_Max_Amount
      ,[Prod_Label_Display]
      ,[Prod_Label_Print]
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
      ,[Prod_Description]
      ,[Prod_DefaultProduct]
      ,[Prod_IssueDate]
      ,[Prod_ExpDate]

FROM Menu_Applications
inner join terminal on term_menukey = MenuApplications_MenuKey
inner join appxref on MenuApplications_AppKey = appxref_appkey
inner join issuer_format on appxref_issuerkey = issuer_key
inner join product on prod_issuer_format = issuer_key
WHERE Prod_U32 = 1'
, @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTerminalProduct'
