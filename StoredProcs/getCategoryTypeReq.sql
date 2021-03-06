USE [TerminalConfig_V5_MJ]
GO

/****** Object:  StoredProcedure [dbo].[getCategoryTypeReq]    Script Date: 04/27/2016 12:29:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getCategoryTypeReq')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getCategoryTypeReq]                 
GO

CREATE  PROCEDURE [dbo].[getCategoryTypeReq] (@catID int)
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)
DECLARE @catParent smallint
DECLARE @parentName varchar(50)
  

BEGIN TRY
  
  SELECT @catParent = Cgr_Parent 
  FROM Categories
  where Cgr_Key = @catID
  
  IF (@catParent is not null)
  BEGIN
    SELECT @parentName = Cgr_Name
    FROM Categories
    where Cgr_Key = @catParent

    SELECT CAST(Cgr_AppType AS int) as catApptype, 
         RTRIM(@parentName) + ' ' + RTRIM(Cgr_Name) as catDesc
    FROM Categories
    where Cgr_Key = @catID
  END
  ELSE
  BEGIN
    SELECT CAST(Cgr_AppType AS int) as catApptype, 
         Cgr_Name as catDesc
    FROM Categories
    where Cgr_Key = @catID
  END 

  if @@ROWCOUNT = 0
  begin
     set @ErrStatus = -1
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



