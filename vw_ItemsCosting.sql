USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_ItemsCosting]    Script Date: 3/7/2024 12:44:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vw_ItemsCosting] AS

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project								  /*Project segment of Item (item) - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                                                      ERPLN table: ticpr007 | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item								  /*Item segment of Item (ticpr007.item) - Reference to tcibd001 Items | TRUE | null | 38 | |*/
	,CAST('IT0001' AS VARCHAR(6)) AS EnterpriseUnit							  /*Enterprise Unit (ticpr007.eunt) - Reference to tcemm030 Enterprise Units | TRUE | null | 6 | |*/
	,CAST('EUR' AS VARCHAR(3)) AS CostingCurrency							  /*Costing Currency (ticpr007.ccur)   - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CASE kps.ItemGroup
		WHEN 'CI0001' THEN 20
		ELSE 10
		END AS CostingType													  /*Costing Type (ticpr007.type) | TRUE | 10 |  | 10;"Logistics";20;"Purchase";30;"Sales Scheme"|*/
	, 2 AS StandardCostsBase
	,CAST('000010' AS VARCHAR(6)) AS Chart									   /*Standard Cost Component Chart (tipcr007.chrt) - Reference to ticpr009 Cost Component Charts | FALSE | null | 6 | |*/
	, CAST(scm.warehouse AS VARCHAR(6)) AS Warehouse	
	,CAST(CASE 
		WHEN kps.ItemType = 70 THEN  100										
		WHEN kps.SupplySource = 60 THEN 50												
		WHEN  kps.SupplySource = 20 THEN  20									
		WHEN  kps.SupplySource = 40 THEN 30									
		WHEN  kps.SupplySource = 50 THEN 40									
		ELSE 100
	 END AS FLOAT) AS CostingSource
	,CAST(NULL AS VARCHAR(6)) AS SupplyingEU									/*Supplying Enterprise Unit (ticpr007.sueu)  - Reference to tcemm030 Enterprise Units ** Only required when costing source is Intercompany Transfer | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SupplyingPO									/*Supplying Purchase Office (ticpr007.cofc)  - Reference to tcmcs065 Purchase Offices ** Only required when costing source is Intercompany purchase | FALSE | null | 6 | |*/
	,1 AS SurchargesByItem														/*Surcharges By Item (ticpr007.spit) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS SurchargesByWH														/*Surcharges By Warehouse (ticpr007.vpwh) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,2 AS IncludeLandedCosts													/*Include Landed Costs (ticpr007.inlc) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(12)) AS LandedCostsSet								/*Landed Costs Set (ticpr007.lcst) - Reference to tclct100 Landed Costs Sets |  | null | 12 | |*/
FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND (kps.POV1  <> 0  ))
	LEFT JOIN ZZZ_Italy.dbo.SCModelMap scm ON (kps.POV1 = scm.POV1 AND scm.Site = 'IT.POV.01')

UNION ALL

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project									/*Project segment of Item (item) - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                                                      ERPLN table: ticpr007 | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item									/*Item segment of Item (ticpr007.item) - Reference to tcibd001 Items | TRUE | null | 38 | |*/
	,CAST('IT0003' AS VARCHAR(6)) AS EnterpriseUnit								/*Enterprise Unit (ticpr007.eunt) - Reference to tcemm030 Enterprise Units | TRUE | null | 6 | |*/
	,CAST('EUR' AS VARCHAR(3)) AS CostingCurrency								/*Costing Currency (ticpr007.ccur)   - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CASE kps.ItemGroup
		WHEN 'CI0001' THEN 20
		ELSE 10
		END AS CostingType														/*Costing Type (ticpr007.type) | TRUE | 10 |  | 10;"Logistics";20;"Purchase";30;"Sales Scheme"|*/
	, 2 AS StandardCostsBase
	,CAST('000010' AS VARCHAR(6)) AS Chart										/*Standard Cost Component Chart (tipcr007.chrt) - Reference to ticpr009 Cost Component Charts | FALSE | null | 6 | |*/
	, CAST(scm.warehouse AS VARCHAR(6)) AS Warehouse
	,CAST(CASE 
		WHEN kps.ItemType =	70 THEN  100										
		WHEN kps.SupplySource =	60 THEN 50													
		WHEN kps.SupplySource = 20 THEN 20									
		WHEN kps.SupplySource = 40 THEN 30									
		WHEN kps.SupplySource = 50 THEN 40									
		ELSE 100
	 END AS FLOAT) AS CostingSource
	,CAST(CASE WHEN kps.SupplySource = 60 THEN 'IT0001' ELSE NULL END AS VARCHAR(6)) AS SupplyingEU			/*Supplying Enterprise Unit (ticpr007.sueu)  - Reference to tcemm030 Enterprise Units ** Only required when costing source is Intercompany Transfer | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SupplyingPO									/*Supplying Purchase Office (ticpr007.cofc)  - Reference to tcmcs065 Purchase Offices ** Only required when costing source is Intercompany purchase | FALSE | null | 6 | |*/
	,1 AS SurchargesByItem														/*Surcharges By Item (ticpr007.spit) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS SurchargesByWH														/*Surcharges By Warehouse (ticpr007.vpwh) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,2 AS IncludeLandedCosts													/*Include Landed Costs (ticpr007.inlc) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(12)) AS LandedCostsSet								/*Landed Costs Set (ticpr007.lcst) - Reference to tclct100 Landed Costs Sets |  | null | 12 | |*/
FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV3 <> 0  )
	JOIN ZZZ_Italy.dbo.KPSourceSP kpp ON (itm.MG_CODICE = kpp.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV3 <> 0  )
	LEFT JOIN ZZZ_Italy.dbo.SCModelMap scm ON (kps.POV3 = scm.POV3 AND scm.Site = 'IT.POV.03')

GO


