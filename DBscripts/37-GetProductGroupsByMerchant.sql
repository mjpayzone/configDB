
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProductGroupsByMerchant]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[GetProductGroupsByMerchant]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetProductGroupsByMerchant]

	@site_id char(8)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT DISTINCT [ProductGroup_Desc]
FROM
(
SELECT pg.*, pxt.*, tml.*, tl.*
	FROM [dbo].[ProductGroups] pg
	JOIN [dbo].[ProdsXTerminal] pxt
		on pg.[ProductGroup_Key] = pxt.[ProdsXTerminal_ProdGKey]
	JOIN [dbo].[Terminal] tml
		on pxt.[ProdsXTerminal_TermTillIDKey] = tml.[Term_TillID]
	JOIN [dbo].[Till] tl		
		on tml.[Term_TillID] = tl.[Till_ID]
	WHERE tl.[Till_MerchantNumber] = @site_id
) p
ORDER BY 1 ASC
END
GO

--test
exec [dbo].[GetProductGroupsByMerchant] '197157  '


