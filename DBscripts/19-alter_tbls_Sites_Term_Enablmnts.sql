USE [Terminal_config_MJ]
GO

ALTER TABLE MerchantSites
ADD Site_HOID int, Site_HOdesc char(35), Site_Sponsor char(6)

ALTER TABLE Terminal
ADD Term_Profile smallint

ALTER TABLE EnablementRules
ADD ER_ProfileRule varchar(500)

