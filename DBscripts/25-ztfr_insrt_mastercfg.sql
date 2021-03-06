USE [TerminalConfig_V5_MJ]
GO

DECLARE @tabletmasterconf INTEGER

begin transaction

-------------------------------------------------------------------------------------------------------------------------------------
--   insert a dummy entry for the terminal master config for tablets
--  this is required as any insert into the Terminals table need a master app config ID,
--  which is not relevant for the tablet terminals
-------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [Master_Config]
           ([MA_GEMSTelephoneNumber]
           ,[MA_GeneralHelpDeskPhoneNumber2]
           ,[MA_ErrorCorrection]
           ,[MA_Compression]
           ,[MA_V42Handshake]
           ,[MA_V25AnswerTone]
           ,[MA_IDLEText]
           ,[MA_NumberOfRings]
           ,[MA_SecurityManagementSystem]
           ,[MA_Description])
     VALUES
           (NULL
           ,NULL
           ,0
           ,0
           ,0
           ,0
           ,NULL
           ,0
           ,0
           ,'Tablet')

 SET @tabletmasterconf = SCOPE_IDENTITY()

 select @tabletmasterconf
 
 commit transaction

