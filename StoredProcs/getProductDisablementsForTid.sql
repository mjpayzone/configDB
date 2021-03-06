USE [TerminalConfigs_dev_new]
--USE [TerminalConfig_v5_dev]
GO

--execute [getProductDisablementsForTID] 63378135
/****** Object:  StoredProcedure [dbo].[getProductDisablementsForTID]    Script Date: 07/22/2016 14:57:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getProductDisablementsForTid]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[getProductDisablementsForTID]
GO

CREATE PROCEDURE [dbo].[getProductDisablementsForTid] (@terminalID int)
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
  WHERE TERMINAL_ID = @terminalID
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