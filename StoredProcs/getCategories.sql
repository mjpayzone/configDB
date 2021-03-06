USE [TerminalConfig_V5_MJ]
GO

/****** Object:  StoredProcedure [dbo].[getCategories]    Script Date: 10/21/2015 11:20:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getCategories')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getCategories]                 
GO

CREATE  PROCEDURE [dbo].[getCategories] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

  SELECT  distinct Cgr_Key as categoryID, 
                   Cgr_Name as categoryName,
                   ISNULL(Cgr_Parent, 0) as categoryParent,
                   Cgr_Visible as categoryVisible
  FROM Categories
  ORDER BY Cgr_Key

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


