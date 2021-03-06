USE [TerminalConfig_V5_MJ]
GO
-- select * from categories


-- correct amount types for fixed price products
BEGIN TRANSACTION

update product
set Prod_Amount_Type = 0
where prod_key in
(
select prod_key
--       , prod_description, Prod_Amount, Prod_Min_Amount, Prod_Max_Amount, Prod_Amount_Type
--       , Prod_Default_Amount, prod_categoryID
from product
where 
Prod_Min_Amount = Prod_Max_Amount
and Prod_amount_type > 0
and Prod_Amount > 0 
AND Prod_categoryID  
in 
(select Cgr_Key from Categories where Cgr_Name like 'Evoucher%' 
                                      or Cgr_Name like 'ETU%' 
                                      or Cgr_Name like 'BillPay%')
)

--rollback transaction
COMMIT TRANSACTION
--  

-- update EE pan length - set to 0 by mistake

BEGIN TRANSACTION
  UPDATE [Issuer_Format]
  SET [Issuer_Pan_Length_A] = 19
  WHERE issuer_key IN
  (
  select distinct Issuer_Key
--      ,[Issuer_Name] ,[Issuer_PanLength] ,[Issuer_KeyEntry] ,[Issuer_PoundsAmount]
--      ,[Issuer_Pan_Length_A]  ,[Issuer_Pan_Length_B]
  FROM  Issuer_Format, AppXref, application
  WHERE 
  AppXref_IssuerKey = issuer_key
  and  AppXref_AppKey = app_key
  and app_type = 1
  and issuer_name like 'EE%' 
  )
  
  COMMIT TRANSACTION
 
 
-- update billpay utilities amoounts to 1p where min = 0 and max > 0

BEGIN TRANSACTION
update Product
set Prod_Min_Amount = 1
where Prod_Key in
(
  
  select prod_Key 
  FROM Application
  inner join AppXref on AppXref_AppKey = App_Key
  inner join Issuer_Format on AppXref_IssuerKey = Issuer_Key
  inner join Product on Prod_Issuer_Format  = issuer_Key
  where app_Type = 8
  and Prod_Min_Amount = 0
  and Prod_Max_Amount > 0
  and prod_categoryID = (select Cgr_Key from Categories where Cgr_Name like 'BillPay Utilities%')
)  
--rollback transaction
COMMIT TRANSACTION    


 
 ---------------------------------------------------------------------------------------------
-- tmp hack to cater for tablet feed never having looked at qauntum feed 
----------------------------------------------------------------------------------------------


BEGIN TRANSACTION 

update product 
set prod_categoryID = (select Cgr_Key from Categories where Cgr_Name like 'Cache')
--select * from product
where prod_issuer_format = 1478
and prod_categoryID = (select Cgr_Key from Categories where Cgr_Name like 'QUANTUM')

--rollback transaction 
COMMIT TRANSACTION

 
-- set min = max for fixed amounts

 UPDATE Product   
 set  [Prod_Min_Amount] = [Prod_Amount],
      [Prod_Max_Amount] = [Prod_Amount]
 where [Prod_Min_Amount] <> Prod_Amount   
 and prod_min_amount <> prod_max_amount  
 and Prod_Amount > 0 
-- and prod_amount_type = 0
-- rollback transaction

 COMMIT TRANSACTION



