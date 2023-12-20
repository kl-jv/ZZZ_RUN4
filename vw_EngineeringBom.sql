USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_EngineeringBom]    Script Date: 20/12/2023 11:46:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/*
This Final version must hold all Engineering Items as they are defined by HCE.
This means that the Engineering Items will hold 'Cleansed Items' and 'Not Cleansed Items'.

To be able to approve an engineerig Item, all components, that are Engineering must contain an approved revision, else it is not possible to approve.

This means that all not clenased engieering items must receive a signal code in the revision, that the item is not cleansed.


The ItemGroup will be defaulted to PI9999, because it will not receive any entities at the Item Master Level, other than production if necessary

Removed the Class = 4 from the join of kpc. Bill of material should show all items.
We just remove the quantities of Class = 4 to 0. (See NetQuantity)

*/


ALTER VIEW [dbo].[vw_EngineeringBom] AS

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS EngineeringProject															/*Project segment (eitm)                                                                       Infor LN table: tiedm110 | TRUE | "PROJEMPTY" | Text | 9 | */

--	, kpc.Class
--	, kps.ItemGroup

	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS EngineeringItem															/*Item segment of Engineering Item (eitm) - Reference to tiedm010 | TRUE |  | Text | 38 | */																											/*Item segment of Engineering Item (eitm) - Reference to tiedm010 | TRUE |  | Text | 38 | */
	,CAST('000001' AS VARCHAR(6)) AS Revision																		/*Revision (revi) | FALSE |  | Text | 6 | */
	,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))* 10 AS Position	/*Position (pono) | FALSE | 0 | Long Integer |  | */
	,CASE kpc.[E-Item] 
		WHEN 1 THEN 2   
		WHEN 2 THEN 1	
		ELSE NULL
		END AS ComponentType																						/*Component Type (cmtp) | TRUE | 2 |  | 1;"Item";2;"E-Item (default)"|*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS ComponentProject															/*Project segment Component (comp) | FALSE | "PROJEMPTY" | Text | 9 | */
	,CAST(kpc.ItemLnCE AS VARCHAR(38)) AS ComponentItem																/*Component (comp) | FALSE |  | Text | 38 | */
	,CAST(0 AS FLOAT) AS [Length]																					/*Length (leng) | FALSE | 0 | Decimal |  | */
	,CAST(0 AS FLOAT) AS Width																						/*Width (widt) | FALSE | 0 | Decimal |  | */
	,CAST(NULL AS VARCHAR(3))AS SizeUnit																			/*Size Unit (sizu)  ** Mandatory when length or width > 0 | FALSE |  | Text | 3 | */
	,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
		CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
			ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
			END		
		END AS FLOAT) AS NetQuantity																				/*Net Quantity (nqan) | FALSE | 0 | Decimal |  | */
	,CAST(2 AS FLOAT) AS QuantityIndependent																		/*Quantity Independent (qdep) |  | 2 | Byte |  | */
	,CAST(2 AS FLOAT) AS AllowMultipleItems 																		/*Allow Multiple Items (almi) |  | 2 | Byte |  | */

FROM
	KPRAKTOR.SIAPR.DISBASE bom
	JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)
	JOIN KPRAKTOR.SIAPR.ANAMAG itc ON (bom.DB_CODICE_FIGLIO = itc.MG_CODICE AND bom.DB_DITTA = itc.MG_DITTA)
	
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.[E-Item] = 1 AND kps.ItemType = 30 AND  kps.Migrate IN (0,1) )
	JOIN ZZZ_Italy.dbo.KPSource kpc ON (itc.MG_CODICE = kpc.Item AND itc.MG_DITTA = 1 AND kpc.Itemtype = 30 AND kpc.Migrate IN (0,1)) ----AND kpc.Class <> 4 removed
	LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
WHERE
	bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())

GO


