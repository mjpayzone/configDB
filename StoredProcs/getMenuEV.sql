USE [TerminalConfigs_dev_new]
GO
/****** Object:  StoredProcedure [dbo].[getMenuEV]    Script Date: 08/01/2016 10:13:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getMenuEV]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[getMenuEV]
GO

CREATE  PROCEDURE [dbo].[getMenuEV] (@terminalID int, @catID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
declare @prodID int
declare @issprodID int
declare @prodName varchar(50)
declare @issID int
declare @idx smallint
declare @childP int
declare @nextP int
declare @pnextP int
declare @lastinsrt int

BEGIN TRY

  IF OBJECT_ID('tempdb..#tmpProds') is not null
    drop table #tmpProds

  CREATE TABLE #tmpProds 
  (
     iss smallint, 
     issprod smallint,
     prod smallint,
     proddesc varchar(50),
     nextp smallint,
     childp smallint
  )

  DECLARE issProdsC CURSOR LOCAL FORWARD_ONLY FOR 
  SELECT  distinct 
        Prod_Key as productID
       , Prod_Description as productName
       , Prod_Child_Products as childP
       , Prod_Next_Product_Index as nextP
       , Issuer_Key as issuerID 
       , Issuer_MenuIndex as idx
  FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join Till on Till_ID = Term_TillID  
  inner join ProductGroups on ProductGroup_ID = ProdsXTerminal_ProdGKey
  inner join ProdGroupXProds on PGXProds_ProdGKey = ProductGroup_Key 
  inner join Product on Prod_Key = PGXProds_ProdKey
  inner join Issuer_Format on Prod_Issuer_Format = Issuer_key
  inner join AppXref on Issuer_key = AppXref_IssuerKey
  inner join Application on AppXref_AppKey = App_Key 
  inner join AppTypeDesc on App_Type = AppType_Type
  and Prod_CategoryID = @catID
  and TERMINAL_ID = @terminalID
  and Prod_Child_Products > 0
  and Prod_U32 < 2
  and prod_key NOT IN 
     (select PD_ProdKey from [ProductDisablements] 
      inner join Terminal on Term_TillID = PD_TillID
      where TERMINAL_ID = @terminalID)
  order by Issuer_MenuIndex, 1 
  
   OPEN issProdsC
   FETCH NEXT FROM issProdsC into @issprodID, @prodName, @childP, @nextP, @issID, @idx
   WHILE @@FETCH_STATUS = 0
   BEGIN 
      insert into #tmpProds values (@issID, @issprodID, 0, @prodName, @nextP, @childP)
      
      select @prodID = prod_key, @prodName = prod_description, @nextP = Prod_Next_Product_Index 
             ,@childP = Prod_Child_Products
      from Product 
      where prod_key = @childP
      and Prod_DefaultProduct = 1

      insert into #tmpProds values (@issID, 0, @prodID, @prodName, @nextP, @childP)
      set @lastinsrt = @prodID
     
      WHILE @nextP > 0
      BEGIN
      
          select @prodID = prod_key, @prodName = prod_description, @pnextP = Prod_Next_Product_Index 
          from Product 
          where Prod_Key = @nextP
          and Prod_Issuer_Format = @issID
          and Prod_U32 = 1
          
          if @@ROWCOUNT = 0
          begin
             set @nextP = 0
             update #tmpProds set nextp = 0 where prod = @lastinsrt
          end
          else
          begin   
              insert into #tmpProds values (@issID, 0, @prodID, @prodName, @pnextP, @childP) 
              set @nextP = @pnextP
              set @lastinsrt = @prodID
          end
      END
      FETCH NEXT FROM issProdsC into @issprodID, @prodName, @childP, @nextP, @issID, @idx 
  END
  CLOSE issProdsC
  DEALLOCATE issProdsC
  
  select * from #tmpProds

  if @@ROWCOUNT = 0
     set @ErrStatus = 100
  else 
     set @ErrStatus = @@ERROR
  
  drop table #tmpProds
  RETURN @ErrStatus
    
END TRY

BEGIN CATCH
    SELECT ERROR_NUMBER(),ERROR_MESSAGE()
    RETURN @ErrStatus
END CATCH

END

