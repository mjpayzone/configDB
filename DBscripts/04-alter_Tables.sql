USE [TerminalConfig_V5_MJ]
GO 

-------------
-- Till table
-------------

ALTER TABLE [dbo].[Till]
ADD 
Till_Status CHAR(3)

GO
--select cast(Till_terminalNo as INT) from Till
ALTER TABLE [dbo].[Till]
ALTER COLUMN Till_TerminalNo INT not null
GO

ALTER TABLE [dbo].[Till]
ADD CONSTRAINT uc_ZTillID UNIQUE (Till_TerminalNo)


-- Till table changes
GO 
ALTER TABLE [dbo].[Till]
DROP COLUMN 
Till_EFTMerchant, Till_EFTMerchCompNo

GO 
ALTER TABLE [dbo].[Till]
ADD Till_EFT char(1) 
GO



--------------------------------------------
--  Terminal table changes
---------------------------------------------
--   add services enabled
ALTER TABLE [dbo].[Terminal]
ADD Term_NextReturns bit not null default 0
GO

ALTER TABLE [dbo].[Terminal]
ADD Term_Hermes bit not null default 0


GO
--select cast(TERMINAL_ID as INT) from Terminal
ALTER TABLE [dbo].[Terminal]
ALTER COLUMN TERMINAL_ID INT


GO
ALTER TABLE Terminal
DROP COLUMN 
NEXT_CALL_DATE, COMMS, CATEGORY, REGISTRATION_DATE,
DESCRIPTION, PARENT_ID, NAME, SIGNATURE, TYPE

GO
ALTER TABLE Terminal
ADD Term_Profile smallint,
    Term_Clas varchar(6)

GO
ALTER TABLE Terminal
ADD 
 Term_SerialNr      varchar(15),
 Term_PartNr        varchar(15),
 Term_AddSerialNr   varchar(15),
 Term_AddPartNr     varchar(15)
 
--GO
--ALTER TABLE Terminal
--ALTER COLUMN TYPE varchar(6)
-- 
--GO
--EXEC sp_rename 'Terminal.TYPE', 'Term_Clas', 'COLUMN' 


 
----------------------
--- Product Table 
-----------------------
GO
ALTER TABLE [dbo].[Product]
ADD 
Prod_CategoryID INT,
Prod_U32 SMALLINT NOT NULL DEFAULT 1


GO
ALTER TABLE  Product
ALTER COLUMN  Prod_Description varchar(50) not null;




-----------------------------------------
--- MechantSites table changes
----------------------------------------
GO
ALTER TABLE MerchantSites
ADD Site_HOID int, Site_HOdesc char(35), Site_Sponsor char(6)

GO
ALTER TABLE [dbo].[MerchantSites]
ADD Site_EFTmerchant varchar(16), 
    Site_AMEXmerchant varchar(16) 
    
GO
ALTER TABLE [dbo].[MerchantSites]   
ADD CONSTRAINT Uniq_Site_ID unique 
( site_ID )

GO
ALTER TABLE [dbo].[MerchantSites]
ADD 
Site_TransientCreditLimit int,
Site_TransientCreditLimitExpiry datetime,
Site_Distributor char(2)

GO
ALTER TABLE [dbo].[MerchantSites] 
ALTER COLUMN [Site_EnabledMsg] [char](48) 


---------------------------
---- Other tables 
---------------------------

--GO
---- ProductGroups table
--ALTER TABLE [ProductGroups]
--ADD 
--ProductGroup_IsGeneric TINYINT NOT NULL DEFAULT 0
--

--- EnablementRules table changes
GO 
ALTER TABLE EnablementRules
ADD ER_ProfileRule varchar(500)

GO
ALTER TABLE [TMSRebuilds]
ALTER COLUMN TR_TerminalId int NOT NULL

GO
ALTER TABLE [ProductDisablements] 
   DROP COLUMN [PD_TID]





--- add timestamps
GO
ALTER TABLE [dbo].[Terminal] 
ADD [RowVersion] [timestamp] NOT NULL

GO
ALTER TABLE [dbo].[Till] 
ADD [RowVersion] [timestamp] NOT NULL

GO
ALTER TABLE [dbo].[MerchantSites] 
ADD [RowVersion] [timestamp] NOT NULL


------------------------------------
-- Contraints AND Triggers
------------------------------------

--- Constraints on Draws table
GO

CREATE TABLE [dbo].[TempDraws]
(
	[DrawId] [int] IDENTITY (1,1) NOT NULL,
	[Start_Date] [smalldatetime] NULL,
	[Expiry_Date] [smalldatetime] NULL,
	[Fund_Type] [smallint] NOT NULL,
	[Price] [smallint] NOT NULL,
	[Saturday] [bit] NOT NULL,
	[Sunday] [bit] NOT NULL,
	[Monday] [bit] NOT NULL,
	[Tuesday] [bit] NOT NULL,
	[Wednesday] [bit] NOT NULL,
	[Thursday] [bit] NOT NULL,
	[Friday] [bit] NOT NULL,
	[IssuerFormat_key] [smallint] NOT NULL

)
GO

INSERT INTO [dbo].[TempDraws] ([Start_Date],[Expiry_Date],[Fund_Type],[Price],[Saturday],[Sunday],[Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[IssuerFormat_key]) SELECT [Start_Date],[Expiry_Date],[Fund_Type],[Price],[Saturday],[Sunday],[Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[IssuerFormat_key] FROM [dbo].[Draws]
DROP TABLE [dbo].[Draws]
GO
EXEC sp_rename N'[dbo].[TempDraws]',N'Draws', 'OBJECT'
GO




ALTER TABLE [dbo].[ProductGroups] ADD CONSTRAINT [IX_ProductGroups] UNIQUE NONCLUSTERED
	(
		[ProductGroup_ID] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY  = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
ALTER TABLE [dbo].[Draws] ADD CONSTRAINT [DrawId] PRIMARY KEY CLUSTERED
	(
		[DrawId] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY  = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90)
GO
ALTER TABLE [dbo].[ProductDisablements] ADD CONSTRAINT [FK_ProductDisablements_Till] FOREIGN KEY
	(
		[PD_TillID]
	)
	REFERENCES [dbo].[Till]
	(
		[Till_ID]
	)
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--	Add [Categories] primary key, foreign key between [Categories] and [Product] and foreign key between [ProductGroups] and [ProdsXTerminal]  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME = 'Categories' 
AND TABLE_SCHEMA ='dbo' AND CONSTRAINT_NAME = 'PK_Categories')
   ALTER TABLE [dbo].[Categories] ADD CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Cgr_Key ] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_Categories]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
	ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_Categories] FOREIGN KEY([Prod_CategoryID])
		REFERENCES [dbo].[Categories] ([Cgr_Key ])

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProdsXTerminal_ProductGroups]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProdsXTerminal]'))
	ALTER TABLE [dbo].[ProdsXTerminal]  WITH CHECK ADD  CONSTRAINT [FK_ProdsXTerminal_ProductGroups] FOREIGN KEY([ProdsXTerminal_ProdGKey])
		REFERENCES [dbo].[ProductGroups] ([ProductGroup_Key])
GO







