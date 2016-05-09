use [TerminalConfig_V3];

begin transaction;

-- THESE TWO LINES ONLY NECESSARY IF EVOUCHER SCRIPT HASN'T ALREADY BEEN APPLIED
alter table Product
alter column Prod_Description varchar(50) not null;

-- CLEAR OUT TEMP TABLES IF NECESSARY
if OBJECT_ID('tempdb..#t1') is not null
  drop table #t1;
if OBJECT_ID('tempdb..#t2') is not null
  drop table #t2;

-- START OFF WITH SOME SPELLING FIXES
update product set prod_description = replace (prod_description, 'Hosung', 'Housing')
where prod_description like '%hosung%';
update product set prod_description = replace (prod_description, 'Hosing', 'Housing')
where prod_description like '%hosing%';
update product set prod_description = replace (prod_description, ' bar code', 'Barcode')
where prod_description like ' bar%';
update product set prod_description = replace (prod_description, 'Assesment', 'Assessment')
where prod_description like 'Asses%';
update product set prod_description = replace (prod_description, 'Enginner', 'Engineer')
where prod_description like '%engin%';

-- PULL PRODUCTS THAT HAVE USELESS DESCRIPTIONS INTO T1 - WILL USE ISSUER NAME INSTEAD
SELECT distinct   [Issuer_Name] as descript
	     ,[Prod_Key] as prodid
     into #t1
     FROM [Application]
     JOIN [AppXref] ON [AppXref_AppKey] = [App_Key]
     JOIN [Issuer_Format] ON [AppXref_IssuerKey] = [Issuer_Key]
LEFT JOIN [Product] ON Prod_Issuer_Format = Issuer_Key
    WHERE App_Type = 8
	  AND (Prod_Description LIKE 'Received%'
	   OR  Prod_Description LIKE 'Payment with Thanks%'
	   OR  Prod_Description LIKE 'Thank%'
	   OR  Prod_Description LIKE 'Many%'
	   OR  Prod_Description LIKE 'Merchant %'
	   OR  Prod_Description LIKE 'Stock%'
	   OR  Prod_Description LIKE 'Subscription%'
	   OR  Prod_Description LIKE 'Recieved%'
	   OR  Prod_Description LIKE 'Issue%'
	   OR  Prod_Description LIKE 'Request%'
	   OR  Prod_Description LIKE 'receipt%'
	   OR  Prod_Description LIKE 'Receives%'
	   OR  Prod_Description LIKE 'Quantum%'
	   OR  Prod_Description LIKE '2 issue%'
	   or Issuer_Name LIKE 'Airtricity Bill%'
	   );

-- PULL PRODUCTS THAT NEED QUALIFIED DESCRIPTIONS (ISS: PROD) INTO T2
SELECT distinct   rtrim([Issuer_Name]) + ': ' + rtrim(Prod_Description) as descript
	     ,[Prod_Key] as prodid
     into #t2
     FROM [Application]
     JOIN [AppXref] ON [AppXref_AppKey] = [App_Key]
     JOIN [Issuer_Format] ON [AppXref_IssuerKey] = [Issuer_Key]
LEFT JOIN [Product] ON Prod_Issuer_Format = Issuer_Key
    WHERE App_Type = 8
      AND Prod_Key not in (select prodid from #t1)
	  AND (Prod_Description LIKE 'Assesment%'
	   OR  Prod_Description LIKE 'Barcode%'
	   OR  Prod_Description LIKE 'Benefit%'
	   OR  Prod_Description LIKE 'BIDS%'
	   OR  Prod_Description LIKE 'Bill %'
	   OR  Prod_Description LIKE 'BOP%'
	   OR  Prod_Description LIKE 'Booklet%'
	   OR  Prod_Description LIKE 'Business Rate%'
	   OR  Prod_Description LIKE 'Business%'
	   OR  Prod_Description LIKE 'Car%'
	   OR  Prod_Description LIKE 'Council %'
	   OR  Prod_Description LIKE 'CREDIT %'
	   OR  Prod_Description LIKE 'Crossroads %'
	   OR  Prod_Description LIKE 'Csh. %'
	   OR  Prod_Description LIKE 'Community%'
	   OR  Prod_Description LIKE 'Concessionary%'
	   OR  Prod_Description LIKE 'Contents%'
	   OR  Prod_Description LIKE 'Debt%'
	   OR  Prod_Description LIKE 'default%'
	   OR  Prod_Description LIKE 'Domiciliary%'
	   OR  Prod_Description LIKE 'Early%'
	   OR  Prod_Description LIKE 'Engineer%'
	   OR  Prod_Description LIKE 'Finance%'
	   OR  Prod_Description LIKE 'Full%'
	   OR  Prod_Description LIKE 'Family%'
	   OR  Prod_Description LIKE 'Fire%'
	   OR  Prod_Description LIKE 'Former%'
	   OR  Prod_Description LIKE 'Freepay%'
	   OR  Prod_Description LIKE 'Garage%'
	   OR  Prod_Description LIKE 'Giftcard%'
	   OR  Prod_Description LIKE 'GMPF%'
	   OR  Prod_Description LIKE 'H B%'
	   OR  Prod_Description LIKE 'HAMA%'
	   OR  Prod_Description LIKE 'HBOP%'
	   OR  Prod_Description LIKE 'HO %'
	   OR  Prod_Description LIKE 'Hsg.%'
	   OR  Prod_Description LIKE 'Hous%'
	   OR  Prod_Description LIKE 'Home%'
	   OR  Prod_Description LIKE 'Insurance%'
	   OR  Prod_Description LIKE 'IMAN%'
	   OR  Prod_Description LIKE 'Income%'
	   OR  Prod_Description LIKE 'Invoice%'
	   OR  Prod_Description LIKE 'Lease%'
	   OR  Prod_Description LIKE 'Loan %'
	   OR  Prod_Description LIKE 'Mag %'
	   OR  Prod_Description LIKE 'Main %'
	   OR  Prod_Description LIKE 'Manual %'
	   OR  Prod_Description LIKE 'Membership %'
	   OR  Prod_Description LIKE 'Misc%'
	   OR  Prod_Description LIKE 'Mortgage%'
	   OR  Prod_Description LIKE 'Non %'
	   OR  Prod_Description LIKE 'N.N%'
	   OR  Prod_Description LIKE 'NBH %'
	   OR  Prod_Description LIKE 'NCHT %'
	   OR  Prod_Description LIKE 'Over%'
	   OR  Prod_Description LIKE 'P.C.N%'
	   OR  Prod_Description LIKE 'Parking %'
	   OR  Prod_Description LIKE 'PAYMT %'
	   OR  Prod_Description LIKE 'Pink %'
	   OR  Prod_Description LIKE 'PIP %'
	   OR  Prod_Description LIKE 'Plaintiff %'
	   OR  Prod_Description LIKE 'Proj. %'
	   OR  Prod_Description LIKE 'Part%'
	   OR  Prod_Description LIKE 'Payment%'
	   OR  Prod_Description LIKE 'Poll%'
	   OR  Prod_Description LIKE 'Rechar%'
	   OR  Prod_Description LIKE 'Rent%'
	   OR  Prod_Description LIKE 'Residential%'
	   OR  Prod_Description LIKE 'Regular%'
	   OR  Prod_Description LIKE 'Rate %'
	   OR  Prod_Description LIKE 'RCS %'
	   OR  Prod_Description LIKE 'Recon %'
	   OR  Prod_Description LIKE 'School %'
	   OR  Prod_Description LIKE 'Sec. %'
	   OR  Prod_Description LIKE 'Self %'
	   OR  Prod_Description LIKE 'Supporting %'
	   OR  Prod_Description LIKE 'Surma %'
	   OR  Prod_Description LIKE 'Sale%'
	   OR  Prod_Description LIKE 'Sundr%'
	   OR  Prod_Description LIKE 'Social%'
	   OR  Prod_Description LIKE 'Temp %'
	   OR  Prod_Description LIKE 'Tenants %'
	   OR  Prod_Description LIKE 'Test %'
	   OR  Prod_Description LIKE 'Water %'
	   OR  Prod_Description LIKE 'White %'
	   OR  Prod_Description LIKE '£%'
	   OR Issuer_Name LIKE 'Coop Development%'
	   );

-- USED TO CHECK CONTENTS OF TEMP TABLES
--select * from #t1;
--select * from #t2;

-- LIST OF UNMODIFIED BILL PAYMENT PRODUCTS
--SELECT DISTINCT
--       Issuer_Name,Issuer_Key,[Prod_Description],[Prod_Key] as ProdID,App_Type
--     FROM [Application]
--     JOIN [AppXref] ON [AppXref_AppKey] = [App_Key]
--     JOIN [Issuer_Format] ON [AppXref_IssuerKey] = [Issuer_Key]
--LEFT JOIN [Product] ON Prod_Issuer_Format = Issuer_Key
--    WHERE App_Type =8
--      AND Prod_Key not in (select prodid from #t1)
--      AND Prod_Key not in (select prodid from #t2)
-- order by Prod_Description;

-- UPDATE PRODUCT TABLE
update Product set Prod_Description = descript from Product join #t1 on ProdId = Prod_Key;
update Product set Prod_Description = descript from Product join #t2 on ProdId = Prod_Key;

-- USED TO CHECK FINAL DESCRIPTIONS
SELECT DISTINCT
          Issuer_Name
         ,Issuer_Key
	     ,[Prod_Description]
	     ,[Prod_Key] as ProdID
		 ,App_Type
     FROM [Application]
     JOIN [AppXref] ON [AppXref_AppKey] = [App_Key]
     JOIN [Issuer_Format] ON [AppXref_IssuerKey] = [Issuer_Key]
LEFT JOIN [Product] ON Prod_Issuer_Format = Issuer_Key
    WHERE App_Type =8
 order by Prod_Description;

-- DROP TEMPORARY TABLES
drop table #t1;
drop table #t2;

--rollback transaction;
commit transaction;
