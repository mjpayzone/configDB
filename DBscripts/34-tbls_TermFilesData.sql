USE [Terminal_config_MJ]
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