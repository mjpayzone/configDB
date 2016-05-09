use [TerminalConfig_V5_MJ]
GO

begin transaction;
DECLARE @prod smallint
DECLARE @str smallint

-- CLEAR OUT TEMP TABLES IF NECESSARY
if OBJECT_ID('tempdb..#t1') is not null
  drop table #t1;

-- PULL PRODUCTS THAT HAVE USELESS DESCRIPTIONS INTO T1 - WILL USE ISSUER NAME INSTEAD
SELECT distinct   
     [Issuer_Name] as descript ,[Prod_Key] as prodid
     into #t1
     FROM [Application]
     JOIN [AppXref] ON [AppXref_AppKey] = [App_Key]
     JOIN [Issuer_Format] ON [AppXref_IssuerKey] = [Issuer_Key]
     LEFT JOIN [Product] ON Prod_Issuer_Format = Issuer_Key
     JOIN Categories ON Prod_CategoryID = Categories.[Cgr_Key ]
    WHERE Cgr_Name LIKE 'Keypad%';

DECLARE strCursor CURSOR FOR
 SELECT prodid from #t1;

OPEN strCursor
FETCH NEXT FROM strCursor INTO @prod

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO Strings (Strings_Text, Strings_Type) SELECT descript, 1 FROM #t1 WHERE prodid = @prod; 
	SET @str = @@IDENTITY;
	UPDATE Product SET Prod_Label_Display = @str WHERE Prod_Key = @prod;
	FETCH NEXT FROM strCursor INTO @prod
END
CLOSE strCursor
DEALLOCATE strCursor

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

-- USED TO CHECK FINAL DESCRIPTIONS
SELECT distinct [Issuer_Name] as descript
                , [Prod_Key] as prodid
		        , dispStr.Strings_Text
     FROM [Application]
     JOIN [AppXref] ON [AppXref_AppKey] = [App_Key]
     JOIN [Issuer_Format] ON [AppXref_IssuerKey] = [Issuer_Key]
     LEFT JOIN [Product] ON Prod_Issuer_Format = Issuer_Key
     JOIN Categories ON Prod_CategoryID = Categories.[Cgr_Key ]
	 JOIN Strings AS dispStr ON Prod_Label_Display = Strings_Key
    WHERE Cgr_Name LIKE 'Keypad%';


-- DROP TEMPORARY TABLES
drop table #t1;

-- CHANGE TO COMMIT IF HAPPY
--rollback transaction;
commit transaction;
