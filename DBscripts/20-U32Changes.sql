USE [TerminalConfig_V5_MJ]
GO
--------------------------------------------------------------------------------------------------------------------------------------------------
--- vwTerminalProduct view,  changes to cater for now pence columns and U32 applicable
--------------------------------------------------------------------------------------------------------------------------------------------------
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
       ,CASE WHEN ([Prod_Max_Amount]%100) > 0 THEN [Prod_Max_Amount]/100 + 1 
            ELSE [Prod_Max_Amount]/100 END as Prod_Max_Amount
--      ,[Prod_Max_Amount]/100 as Prod_Max_Amount
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
WHERE Prod_U32 in (1,2)




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
       ,CASE WHEN ([Prod_Max_Amount]%100) > 0 THEN [Prod_Max_Amount]/100 + 1 
            ELSE [Prod_Max_Amount]/100 END as Prod_Max_Amount
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
WHERE Prod_U32 = in (1,2)'
, @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTerminalProduct'





--------------------------------------------------------------------------------------------------------------------------------------------------
-- ts3_GetTill - changes TO cater FOR dropped COLUMNS - these were NOT used IN Origin FOR the config
--------------------------------------------------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[ts3_GetTill]    Script Date: 02/09/2016 09:37:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ts3_GetTill] @TillID int
AS

SELECT Till.*,
   Term_TillID, 
   Term_DownLoadPrintFileEnable, 
   Term_SmartPowerEnable, 
   Term_QuantumEnable, 
   Term_QuantumDebtEnable, 
   Term_TalexusEnable, 
   Term_HotCardsEnabled, 
   Term_TalexusRegionID, 
   Term_SPKeySet, 
   Term_NumTalexusTariffs, 
   Term_NumTalexusSAs, 
   Term_NumQuantumRegions, 
   Term_NumQuantumCommands, 
   Term_NumSPTariffs, 
   Term_NumSPCommands, 
   Term_NumHotCards, 
   Term_NumSPRECIDs, 
   Term_CurrencySymbol, 
   Term_CurrencyCode, 
   Term_CurrencyPlaces, 
   Term_ReceiptHeader1, 
   Term_ReceiptHeader2, 
   Term_ReceiptHeader3, 
   Term_ReceiptHeader4, 
   Term_StockDayOfWeek, 
   Term_StockDaysToAudit, 
   Term_PaperType, 
   Term_MenuKey, 
   Term_RefreshTalexus,
   Term_RefreshQuantum,
   Term_RefreshSmartPower,
   Term_RefreshHotList,
   Term_RefreshPrintFile,
   Term_TxnUpload,
   Term_Hour,
   Term_Minute,
   Term_MasterConfig,
   Term_MASoftware,
   Term_EFTConfig,
   Term_EFTSoftware,
   Term_StockGroup,
   --Signature,
   Status,
   --Name,
   --Description,
   --Registration_Date,
   ctl_TillID,
   ctl_EODHostReconcile, 
   ctl_TZTerminal, 
   ctl_ErrorText, 
   ctl_ModemTele, 
   ctl_ETUDisID, 
   ctl_CLICapture, 
   ctl_ConfirmReqAct, 
   ctl_DefaultKey, 
   ctl_CheckMAC, 
   ctl_CheckCLI, 
   ctl_MonOpen, 
   ctl_MonClose, 
   ctl_TueOpen, 
   ctl_TueClose, 
   ctl_WedOpen, 
   ctl_WedClose, 
   ctl_ThuOpen, 
   ctl_ThuClose, 
   ctl_FriOpen, 
   ctl_FriClose, 
   ctl_SatOpen, 
   ctl_SatClose, 
   ctl_SunOpen, 
   ctl_SunClose, 
   ctl_ResetMAC, 
   ctl_ResetTotals,
   ctl_TillStatus,
	EFT_TerminalIdentity.*,
	EFT_MerchantAdvertCourtesy.*, 
	EFT_EMVAppConfig.*
FROM Till
LEFT OUTER JOIN tblTillControl on TIll_ID = ctl_TILLID
LEFT OUTER JOIN Terminal on Till_ID = Term_TillID
LEFT OUTER JOIN EFT_TerminalIdentity ON Till_ID = EFTTerm_TillID
LEFT OUTER JOIN EFT_MerchantAdvertCourtesy ON Till_ID = EFTAdvert_TillID
LEFT OUTER JOIN EFT_EMVAppConfig ON Till_ID = EMVConfig_TillID
WHERE Till_ID = @TillID



