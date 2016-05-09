USE [Terminal_config_MJ]
GO

begin transaction  
UPDATE [TxnType]
   SET [TxnType_BarCodeScanner] = 1
 WHERE TxnType_AppKey = 109
 -- is app 'Key Entry' where default_txn_type = 0, there are 2, 
 --     the other has default_txn_type 66
commit transaction 
  
 -- This script is to correct some data that has been set up incorrectly
 -- Each update has its own begin ttransaction so can be run in stages
 
begin transaction  
update ProdGroupXProds
set PGXProds_PGID = 
 (select ProductGroup_ID from ProductGroups where ProductGroup_Desc = 'BillPay Santander Basic' )
,PGXProds_ProdGKey = 
 (select ProductGroup_Key from ProductGroups where ProductGroup_Desc = 'BillPay Santander Basic' )
 where PGXProds_ProdKey = 3880
-- 
-- rollback transaction
 commit transaction

begin transaction  
update Product
set prod_categoryID = 
 (select Cgr_Key from Categories where Cgr_Name = 'BillPay Utilities' )
 where Prod_Key = 3880
 
-- rollback transaction
 commit transaction


-- the below peoduct was added to 2 productgroups
begin transaction  
delete from ProdGroupXProds
 where PGXProds_ProdKey = 3808
 and PGXProds_PGID = 10
-- rollback transaction
 commit transaction

--the next products amount were defaulted to 0, so needs correcting
begin transaction  
update product
set prod_amount = 250
where prod_key in (2464, 2468, 2611, 3170, 3174, 3343)
---- (ie IDT Europe, IDT Africa, White Card, IDT 893530403 and 893530405, IDT 893530404, IDT 893530402)
--
---- 5 strange valued SIMPLECALL products
update product 
set prod_amount = 410
where prod_key = 2587

update product 
set prod_amount = 450
where prod_key = 2588

update product 
set prod_amount = 475
where prod_key = 2589

update product 
set prod_amount = 950
where prod_key = 2590

update product 
set prod_amount = 4750
where prod_key = 2592

--Orange 10p and 50p
update product 
set prod_amount = 10
where prod_key = 2918

update product 
set prod_amount = 50
where prod_key = 2919

 commit transaction


begin transaction
  delete from ProdGroupXProds
  where PGXProds_ProdKey in 
        (2756,3079,3134,3178,3179,3228,3319,3320,3365,3360,3380,3466,3522,4094,4095)
  and PGXProds_PGID = 9
commit transaction



begin transaction
delete 
from EnablementRules
where ER_ProductGroupID in (2,3,4,5,6,7,8,14,18)

update ProductGroups
set ProductGroup_IsGeneric = 1
where ProductGroup_ID in (2,3,4,5,6,7,8,18,45)

update ProductGroups
set ProductGroup_IsGeneric = 0
where ProductGroup_ID in (11,13,16,19,21,23,24,25,26)

commit transaction

