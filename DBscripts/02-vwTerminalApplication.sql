USE [Terminal_config_MJ]
GO
DROP  view [dbo].[vwTerminalApplication]
--
/****** Object:  View [dbo].[vwTerminalApplication]    Script Date: 04/01/2015 15:49:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  view [dbo].[vwTerminalApplication]
as
SELECT term_tillid, --application.*
       App_Key, App_Name, AppType_U32Type, App_Control, App_Default_Txn_Type
FROM Menu_Applications
inner join terminal on term_menukey = MenuApplications_MenuKey
inner join appxref on MenuApplications_AppKey = appxref_appkey
inner join application on appxref_appkey = app_key
inner join AppTypeDesc on AppType_Type = App_Type


GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A view of terminal applications grouped by tillid

SELECT term_tillid, 
       App_Key, App_Name, AppType_U32Type, App_Control, App_Default_Txn_Type
FROM Menu_Applications
inner join terminal on term_menukey = MenuApplications_MenuKey
inner join appxref on MenuApplications_AppKey = appxref_appkey
inner join application on appxref_appkey = app_key
inner join AppTypeDesc on AppType_Type = App_Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTerminalApplication'