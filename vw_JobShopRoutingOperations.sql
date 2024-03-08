USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_JobShopRoutingOperations]    Script Date: 3/8/2024 10:46:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[vw_JobShopRoutingOperations] AS 

/* 2023-10-17 : CHECK FOR POV 3 THE REFERENCE OPERATIONS AND WORK CENTERS, THE MAPPING FILE DEPENDS OP BELINDA */
/* 2024-01-30 : New excel provided by Belinda : mail 21-12-2023 ) */ 
/* 20240212 Changed the next operation and pulled it from the mappoing workcenter */
/* 20124/02/26 JVD: Changed Pto POV1 <> 0 and POV3 <> 0 */

SELECT
	 CAST('IT.POV.01' AS VARCHAR(9)) AS [Site]											/*Site (site) - Reference to tcemm050 Sites     Infor LN table: tirou401 | TRUE | null |Text | 9 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS ManufacturedProject								/*Project (mitm)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" |Text | 9 | |*/
	,CAST(CASE WHEN kps.Itemgroup = 'DPMTO1' THEN kps.ItemLnCE ELSE NULL END AS VARCHAR(38)) AS ManufacturedItem										/*Manufactured Item (mitm)   - References tiipd001 Item Production Data | TRUE | null | 38 | |*/
	,CAST(roh.Routing AS VARCHAR(9)) AS Routing											/*Routing (rouc) | TRUE | null |Text | 9 | |*/
/* 30-01-2023 KL : Not New field Revision in template 202310 was already in april template */
	,CAST('000001' AS VARCHAR(6)) AS Revision											/* Revision (tirou401.rorv) */
	,CAST(CASE WHEN mwc.Operation IS NULL THEN 0 ELSE mwc.Operation END AS FLOAT) AS Operation	/*Operation (opno) | TRUE | 0 |Long Integer |  | <100000|*/
	,CAST(CASE WHEN mwc.NextOperation IS NULL THEN 0 ELSE mwc.NextOperation END AS FLOAT) AS NextOperation													/*Next Operation (nopr) | TRUE | 0 |Long Integer |  | <100000|*/
	,CAST(CASE WHEN mwc.ReferenceOperation IS NULL THEN NULL ELSE  mwc.ReferenceOperation END AS VARCHAR(8)) AS ReferenceOperation					/*Reference Operation (refo) - References tirou450 Reference Operations (formerly called 'Task') | TRUE | null |Text | 8 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MachineType	      									/*Machine Type (mtyp)  - References tirou460 Machine Types | FALSE | null |Text | 9 | |*/
	,CAST(CASE WHEN mwc.WorkCenter IS NULL THEN NULL  ELSE mwc.WorkCenter END AS VARCHAR(9)) AS WorkCenter	/*Work Center (cwoc)  - References tirou001 Work Centers | FALSE | null |Text | 9 | |*/
	,CAST(rou.CL_TEMPO_ATTREZZ AS FLOAT) AS SetupTime									/*Setup Time in Minutes (sutm) | FALSE | 0 |Decimal |  | |*/
	,CAST(rou.CL_TEMPO_LAVOR AS FLOAT) AS CycleTime										/*Cycle Time in Minutes (rutm) | TRUE | 0 |Decimal |  | |*/
	,0 AS NumberOfMachines																/*Number of Machines (nomc) | TRUE | 0 |Integer |  | |*/
	,0 AS LaborResourceSetup															/*Labor Resource for Setup (lrst) ** Mandatory if Setup time is filled, else value 0 | FALSE | 0 |Double |  | |*/
	,1 AS LaborResourceProduction														/*Labor Resource for Production (lrpr) | FALSE | 1 |Double |  | |*/
	,10 AS TimeUnit																		/*Time Unit (tuni) | FALSE | 10 |Byte |  | 5;"Hours";10;"Days"|*/
	,0 AS QueueTime																		/*Queue Time (qutm) in Time Unit | FALSE | 0 |Decimal |  | |*/
	,0 AS WaitTime																		/*Wait Time (watm) in Time Unit | FALSE | 0 |Decimal |  | |*/
	,0 AS MoveTime																		/*Move Time (mvtm) in Time Unit | FALSE | 0 |Decimal |  | |*/
	,2 AS UseTransferBatch																/*Use Transfer Batch (utrb) | FALSE | 2 |Byte |  | 1;"Yes";2;"No"|*/
	,0 AS TransferBatchQuantity															/*Transfer Batch Quantity (trbq) | FALSE | 0 |Double |  | |*/
	,2 AS FixedDuration																	/*Fixed Duration (fdur) | FALSE | 2 |Byte |  | 1;"Yes";2;"No"|*/
	,2 AS ReportLaborHours																/*Report Labor Hours (bfls) | FALSE | 2 |Byte |  | 1;"Backflush";2;"Manual";99;"Retrieve from Workcenter"|*/
	,2 AS ReportProduct																	/*Report Product (copo) | FALSE | 2 |Byte |  | 1;"Manual";2;"Automatic";99;"Retrieve from Workcenter"|*/
	,90 AS ReportMachineHours															/*Report Machine Hours (rmch) | FALSE | 90 |Byte |  | 1;"Backflush";2;"Manual";90;"Not Applicable"|*/
	,2 AS DmsOnCompletion																/*DMS on Completion (dmso) | FALSE | 2 |Byte |  | 1;"Yes";2;"No"|*/
	,CAST(NULL AS VARCHAR(9)) AS SubassemblyProject										/*Subassembly Project (suba)   - Reference to tcmcs052 General Projects. | FALSE | null |Text | 9 | |*/
	,CAST(NULL AS VARCHAR(38))  AS SubassemblyItem										/*Subassembly Item (suba)    - References tcibd001 Items | FALSE | null |Text | 38 | |*/
	,CAST(NULL AS VARCHAR(9))  AS SubassemblyWarehouse									/*SubassemblyWarehouse (whsa)    - References tcmcs003 Warehouses | FALSE | null |Text | 9 | |*/
	,CAST(NULL AS VARCHAR(255))  AS OperationText										/*Operation Text (tttxt010.ctxt) |  | null |Memo |  | |*/
	,0 AS OperationTextID																/*Operation Text ID (tirou401.txta) |  | 0 |Long Integer |  | |*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV1 <> 0)
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


UNION ALL

/* UNION FOR POVIGLIO 3 SPARE PARTS */
/* 04/03/2024: JVD Changes for RO1, calibrated Items  */

SELECT
	 t3.Site
	,t3.ManufacturedProject
	,t3.ManufacturedItem
	,t3.Routing
	,t3.Revision
	,t3.Operation
	,t3.NextOperation
	,t3.ReferenceOperation
	,t3.MachineType
	,t3.WorkCenter
	,t3.SetupTime
	,SUM(t3.CycleTime) AS CycleTime
	,t3.NumberOfMachines
	,t3.LaborResourceSetup
	,t3.LaborResourceProduction
	,t3.TimeUnit
	,t3.QueueTime
	,t3.WaitTime
	,t3.MoveTime
	,t3.UseTransferBatch
	,t3.TransferBatchQuantity
	,t3.FixedDuration
	,t3.ReportLaborHours
	,t3.ReportProduct
	,t3.ReportMachineHours
	,t3.DmsOnCompletion
	,t3.SubassemblyProject
	,t3.SubassemblyItem
	,t3.SubassemblyWarehouse
	,t3.OperationText
	,t3.OperationTextID
FROM
(
SELECT
	 CAST('IT.POV.03' AS VARCHAR(9)) AS [Site]											/*Site (site) - Reference to tcemm050 Sites     Infor LN table: tirou401 | TRUE | null |Text | 9 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS ManufacturedProject								/*Project (mitm)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" |Text | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ManufacturedItem								/*Manufactured Item (mitm)   - References tiipd001 Item Production Data | TRUE | null | 38 | |*/
	,CAST('001' AS VARCHAR(9)) AS Routing												/*Routing (rouc) | TRUE | null |Text | 9 | |*/
/* 30-01-2023 KL : Not New field Revision in template 202310 was already in april template */
	,CAST('000001' AS VARCHAR(6)) AS Revision											/* Revision (tirou401.rorv) */

/* Changes due to R01 excluded 
	,CAST(CASE WHEN mwc.WorkCenter IS NOT NULL AND kps.Itemgroup = 'GEKIT6' THEN 6000
		ELSE
			CASE WHEN mwc.WorkCenter IS NOT NULL AND kps.Itemgroup <> 'GEKIT6' THEN 6010
				ELSE 
					CASE WHEN rou.CL_CODICE_CENTRO IS NOT NULL OR LEN(TRIM(rou.CL_CODICE_CENTRO))>0 THEN 6000
						ELSE NULL
						END
				END
		END AS FLOAT) AS Operation														/*Operation (opno) | TRUE | 0 |Long Integer |  | <100000|*/
*/
	,CAST(CASE WHEN mwc.Centro = 'R01' THEN 6010 ELSE 6000 END AS FLOAT) AS Operation					/*Operation (opno) | TRUE | 0 |Long Integer |  | <100000|*/
	,CAST(0 AS FLOAT) AS NextOperation			/*Next Operation (nopr) | TRUE | 0 |Long Integer |  | <100000|*/

/* Changes due to R01 excluded 
	,CAST(CASE WHEN mwc.WorkCenter IS NOT NULL AND kps.Itemgroup = 'GEKIT6' THEN 'IT000051'
		ELSE
			CASE WHEN mwc.WorkCenter IS NOT NULL AND kps.Itemgroup <> 'GEKIT6' THEN 'IT000052'
				ELSE 
					CASE WHEN rou.CL_CODICE_CENTRO IS NOT NULL OR LEN(TRIM(rou.CL_CODICE_CENTRO))>0 THEN 'IT000051'
						ELSE NULL
						END
				END
		END AS VARCHAR(8)) AS ReferenceOperation
*/	,CAST(CASE WHEN mwc.Centro = 'R01' THEN 'IT000052' ELSE 'IT000051' END AS VARCHAR(8)) AS ReferenceOperation
	,CAST(NULL AS VARCHAR(9)) AS MachineType	      									/*Machine Type (mtyp)  - References tirou460 Machine Types | FALSE | null |Text | 9 | |*/

/* Changes due to R01 excluded 
	,CAST(CASE WHEN mwc.WorkCenter IS NOT NULL AND kps.Itemgroup = 'GEKIT6' THEN 'IT4300'
		ELSE
			CASE WHEN mwc.WorkCenter IS NOT NULL AND kps.Itemgroup <> 'GEKIT6' THEN 'IT4301'
				ELSE 
					CASE WHEN rou.CL_CODICE_CENTRO IS NOT NULL OR LEN(TRIM(rou.CL_CODICE_CENTRO))>0 THEN 'IT4300'
						ELSE NULL
						END
				END
		END AS VARCHAR(6)) AS WorkCenter												/*Work Center (cwoc)  - References tirou001 Work Centers | FALSE | null |Text | 9 | |*/
*/	
	,CAST(CASE WHEN mwc.Centro = 'R01' THEN 'IT4301' ELSE 'IT4300' END AS VARCHAR(6))AS WorkCenter	/*Work Center (cwoc)  - References tirou001 Work Centers | FALSE | null |Text | 6 | |*/
	,CAST(rou.CL_TEMPO_ATTREZZ AS FLOAT) AS SetupTime									/*Setup Time in Minutes (sutm) | FALSE | 0 |Decimal |  | |*/
	,CAST(rou.CL_TEMPO_LAVOR AS FLOAT) AS CycleTime										/*Cycle Time in Minutes (rutm) | TRUE | 0 |Decimal |  | |*/
	,0 AS NumberOfMachines																/*Number of Machines (nomc) | TRUE | 0 |Integer |  | |*/
	,0 AS LaborResourceSetup															/*Labor Resource for Setup (lrst) ** Mandatory if Setup time is filled, else value 0 | FALSE | 0 |Double |  | |*/
	,1 AS LaborResourceProduction														/*Labor Resource for Production (lrpr) | FALSE | 1 |Double |  | |*/
	,10 AS TimeUnit																		/*Time Unit (tuni) | FALSE | 10 |Byte |  | 5;"Hours";10;"Days"|*/
	,0 AS QueueTime																		/*Queue Time (qutm) in Time Unit | FALSE | 0 |Decimal |  | |*/
	,0 AS WaitTime																		/*Wait Time (watm) in Time Unit | FALSE | 0 |Decimal |  | |*/
	,0 AS MoveTime																		/*Move Time (mvtm) in Time Unit | FALSE | 0 |Decimal |  | |*/
	,2 AS UseTransferBatch																/*Use Transfer Batch (utrb) | FALSE | 2 |Byte |  | 1;"Yes";2;"No"|*/
	,0 AS TransferBatchQuantity															/*Transfer Batch Quantity (trbq) | FALSE | 0 |Double |  | |*/
	,2 AS FixedDuration																	/*Fixed Duration (fdur) | FALSE | 2 |Byte |  | 1;"Yes";2;"No"|*/
	,2 AS ReportLaborHours																/*Report Labor Hours (bfls) | FALSE | 2 |Byte |  | 1;"Backflush";2;"Manual";99;"Retrieve from Workcenter"|*/
	,2 AS ReportProduct																	/*Report Product (copo) | FALSE | 2 |Byte |  | 1;"Manual";2;"Automatic";99;"Retrieve from Workcenter"|*/
	,90 AS ReportMachineHours															/*Report Machine Hours (rmch) | FALSE | 90 |Byte |  | 1;"Backflush";2;"Manual";90;"Not Applicable"|*/
	,2 AS DmsOnCompletion																/*DMS on Completion (dmso) | FALSE | 2 |Byte |  | 1;"Yes";2;"No"|*/
	,CAST(NULL AS VARCHAR(9)) AS SubassemblyProject										/*Subassembly Project (suba)   - Reference to tcmcs052 General Projects. | FALSE | null |Text | 9 | |*/
	,CAST(NULL AS VARCHAR(38))  AS SubassemblyItem										/*Subassembly Item (suba)    - References tcibd001 Items | FALSE | null |Text | 38 | |*/
	,CAST(NULL AS VARCHAR(9))  AS SubassemblyWarehouse									/*SubassemblyWarehouse (whsa)    - References tcmcs003 Warehouses | FALSE | null |Text | 9 | |*/
	,CAST(NULL AS VARCHAR(255))  AS OperationText										/*Operation Text (tttxt010.ctxt) |  | null |Memo |  | |*/
	,0 AS OperationTextID																/*Operation Text ID (tirou401.txta) |  | 0 |Long Integer |  | |*/
FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND POV3 = 1)
	JOIN KPRAKTOR.SIAPR.CICLIL rou ON (itm.MG_CODICE = rou.CL_CODICE_CICLO AND itm.MG_DITTA = rou.CL_DITTA AND rou.CL_DATA_FIN_VAL >= CONVERT(INT,GETDATE()) AND CL_CODICE_CENTRO <> 'E')
	LEFT JOIN ZZZ_Italy.dbo.MappingWC mwc ON (rou.CL_CODICE_CENTRO = mwc.Centro AND  rou.CL_DITTA = 1)
	JOIN
	 (
		 SELECT
		 'IT.POV.03' AS [Site]														/*Site (site) - Reference to tcemm050 Sites                                                                                     Infor LN table: tirou400 | TRUE | null | 9 | |*/
		,CAST('PROJEMPTY' AS VARCHAR(9)) AS ManufacturedProject						/*Project (mitm)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
		,CAST(''   AS VARCHAR(38)) AS ManufacturedItem								/*Manufactured Item (mitm)   - References tiipd001 Item Production Data | TRUE | null | 38 | |*/
		,'IT.' + RIGHT(('000000' + CAST((ROW_NUMBER() OVER(ORDER BY (CAST(kps.ItemLnCE AS VARCHAR(38))) ASC)) AS VARCHAR(6))),6) AS Routing
/* 30-01-2023 KL : Not New field Revision in template 202310 was already in april template */
		, CAST('000001' AS VARCHAR(6)) AS Revision
		,rou.CL_CODICE_CICLO
		,itm.MG_DITTA
	FROM
		KPRAKTOR.SIAPR.ANAMAG itm
		JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV3 = 1)
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

	/* because of duplicates in work center, duplicates removed */
		LEFT JOIN
			(
				SELECT
					 CL_CODICE_CICLO
					,CL_CODICE_CENTRO
					,CL_DITTA
					,COUNT(*) AS qty
				FROM
					KPRAKTOR.SIAPR.CICLIL rou
					JOIN ZZZ_Italy.dbo.KPSource kps ON (rou.CL_CODICE_CICLO = kps.Item AND rou.CL_DITTA =  1 AND kps.Migrate = 1 AND kps.POV3 = 1)
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
)t3
GROUP BY
	 t3.Site
	,t3.ManufacturedProject
	,t3.ManufacturedItem
	,t3.Routing
	,t3.Revision
	,t3.Operation
	,t3.NextOperation
	,t3.ReferenceOperation
	,t3.MachineType
	,t3.WorkCenter
	,t3.SetupTime
	,t3.NumberOfMachines
	,t3.LaborResourceSetup
	,t3.LaborResourceProduction
	,t3.TimeUnit
	,t3.QueueTime
	,t3.WaitTime
	,t3.MoveTime
	,t3.UseTransferBatch
	,t3.TransferBatchQuantity
	,t3.FixedDuration
	,t3.ReportLaborHours
	,t3.ReportProduct
	,t3.ReportMachineHours
	,t3.DmsOnCompletion
	,t3.SubassemblyProject
	,t3.SubassemblyItem
	,t3.SubassemblyWarehouse
	,t3.OperationText
	,t3.OperationTextID

GO


