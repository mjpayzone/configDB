USE [TerminalConfig_V5_MJ]
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
 
 commit transaction


---- the below product was added to 2 productgroups
begin transaction  
delete from ProdGroupXProds
 where PGXProds_ProdKey = 3808
 and PGXProds_PGID = 10
 commit transaction
--


--the next products amount needs correcting

--begin transaction
--update product 
--set prod_amount = 4750
--where prod_key = 2592
--commit transaction
--

begin transaction
  delete from ProdGroupXProds
  where PGXProds_ProdKey in 
        (2756,3079,3134,3178,3179,3228,3319,3320,3365,3360,3380,3466,3522,4094,4095)
  and PGXProds_PGID = 9
commit transaction



begin transaction
--delete 
--from EnablementRules
--where ER_ProductGroupID in (2,3,4,5,6,7,8,14,18)
--
update ProductGroups
set ProductGroup_IsGeneric = 1
where ProductGroup_ID in 
---(2,3,4,5,6,7,8,18,45)
( select ProductGroup_ID from ProductGroups
  where ProductGroup_Desc like 'Airtel Guernsey E-Voucher' OR
        ProductGroup_Desc like 'Airtel Jersey E-Voucher' OR
        ProductGroup_Desc like 'Sure Isle of Man E-Voucher' OR
        ProductGroup_Desc like 'Sure Guernsey E-Voucher' OR
        ProductGroup_Desc like 'Sure Jersey E-Voucher' OR
        ProductGroup_Desc like 'JT Jersey E-Voucher' OR
        ProductGroup_Desc like 'JT Guernsey E-Voucher' OR
        ProductGroup_Desc like 'BillPay Channel Islands' OR
        ProductGroup_Desc like 'SmartTicketing Centro'
)

update ProductGroups
set ProductGroup_IsGeneric = 0
where ProductGroup_ID in 
--(11,13,16,19,21,23,24,25,26)
( select ProductGroup_ID from ProductGroups
  where ProductGroup_Desc like 'PrePaidCards' OR
        ProductGroup_Desc like 'BillPay Utilities UK' OR
        ProductGroup_Desc like 'BillPay Santander Basic' OR
        ProductGroup_Desc like 'BillPay Stock' OR
        ProductGroup_Desc like 'BillPay General' OR
        ProductGroup_Desc like 'KeyPad' OR
        ProductGroup_Desc like 'THL' OR
        ProductGroup_Desc like 'Quantum' OR
        ProductGroup_Desc like 'Talexus' 
)

commit transaction



-- correct quantum amount entry enables setting                 
GO
begin transaction

update TxnType
set TxnType_EnterTxnAmount = 1 
where TxnType_AppKey in
(
select distinct app_key
from Product 
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join TxnType on TxnType_AppKey = App_Key
where prod_categoryID = (select Cgr_Key from Categories where Cgr_Name like '%Quantum%')
and Prod_DefaultProduct = 1
)

commit transaction





--- set prod_U32 to U32 only for duplicate 'prods' set up for U32 to display
begin transaction 
update product
set prod_U32 = 2
where prod_key 
in (
select distinct prod_key from product, issuer_format 
where 
[Prod_Issuer_Format] = issuer_key 
and prod_categoryID in (6,7)
and prod_U32 = 1
  and (issuer_name like '%Sunrise Extra%' 
  or issuer_name like '%Orange World 4MB%'
  or issuer_name like '%Orange Text%'
  or issuer_name like '%Orange Talk%'
  or issuer_name like  '%Spark%')
and Prod_DefaultProduct = 0 and Prod_Next_Product_Index = 0 
)     

commit transaction


------------------------------------------------------------------------
--- update billpayment display text to be more meaningful
-------------------------------------------------------------------------
GO

DECLARE @strID int
DECLARE @catID int

SELECT @catID = Cgr_Key  FROM Categories
WHERE Cgr_Name LIKE 'BillPay Utilities%'
--select @catID as catID

SELECT @strID = Strings_Key 
FROM [Strings]
WHERE Strings_Text like 'Bill Payment%'
AND Strings_Type = 1
--select @strID as strID


BEGIN TRANSACTION
--rollback transaction

UPDATE Product
SET Prod_Label_Display = @strID

--select prod_key, prod_description, Prod_Label_Display, strings_text
--from Product join strings on Prod_Label_Display = Strings_Key
WHERE Prod_categoryID = 8 --@catID
AND Prod_Label_Display in 
(
select Strings_Key --, Strings_text 
from Strings
 where  
 (
 Strings_Text like 'PAYMT' OR
 Strings_Text like 'FULL' OR
 Strings_Text like 'PART' OR
 Strings_Text like 'PAYMENT' OR
 Strings_Text like 'RECEIVED WITH THANKS' OR
 Strings_Text like 'Received with Thanks' OR
 Strings_Text like 'Payment' OR
 Strings_Text like 'Payment With Thanks' OR
 Strings_Text like 'Thank You' OR
 Strings_Text like 'Payment Received' 
 )
 )
 
COMMIT TRANSACTION    
 
 
---------------------------------------------------------------------------
-- UPDATE whole currency TO 1 FOR Quantum products 
---------------------------------------------------------------------------- 
 begin transaction
update product
set Prod_Whole_Currency = 1
--select * from Product 
where prod_key in 
(
select prod_key  from product
where prod_categoryID = 12
)

commit transaction

                 


---------------------------------------------
-- change quantum DESC
---------------------------------------------
BEGIN TRANSACTION 

update product
set prod_description = 'Quantum Sale/RTI' 
where prod_description like 'Default%'
and prod_categoryID = (select Cgr_Key from Categories where Cgr_Name like 'QUANTUM')

--rollback transaction 
COMMIT TRANSACTION





-----------------------------------------------------------------------------------------------------------------------
-- tmp hack category to cater for tablet feed not being able to cope with certain situations yet
-----------------------------------------------------------------------------------------------------------------------

BEGIN TRANSACTION

insert into categories
(Cgr_Name, Cgr_Visible, Cgr_AppType, Cgr_TxnType)
values 
('Cache', 0, 0, 0)

COMMIT TRANSACTION







               


