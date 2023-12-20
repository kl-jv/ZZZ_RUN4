USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_JobShopRouting]    Script Date: 20/12/2023 12:04:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[vw_JobShopRouting] AS

SELECT
	 'IT.POV.01' AS [Site]														/*Site (site) - Reference to tcemm050 Sites                                                                                     Infor LN table: tirou400 | TRUE | null | 9 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS ManufacturedProject						/*Project (mitm)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(NULL AS VARCHAR(38)) AS ManufacturedItem		         			    /*Manufactured Item (mitm)   - References tiipd001 Item Production Data | TRUE | null | 38 | |*/
	,'IT.' + RIGHT(('000000' + CAST((ROW_NUMBER() OVER(ORDER BY (CAST(kps.ItemLnCE AS VARCHAR(38))) ASC)) AS VARCHAR(6))),6) AS Routing  	/*Routing (rouc) | TRUE | null | 9 | |*/
	,'000001' AS Revision
	,10 AS Status																/*Status (rost)  When loading with DAL, use status 10 (new) and approve as post conversion action. | FALSE | 20 |  | 10;"New";20;"Approved";30;"Expired"|*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (efdt) | FALSE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (exdt) - When empty, date will be set to MAX | TRUE | null |  | |*/
	,CAST(CASE WHEN SUBSTRING(itm.MG_CODICE,1,1) = 'T' THEN TRIM(SUBSTRING(itm.MG_CODICE, 2,50)) ELSE TRIM(itm.MG_CODICE) END AS VARCHAR(38)) AS Description									/*Description (dsca) | TRUE | null | 30 | |*/
	,1 AS StandardRouting														/*Standard Routing (stor) | TRUE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST('IT.' + RIGHT(('000000' + CAST((ROW_NUMBER() OVER(ORDER BY (CAST(kps.ItemLnCE AS VARCHAR(38))) ASC)) AS VARCHAR(6))),6) AS VARCHAR(9)) AS StandardRoutingCode /*Standard Routing Code (strc)   When Item is empty or Standard Routing is "no", no value allowed. When standard routing is "yes", this field is mandatory and must be an existing standard routing code. | FALSE | null | 9 | |*/
	,CAST('000001' AS VARCHAR(6)) AS StandardRoutingRevision					/*Standard Routing Revision (rtrv) When Item is empty or Standard Routing is "no", no value allowed. When standard routing is "yes", this field is mandatory and must be an existing standard routing code. | FALSE | null | 6 | |*/
	,1 AS RoutingQuantity														/*Routing Quantity (roqa) | FALSE | 1 |  | >0|*/
	,1 AS MinimumQuantity														/*Minimum Quantity (minq) | FALSE | 0 |  | >=0|*/
	,99999999 AS MaximumQuantity												/*Maximum Quantity (maxq) | FALSE | 99999999 |  | >0|*/
	,0 AS OrderLeadTime															/*Order Lead Time (oltm) | FALSE | 0 |  | >=0|*/
	,5 AS OrderLeadTimeUnit														/*Order Lead Time Unit (oltu) | FALSE | 5 |  | 5;"Hours";10;"Days"|*/
	,2 AS SubcWithMaterialFlow													/*Subcontracting with Material Flow (smfs) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS UseForPlanning														/*Use for Planning (ufpl) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
	,2 AS UseForCosting															/*Use for Planning (ufcs) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
     ,CAST(NULL AS VARCHAR(6)) AS PlanGroup                                     /* PlanGroup Can be used if production scheduler is checked in implemented software components  | FALSE |  |  | |*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1)
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
				JOIN ZZZ_Italy.dbo.KPSource kps ON (rou.CL_CODICE_CICLO = kps.Item AND rou.CL_DITTA =  1 AND kps.Migrate = 1)
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
	AND (kps.POV1 = 1 OR kps.POV2 = 1)

UNION ALL

SELECT
	 'IT.POV.03' AS [Site]														/*Site (site) - Reference to tcemm050 Sites                                                                                     Infor LN table: tirou400 | TRUE | null | 9 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS ManufacturedProject						/*Project (mitm)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemlnCE AS VARCHAR(38)) AS ManufacturedItem		         			    /*Manufactured Item (mitm)   - References tiipd001 Item Production Data | TRUE | null | 38 | |*/
	,CAST('001' AS VARCHAR(6)) AS Routing  												/*Routing (rouc) | TRUE | null | 9 | |*/
	,'000001' AS Revision
	,10 AS Status																/*Status (rost)  When loading with DAL, use status 10 (new) and approve as post conversion action. | FALSE | 20 |  | 10;"New";20;"Approved";30;"Expired"|*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (efdt) | FALSE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (exdt) - When empty, date will be set to MAX | TRUE | null |  | |*/
	,CAST('Migrated from KPrakor'AS VARCHAR(30)) AS Description						/*Description (dsca) | TRUE | null | 30 | |*/
	,2 AS StandardRouting															/*Standard Routing (stor) | TRUE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(9)) AS StandardRoutingCode								/*Standard Routing Code (strc)   When Item is empty or Standard Routing is "no", no value allowed. When standard routing is "yes", this field is mandatory and must be an existing standard routing code. | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS StandardRoutingRevision							/*Standard Routing Revision (rtrv) When Item is empty or Standard Routing is "no", no value allowed. When standard routing is "yes", this field is mandatory and must be an existing standard routing code. | FALSE | null | 6 | |*/
	,1 AS RoutingQuantity														/*Routing Quantity (roqa) | FALSE | 1 |  | >0|*/
	,1 AS MinimumQuantity														/*Minimum Quantity (minq) | FALSE | 0 |  | >=0|*/
	,99999999 AS MaximumQuantity												/*Maximum Quantity (maxq) | FALSE | 99999999 |  | >0|*/
	,0 AS OrderLeadTime															/*Order Lead Time (oltm) | FALSE | 0 |  | >=0|*/
	,5 AS OrderLeadTimeUnit														/*Order Lead Time Unit (oltu) | FALSE | 5 |  | 5;"Hours";10;"Days"|*/
	,2 AS SubcWithMaterialFlow													/*Subcontracting with Material Flow (smfs) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,1 AS UseForPlanning														/*Use for Planning (ufpl) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS UseForCosting															/*Use for Planning (ufcs) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
     ,CAST(NULL AS VARCHAR(6)) AS PlanGroup                                     /* PlanGroup Can be used if production scheduler is checked in implemented software components  | FALSE |  |  | |*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1)
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
				JOIN ZZZ_Italy.dbo.KPSource kps ON (rou.CL_CODICE_CICLO = kps.Item AND rou.CL_DITTA =  1 AND kps.Migrate = 1)
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
	AND kps.POV3 = 1
GO


