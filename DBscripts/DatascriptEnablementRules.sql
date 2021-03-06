
-- NOTE: 
-- The unloadfile will populate the data in the EnablementRules table 
-- The unload datafile contains productgroupIDs as in the below table. 
-- This may differ from the test config databse and if so should be updated with the below script after 
-- the table has been populated with the script ld_EnablementRules
-- This method may seem longwinded but is a lot easier 
-- than doing all the initial config adjustments extractions from Zorin which i needed to do so

-- ProductgroupIDs used in the EnablementRules:
-- ProductGroupID       ProductGroupName
-- 36                   BusTickets nBus
-- 30                   BusTickets Arriva Midlands
-- 31                   BusTickets Arriva Shires
-- 32                   BusTickets Arriva NorthEast
-- 33                   BusTickets Arriva Yorkshire
-- 34                   BusTickets Arriva NW & Wales
-- 35                   BusTickets Arriva Southern Counties
-- 


USE [TerminalConfigs_test]
GO

UPDATE [EnablementRules]
SET [ER_ProductGroupID] = <what the productgroupID is in the test config database for this peoduct group>>
WHERE [ER_ProductGroupID] = <what is currently in the unloadfile>