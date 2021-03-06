USE [TerminalConfig_V5_MJ]
GO
-- the data filepath will need to be changed depending on 
-- where the datafile is located on the required server

create view tmp_bulk_insert_enable
as
select [ER_ProductGroupID],[ER_PostCode] from [EnablementRules]
GO

BULK INSERT [tmp_bulk_insert_enable]
FROM 'C:\tmp\EnablementRulesData.unl'
WITH ( FIELDTERMINATOR =',', ROWTERMINATOR ='\n')

GO
drop view [tmp_bulk_insert_enable]
--select * from [EnablementRules]