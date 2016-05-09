USE [Terminal_config_MJ]
GO

-- create table ProductGroups
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
	[ProductGroup_IsGeneric] [bit] NOT NULL DEFAULT ((0)),
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



-- create table ProdGroupXProds
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


-- create table ProductDisablements
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



-- create table ConfigErrors
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


