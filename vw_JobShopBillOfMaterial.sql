USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_JobShopBillOfMaterial]    Script Date: 20/12/2023 12:02:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[vw_JobShopBillOfMaterial] AS 

/* WARNING: NOT YET FINISHED */

/*************************************************************************************/
/* Check for Status, Use for Planning and use for Costing							 */
/* Routing is standard 0, routing will only be added on final cranes				 */
/* removed all inactive item from the Padre.										 */
/*************************************************************************************/

SELECT
	 CAST('IT.POV.01' AS VARCHAR(9))AS Site										/*Site (tibom300/310.site) - References to tcemm050 Sites                                                                                               Infor LN tables: tibom300, tibom310, timfc301 | TRUE | null | 9 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS ProductProject							/*Project segment of Product (tibom300/310.mitm)   - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tibom300/310.mitm)   - References to tiipd001 Item Production Data | TRUE | null | 38 | |*/	
	,t1.Model AS Model															/*Model (tibom300/310.bmdl) | FALSE | null | 9 | |*/
/* 30-01-2023 KL : New field Revision in template 202310 */
	,CAST('000001' AS VARCHAR(6)) AS Revision									/* Revision (tibom300/tibom310.bmrv) */
	,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))*10 AS Position																																				/*Position (tibom310.pono) | TRUE | 0 |  | |*/
	,20 AS [Status]																/*Status (tibom300.bmst) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |  | 10;"New";20;"Approved";30;"Expired"|*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tibom300.efdt) | TRUE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tibom300.exdt)  - When empty, date will be set to MAX | TRUE | null |  | |*/
	,CAST(NULL AS VARCHAR(9)) AS Routing										/*Routing (tibom300.rouc) | FALSE | null | 9 | |*/
	,CAST(1 AS FLOAT) AS BomQuantity											/*BOM Quantity (tibom300.unom) - Quantity on Main item, usually this is set to 1 | FALSE | 1 |  | |*/
	,CAST(1 AS FLOAT) AS UseForPlanning											/*Use for Planning (tibom300.ufpl) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(1 AS FLOAT) AS UseForCosting											/*Use for Planning (tibom300.ufcs) | TRUE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CASE WHEN itc.MG_GEST_PROD = 'I' AND itc.MG_ESPL_DB IN ('00','01','02','03','06') THEN 0                                                                 
		ELSE CAST(mwc.Operation AS FLOAT)									
		END 
	AS Operation																/*Operation (tibom310.opno) | TRUE | 0 |  | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS SubItemProjectSegment					/*Project segment of Sub Item (tibom310.sitm)   - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kpc.ItemLnCE AS VARCHAR(38)) AS SubItemItemSegment					/*Item segment of Sub Item (tibom310.sitm)   - References to tcibd001 General Item Data | FALSE | null | 38 | |*/
	,CAST(CASE WHEN mwc.POV1 = 1 THEN 'IT0110'
		ELSE 
			CASE WHEN mwc.POV2 = 1 THEN 'IT0210'
				ELSE 'IT0110'
				END
		END AS VARCHAR(6)) AS Warehouse											/*Warehouse (tibom310.cwar)     - References tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
		CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
			ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
			END		
		END AS FLOAT) AS NetQuantity											/*Net Quantity (tibom310.qana) - Quantity for the Sub item | FALSE | 0 |  | |*/
	,0 AS ScrapQuantity															/*Scrap Quantity (tibom310.scpq) | FALSE | 0 |  | |*/
	,0 AS ScrapFactor															/*Scrap Factor (tibom310.scpf) | FALSE | 0 |  | |*/
	,0 AS [Length]																/*Length (tibom310.leng) Can only be filled when unit is of type lenght or area. Default = 0 | FALSE | 0 |  | |*/
	,0 AS Width																	/*Width (tibom310.widt) Can only be filled when unit is of type lenght or area. Default = 0 | FALSE | 0 |  | |*/
	,CAST(NULL AS VARCHAR(3)) AS SizeUnit										/*Size Unit (tibom310.sizu) - references to tcmcs001 | FALSE | null | 3 | |*/
	,0 AS NumberOfUnits															/*Number of Units (tibom310.noun) The required quantity of the material, expressed as the number of units of specified length and width. Default = 0 | FALSE | 0 |  | |*/
	,CASE WHEN itc.MG_GEST_PROD = 'I' AND itc.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 ELSE 2 END AS Phantom 	/*Phantom (tibom310.cpha) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE WHEN itc.MG_GEST_PROD = 'I' AND itc.MG_ESPL_DB IN ('00','01','02','03','06') THEN 2 ELSE 1 END AS ReportMaterial	/*Report Material (tibom310.rmtl) | FALSE | 2 |  | 1;"Backflush";2;"Manual";80;"Undefined"|*/
	,2 AS InheritDemandPeg														/*Inherit Demand Peg (tibom310.idpg) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS AllowMultipleItems													/*Allow Multiple Items (tibom310.almi) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS SuppliedBySubcontractor												/*Supplied by Subcontractor (tibom310.sbsr) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS AlternativesPresent													/*Alternatives Present (tibom310.altp) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CAST(NULL AS VARCHAR(9))  AS BomLineText									/*BOM Line Text (tttxt010.ctxt) |  | null |  | |*/
	,0 AS BomLineTextID															/*BOM Text ID (tibom310.txta) |  | 0 |  | |*/
FROM
    KPRAKTOR.SIAPR.DISBASE bom
    JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)
    JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.SupplySource IN (20) AND kps.Class <> 4 AND kps.ItemType = 30 AND (kps.POV1 = 1 OR kps.POV2 =1)) 
	JOIN KPRAKTOR.SIAPR.ANAMAG itc ON (bom.DB_CODICE_FIGLIO = itc.MG_CODICE AND bom.DB_DITTA = itc.MG_DITTA)
	JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND itc.MG_DITTA = 1 AND kpc.Migrate = 1 AND kpc.Class <> 4  AND kpc.ItemType = 30 ) 
	LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
	LEFT JOIN ZZZ_Italy.dbo.MappingWC mwc ON (bom.DB_REPARTO = mwc.Reparto AND  bom.DB_DITTA = 1)
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
							bom.DB_CODICE_PADRE AS Item
							,COUNT(bom.DB_CODICE_FIGLIO) AS lines
						FROM
							KPRAKTOR.SIAPR.DISBASE bom
						WHERE
							bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
							AND bom.DB_DITTA = 1
						GROUP BY
							bom.DB_CODICE_PADRE
					)bom ON (kps.Item = bom.Item)
		)bol ON (kpc.Item = bol.item)
	LEFT JOIN
		(
			SELECT
				 t1.DB_CODICE_PADRE
				,t1.DB_DITTA
				,'IT' + RIGHT('0000000' + CAST(RANK() OVER (PARTITION BY t1.DB_DITTA ORDER BY t1.DB_CODICE_PADRE ASC) AS VARCHAR(5)),7) AS Model
			FROM
				(
			SELECT
				DISTINCT
					bom.DB_CODICE_PADRE
					,bom.DB_DITTA
			FROM
				KPRAKTOR.SIAPR.DISBASE bom
				JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kps.SupplySource IN (20) AND kps.Class <> 4 AND bom.DB_DITTA = 1 AND (kps.POV1 = 1 OR kps.POV2 = 1))
				)t1
		)t1 ON (bom.DB_CODICE_PADRE = t1.DB_CODICE_PADRE AND bom.DB_DITTA = t1.DB_DITTA)
WHERE
	bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
	AND itm.MG_FLAG_FUORI_PROD <> 'S'

UNION ALL



/* JOBSHOP FOR POVIGLIO 3 SPARE PARTS   */


SELECT
	 CAST('IT.POV.03' AS VARCHAR(9))AS Site										/*Site (tibom300/310.site) - References to tcemm050 Sites                                                                                               Infor LN tables: tibom300, tibom310, timfc301 | TRUE | null | 9 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS ProductProject							/*Project segment of Product (tibom300/310.mitm)   - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tibom300/310.mitm)   - References to tiipd001 Item Production Data | TRUE | null | 38 | |*/	
	,t1.Model AS Model															/*Model (tibom300/310.bmdl) | FALSE | null | 9 | |*/
/* 30-01-2023 KL : New field Revision in template 202310 */
	,CAST('000001' AS VARCHAR(6)) AS Revision									/* Revision (tibom300/tibom310.bmrv) */
	,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))*10 AS Position																																				/*Position (tibom310.pono) | TRUE | 0 |  | |*/
	,20 AS [Status]																/*Status (tibom300.bmst) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |  | 10;"New";20;"Approved";30;"Expired"|*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tibom300.efdt) | TRUE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tibom300.exdt)  - When empty, date will be set to MAX | TRUE | null |  | |*/
	,CAST(NULL AS VARCHAR(9)) AS Routing										/*Routing (tibom300.rouc) | FALSE | null | 9 | |*/
	,CAST(1 AS FLOAT) AS BomQuantity											/*BOM Quantity (tibom300.unom) - Quantity on Main item, usually this is set to 1 | FALSE | 1 |  | |*/
	,CAST(1 AS FLOAT) AS UseForPlanning											/*Use for Planning (tibom300.ufpl) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(1 AS FLOAT) AS UseForCosting											/*Use for Planning (tibom300.ufcs) | TRUE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CASE WHEN itc.MG_GEST_PROD = 'I' AND itc.MG_ESPL_DB IN ('00','01','02','03','06') THEN 0                                                                 
		ELSE
			CASE WHEN mwc.WorkCenter IS NOT NULL AND kps.Itemgroup = 'GEKIT6' THEN 6000
				ELSE
					CASE WHEN mwc.WorkCenter IS NOT NULL AND kps.Itemgroup <> 'GEKIT6' THEN 6010
								ELSE 6000
						END
				END 
		END AS Operation														/*Operation (tibom310.opno) | TRUE | 0 |  | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS SubItemProjectSegment					/*Project segment of Sub Item (tibom310.sitm)   - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kpc.ItemLnCE AS VARCHAR(38)) AS SubItemItemSegment					/*Item segment of Sub Item (tibom310.sitm)   - References to tcibd001 General Item Data | FALSE | null | 38 | |*/
	,CAST('IT0300' AS VARCHAR(6)) AS Warehouse									/*Warehouse (tibom310.cwar)     - References tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
		CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
			ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
			END		
		END AS FLOAT) AS NetQuantity											/*Net Quantity (tibom310.qana) - Quantity for the Sub item | FALSE | 0 |  | |*/
	,0 AS ScrapQuantity															/*Scrap Quantity (tibom310.scpq) | FALSE | 0 |  | |*/
	,0 AS ScrapFactor															/*Scrap Factor (tibom310.scpf) | FALSE | 0 |  | |*/
	,0 AS [Length]																/*Length (tibom310.leng) Can only be filled when unit is of type lenght or area. Default = 0 | FALSE | 0 |  | |*/
	,0 AS Width																	/*Width (tibom310.widt) Can only be filled when unit is of type lenght or area. Default = 0 | FALSE | 0 |  | |*/
	,CAST(NULL AS VARCHAR(3)) AS SizeUnit										/*Size Unit (tibom310.sizu) - references to tcmcs001 | FALSE | null | 3 | |*/
	,0 AS NumberOfUnits															/*Number of Units (tibom310.noun) The required quantity of the material, expressed as the number of units of specified length and width. Default = 0 | FALSE | 0 |  | |*/
	,CASE WHEN itc.MG_GEST_PROD = 'I' AND itc.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 ELSE 2 END AS Phantom 	/*Phantom (tibom310.cpha) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE WHEN itc.MG_GEST_PROD = 'I' AND itc.MG_ESPL_DB IN ('00','01','02','03','06') THEN 2 ELSE 1 END AS ReportMaterial	/*Report Material (tibom310.rmtl) | FALSE | 2 |  | 1;"Backflush";2;"Manual";80;"Undefined"|*/
	,2 AS InheritDemandPeg														/*Inherit Demand Peg (tibom310.idpg) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS AllowMultipleItems													/*Allow Multiple Items (tibom310.almi) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS SuppliedBySubcontractor												/*Supplied by Subcontractor (tibom310.sbsr) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS AlternativesPresent													/*Alternatives Present (tibom310.altp) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CAST(NULL AS VARCHAR(9))  AS BomLineText									/*BOM Line Text (tttxt010.ctxt) |  | null |  | |*/
	,0 AS BomLineTextID															/*BOM Text ID (tibom310.txta) |  | 0 |  | |*/
FROM
    KPRAKTOR.SIAPR.DISBASE bom
    JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)
    JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.SupplySource IN (20) AND kps.Class <> 4 AND kps.ItemType = 30 AND (kps.POV3 = 1)) 
	JOIN ZZZ_Italy.dbo.KPSourceSP kpp ON (kps.Item = kpp.item AND kpp.SupplySource = 20)
	JOIN KPRAKTOR.SIAPR.ANAMAG itc ON (bom.DB_CODICE_FIGLIO = itc.MG_CODICE AND bom.DB_DITTA = itc.MG_DITTA)
	JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND itc.MG_DITTA = 1 AND kpc.Migrate = 1 AND kpc.Class <> 4  AND kpc.ItemType = 30 ) 
	LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
	LEFT JOIN ZZZ_Italy.dbo.MappingWC mwc ON (bom.DB_REPARTO = mwc.Reparto AND  bom.DB_DITTA = 1)
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
							bom.DB_CODICE_PADRE AS Item
							,COUNT(bom.DB_CODICE_FIGLIO) AS lines
						FROM
							KPRAKTOR.SIAPR.DISBASE bom
						WHERE
							bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
							AND bom.DB_DITTA = 1
						GROUP BY
							bom.DB_CODICE_PADRE
					)bom ON (kps.Item = bom.Item)
		)bol ON (kpc.Item = bol.item)
	LEFT JOIN
		(
			SELECT
				 t1.DB_CODICE_PADRE
				,t1.DB_DITTA
				,'IT' + RIGHT('0000000' + CAST(RANK() OVER (PARTITION BY t1.DB_DITTA ORDER BY t1.DB_CODICE_PADRE ASC) AS VARCHAR(5)),7) AS Model
			FROM
				(
			SELECT
				DISTINCT
					bom.DB_CODICE_PADRE
					,bom.DB_DITTA
			FROM
				KPRAKTOR.SIAPR.DISBASE bom
				JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kps.SupplySource IN (20) AND kps.Class <> 4 AND bom.DB_DITTA = 1 AND kps.POV3 = 1)
				)t1
		)t1 ON (bom.DB_CODICE_PADRE = t1.DB_CODICE_PADRE AND bom.DB_DITTA = t1.DB_DITTA)
WHERE
	bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
	AND itm.MG_FLAG_FUORI_PROD <> 'S'
GO


