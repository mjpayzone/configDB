USE [TerminalConfig_V5_MJ]  
GO
--drop view tmp_bulk_insert_prodgroups
create view tmp_bulk_insert_prodgroups
as
select [ProductGroup_ID], [ProductGroup_Desc], [ProductGroup_IsGeneric] from [ProductGroups]
GO

BULK INSERT [tmp_bulk_insert_prodgroups]
FROM 'C:\tmp\ProductGroupsData.unl'
WITH ( FIELDTERMINATOR =',', ROWTERMINATOR ='\n', ERRORFILE='C:\tmp\bulkerr.log')

GO
drop view [tmp_bulk_insert_prodgroups]
select * from [ProductGroups]


