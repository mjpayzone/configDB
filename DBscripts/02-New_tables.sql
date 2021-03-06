USE [TerminalConfig_V5_MJ]
GO

----------------------------------------------
--
-- PRODUCTGROUP TABLES
--
----------------------------------------------


-- create TABLE ProductGroups
/****** Object:  Table [dbo].[ProductGroups]    Script Date: 10/15/2015 16:22:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductGroups](
	[ProductGroup_Key] [int] IDENTITY(1,1) NOT NULL,
	[ProductGroup_ID] [smallint] NOT NULL,
	[ProductGroup_Desc] [varchar](100) NOT NULL,
	[ProductGroup_IsGeneric] [tinyint] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_ProductGroups] PRIMARY KEY CLUSTERED 
(
	[ProductGroup_Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key for this table. Identity column incremented by 1 for every new row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductGroups', @level2type=N'COLUMN',@level2name=N'ProductGroup_Key'


-- create table ProdsXTerminal.
/****** Object:  Table [dbo].[ProdsXTerminal]    Script Date: 10/15/2015 16:25:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProdsXTerminal](
	[ProdsXTerminal_Key] [int] IDENTITY(1,1) NOT NULL,
	[ProdsXTerminal_ProdGKey] [int] NOT NULL,
	[ProdsXTerminal_TermTillIDKey] [int] NOT NULL,
 CONSTRAINT [PK_ProdsXTerminal] PRIMARY KEY CLUSTERED 
(
	[ProdsXTerminal_Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [Uniq_ProdgroupTerminal] UNIQUE NONCLUSTERED 
(
	[ProdsXTerminal_ProdGKey] ASC,
	[ProdsXTerminal_TermTillIDKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key for this table. Identity column incremented by 1 for every new row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProdsXTerminal', @level2type=N'COLUMN',@level2name=N'ProdsXTerminal_Key'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key to Product table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProdsXTerminal', @level2type=N'COLUMN',@level2name=N'ProdsXTerminal_ProdGKey'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key to Terminal table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProdsXTerminal', @level2type=N'COLUMN',@level2name=N'ProdsXTerminal_TermTillIDKey'
GO
ALTER TABLE [dbo].[ProdsXTerminal]  WITH NOCHECK ADD  CONSTRAINT [FK_ProdsXTerminal_Terminal] FOREIGN KEY([ProdsXTerminal_TermTillIDKey])
REFERENCES [dbo].[Terminal] ([Term_TillID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProdsXTerminal] CHECK CONSTRAINT [FK_ProdsXTerminal_Terminal]


-------------------------------------------
-- create table ProdGroupXProds
-------------------------------------------
/****** Object:  Table [dbo].[ProdGroupXProds]    Script Date: 10/15/2015 16:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProdGroupXProds](
	[PGXProds_Key] [int] IDENTITY(1,1) NOT NULL,
	[PGXProds_ProdGKey] [int] NOT NULL,
	[PGXProds_ProdKey] [smallint] NOT NULL,
	[PGXProds_PGID] [smallint] NOT NULL,
	[PGXProds_ProdName] [varchar](50) NULL,
 CONSTRAINT [PK_ProdGroupXProds] PRIMARY KEY CLUSTERED 
(
	[PGXProds_Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key for this table. Identity column incremented by 1 for every new row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProdGroupXProds', @level2type=N'COLUMN',@level2name=N'PGXProds_Key'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key to ProductGroups table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProdGroupXProds', @level2type=N'COLUMN',@level2name=N'PGXProds_ProdGKey'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key to Product table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProdGroupXProds', @level2type=N'COLUMN',@level2name=N'PGXProds_ProdKey'
GO
ALTER TABLE [dbo].[ProdGroupXProds]  WITH NOCHECK ADD  CONSTRAINT [FK_ProdGroupXProds_ProdGroups] FOREIGN KEY([PGXProds_ProdGKey])
REFERENCES [dbo].[ProductGroups] ([ProductGroup_Key])
GO
ALTER TABLE [dbo].[ProdGroupXProds] CHECK CONSTRAINT [FK_ProdGroupXProds_ProdGroups]
GO
ALTER TABLE [dbo].[ProdGroupXProds]  WITH NOCHECK ADD  CONSTRAINT [FK_ProdGroupXProds_Products] FOREIGN KEY([PGXProds_ProdKey])
REFERENCES [dbo].[Product] ([Prod_Key])
GO
ALTER TABLE [dbo].[ProdGroupXProds] CHECK CONSTRAINT [FK_ProdGroupXProds_Products]

-----------------------------------------------
-- create table ProductDisablements
------------------------------------------------
/****** Object:  Table [dbo].[ProductDisablements]    Script Date: 10/15/2015 16:24:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductDisablements](
	[PD_Key] [int] IDENTITY(1,1) NOT NULL,
	[PD_TillID] [int] NOT NULL,
	[PD_TID] [int] NOT NULL,
	[PD_ProdKey] [smallint] NOT NULL,
	[PD_PGID] [smallint] NOT NULL,
	[PD_Desc] [varchar](50) NULL,
 CONSTRAINT [PK_ProductDisablements] PRIMARY KEY CLUSTERED 
(
	[PD_Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key for this table. Identity column incremented by 1 for every new row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductDisablements', @level2type=N'COLUMN',@level2name=N'PD_Key'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key to Product table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductDisablements', @level2type=N'COLUMN',@level2name=N'PD_ProdKey'
GO
ALTER TABLE [dbo].[ProductDisablements]  WITH NOCHECK ADD  CONSTRAINT [FK_PD_Products] FOREIGN KEY([PD_ProdKey])
REFERENCES [dbo].[Product] ([Prod_Key])
GO
ALTER TABLE [dbo].[ProductDisablements] CHECK CONSTRAINT [FK_PD_Products]


--------------------------------------
-- create table ConfigErrors
--------------------------------------
/****** Object:  Table [dbo].[ConfigErrors]    Script Date: 10/15/2015 16:27:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ConfigErrors](
	[ConfigErr_Key] [int] IDENTITY(1,1) NOT NULL,
	[ConfigErr_Tid] [int] NOT NULL,
	[ConfigErr] [smallint] NOT NULL,
	[ConfigErr_Desc] [varchar](250) NOT NULL,
	[ConfigErr_Date] [smalldatetime] NOT NULL CONSTRAINT [DF_ConfigErrors_ConfigErr_Date]  DEFAULT (getdate())
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF


----------------
--
-- ITSO TABLES
--
----------------

GO
----------------------------------------
---- create table ITSOProducts
-----------------------------------------
/****** Object:  Table [dbo].[ITSOProducts]    Script Date: 10/21/2015 17:31:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ITSOProducts](
	[IP_Key] [int] IDENTITY(1,1) NOT NULL,
	[IP_ID] [smallint] NOT NULL,
	[IP_FieldsKey] [smallint] NOT NULL,
	[IP_Value] [int] NOT NULL,
 CONSTRAINT [PK_ITSOProducts] PRIMARY KEY CLUSTERED 
(
	[IP_Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ITSOProducts]  WITH NOCHECK ADD  CONSTRAINT [FK_Products] FOREIGN KEY([IP_ID])
REFERENCES [dbo].[Product] ([Prod_Key])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ITSOProducts] CHECK CONSTRAINT [FK_Products]

------------------------------------
---- create table ITSORules
-------------------------------------
/****** Object:  Table [dbo].[ITSORules]    Script Date: 10/21/2015 17:31:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ITSORules](
	[IR_Key] [int] NOT NULL,
	[IR_ProductID] [int] NOT NULL,
	[IR_Rules] [varchar](500) NOT NULL,
	[IR_Actions] [varchar](500) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

-----------------------------------
---- create table IPEFields
-----------------------------------
GO
/****** Object:  Table [dbo].[IPEFields]    Script Date: 10/21/2015 17:29:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IPEFields](
	[IPE_Key] [int] IDENTITY(1,1) NOT NULL,
	[IPE_Field] [varchar](250) NOT NULL,
 CONSTRAINT [PK_IPEFields] PRIMARY KEY CLUSTERED 
(
	[IPE_Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO 

--------------------------------------
---- create table IPEMapping
--------------------------------------
/****** Object:  Table [dbo].[IPEMapping]    Script Date: 10/21/2015 17:30:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[IPEMapping](
	[IPEM_key] [int] IDENTITY(1,1) NOT NULL,
	[IPEM_field] [int] NOT NULL,
	[IPEM_IPEtype] [smallint] NOT NULL,
	[IPEM_datagroup] [varchar](15) NOT NULL,
	[IPEM_rev] [smallint] NOT NULL,
	[IPEM_datatype] [varchar](15) NOT NULL,
	[IPEM_offset] [int] NOT NULL,
	[IPEM_length] [int] NOT NULL,
 CONSTRAINT [PK_IPEMapping] PRIMARY KEY CLUSTERED 
(
	[IPEM_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[IPEMapping]  WITH NOCHECK ADD  CONSTRAINT [FK_IPEfields] FOREIGN KEY([IPEM_field])
REFERENCES [dbo].[IPEFields] ([IPE_Key])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[IPEMapping] CHECK CONSTRAINT [FK_IPEfields]

---

-------------------------------------------------------------------------------------------------------------------------------------
--   table MerchantSites
-------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  Table [dbo].[MerchantSites]    Script Date: 05/20/2015 16:33:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MerchantSites](
	[Site_Key] [int] IDENTITY(1,1) NOT NULL,
	[Site_ID] [int] NOT NULL,
	[Site_Name] [char](24) NOT NULL,
	[Site_Addr1] [char](24) NOT NULL,
	[Site_Addr1a] [char](24) NULL,
	[Site_Addr2] [char](24) NOT NULL,
	[Site_Addr3] [char](24) NULL,
	[Site_Postcode] [char](10) NULL,
	[Site_Tel] [char](16) NULL,
	[Site_Status] [char](3) NOT NULL,
	[Site_Contact] [char](24) NULL,
	[Site_CreditLimit] [int] NOT NULL DEFAULT ((30000)),
	[Site_Enabled] [char](1) NULL,
	[Site_EnabledMsg] [char](24) NULL,
	[Site_MonOpen] [char](4) NULL,
	[Site_MonClose] [char](4) NULL,
	[Site_TueOpen] [char](4) NULL,
	[Site_TueClose] [char](4) NULL,
	[Site_WedOpen] [char](4) NULL,
	[Site_WedClose] [char](4) NULL,
	[Site_ThuOpen] [char](4) NULL,
	[Site_ThuClose] [char](4) NULL,
	[Site_FriOpen] [char](4) NULL,
	[Site_FriClose] [char](4) NULL,
	[Site_SatOpen] [char](4) NULL,
	[Site_SatClose] [char](4) NULL,
	[Site_SunOpen] [char](4) NULL,
	[Site_SunClose] [char](4) NULL,
 CONSTRAINT [PK_MerchantSites] PRIMARY KEY CLUSTERED 
(
	[Site_Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key for this table. Identity column increments by 1 for every new record.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MerchantSites', @level2type=N'COLUMN',@level2name=N'Site_Key'



-------------------------------------------------------------------------------------------------------------------------------------
--   table EnablementRules
-------------------------------------------------------------------------------------------------------------------------------------
GO
/****** Object:  Table [dbo].[EnablementRules]    Script Date: 09/24/2015 14:21:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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


-----------------------------------
-- Categories table
-----------------------------------
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 10/09/2015 14:26:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Categories](
	[Cgr_Key ] [int] IDENTITY(1,1) NOT NULL,
	[Cgr_Name] [varchar](50) NOT NULL,
	[Cgr_Parent] [int] NULL,
	[Cgr_Visible] [smallint] NOT NULL,
	[Cgr_AppType] [smallint] NOT NULL,
	[Cgr_TxnType] [smallint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

-------------------------------------------------------------------------------------------------------------------------------------
--   populate Categories table
-------------------------------------------------------------------------------------------------------------------------------------
declare @prntID int

BEGIN TRANSACTION

 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('SmartTicket', null,0,15,0)
  SET @prntID = SCOPE_IDENTITY()
          

 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('STR TopUp', @prntID,1,15,1)

 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('Product Purchase', @prntID,1,15,2)

 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('Entitlements', @prntID,1,15,0)

 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('Carnet TopUp', @prntID,1,15,7)

 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('EVoucher', null,1,3,0)
 
 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('ETU', null,1,1,0)

 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('BillPay Utilities', null,1,8,0)

 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('BillPay Stock', null,1,8,0)

 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('BillPay PZ Requests', null,1,8,0)
           
 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('Talexus', null,1,4,0)
           
 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('Quantum', null,1,5,0)

 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('Tolling Dart Charge', null,1,18,0)

 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('THL', null,1,19,0)

 INSERT INTO [Categories]
           ([Cgr_Name],[Cgr_Parent],[Cgr_Visible],[Cgr_AppType],[Cgr_TxnType])
     VALUES
           ('NEXT Returns', null,1,12,0)

      
COMMIT TRANSACTION

--select * from Categories
           

---------------------
--
-- printfiles tables 
--
---------------------
/****** Object:  Table [dbo].[DDlineFiles]    Script Date: 11/11/2015 15:02:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DDlineFiles](
	[ddf_Key] [int] IDENTITY(1,1) NOT NULL,
	[ddf_Site] [int] NOT NULL,
	[ddf_Date] [date] NOT NULL DEFAULT (getdate()),
	[ddf_FileString] [varchar](max) NOT NULL,
 CONSTRAINT [PK_ddf] PRIMARY KEY CLUSTERED 
(
	[ddf_Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

--

GO
/****** Object:  Table [dbo].[InvoiceFiles]    Script Date: 11/11/2015 15:03:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InvoiceFiles](
	[invf_Key] [int] IDENTITY(1,1) NOT NULL,
	[invf_Site] [int] NOT NULL,
	[invf_FileString] [varchar](max) NOT NULL,
	[invf_Date] [date] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_invf] PRIMARY KEY CLUSTERED 
(
	[invf_Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

--

GO
/****** Object:  Table [dbo].[StatementFiles]    Script Date: 11/11/2015 15:03:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StatementFiles](
	[stmf_Key] [int] IDENTITY(1,1) NOT NULL,
	[stmf_Site] [int] NOT NULL,
	[stmf_FileString] [varchar](max) NOT NULL,
	[stmf_Date] [date] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_stmf] PRIMARY KEY CLUSTERED 
(
	[stmf_Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF



-----------------------
-- TMS Tables
-----------------------
GO

-- TMSdata

CREATE TABLE [dbo].[TMSdata](
	[TMS_TillID] [int] NOT NULL,
	[TMS_MA_SystemPwd] [varchar](8) NULL,
	[TMS_PA_AdminPwd] [varchar](8) NULL,
	[TMS_MA_DloadStart] [char](4) NULL,
	[TMS_MA_DloadEnd] [char](4) NULL,
	[TMS_MA_DloadInt] [int] NULL,
	[TMS_MA_WiFi] [tinyint] NULL,
	[TMS_PA_IP] [tinyint] NULL,
	[TMS_PA_DialBackup] [tinyint] NULL,
	[TMS_MA_PBXaccess] [varchar](6) NULL,
	[TMS_PA_ClerkPrcsing] [tinyint] NULL,
	[TMS_AppProfileCode] [varchar](20) NULL,
	[TMS_PaymentEnabled] [tinyint] NULL,
	[RowVersion] [timestamp] NOT NULL,
 CONSTRAINT [PK_TMSdata] PRIMARY KEY CLUSTERED 
(
	[TMS_TillID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TMSdata]  WITH CHECK ADD  CONSTRAINT [FK_TMSdata_Till] FOREIGN KEY([TMS_TillID])
REFERENCES [dbo].[Till] ([Till_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TMSdata] CHECK CONSTRAINT [FK_TMSdata_Till]

-- TMSRebuilds

GO

CREATE TABLE dbo.TMSRebuilds
(
	TR_ID		INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	TR_TerminalID	VARCHAR(50) NOT NULL,
	TR_Date		DATETIME2 NOT NULL	
)