USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_JobShopBillOfMaterial]    Script Date: 3/8/2024 10:14:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[vw_JobShopBillOfMaterial] AS

SELECT
	 CAST('IT.POV.01' AS VARCHAR(9))AS Site										/*Site (tibom300/310.site) - References to tcemm050 Sites                                                                                               Infor LN tables: tibom300, tibom310, timfc301 | TRUE | null | 9 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS ProductProject							/*Project segment of Product (tibom300/310.mitm)   - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tibom300/310.mitm)   - References to tiipd001 Item Production Data | TRUE | null | 38 | |*/	
	,CAST(t1.Model AS VARCHAR(9)) AS Model										/*Model (tibom300/310.bmdl) | FALSE | null | 9 | |*/
/* 30-01-2023 KL : New field Revision in template 202310 */
	,CAST('000001' AS VARCHAR(6)) AS Revision									/* Revision (tibom300/tibom310.bmrv) */
	,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))* 10 AS Position																																				/*Position (tibom310.pono) | TRUE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS [Status]																/*Status (tibom300.bmst) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |  | 10;"New";20;"Approved";30;"Expired"|*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tibom300.efdt) | TRUE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tibom300.exdt)  - When empty, date will be set to MAX | TRUE | null |  | |*/
	,CAST(CASE WHEN rou.Routing IS NULL THEN NULL ELSE rou.Routing END AS VARCHAR(9)) AS Routing										/*Routing (tibom300.rouc) | FALSE | null | 9 | |*/
	,CAST(1 AS FLOAT) AS BomQuantity											/*BOM Quantity (tibom300.unom) - Quantity on Main item, usually this is set to 1 | FALSE | 1 |  | |*/
	,CAST(2 AS FLOAT) AS UseForPlanning											/*Use for Planning (tibom300.ufpl) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(2 AS FLOAT) AS UseForCosting											/*Use for Planning (tibom300.ufcs) | TRUE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(CASE WHEN mwc.Operation IS NULL THEN 0
		ELSE
			CASE WHEN (kpc.ItemGroup = 'DPMTO' OR kpc.SupplySource IN (50)) AND mwc.Operation IS NOT NULL THEN mwc.Operation
				ELSE
					CASE WHEN (kpc.ItemGroup = 'DPMTO' OR kpc.SupplySource IN (50)) AND mwc.Operation IS NULL THEN 0
						ELSE
							CASE WHEN itc.MG_GEST_PROD = 'I' AND itc.MG_ESPL_DB IN ('00','01','02','03','06') THEN 0
								ELSE CAST(mwc.Operation AS FLOAT)
								END
						END
				END
		END AS FLOAT) AS Operation												/*Operation (tibom310.opno) | TRUE | 0 |  | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS SubItemProjectSegment					/*Project segment of Sub Item (tibom310.sitm)   - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kpc.ItemLnCE AS VARCHAR(38)) AS SubItemItemSegment					/*Item segment of Sub Item (tibom310.sitm)   - References to tcibd001 General Item Data | FALSE | null | 38 | |*/
	,CAST(scc.Warehouse AS VARCHAR(6)) AS Warehouse								/*Warehouse (tibom310.cwar)     - References tcmcs003 Warehouses | FALSE | null | 6 | |*/
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
	,CAST(CASE WHEN kps.ItemGroup = 'DPMTO' OR kps.SupplySource IN (50) THEN 2
		ELSE
			CASE WHEN itc.MG_GEST_PROD = 'I' AND itc.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 
				ELSE 2 
				END 
		END AS FLOAT) AS Phantom 												/*Phantom (tibom310.cpha) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CAST(2 AS FLOAT) AS ReportMaterial											/*Report Material (tibom310.rmtl) | FALSE | 2 |  | 1;"Backflush";2;"Manual";80;"Undefined"|*/
	,2 AS InheritDemandPeg														/*Inherit Demand Peg (tibom310.idpg) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS AllowMultipleItems													/*Allow Multiple Items (tibom310.almi) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS SuppliedBySubcontractor												/*Supplied by Subcontractor (tibom310.sbsr) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS AlternativesPresent													/*Alternatives Present (tibom310.altp) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CAST(NULL AS VARCHAR(9))  AS BomLineText									/*BOM Line Text (tttxt010.ctxt) |  | null |  | |*/
	,0 AS BomLineTextID															/*BOM Text ID (tibom310.txta) |  | 0 |  | |*/
FROM
    KPRAKTOR.SIAPR.DISBASE bom
    JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)
    JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.SupplySource IN (20) AND kps.Class <> 4 AND kps.ItemType = 30 AND (kps.POV1 <> 0)) 
	JOIN KPRAKTOR.SIAPR.ANAMAG itc ON (bom.DB_CODICE_FIGLIO = itc.MG_CODICE AND bom.DB_DITTA = itc.MG_DITTA)
	JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND itc.MG_DITTA = 1 AND kpc.Migrate = 1 AND kpc.Class <> 4  AND kpc.ItemType = 30 AND kps.POV1 <> 0 ) 
	LEFT JOIN [ZZZ_Italy].[dbo].[SCModelMap] scc ON (kpc.POV1 = scc.POV1 AND scc.Site = 'IT.POV.01')
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
				JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kps.SupplySource IN (20) AND kps.Class <> 4 AND bom.DB_DITTA = 1 AND kps.POV1 <> 0)
				)t1
		)t1 ON (bom.DB_CODICE_PADRE = t1.DB_CODICE_PADRE AND bom.DB_DITTA = t1.DB_DITTA)
LEFT JOIN
	(
SELECT
	 jsr.Site
	,jsr.ManufacturedProject
	,jsr.ManufacturedItem
	,jsr.Routing
	,jsr.Revision
	,jsr.Status
	,jsr.EffectiveDate
	,jsr.ExpiryDate
	,jsr.Description
	,jsr.StandardRouting
	,jsr.StandardRoutingCode
	,jsr.StandardRoutingRevision
	,jsr.RoutingQuantity
	,jsr.MinimumQuantity
	,jsr.MaximumQuantity
	,CASE WHEN jsr.StandardRouting = 2 THEN lt.Leadtime ELSE jsr.OrderLeadTime END AS OrderLeadTime
	,jsr.OrderLeadTimeUnit
	,jsr.SubcWithMaterialFlow
	,jsr.UseForPlanning
	,jsr.UseForCosting
	,jsr.PlanGroup
FROM
	(
		SELECT
			 'IT.POV.01' AS [Site]														/*Site (site) - Reference to tcemm050 Sites                                                                                     Infor LN table: tirou400 | TRUE | null | 9 | |*/
			,CAST('PROJEMPTY' AS VARCHAR(9)) AS ManufacturedProject						/*Project (mitm)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
			,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN kps.ItemLnCE ELSE NULL END AS VARCHAR(38)) AS ManufacturedItem		 /*Manufactured Item (mitm)   - References tiipd001 Item Production Data | TRUE | null | 38 | |*/	/* ||||| New 20240209 ||||| */
			,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN '001' ELSE ('IT.' + RIGHT(('000000' + CAST((ROW_NUMBER() OVER(ORDER BY (CAST(kps.ItemLnCE AS VARCHAR(38))) ASC)) AS VARCHAR(6))),6)) END AS VARCHAR(9)) AS Routing /*Routing (rouc) | TRUE | null | 9 | |*/
		/* 30-01-2023 KL : Not New field Revision in template 202310 was already in april template */
			,CAST('000001' AS VARCHAR(6)) AS Revision	
			,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN 10 ELSE 10 END AS FLOAT) AS Status		/*Status (rost)  When loading with DAL, use status 10 (new) and approve as post conversion action. | FALSE | 20 |  | 10;"New";20;"Approved";30;"Expired"|*/
			,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (efdt) | FALSE | null |  | |*/
			,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (exdt) - When empty, date will be set to MAX | TRUE | null |  | |*/
			,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN NULL ELSE kps.ItemLnCE END AS VARCHAR(38)) AS Description 							/*Description (dsca) | TRUE | null | 30 | |*/							/* ||||| New 20240209 ||||| */
			,CASE WHEN kps.Itemgroup = 'DPMTO1' THEN 2 ELSE 1 END StandardRouting		/*Standard Routing (stor) | TRUE | 2 |  | 1;"Yes";2;"No (default)"|*/	/* ||||| New 20240209 ||||| */
			,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN NULL ELSE kps.ItemLnCE END AS VARCHAR(38)) AS StandardRoutingCode			/*Standard Routing Code (strc)   When Item is empty or Standard Routing is "no", no value allowed. When standard routing is "yes", this field is mandatory and must be an existing standard routing code. | FALSE | null | 9 | |*/		/* ||||| New 20240209 ||||| */
			,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN NULL ELSE '000001' END AS VARCHAR(6)) AS StandardRoutingRevision					/*Standard Routing Revision (rtrv) When Item is empty or Standard Routing is "no", no value allowed. When standard routing is "yes", this field is mandatory and must be an existing standard routing code. | FALSE | null | 6 | |*/
			,1 AS RoutingQuantity														/*Routing Quantity (roqa) | FALSE | 1 |  | >0|*/
			,1 AS MinimumQuantity														/*Minimum Quantity (minq) | FALSE | 0 |  | >=0|*/
			,99999999 AS MaximumQuantity												/*Maximum Quantity (maxq) | FALSE | 99999999 |  | >0|*/
			,0 AS OrderLeadTime															/*Order Lead Time (oltm) | FALSE | 0 |  | >=0|*/
			,5 AS OrderLeadTimeUnit														/*Order Lead Time Unit (oltu) | FALSE | 5 |  | 5;"Hours";10;"Days"|*/
			,2 AS SubcWithMaterialFlow													/*Subcontracting with Material Flow (smfs) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
			,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN 2 ELSE 2 END AS FLOAT) AS UseForPlanning					/*Use for Planning (ufpl) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
			,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN 2 ELSE 2 END AS FLOAT) AS UseForCosting					/*Use for Planning (ufcs) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
			,CAST(NULL AS VARCHAR(6)) AS PlanGroup                                     /* PlanGroup Can be used if production scheduler is checked in implemented software components  | FALSE |  |  | |*/

		FROM
			KPRAKTOR.SIAPR.ANAMAG itm
			JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV1 <> 0)
			JOIN 
				(
					SELECT
						 rou.CL_CODICE_CICLO
						,rou.CL_DITTA
					FROM
						KPRAKTOR.SIAPR.CICLIL rou
					WHERE
						rou.CL_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
						AND CL_CODICE_CENTRO <> 'E'
					GROUP BY
						 rou.CL_CODICE_CICLO
						,rou.CL_DITTA
			)rou ON (itm.MG_CODICE = rou.CL_CODICE_CICLO AND itm.MG_DITTA = rou.CL_DITTA)
			LEFT JOIN
				(
					SELECT
						 CL_CODICE_CICLO
						,CL_CODICE_CENTRO
						,CL_DITTA
						,COUNT(*) AS qty
					FROM
						KPRAKTOR.SIAPR.CICLIL rou
						JOIN ZZZ_Italy.dbo.KPSource kps ON (rou.CL_CODICE_CICLO = kps.Item AND rou.CL_DITTA =  1 AND kps.Migrate = 1 AND kps.POV1 <> 0)
					WHERE
						rou.CL_DATA_FIN_VAL >= CONVERT(INT,GETDATE()) AND CL_CODICE_CENTRO <> 'E'
					GROUP BY 
						CL_CODICE_CICLO
						,CL_CODICE_CENTRO
						,CL_DITTA
					HAVING COUNT(*) > 1
				)dup ON  (rou.CL_CODICE_CICLO = dup.CL_CODICE_CICLO AND rou.CL_DITTA = dup.CL_DITTA)
		WHERE
			dup.CL_CODICE_CENTRO IS NULL
	)jsr
	LEFT JOIN
		(
			SELECT
				 lt.Site
				,lt.ManufacturedProject
				,lt.ManufacturedItem
				,ROUND(SUM(lt.CycleTime)/60,4) AS LeadTime
			FROM
				(
			SELECT
				 lt.Site
				,lt.ManufacturedProject
				,lt.ManufacturedItem
				,lt.Operation
				,lt.NextOperation
				,lt.CycleTime
				,ROW_NUMBER () OVER (PARTITION BY lt.Site, lt.ManufacturedItem, Lt.NextOperation ORDER BY lt.Operation) AS RN

			FROM
				(
					SELECT
						 CAST('IT.POV.01' AS VARCHAR(9)) AS [Site]											/*Site (site) - Reference to tcemm050 Sites     Infor LN table: tirou401 | TRUE | null |Text | 9 | |*/
						,CAST('PROJEMPTY' AS VARCHAR(9)) AS ManufacturedProject								/*Project (mitm)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN kps.ItemLnCE ELSE NULL END AS VARCHAR(38)) AS ManufacturedItem										/*Manufactured Item (mitm)   - References tiipd001 Item Production Data | TRUE | null | 38 | |*/
						,CAST(roh.Routing AS VARCHAR(9)) AS Routing											/*Routing (rouc) | TRUE | null |Text | 9 | |*/
						,CAST(CASE WHEN mwc.Operation IS NULL THEN 0 ELSE mwc.Operation END AS FLOAT) AS Operation	/*Operation (opno) | TRUE | 0 |Long Integer |  | <100000|*/
						,CAST(CASE WHEN mwc.NextOperation IS NULL THEN 0 ELSE mwc.NextOperation END AS FLOAT) AS NextOperation													/*Next Operation (nopr) | TRUE | 0 |Long Integer |  | <100000|*/
						,CAST(rou.CL_TEMPO_LAVOR AS FLOAT) AS CycleTime										/*Cycle Time in Minutes (rutm) | TRUE | 0 |Decimal |  | |*/

					FROM
						KPRAKTOR.SIAPR.ANAMAG itm
						JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND POV1 <> 0)
						JOIN KPRAKTOR.SIAPR.CICLIL rou ON (itm.MG_CODICE = rou.CL_CODICE_CICLO AND itm.MG_DITTA = rou.CL_DITTA AND rou.CL_DATA_FIN_VAL >= CONVERT(INT,GETDATE()) AND CL_CODICE_CENTRO <> 'E')
						LEFT JOIN ZZZ_Italy.dbo.MappingWC mwc ON (rou.CL_CODICE_CENTRO = mwc.Centro AND  rou.CL_DITTA = 1)
						JOIN
						 (
							SELECT
								 'IT.POV.01' AS [Site]														/*Site (site) - Reference to tcemm050 Sites                                                                                     Infor LN table: tirou400 | TRUE | null | 9 | |*/
								,CAST('PROJEMPTY' AS VARCHAR(9)) AS ManufacturedProject						/*Project (mitm)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN kps.ItemLnCE ELSE NULL END AS VARCHAR(38)) AS ManufacturedItem		 /*Manufactured Item (mitm)   - References tiipd001 Item Production Data | TRUE | null | 38 | |*/	/* ||||| New 20240209 ||||| */
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN '001' ELSE ('IT.' + RIGHT(('000000' + CAST((ROW_NUMBER() OVER(ORDER BY (CAST(kps.ItemLnCE AS VARCHAR(38))) ASC)) AS VARCHAR(6))),6)) END AS VARCHAR(9)) AS Routing /*Routing (rouc) | TRUE | null | 9 | |*/

							/* 30-01-2023 KL : Not New field Revision in template 202310 was already in april template */
								,CAST('000001' AS VARCHAR(6)) AS Revision	
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN 20 ELSE 10 END AS FLOAT) AS Status		/*Status (rost)  When loading with DAL, use status 10 (new) and approve as post conversion action. | FALSE | 20 |  | 10;"New";20;"Approved";30;"Expired"|*/
								,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (efdt) | FALSE | null |  | |*/
								,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (exdt) - When empty, date will be set to MAX | TRUE | null |  | |*/
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN NULL ELSE kps.ItemLnCE END AS VARCHAR(38)) AS Description 							/*Description (dsca) | TRUE | null | 30 | |*/							/* ||||| New 20240209 ||||| */
								,CASE WHEN kps.Itemgroup = 'DPMTO1' THEN 2 ELSE 1 END StandardRouting		/*Standard Routing (stor) | TRUE | 2 |  | 1;"Yes";2;"No (default)"|*/	/* ||||| New 20240209 ||||| */
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN NULL ELSE kps.ItemLnCE END AS VARCHAR(38)) AS StandardRoutingCode			/*Standard Routing Code (strc)   When Item is empty or Standard Routing is "no", no value allowed. When standard routing is "yes", this field is mandatory and must be an existing standard routing code. | FALSE | null | 9 | |*/		/* ||||| New 20240209 ||||| */
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN NULL ELSE '000001' END AS VARCHAR(6)) AS StandardRoutingRevision					/*Standard Routing Revision (rtrv) When Item is empty or Standard Routing is "no", no value allowed. When standard routing is "yes", this field is mandatory and must be an existing standard routing code. | FALSE | null | 6 | |*/
								,1 AS RoutingQuantity														/*Routing Quantity (roqa) | FALSE | 1 |  | >0|*/
								,1 AS MinimumQuantity														/*Minimum Quantity (minq) | FALSE | 0 |  | >=0|*/
								,99999999 AS MaximumQuantity												/*Maximum Quantity (maxq) | FALSE | 99999999 |  | >0|*/
								,0 AS OrderLeadTime															/*Order Lead Time (oltm) | FALSE | 0 |  | >=0|*/
								,5 AS OrderLeadTimeUnit														/*Order Lead Time Unit (oltu) | FALSE | 5 |  | 5;"Hours";10;"Days"|*/
								,2 AS SubcWithMaterialFlow													/*Subcontracting with Material Flow (smfs) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN 1 ELSE 2 END AS FLOAT) AS UseForPlanning					/*Use for Planning (ufpl) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN 1 ELSE 2 END AS FLOAT) AS UseForCosting					/*Use for Planning (ufcs) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
								,CAST(NULL AS VARCHAR(6)) AS PlanGroup                                     /* PlanGroup Can be used if production scheduler is checked in implemented software components  | FALSE |  |  | |*/
								,rou.CL_CODICE_CICLO
								,itm.MG_DITTA
							FROM
								KPRAKTOR.SIAPR.ANAMAG itm
								JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV1 <> 0)
								JOIN 
									(
										SELECT
											 rou.CL_CODICE_CICLO
											,rou.CL_DITTA
										FROM
											KPRAKTOR.SIAPR.CICLIL rou
										WHERE
											rou.CL_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
											AND CL_CODICE_CENTRO <> 'E'
										GROUP BY
											 rou.CL_CODICE_CICLO
											,rou.CL_DITTA
								)rou ON (itm.MG_CODICE = rou.CL_CODICE_CICLO AND itm.MG_DITTA = rou.CL_DITTA)
								LEFT JOIN
									(
										SELECT
											 CL_CODICE_CICLO
											,CL_CODICE_CENTRO
											,CL_DITTA
											,COUNT(*) AS qty
										FROM
											KPRAKTOR.SIAPR.CICLIL rou
											JOIN ZZZ_Italy.dbo.KPSource kps ON (rou.CL_CODICE_CICLO = kps.Item AND rou.CL_DITTA =  1 AND kps.Migrate = 1 AND kps.POV1 <> 0)
										WHERE
											rou.CL_DATA_FIN_VAL >= CONVERT(INT,GETDATE()) AND CL_CODICE_CENTRO <> 'E'
										GROUP BY 
											CL_CODICE_CICLO
											,CL_CODICE_CENTRO
											,CL_DITTA
										HAVING COUNT(*) > 1
									)dup ON  (rou.CL_CODICE_CICLO = dup.CL_CODICE_CICLO AND rou.CL_DITTA = dup.CL_DITTA)
							WHERE
								dup.CL_CODICE_CENTRO IS NULL
						)roh ON (rou.CL_CODICE_CICLO = roh.CL_CODICE_CICLO)
				)lt
			WHERE
				lt.ManufacturedItem IS NOT NULL
				)lt
			WHERE
				lt.RN = 1
			GROUP BY
				 lt.Site
				,lt.ManufacturedProject
				,lt.ManufacturedItem
		)lt ON (jsr.Site = lt.Site AND jsr.ManufacturedProject = lt.ManufacturedProject AND jsr.ManufacturedItem = lt.ManufacturedItem)
	)rou ON (kps.ItemLnCE = rou.ManufacturedItem AND rou.StandardRouting = 2 AND  kps.ItemGroup = 'DPMTO1')
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
	,10 AS [Status]																/*Status (tibom300.bmst) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |  | 10;"New";20;"Approved";30;"Expired"|*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tibom300.efdt) | TRUE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tibom300.exdt)  - When empty, date will be set to MAX | TRUE | null |  | |*/
	,CAST(rou.Routing AS VARCHAR(9)) AS Routing									/*Routing (tibom300.rouc) | FALSE | null | 9 | |*/
	,CAST(1 AS FLOAT) AS BomQuantity											/*BOM Quantity (tibom300.unom) - Quantity on Main item, usually this is set to 1 | FALSE | 1 |  | |*/
	,CAST(2 AS FLOAT) AS UseForPlanning											/*Use for Planning (tibom300.ufpl) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(2 AS FLOAT) AS UseForCosting											/*Use for Planning (tibom300.ufcs) | TRUE | 2 |  | 1;"Yes";2;"No (default)"|*/

/*	Due to Mapping R01 excluded
	,CASE WHEN itc.MG_GEST_PROD = 'I' AND itc.MG_ESPL_DB IN ('00','01','02','03','06') THEN 0                                                                 
		ELSE
			CASE WHEN mwc.WorkCenter IS NOT NULL AND kps.Itemgroup = 'GEKIT6' THEN 6000
				ELSE
					CASE WHEN mwc.WorkCenter IS NOT NULL AND kps.Itemgroup <> 'GEKIT6' THEN 6010
								ELSE 6000
						END
				END 
		END AS Operation														/*Operation (tibom310.opno) | TRUE | 0 |  | |*/
*/
	,CAST(CASE WHEN mwc.Reparto = 'R01' THEN 6010 ELSE 6000 END AS FLOAT) AS Operation	/*Operation (tibom310.opno) | TRUE | 0 |  | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS SubItemProjectSegment					/*Project segment of Sub Item (tibom310.sitm)   - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kpc.ItemLnCE AS VARCHAR(38)) AS SubItemItemSegment					/*Item segment of Sub Item (tibom310.sitm)   - References to tcibd001 General Item Data | FALSE | null | 38 | |*/
	,CAST(scc.Warehouse AS VARCHAR(6)) AS Warehouse								/*Warehouse (tibom310.cwar)     - References tcmcs003 Warehouses | FALSE | null | 6 | |*/
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
	,CAST(CASE WHEN kpc.ItemGroup = 'DPMTO' OR kpu.SupplySource IN (50) THEN 2
		ELSE
			CASE WHEN itc.MG_GEST_PROD = 'I' AND itc.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 
				ELSE 2 
				END 
		END AS FLOAT) AS														Phantom 	/*Phantom (tibom310.cpha) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CAST(2 AS FLOAT) AS ReportMaterial											/*Report Material (tibom310.rmtl) | FALSE | 2 |  | 1;"Backflush";2;"Manual";80;"Undefined"|*/
	,2 AS InheritDemandPeg														/*Inherit Demand Peg (tibom310.idpg) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS AllowMultipleItems													/*Allow Multiple Items (tibom310.almi) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS SuppliedBySubcontractor												/*Supplied by Subcontractor (tibom310.sbsr) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS AlternativesPresent													/*Alternatives Present (tibom310.altp) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CAST(NULL AS VARCHAR(9))  AS BomLineText									/*BOM Line Text (tttxt010.ctxt) |  | null |  | |*/
	,0 AS BomLineTextID															/*BOM Text ID (tibom310.txta) |  | 0 |  | |*/
FROM
    KPRAKTOR.SIAPR.DISBASE bom
    JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)
    JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.Class <> 4 AND kps.ItemType = 30 AND (kps.POV3 = 1)) 
	JOIN ZZZ_Italy.dbo.KPSourceSP kpp ON (kps.Item = kpp.item AND kpp.SupplySource = 20)
	JOIN KPRAKTOR.SIAPR.ANAMAG itc ON (bom.DB_CODICE_FIGLIO = itc.MG_CODICE AND bom.DB_DITTA = itc.MG_DITTA)
	JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND itc.MG_DITTA = 1 AND kpc.Migrate = 1 AND kpc.Class <> 4  AND kpc.ItemType = 30 AND kps.POV3 = 1)
	LEFT JOIN [ZZZ_Italy].[dbo].[SCModelMap] scc ON (kpc.POV3 = scc.POV3 AND scc.Site = 'IT.POV.03' )
	JOIN ZZZ_Italy.dbo.KPSourceSP kpu ON (kpc.Item = kpu.item)
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
				JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1  AND kps.Class <> 4 AND bom.DB_DITTA = 1 AND kps.POV3 = 1)
				JOIN ZZZ_Italy.dbo.KPSourceSP kpp ON (kps.Item = kpp.item AND kpp.SupplySource = 20)
				)t1
		)t1 ON (bom.DB_CODICE_PADRE = t1.DB_CODICE_PADRE AND bom.DB_DITTA = t1.DB_DITTA)
LEFT JOIN
	(
SELECT
	 jsr.Site
	,jsr.ManufacturedProject
	,jsr.ManufacturedItem
	,jsr.Routing
	,jsr.Revision
	,jsr.Status
	,jsr.EffectiveDate
	,jsr.ExpiryDate
	,jsr.Description
	,jsr.StandardRouting
	,jsr.StandardRoutingCode
	,jsr.StandardRoutingRevision
	,jsr.RoutingQuantity
	,jsr.MinimumQuantity
	,jsr.MaximumQuantity
	,CASE WHEN jsr.StandardRouting = 2 THEN lt.Leadtime ELSE jsr.OrderLeadTime END AS OrderLeadTime
	,jsr.OrderLeadTimeUnit
	,jsr.SubcWithMaterialFlow
	,jsr.UseForPlanning
	,jsr.UseForCosting
	,jsr.PlanGroup
FROM
	(
		SELECT
			 'IT.POV.03' AS [Site]														/*Site (site) - Reference to tcemm050 Sites                                                                                     Infor LN table: tirou400 | TRUE | null | 9 | |*/
			,CAST('PROJEMPTY' AS VARCHAR(9)) AS ManufacturedProject						/*Project (mitm)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
			,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ManufacturedItem						/*Manufactured Item (mitm)   - References tiipd001 Item Production Data | TRUE | null | 38 | |*/	/* ||||| New 20240209 ||||| */
			,CAST('001' AS VARCHAR(9)) AS Routing /*Routing (rouc) | TRUE | null | 9 | |*/
		/* 30-01-2023 KL : Not New field Revision in template 202310 was already in april template */
			,CAST('000001' AS VARCHAR(6)) AS Revision	
			,CAST(10 AS FLOAT) AS Status												/*Status (rost)  When loading with DAL, use status 10 (new) and approve as post conversion action. | FALSE | 20 |  | 10;"New";20;"Approved";30;"Expired"|*/
			,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (efdt) | FALSE | null |  | |*/
			,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (exdt) - When empty, date will be set to MAX | TRUE | null |  | |*/
			,CAST(NULL AS VARCHAR(38)) AS Description 									/*Description (dsca) | TRUE | null | 30 | |*/							/* ||||| New 20240209 ||||| */
			,CAST(2 AS FLOAT) AS StandardRouting										/*Standard Routing (stor) | TRUE | 2 |  | 1;"Yes";2;"No (default)"|*/	/* ||||| New 20240209 ||||| */
			,CAST(NULL AS VARCHAR(38)) AS StandardRoutingCode							/*Standard Routing Code (strc)   When Item is empty or Standard Routing is "no", no value allowed. When standard routing is "yes", this field is mandatory and must be an existing standard routing code. | FALSE | null | 9 | |*/		/* ||||| New 20240209 ||||| */
			,CAST(NULL AS VARCHAR(6))			AS StandardRoutingRevision					/*Standard Routing Revision (rtrv) When Item is empty or Standard Routing is "no", no value allowed. When standard routing is "yes", this field is mandatory and must be an existing standard routing code. | FALSE | null | 6 | |*/
			,1 AS RoutingQuantity														/*Routing Quantity (roqa) | FALSE | 1 |  | >0|*/
			,1 AS MinimumQuantity														/*Minimum Quantity (minq) | FALSE | 0 |  | >=0|*/
			,99999999 AS MaximumQuantity												/*Maximum Quantity (maxq) | FALSE | 99999999 |  | >0|*/
			,0 AS OrderLeadTime															/*Order Lead Time (oltm) | FALSE | 0 |  | >=0|*/
			,5 AS OrderLeadTimeUnit														/*Order Lead Time Unit (oltu) | FALSE | 5 |  | 5;"Hours";10;"Days"|*/
			,2 AS SubcWithMaterialFlow													/*Subcontracting with Material Flow (smfs) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
			,CAST(2 AS FLOAT)						AS UseForPlanning					/*Use for Planning (ufpl) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
			,CAST(2 AS FLOAT) AS UseForCosting											/*Use for Planning (ufcs) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
			,CAST(NULL AS VARCHAR(6)) AS PlanGroup                                     /* PlanGroup Can be used if production scheduler is checked in implemented software components  | FALSE |  |  | |*/

		FROM
			KPRAKTOR.SIAPR.ANAMAG itm
			JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV1 <> 0)
			JOIN 
				(
					SELECT
						 rou.CL_CODICE_CICLO
						,rou.CL_DITTA
					FROM
						KPRAKTOR.SIAPR.CICLIL rou
					WHERE
						rou.CL_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
						AND CL_CODICE_CENTRO <> 'E'
					GROUP BY
						 rou.CL_CODICE_CICLO
						,rou.CL_DITTA
			)rou ON (itm.MG_CODICE = rou.CL_CODICE_CICLO AND itm.MG_DITTA = rou.CL_DITTA)
			LEFT JOIN
				(
					SELECT
						 CL_CODICE_CICLO
						,CL_CODICE_CENTRO
						,CL_DITTA
						,COUNT(*) AS qty
					FROM
						KPRAKTOR.SIAPR.CICLIL rou
						JOIN ZZZ_Italy.dbo.KPSource kps ON (rou.CL_CODICE_CICLO = kps.Item AND rou.CL_DITTA =  1 AND kps.Migrate = 1 AND kps.POV1 <> 0)
					WHERE
						rou.CL_DATA_FIN_VAL >= CONVERT(INT,GETDATE()) AND CL_CODICE_CENTRO <> 'E'
					GROUP BY 
						CL_CODICE_CICLO
						,CL_CODICE_CENTRO
						,CL_DITTA
					HAVING COUNT(*) > 1
				)dup ON  (rou.CL_CODICE_CICLO = dup.CL_CODICE_CICLO AND rou.CL_DITTA = dup.CL_DITTA)
		WHERE
			dup.CL_CODICE_CENTRO IS NULL
	)jsr
	LEFT JOIN
		(
			SELECT
				 lt.Site
				,lt.ManufacturedProject
				,lt.ManufacturedItem
				,ROUND(SUM(lt.CycleTime)/60,4) AS LeadTime
			FROM
				(
			SELECT
				 lt.Site
				,lt.ManufacturedProject
				,lt.ManufacturedItem
				,lt.Operation
				,lt.NextOperation
				,lt.CycleTime
				,ROW_NUMBER () OVER (PARTITION BY lt.Site, lt.ManufacturedItem, Lt.NextOperation ORDER BY lt.Operation) AS RN

			FROM
				(
					SELECT
						 CAST('IT.POV.03' AS VARCHAR(9)) AS [Site]											/*Site (site) - Reference to tcemm050 Sites     Infor LN table: tirou401 | TRUE | null |Text | 9 | |*/
						,CAST('PROJEMPTY' AS VARCHAR(9)) AS ManufacturedProject								/*Project (mitm)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN kps.ItemLnCE ELSE NULL END AS VARCHAR(38)) AS ManufacturedItem										/*Manufactured Item (mitm)   - References tiipd001 Item Production Data | TRUE | null | 38 | |*/
						,CAST(roh.Routing AS VARCHAR(9)) AS Routing											/*Routing (rouc) | TRUE | null |Text | 9 | |*/
						,CAST(CASE WHEN mwc.Operation IS NULL THEN 0 ELSE mwc.Operation END AS FLOAT) AS Operation	/*Operation (opno) | TRUE | 0 |Long Integer |  | <100000|*/
						,CAST(CASE WHEN mwc.NextOperation IS NULL THEN 0 ELSE mwc.NextOperation END AS FLOAT) AS NextOperation													/*Next Operation (nopr) | TRUE | 0 |Long Integer |  | <100000|*/
						,CAST(rou.CL_TEMPO_LAVOR AS FLOAT) AS CycleTime										/*Cycle Time in Minutes (rutm) | TRUE | 0 |Decimal |  | |*/

					FROM
						KPRAKTOR.SIAPR.ANAMAG itm
						JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND POV1 <> 0)
						JOIN KPRAKTOR.SIAPR.CICLIL rou ON (itm.MG_CODICE = rou.CL_CODICE_CICLO AND itm.MG_DITTA = rou.CL_DITTA AND rou.CL_DATA_FIN_VAL >= CONVERT(INT,GETDATE()) AND CL_CODICE_CENTRO <> 'E')
						LEFT JOIN ZZZ_Italy.dbo.MappingWC mwc ON (rou.CL_CODICE_CENTRO = mwc.Centro AND  rou.CL_DITTA = 1)
						JOIN
						 (
							SELECT
								 'IT.POV.03' AS [Site]														/*Site (site) - Reference to tcemm050 Sites                                                                                     Infor LN table: tirou400 | TRUE | null | 9 | |*/
								,CAST('PROJEMPTY' AS VARCHAR(9)) AS ManufacturedProject						/*Project (mitm)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN kps.ItemLnCE ELSE NULL END AS VARCHAR(38)) AS ManufacturedItem		 /*Manufactured Item (mitm)   - References tiipd001 Item Production Data | TRUE | null | 38 | |*/	/* ||||| New 20240209 ||||| */
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN '001' ELSE ('IT.' + RIGHT(('000000' + CAST((ROW_NUMBER() OVER(ORDER BY (CAST(kps.ItemLnCE AS VARCHAR(38))) ASC)) AS VARCHAR(6))),6)) END AS VARCHAR(9)) AS Routing /*Routing (rouc) | TRUE | null | 9 | |*/

							/* 30-01-2023 KL : Not New field Revision in template 202310 was already in april template */
								,CAST('000001' AS VARCHAR(6)) AS Revision	
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN 20 ELSE 10 END AS FLOAT) AS Status		/*Status (rost)  When loading with DAL, use status 10 (new) and approve as post conversion action. | FALSE | 20 |  | 10;"New";20;"Approved";30;"Expired"|*/
								,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (efdt) | FALSE | null |  | |*/
								,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (exdt) - When empty, date will be set to MAX | TRUE | null |  | |*/
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN NULL ELSE kps.ItemLnCE END AS VARCHAR(38)) AS Description 							/*Description (dsca) | TRUE | null | 30 | |*/							/* ||||| New 20240209 ||||| */
								,CASE WHEN kps.Itemgroup = 'DPMTO1' THEN 2 ELSE 1 END StandardRouting		/*Standard Routing (stor) | TRUE | 2 |  | 1;"Yes";2;"No (default)"|*/	/* ||||| New 20240209 ||||| */
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN NULL ELSE kps.ItemLnCE END AS VARCHAR(38)) AS StandardRoutingCode			/*Standard Routing Code (strc)   When Item is empty or Standard Routing is "no", no value allowed. When standard routing is "yes", this field is mandatory and must be an existing standard routing code. | FALSE | null | 9 | |*/		/* ||||| New 20240209 ||||| */
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN NULL ELSE '000001' END AS VARCHAR(6)) AS StandardRoutingRevision					/*Standard Routing Revision (rtrv) When Item is empty or Standard Routing is "no", no value allowed. When standard routing is "yes", this field is mandatory and must be an existing standard routing code. | FALSE | null | 6 | |*/
								,1 AS RoutingQuantity														/*Routing Quantity (roqa) | FALSE | 1 |  | >0|*/
								,1 AS MinimumQuantity														/*Minimum Quantity (minq) | FALSE | 0 |  | >=0|*/
								,99999999 AS MaximumQuantity												/*Maximum Quantity (maxq) | FALSE | 99999999 |  | >0|*/
								,0 AS OrderLeadTime															/*Order Lead Time (oltm) | FALSE | 0 |  | >=0|*/
								,5 AS OrderLeadTimeUnit														/*Order Lead Time Unit (oltu) | FALSE | 5 |  | 5;"Hours";10;"Days"|*/
								,2 AS SubcWithMaterialFlow													/*Subcontracting with Material Flow (smfs) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN 1 ELSE 2 END AS FLOAT) AS UseForPlanning					/*Use for Planning (ufpl) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
								,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN 1 ELSE 2 END AS FLOAT) AS UseForCosting					/*Use for Planning (ufcs) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
								,CAST(NULL AS VARCHAR(6)) AS PlanGroup                                     /* PlanGroup Can be used if production scheduler is checked in implemented software components  | FALSE |  |  | |*/
								,rou.CL_CODICE_CICLO
								,itm.MG_DITTA
							FROM
								KPRAKTOR.SIAPR.ANAMAG itm
								JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV1 <> 0)
								JOIN 
									(
										SELECT
											 rou.CL_CODICE_CICLO
											,rou.CL_DITTA
										FROM
											KPRAKTOR.SIAPR.CICLIL rou
										WHERE
											rou.CL_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
											AND CL_CODICE_CENTRO <> 'E'
										GROUP BY
											 rou.CL_CODICE_CICLO
											,rou.CL_DITTA
								)rou ON (itm.MG_CODICE = rou.CL_CODICE_CICLO AND itm.MG_DITTA = rou.CL_DITTA)
								LEFT JOIN
									(
										SELECT
											 CL_CODICE_CICLO
											,CL_CODICE_CENTRO
											,CL_DITTA
											,COUNT(*) AS qty
										FROM
											KPRAKTOR.SIAPR.CICLIL rou
											JOIN ZZZ_Italy.dbo.KPSource kps ON (rou.CL_CODICE_CICLO = kps.Item AND rou.CL_DITTA =  1 AND kps.Migrate = 1 AND kps.POV1 <> 0)
										WHERE
											rou.CL_DATA_FIN_VAL >= CONVERT(INT,GETDATE()) AND CL_CODICE_CENTRO <> 'E'
										GROUP BY 
											CL_CODICE_CICLO
											,CL_CODICE_CENTRO
											,CL_DITTA
										HAVING COUNT(*) > 1
									)dup ON  (rou.CL_CODICE_CICLO = dup.CL_CODICE_CICLO AND rou.CL_DITTA = dup.CL_DITTA)
							WHERE
								dup.CL_CODICE_CENTRO IS NULL
						)roh ON (rou.CL_CODICE_CICLO = roh.CL_CODICE_CICLO)
				)lt
			WHERE
				lt.ManufacturedItem IS NOT NULL
				)lt
			WHERE
				lt.RN = 1
			GROUP BY
				 lt.Site
				,lt.ManufacturedProject
				,lt.ManufacturedItem
		)lt ON (jsr.Site = lt.Site AND jsr.ManufacturedProject = lt.ManufacturedProject AND jsr.ManufacturedItem = lt.ManufacturedItem)
	)rou ON (kps.ItemLnCE = rou.ManufacturedItem AND rou.StandardRouting = 2)
WHERE
	bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
	AND itm.MG_FLAG_FUORI_PROD <> 'S'

GO


