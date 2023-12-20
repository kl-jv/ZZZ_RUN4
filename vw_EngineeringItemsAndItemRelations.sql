USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_EngineeringItemsAndItemRelations]    Script Date: 20/12/2023 11:52:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*
This Final version must hold all Engineering Items as they are defined by HCE.
This means that the Engineering Items will hold 'Cleansed Items' and 'Not Cleansed Items'.

To be able to approve an engineerig Item, all components, hat are Engineering must contain an approved revision, else it is not possible to approve.
This means that all not clenased engieering item must recieve a signal code in the revision, that the item is not cleansed.
The ItemGroup will be defaulted to PI9999, because it will not receive any entities at the Item Master Level, other than production if necessary
*/

ALTER VIEW [dbo].[vw_EngineeringItemsAndItemRelations] AS 


SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project																														/*Project segment (item)                                                                                                               Infor LN table: tiedm101 | TRUE | "PROJEMPTY" | Text | 9 | */
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item																														/*Item segment of Main Item (item) | TRUE |  | Text | 38 | */		
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS EngineeringProject																											/*Engineering Project segment (eitm) | TRUE | "PROJEMPTY" | Text | 9 | */
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS EngineeringItem																											/*Engineering Item segment of Engineering Item (eitm) | TRUE |  | Text | 38 | */
	,CAST('000001' AS VARCHAR(6)) AS EngineeringItemRevision																										/*Engineering Item Revision (revi) | FALSE |  | Text | 6 | */
	,1 AS EItemCopied																																				/*E-Item Copied (eicp) | TRUE | 2 | Byte |  | */
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EItemCopyDate																									/*E-Item Copy Date (deic) | FALSE |  | Date/Time |  | */
	,CASE WHEN bom.BomLines >0 THEN 1 ELSE 2 END AS EBomCopied																										/*E-BOM Copied (eicp) |  | 2 | Byte |  | */
	,CASE WHEN bom.BomLines >0 THEN CAST('2023/01/01 00:00:00' AS SMALLDATETIME) ELSE CAST(NULL AS SMALLDATETIME) END AS EBomCopyDate								/*E-BOM Copy Date (deic) | FALSE | Date/Time | | */

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.[E-Item] = 1 AND kps.ItemType = 30 AND kps.Migrate IN (0,1))    
	LEFT JOIN
		(
			SELECT
				 CAST(kps.Item AS VARCHAR(38)) AS Item
				,COUNT(bom.DB_CODICE_FIGLIO) AS BomLines
			FROM
				KPRAKTOR.SIAPR.DISBASE bom
				JOIN ZZZ_Italy.dbo.KPsource kps ON (kps.Item = bom.DB_CODICE_PADRE AND kps.Migrate IN (0,1))
				JOIN ZZZ_Italy.dbo.KPsource kpc	ON (kpc.Item = bom.DB_CODICE_FIGLIO AND kpc.Migrate IN (0,1))
			WHERE
				bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
				AND bom.DB_DITTA = 1
			GROUP BY
				kps.Item
				,bom.DB_DITTA
		)bom ON (kps.Item = bom.Item)

GO


