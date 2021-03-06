USE [TerminalConfig_V5_MJ]
GO

-------------------------------------------------------------------------------------------------------------------------
-- create AppTypeDesc table
-------------------------------------------------------------------------------------------------------------------------
/****** Object:  Table [dbo].[AppTypeDesc]    Script Date: 10/14/2015 17:02:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AppTypeDesc](
	[AppType_Type] [int] NOT NULL,
	[AppType_U32Type] [int] NOT NULL,
	[AppType_Desc] [varchar](25) NOT NULL,
 CONSTRAINT [AppType_Type] UNIQUE NONCLUSTERED 
(
	[AppType_Type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

-------------------------------------------------------------------------------------------------------------------------
-- populate the table created above
-------------------------------------------------------------------------------------------------------------------------
INSERT INTO [AppTypeDesc]   ( [AppType_Type],  [AppType_U32Type],  [AppType_Desc])
     VALUES
     (1, 1,	'ETU')

INSERT INTO [AppTypeDesc]   ( [AppType_Type],  [AppType_U32Type],  [AppType_Desc])
     VALUES
     (2, 2,	'KeyPad')

INSERT INTO [AppTypeDesc]   ( [AppType_Type],  [AppType_U32Type],  [AppType_Desc])
     VALUES
     (3, 3,	'E-Voucher')

INSERT INTO [AppTypeDesc]   ( [AppType_Type],  [AppType_U32Type],  [AppType_Desc])
     VALUES
     (4, 4,	'Talexus')

INSERT INTO [AppTypeDesc]   ( [AppType_Type],  [AppType_U32Type],  [AppType_Desc])
     VALUES
     (5, 5,	'Quantum')

INSERT INTO [AppTypeDesc]   ( [AppType_Type],  [AppType_U32Type],  [AppType_Desc])
    VALUES
     (8, 8,	'Bill Payments')

INSERT INTO [AppTypeDesc]   ( [AppType_Type],  [AppType_U32Type],  [AppType_Desc])
    VALUES
     (10, 10,	'Bus Tickets')

INSERT INTO [AppTypeDesc]   ( [AppType_Type],  [AppType_U32Type],  [AppType_Desc])
     VALUES
     (12, 12,	'Retail Returns')

INSERT INTO [AppTypeDesc]   ( [AppType_Type],  [AppType_U32Type],  [AppType_Desc])
     VALUES
     (15, 15,	'SmartTicketing')

INSERT INTO [AppTypeDesc]   ( [AppType_Type],  [AppType_U32Type],  [AppType_Desc])
    VALUES
     (16, 16,	'Hermes Parcels')

INSERT INTO [AppTypeDesc]   ( [AppType_Type],  [AppType_U32Type],  [AppType_Desc])
     VALUES
     (18, 18,	'Dartford Charge')

INSERT INTO [AppTypeDesc]   ( [AppType_Type],  [AppType_U32Type],  [AppType_Desc])
     VALUES
     (19, 1, 'Health Lottery')
     
-- select * from [AppTypeDesc]

-------------------------------------------------------------------------------------------------------------------------
-- reset app_type to 19 for THL in Application table
-------------------------------------------------------------------------------------------------------------------------
BEGIN TRANSACTION
UPDATE [Application]
   SET [App_Type] = 19
WHERE App_Key in (28, 31, 189)
and 
app_name like '%health%'
COMMIT TRANSACTION 

-------------------------------------------------------------------------------------------------------------------------
-- add message type 
-------------------------------------------------------------------------------------------------------------------------
GO
ALTER TABLE [AppTypeDesc]
ADD AppType_MsgType smallint not null default 0

GO
begin transaction
--rollback transaction

update [AppTypeDesc]
set AppType_MsgType = 2
where AppType_Type in (1,3,10,18) -- ETU, EV, BusTickets, Tolling 

update [AppTypeDesc]
set AppType_MsgType = 1
where AppType_Type = 8 -- Bill Payments

update [AppTypeDesc]
set AppType_MsgType = 3
where AppType_Type = 15 -- SmartTicketing

update [AppTypeDesc]
set AppType_MsgType = 4
where AppType_Type in (12,16) -- NEXT Returns, Hermes Parcels

update [AppTypeDesc]
set AppType_MsgType = 5
where AppType_Type = 2 -- KeyPad

update [AppTypeDesc]
set AppType_MsgType = 6
where AppType_Type = 19 -- THL

update [AppTypeDesc]
set AppType_MsgType = 9
where AppType_Type = 5 -- Quantum

update [AppTypeDesc]
set AppType_MsgType = 8
where AppType_Type = 4 -- Talexus

--rollback transaction
commit transaction


-------------------------------------------------------------------------------------------------------------------------
-- add foreign key to application to ensure entries in both apptypedesc and application
-------------------------------------------------------------------------------------------------------------------------
ALTER TABLE [dbo].[Application]  WITH NOCHECK ADD  CONSTRAINT [FK_AppType_AppTypeDesc] FOREIGN KEY([App_Type])
REFERENCES [dbo].[AppTypeDesc] ([AppType_Type])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Application] CHECK CONSTRAINT [FK_AppType_AppTypeDesc]



