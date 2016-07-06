USE [TerminalConfigs_dev_new]
GO

BEGIN TRANSACTION
--rollback transaction

EXEC sp_rename 'Draws.IssuerFormat_key', 'Product_Key', 'COLUMN' 
GO

declare @pkey smallint

-- insert draws entry for each product
DECLARE curP CURSOR LOCAL FORWARD_ONLY FOR 
  SELECT distinct prod_key
  FROM  [Product], [issuer_Format], [AppXref], [Application]
  where 
  Prod_Issuer_Format = Issuer_Key
  and Issuer_Key = AppXref_IssuerKey
  and AppXref_AppKey = App_Key
  and App_Type = 19
  and App_Key in
(
    SELECT distinct App_Key 
    FROM [Menu_Applications], [Menu], [Application] 
    where MenuApplications_MenuKey = menu_key
    and MenuApplications_AppKey = App_Key
    and app_type = 19
    and menu_name in 
    ('PAYZ','PZNI','PZCI','PZNX','PZYC','PZCE','PZNG','TTMS','PZSP','PZLE','PZSY')
)

OPEN curP
FETCH NEXT FROM curP into @pkey
WHILE @@FETCH_STATUS = 0
BEGIN 

--select @pkey as prodkey
insert into Draws
select [Start_Date],[Expiry_Date],[Fund_Type],[Price]
       ,[Saturday],[Sunday],[Monday],[Tuesday],[Wednesday],[Thursday],[Friday]
      ,@pkey
from Draws 
where Product_Key = 1114
      

FETCH NEXT FROM curP into @pkey 
END
CLOSE curP
DEALLOCATE curP
      
-- delete original entry as this point to issuer_format
delete from Draws
where Product_Key = 1114

commit transaction
