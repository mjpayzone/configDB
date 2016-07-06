USE [TerminalConfigs_dev_new]
GO

IF OBJECT_ID('tempdb..#tmptbl1') IS NOT NULL
  DROP TABLE #tmptbl1;
  
BEGIN TRANSACTION  

SELECT replace
         (replace
           (replace
             (replace
               (replace
                 (replace
                   (replace(rtrim([Issuer_Name]), 'EU', ''), 
                  'E-Voucher', ''), 
                'EVoucher',''), 
              'Voucher',''),
            'Pay As You Go', 'PAYG'), 
          ' TopUp', ''), 
        ' Mobile', '') 
       + ' ' + rtrim([Prod_Description]) as proddesc
       ,Prod_Key as prodkey
INTO #tmptbl1
FROM [Application]
JOIN [AppXref] ON [AppXref_AppKey] = [App_Key]
JOIN [Issuer_Format] ON [AppXref_IssuerKey] = [Issuer_Key]
LEFT JOIN [Product] ON Prod_Issuer_Format = Issuer_Key
WHERE App_Type = 3
--and prod_categoryID = 6
and prod_U32 > 0
order by 2

--SELECT * FROM #tmptbl1

UPDATE Product
SET Prod_Description = proddesc
FROM Product
JOIN #tmptbl1 on prodkey = Prod_Key;


-- test
SELECT    App_key
         ,Issuer_Name
         ,Issuer_Key
	     ,[Prod_Description]
	     ,[Prod_Key] 
FROM [Application]
JOIN [AppXref] ON [AppXref_AppKey] = [App_Key]
JOIN [Issuer_Format] ON [AppXref_IssuerKey] = [Issuer_Key]
LEFT JOIN [Product] ON Prod_Issuer_Format = Issuer_Key
WHERE App_Type = 3
and prod_categoryID = 6
and prod_U32 > 0
order by 2

commit transaction
--rollback transaction;

DROP TABLE #tmptbl1;
