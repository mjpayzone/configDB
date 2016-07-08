--USE [TerminalConfigs_dev_new]
GO

ALTER TABLE [dbo].[Product]
ADD 
Prod_TxnType    SMALLINT  DEFAULT 0

GO
begin transaction
--rollback transaction
update product
set Prod_TxnType = 0
where prod_categoryID is not null

update product
set Prod_TxnType = 1
--select prod_key, prod_description from product
where prod_categoryID is not null
and prod_description like '%Quick Pick%'

update product
set Prod_TxnType = 2
--select prod_key, prod_description from product
where prod_categoryID is not null
and prod_description like 'Play Select%'

update product
set Prod_TxnType = 3
--select prod_key, prod_description from product
where prod_categoryID is not null
and prod_description like 'Activate%'

update product
set Prod_TxnType = 4
--select prod_key, prod_description from product
where prod_categoryID is not null
and prod_description like 'Play with Card'

update product
set Prod_TxnType = 5
--select prod_key, prod_description from product
where prod_categoryID is not null
and prod_description like 'Print Past Win%'

update product
set Prod_TxnType = 6
--select prod_key, prod_description from product
where prod_categoryID is not null
and prod_description like 'Reversal%'

update product
set Prod_TxnType = 7
--select prod_key, prod_description from product
where prod_categoryID is not null
and prod_description like 'Winnings Enquiry%'

update product
set Prod_TxnType = 1
--select prod_key, prod_description from product
where prod_categoryID is not null
and prod_key in
(select prod_key from product, issuer_format
 where issuer_key = prod_issuer_format
 and issuer_name like 'Qwik Pk%'
 and prod_categoryID is not null)

commit transaction

--select prod_key, prod_description, prod_TxnType 
--from product
--where prod_categoryID is not null
--and prod_txntype > 0
