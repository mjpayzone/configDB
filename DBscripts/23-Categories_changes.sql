USE [Terminal_config_MJ]
GO
-------------------------------------------------------------------------------------------------------------------------------------
--   new table Categories
-------------------------------------------------------------------------------------------------------------------------------------
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
--   add new field Prod_CategoryID TO Product table
-------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE [dbo].[Product]
ADD 
Prod_CategoryID INT,
Prod_U32 SMALLINT NOT NULL DEFAULT 1


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
           
-------------------------------------------------------------------------------------------------------------------------------------
--   
-------------------------------------------------------------------------------------------------------------------------------------
