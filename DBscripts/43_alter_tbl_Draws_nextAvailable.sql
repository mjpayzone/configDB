USE [TerminalConfig_v5_dev] 
--USE [TerminalConfigs_dev_new]
GO

ALTER TABLE [Draws]
ADD NextAvailable bit not null default 0
GO

--rollback transaction
BEGIN TRANSACTION

UPDATE Product
SET Prod_Description = 'Qwik Pick £1'
WHERE Prod_Description like '£1%'
AND Prod_CategoryID = 14

UPDATE Product
SET Prod_Description = 'Qwik Pick £2'
WHERE Prod_Description like '£2%'
AND Prod_CategoryID = 14


UPDATE [Draws]
SET NextAvailable = 1 
WHERE Product_Key in
(select Prod_Key --,prod_description
 from Product
 where Prod_Description like 'Qwik Pick%'
 and Prod_CategoryID is not null
)

commit transaction


--select Prod_Key ,prod_description
-- from Product where prod_categoryID = 14
--

--execute getGenProductsCategory 14