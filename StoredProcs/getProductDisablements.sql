USE [TerminalConfig_V5_MJ]
GO

/****** Object:  StoredProcedure [dbo].[getProductDisablements]    Script Date: 04/04/2016 15:08:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getProductDisablements')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getProductDisablements]                 
GO

CREATE  PROCEDURE [dbo].[getProductDisablements] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

SELECT TERMINAL_ID as TerminalID, 
       PD_ProdKey as ProductID
  FROM [ProductDisablements]
  INNER JOIN Till on Till_ID = PD_TillID
  INNER JOIN Terminal on Term_TillID = Till_ID
  WHERE TERMINAL_ID is not null AND TERMINAL_ID > 0
  order by 1,2

  if @@ROWCOUNT = 0
  begin
     set @ErrStatus = 100
     RETURN @ErrStatus
  end   
  else 
     set @ErrStatus = @@ERROR
  
  RETURN @ErrStatus
    
END TRY

BEGIN CATCH
    SELECT ERROR_NUMBER(),ERROR_MESSAGE()
    RETURN @ErrStatus
END CATCH

END

