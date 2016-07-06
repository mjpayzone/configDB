USE [TerminalConfig_V5_MJ]
GO

--==========================================================================
--
-- Filename    : calcRandomTime.sql
-- Description : Procedure to calculate a random 'download interval start time' for the TMSData
-- table (in the format HHmm). A random time will be generated over the midnight boundary as required.
-- 
-- All input values are INCLUSIVE.
--
-- Input:
--     startHour (int) : Start hour of range in which the random time must exist.
--     startMin (int): Start minutes of range in which the random time must exist.
--     endHour (int): End hour of range in which the random time must exist.
--     endMin (int): End minutes of range in which the random time must exist.
-- Return Status:
--     Not Used.
-- Output:
--     randomTime (char(4)): Random time in 'HHmm' format.
--             
--==========================================================================

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[calcRandomTime]

	@startHour int,
	@startMin int,
	@endHour int,
	@endMin int,
	@randomTime CHAR(4) OUTPUT
AS

BEGIN
	DECLARE @startAsMins INT
	DECLARE @endAsMins INT
	DECLARE @startDate DATETIME
	DECLARE @endDate DATETIME
	DECLARE @diffInMinutes INT
	DECLARE @randomMinutes INT
	DECLARE @timeString CHAR(5)
		
	-- pull in invalid values
	IF (@startHour < 0)
		SET @startHour = 0

	IF (@startHour > 23)
		SET @startHour = 23

	IF (@startMin < 0)
		SET @startMin = 0

	IF (@startMin > 59)
		SET @startMin = 59

	IF (@endHour < 0)
		SET @endHour = 0

	IF (@endHour > 23)
		SET @endHour = 23

	IF (@endMin < 0)
		SET @endMin = 0

	IF (@endMin > 59)
		SET @endMin = 59

	-- get start & end ranges as the amount of minutes since midnight
	SET @startAsMins = (@startHour * 60) + @startMin
	SET @endAsMins = (@endHour * 60) + @endMin

	-- add a day of minutes onto the end date if it is 
	IF (@endAsMins <= @startAsMins)
		SET @endAsMins = @endAsMins + (24 * 60)

	-- use a base date for our calculation - using CONVERT with style '120' ensures format is read as yyyy-MM-dd
	SET @startDate = CONVERT(datetime, '2000-01-01 00:00:00', 120)
	SET @endDate = CONVERT(datetime, '2000-01-01 00:00:00', 120)

	-- add minutes as provided by input parameters
	SET @startDate = DATEADD(mi, @startAsMins, @startDate)	
	SET @endDate = DATEADD(mi, @endAsMins, @endDate)

	-- generate random amount of minutes between the two dates
	SET @diffInMinutes = DATEDIFF(mi, @startDate, @endDate)
	SET @randomMinutes = RAND()*(@diffInMinutes + 1);

	-- add this random amount onto our start window
	SET @startDate = DATEADD(mi, @randomMinutes, @startDate);

	-- gets the time portion in hh:mm:ss format
	SET @timeString = CONVERT(CHAR(5), @startDate, 108)
		
	-- and remove the :
	SET @randomTime = REPLACE(@timeString, ':', '')
END
