USE [Terminal_config_MJ]
GO
---- create table ITSOProducts
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


---- create table ITSORules
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


---- create table IPEFields
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


---- create table IPEMapping
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