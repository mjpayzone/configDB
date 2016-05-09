USE [Terminal_config_MJ]
GO
-- NOTE
-- the data filepath will need to be changed depending in the second part as it depends on 
-- where the datafile is located on the required server


create view tmp_bulk_insert_enable
as
select [ER_ProductGroupID],[ER_PostCode] from [EnablementRules]

BULK INSERT [tmp_bulk_insert_enable]
FROM 'C:\tmp\EnablementRulesData.unl'
WITH ( FIELDTERMINATOR =',', ROWTERMINATOR ='\n')

drop view [tmp_bulk_insert_enable]
--select * from [EnablementRules]

