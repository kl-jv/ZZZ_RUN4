USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_AlternativeItems]    Script Date: 20/12/2023 11:42:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




 -- ALTER VIEW [dbo].[vw_AlternativeItems] AS


SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project													/*Project Segment of Item (item)   - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                                      ERPLN table: tcibd005 | TRUE | 'PROJEMPTY' |Text | 9 | |*/
	,CAST(kps.ItemLnCE as varchar(38)) as Item													/*Item segment of Item (item)   - References to tcibd001 General Item Data | TRUE | Null |Text | 38 | |*/
	,CAST(kpa.ItemLnCE as varchar(38)) as AlternativeItem										/*Alternative Item (aitm)   - References to tcibd001 General Item Data and is always a standard item of type 'Purchase', 'Manufactured', 'Generic' | TRUE | Null |Text | 38 | |*/

	,2 AS Reverse																				/*Reverse (reve) | TRUE | 2 |Byte |  | 1;"Yes";2;"No - (Default)"|*/
	,2 AS Interchangeable																		/*Interchangeable (natu) | FALSE | 2 |Byte |  | 1;"Yes";2;"No - (Default)"|*/
	,2 AS Replacement																			/*Replacement (repl) | FALSE | 2 |Byte |  | 1;"Yes";2;"No - (Default)"|*/
	,0 AS Priority																				/*Priority (prio) | FALSE | 0 |Byte |  | |*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS IntroductionDate							/*Introduction Date (sdte) |  | Null |Date/Time |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpiryDate													/*Expiry Date (edte) |  | Null |Date/Time |  | |*/
---	,case when kpa.Item is null then 1 else 0 end as MissingSource
FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1)
/* 23-07 */
--	LEFT JOIN ZZZ_Italy.dbo.KPSource kpa ON (itm.MG_COD_ALTERNA = kpa.Item AND itm.MG_DITTA = 1 AND kpa.Migrate = 1)
	JOIN ZZZ_Italy.dbo.KPSource kpa ON (itm.MG_COD_ALTERNA = kpa.Item AND itm.MG_DITTA = 1 AND kpa.Migrate = 1)
	LEFT JOIN KPRAKTOR.SIAPR.ANATEC ate ON (itm.MG_CODICE = ate.AE_CODICE_ART AND itm.MG_DITTA = ate.AE_DITTA)
WHERE
	itm.MG_COD_ALTERNA NOT LIKE ''

GO


