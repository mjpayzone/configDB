USE [TerminalConfig_V5_MJ]
GO

/****** Object:  StoredProcedure [dbo].[getTerminalProductGroups]    Script Date: 03/31/2016 12:34:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getTerminalProductGroups')  AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[getTerminalProductGroups]                 
GO

CREATE   PROCEDURE [dbo].[getTerminalProductGroups] 
AS
BEGIN

DECLARE @ErrStatus int
DECLARE @ErrDesc varchar(250)


BEGIN TRY

SELECT TERMINAL_ID as TerminalID,
       --[ProdsXTerminal_TermTillIDKey] as TillID
       [ProdsXTerminal_ProdGKey] as ProductgroupID
  FROM 
  [Terminal]
  inner join ProdsXTerminal on ProdsXTerminal_TermTillIDKey = Term_TillID
  inner join ProductGroups on ProdsXTerminal_ProdGKey = ProductGroup_Key
  where TERMINAL_ID is not null
  and TERMINAL_ID > 0
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



