USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_ProductionBillOfMaterial]    Script Date: 20/12/2023 12:38:46 ******/
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

Removed the Class = 4 from the join of kpc. Bill of material should show all items.
We just remove the quantities of Class = 4 to 0. (See NetQuantity)

Need to verify with Belinda if the Item Production needs to have phantoms?

*/

ALTER VIEW [dbo].[vw_ProductionBillOfMaterial] AS 

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS ProductProject						/*Project segment of Product (timfc300/310.mitm)   - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".     Infor LN tables: timfc300, timfc310 | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem						/*Item segment of Product (timfc300/310.mitm)   - References to tiipd001 Item Production Data | FALSE |  | 38 | |*/
	,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))*10  AS Position											/*Position (timfc310.pono) | TRUE | 0 |  | |*/
	,20 AS Status														/*Status (timfc300.bmst) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |  | 10;"New";20;"Approved";30;"Expired"|*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate			/*Effective Date (timfc300.indt) | TRUE |  |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpiryDate								/*Expiry Date (timfc300.exdt) | TRUE |  |  | |*/
	,1 AS BomQuantity														/*BOM Quantity (timfc300.unom) - Quantity on Main item, usually this is set to 1 | TRUE | 1 |  | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS SubItemProjectSegment				/*Project segment of Sub Item (timfc310.sitm)   - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | FALSE | "PROJEMPTY" | 9 | |*/
	,CAST(kpc.ItemLnCE AS VARCHAR(38)) AS SubItemItemSegment				/*Item segment of Sub Item (timfc310.sitm)   - References to tcibd001 General Item Data | FALSE |  | 38 | |*/
/* Changed NetQuantity due to ConversionFactors on BOm Quantity */
	,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
		CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
			ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
			END		
		END AS FLOAT) AS NetQuantity										/*Net Quantity (timfc310.qana) - Quantity for the Sub item | FALSE | 0 |  | |*/
	,0 AS ScrapQuantity														/*Scrap Quantity (timfc310.scpq) | FALSE | 0 |  | |*/
	,0 AS ScrapFactor														/*Scrap Factor (timfc310.scpf) | FALSE | 0 |  | |*/
	,0 AS [Length]															/*Length (timfc310.leng) Can only be filled when unit is of type lenght or area. Default = 0 | FALSE | 0 |  | |*/
	,0 AS Width																/*Width (timfc310.widt) Can only be filled when unit is of type lenght or area. Default = 0 | FALSE | 0 |  | |*/
	,CAST(NULL AS VARCHAR(3))AS SizeUnit									/*Size Unit (timfc310.sizu) - references to tcmcs001 | FALSE |  | 3 | |*/
	,0 AS NumberOfUnits														/*Number of Units (timfc310.noun) The required quantity of the material, expressed as the number of units of specified length and width. Default = 0 | FALSE | 0 |  | |*/
	,CASE WHEN its.MG_GEST_PROD = 'I' AND its.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 ELSE 2 END AS Phantom		/*Phantom (timfc310.cpha) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS InheritDemandPeg													/*Inherit Demand Peg (timfc310.idpg) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS AllowMultipleItems												/*Allow Multiple Items (timfc310.almi) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS AlternativesPresent												/*Alternatives Present (timfc310.altp) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CAST(NULL AS VARCHAR(9)) AS BomLineText								/*BOM Line Text (tttxt010.ctxt) |  |  |  | |*/
	,0 AS BomLineTextID														/*BOM Text ID (timfc310.txta) |  | 0 |  | |*/

FROM
	KPRAKTOR.SIAPR.DISBASE bom
	JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)
	JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)
	JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.ItemType = 30 AND kps.Migrate IN (0,1)) 
	JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kpc.ItemType = 30 AND kpc.Migrate IN (0,1)) ---AND kpc.Class <> 4 
	LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
	LEFT JOIN
		(
			SELECT
				kps.Item AS item
				,CASE WHEN bom.lines IS NULL THEN 0 ELSE bom.lines END AS lines
			FROM
				ZZZ_Italy.dbo.KPSource kps
				LEFT JOIN
					(
						SELECT
							 CAST(kps.Item AS VARCHAR(38)) AS Item
							,COUNT(bom.DB_CODICE_FIGLIO) AS lines
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
		)bol ON (kps.Item = bol.item)
WHERE
	bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())





GO


