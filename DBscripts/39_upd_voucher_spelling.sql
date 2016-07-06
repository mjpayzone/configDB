
USE [TerminalConfig_V5_dev]
GO


declare @prodkey smallint
declare @prodstr char(50)

begin transaction


declare vocuherC cursor local forward_only for 
SELECT prod_key, prod_description 
from product
where prod_description like '%Vocuher%'

 open vocuherC
 fetch next from vocuherC into @prodkey, @prodstr
 while @@fetch_status = 0
 begin 

select @prodstr, @prodkey  

update product
set prod_description = (select replace(@prodstr, 'Vocuher', 'Voucher'))
where prod_description like '%Vocuher%'
and prod_key = @prodkey

select prod_key, prod_description from product where prod_key =  @prodkey

fetch next from vocuherC into @prodkey, @prodstr
end

close vocuherC
deallocate vocuherC

-----

declare voucgerC cursor local forward_only for 
select prod_key, prod_description 
from product
where prod_description like '%Voucger%'

 open voucgerC
 fetch next from voucgerC into @prodkey, @prodstr
 while @@fetch_status = 0
 begin 

select @prodstr, @prodkey   

update product
set prod_description = (select replace(@prodstr, 'Voucger', 'Voucher'))
where prod_description like '%Voucger%'
and prod_key = @prodkey

select prod_key, prod_description from product where prod_key =  @prodkey

fetch next from voucgerC into @prodkey, @prodstr
end

close voucgerC
deallocate voucgerC

----rollback transaction
commit transaction