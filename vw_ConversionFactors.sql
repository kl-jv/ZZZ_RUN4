USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_ConversionFactors]    Script Date: 20/12/2023 11:44:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







ALTER VIEW [dbo].[vw_ConversionFactors] AS

/* ConversionFactors cannot be null or 0 */

SELECT
	 'PROJEMPTY' AS Project										/*Project segment of Item (item)  - Reference to tcmcs052 General Projects  *** If this field is empty then fill with PROJEMPTY                    ERPLN table: tcibd003 | TRUE | "PROJEMPTY" |Text | 9 | |*/										
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item					/*Item segment of Item (item)  - Reference to tcibd001 - Items | TRUE | null |Text | 38 | |*/
	,kps.InventoryUnit AS BaseUnit								/*Base Unit (basu)  - Reference to tcmcs001 - Units | TRUE | null |Text | 3 | |*/
	,kps.PurchaseUnitUnit AS Unit								/*Unit (unit)   - Reference to tcmcs001 - Units | FALSE | null |Text | 3 | |*/
	,CAST(kps.ConversionFactor AS FLOAT) AS ConversionFactor	/*Conversion Factor (conv) |  | 0 |Decimal |  | |*/
	,0 AS Raise10tothePower										/*Raise 10 to the Power (rpow) |  | 0 |Integer |  | <100|*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 	AND kps.Migrate = 1 )
WHERE
	kps.PurchaseUnitUnit IS NOT NULL
	AND kps.InventoryUnit <> kps.PurchaseUnitUnit

-- and kps.ConversionFactor not NULL 


GO


