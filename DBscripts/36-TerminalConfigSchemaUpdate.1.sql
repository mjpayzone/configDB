/*
	Add [Categories] primary key, foreign key between [Categories] and [Product] and foreign key between [ProductGroups] and [ProdsXTerminal]  
*/

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
