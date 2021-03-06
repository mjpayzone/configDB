USE [TerminalConfig_V5_MJ]
GO

begin transaction;


if OBJECT_ID('tempdb..#t1') is not null
  drop table #t1;

SELECT    replace(replace(replace(replace(rtrim([Issuer_Name]), 'ETU', ''), 'Top-UP', ''), 'Pay As You Go', 'PAYG'), 'Topup', '') + ' ' + rtrim([Prod_Description]) as descript
	     ,[Prod_Key] as prodid
     into #t1
     FROM [Application]
     JOIN [AppXref] ON [AppXref_AppKey] = [App_Key]
     JOIN [Issuer_Format] ON [AppXref_IssuerKey] = [Issuer_Key]
LEFT JOIN [Product] ON Prod_Issuer_Format = Issuer_Key
    WHERE App_Type not in ( 3, 4, 5, 8, 10, 15)
      and app_name not like 'Health Lot%'
      and app_name <> 'Hermes'
      and app_name <> 'Dart-Charge'
      and app_name <> 'PIP'
      and Issuer_Name not like 'BLUEBERRY%'
 order by 2;

select * from #t1;

update Product
   set Prod_Description = descript
  from Product
  join #t1 on ProdId = Prod_Key;

SELECT    App_key
         ,Issuer_Name
         ,Issuer_Key
	     ,[Prod_Description]
	     ,[Prod_Key] as ProdID
     FROM [Application]
     JOIN [AppXref] ON [AppXref_AppKey] = [App_Key]
     JOIN [Issuer_Format] ON [AppXref_IssuerKey] = [Issuer_Key]
LEFT JOIN [Product] ON Prod_Issuer_Format = Issuer_Key
    WHERE App_Type not in ( 3, 4, 5, 8, 10, 15)
	  and app_name not like 'Health Lot%'
      and app_name <> 'Hermes'
      and app_name <> 'Dart-Charge'
      and app_name <> 'PIP'
      and Issuer_Name not like 'BLUEBERRY%'
 order by 2;

drop table #t1;

--rollback transaction;
commit transaction;
