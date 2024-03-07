USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_ItemsCosting]    Script Date:  07-03-2024 */ 
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- ALTER VIEW [dbo].[vw_ItemsCosting] AS

/*
		ATTENTION : Risks: 
		standard cost base, since it depends if this already exists als in 1.
		Costing Source, for POV3, since they do not really manufacture: should it not be 50;"Intercompany Transfer in case it is now: 20;"Job Shop"
*/

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project								  /*Project segment of Item (item) - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                                                      ERPLN table: ticpr007 | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item								  /*Item segment of Item (ticpr007.item) - Reference to tcibd001 Items | TRUE | null | 38 | |*/
	,CAST('IT0001' AS VARCHAR(6)) AS EnterpriseUnit							  /*Enterprise Unit (ticpr007.eunt) - Reference to tcemm030 Enterprise Units | TRUE | null | 6 | |*/
	,CAST('EUR' AS VARCHAR(3)) AS CostingCurrency							  /*Costing Currency (ticpr007.ccur)   - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CASE kps.ItemGroup
		WHEN 'CI0001' THEN 20
		ELSE 10
		END AS CostingType													  /*Costing Type (ticpr007.type) | TRUE | 10 |  | 10;"Logistics";20;"Purchase";30;"Sales Scheme"|*/
/* 30-04-2023 StandardCostbase must be set to 2 */
	, 2 AS StandardCostsBase
	,CAST('000010' AS VARCHAR(6)) AS Chart									   /*Standard Cost Component Chart (tipcr007.chrt) - Reference to ticpr009 Cost Component Charts | FALSE | null | 6 | |*/
/* 20-07  POV1/POV2/POV3/RD changes */
/* 28-02-2024 KL: Commented because  Map warehouse to warehouse from ZZZ_Italy.dbo.SCModelMap (scm) */ 
/* 	,CAST
	(
	  CASE
	--	WHEN kps.POV1 = 1 THEN 'IT0110'
		WHEN kps.POV1 <> 0 THEN 'IT0110'
		ELSE	
		  CASE
			WHEN kps.POV2 = 1 THEN 'IT0210'
			ELSE
			  CASE
				WHEN kps.POV3 = 1 THEN 'IT0300'
				ELSE
				  CASE
					WHEN kps.RD = 1 THEN 'ITE100'							   /* RD is in POV1 , info POV1/POV2/POV3 and RD from excel mario */	
					ELSE 'IT0110'
				  END
			  END
		  END
	  END AS VARCHAR(6)	
	) AS 	Warehouse														   /*Warehouse (ticpr007.cwar) - Reference to tcmcs003 Warehosues ** Only required when Costing type is Logistics | TRUE | null | 6 | |*/			
*/			

/* 28-02-2024 KL:  Map warehouse to warehouse from ZZZ_Italy.dbo.SCModelMap (scm) */ 
, CAST(scm.warehouse AS VARCHAR(6)) AS Warehouse	

/* 30-8-2023 Items-Costing not correct for Cost Items */ 
/*		,CASE kps.SupplySource
		WHEN 20 THEN 20
		WHEN 40 THEN 30
		WHEN 50 THEN 40
		ELSE ''
		END AS CostingSource													/*Costing Source (ticpr007.scos) | TRUE | 100 |  | 20;"Job Shop";30;"Purchase";40;"Subcontract";50;"Intercompany Transfer";55;"Intercompany Purchase";100;"Not Applicable"|*/
*/

	,CASE 
		WHEN kps.ItemType = 70 THEN '100'										/* ItemType  70  Cost   (30;"Product";40;"Tool";60;"Subcontracted Service";70;"Cost";80;"Service";90;"Generic") */ 
																				/* ItemType  70 has SupplySource 40 Subcontract */
																				/* ItemType 70  has  ItemGroup  CI0001 */ 
		WHEN  kps.SupplySource = 20 THEN '20'									/* SupplySource 20;"Job Shop";30;"Purchase";40;"Subcontract";50;"Intercompany Transfer";55;"Intercompany Purchase";100;"Not Applicable"|*/
		WHEN  kps.SupplySource = 40 THEN '30'									/* 40 SubContract to 30 Purchase */ 
		WHEN  kps.SupplySource = 50 THEN '40'									/* 50 Intercompany Transfer  to 40 Subcontract */ 
		ELSE ''
	 END AS CostingSource
	,CAST(NULL AS VARCHAR(6)) AS SupplyingEU									/*Supplying Enterprise Unit (ticpr007.sueu)  - Reference to tcemm030 Enterprise Units ** Only required when costing source is Intercompany Transfer | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SupplyingPO									/*Supplying Purchase Office (ticpr007.cofc)  - Reference to tcmcs065 Purchase Offices ** Only required when costing source is Intercompany purchase | FALSE | null | 6 | |*/
	,1 AS SurchargesByItem														/*Surcharges By Item (ticpr007.spit) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS SurchargesByWH														/*Surcharges By Warehouse (ticpr007.vpwh) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,2 AS IncludeLandedCosts													/*Include Landed Costs (ticpr007.inlc) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(12)) AS LandedCostsSet								/*Landed Costs Set (ticpr007.lcst) - Reference to tclct100 Landed Costs Sets |  | null | 12 | |*/
FROM
	KPRAKTOR.SIAPR.ANAMAG itm
/* 28-02-2024 KL:   Change to POV1 <> 0 , remove POV2 and RD  */ 
-- 	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND (kps.POV1 = 1 OR kps.POV2 = 1 OR kps.RD = 1 ))
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND (kps.POV1  <> 0  ))
/* 28-02-2024 KL:  Map warehouse to warhouse from ZZZ_Italy.dbo.SCModelMap (scm) */ 
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
/* 28-02-2024 KL: Commented because  Map warehouse to warehouse from ZZZ_Italy.dbo.SCModelMap (scm) */ 
/*	,CAST(CASE WHEN kps.POV3 = 1 THEN 'IT0300'
		ELSE 'IT0300'
		END AS VARCHAR(6)) AS Warehouse											/*Warehouse (ticpr007.cwar) - Reference to tcmcs003 Warehosues ** Only required when Costing type is Logistics | TRUE | null | 6 | |*/
*/

/* 28-02-2024 KL:  Map warehouse to warhouse from ZZZ_Italy.dbo.SCModelMap (scm) */ 
, CAST(scm.warehouse AS VARCHAR(6)) AS Warehouse

/* 30-08-2023  Items-Costing not correct for Cost Items */ 
/*	,CASE WHEN kps.POV1 = 1 OR kps.POV2 = 1 THEN 50 ELSE  	-- 50;"Intercompany Transfer
	CASE kps.SupplySource
		WHEN 20 THEN 20
		WHEN 40 THEN 30
		WHEN 50 THEN 40
		ELSE ''
		END 
		END AS CostingSource													/*Costing Source (ticpr007.scos) | TRUE | 100 |  | 20;"Job Shop";30;"Purchase";40;"Subcontract";50;"Intercompany Transfer";55;"Intercompany Purchase";100;"Not Applicable"|*/
*/
/* 28-02-2024 KL:  POV2 not relevant anymore and kps.POV1 <> 0  */ 
		, CASE
		-- WHEN kps.POV1 = 1 OR kps.POV2 = 1 THEN 50							/* 50;"Intercompany Transfer"  */
		-- WHEN kps.POV1 = 1 THEN 50											/* 50;"Intercompany Transfer"  */
		WHEN kps.POV1 <> 0 THEN 50												/* 50;"Intercompany Transfer"  */
		WHEN kps.ItemType = 70 THEN '100'										/* 70 Cost, 100 Not Applicable  (30;"Product";40;"Tool";60;"Subcontracted Service";70;"Cost";80;"Service";90;"Generic") */ 
																				/* ItemType  70 has SupplySource 40 Subcontract and also Source 20 Job Shop */
																				/*ItemType 70  has  ItemGroup  CI0001 */ 
/* 19-10-2023  FOR POV3 get SupplySource from KPsourceSP */
/* kps.SupplySource to kpp.SupplySource */
			WHEN kpp.SupplySource = 20 THEN '20'								/* SupplySource 20;"Job Shop";30;"Purchase";40;"Subcontract";50;"Intercompany Transfer";55;"Intercompany Purchase";100;"Not Applicable"|*/
			WHEN kpp.SupplySource = 40 THEN '30'								/* 40 SubContract to 30 Purchase */ 
			WHEN kpp.SupplySource = 50 THEN '40'								/* 50 Intercompany Transfer  to 40 Subcontract */ 
		ELSE ''
	END  AS CostingSource_KPSP

/* 20-07*  added POV1/RD brackets    */
/* 28-02-2024 KL:  POV2 and RD not relevant anymore and kps.POV1 <> 0  */ 
--	,CAST(CASE WHEN (kps.POV1 = 1 OR kps.POV2 = 1 OR kps.RD = 1)  THEN 'IT0001' ELSE NULL END AS VARCHAR(6)) AS SupplyingEU									/*Supplying Enterprise Unit (ticpr007.sueu)  - Reference to tcemm030 Enterprise Units ** Only required when costing source is Intercompany Transfer | FALSE | null | 6 | |*/
	,CAST(CASE WHEN (kps.POV1 <> 0 )  THEN 'IT0001' ELSE NULL END AS VARCHAR(6)) AS SupplyingEU									/*Supplying Enterprise Unit (ticpr007.sueu)  - Reference to tcemm030 Enterprise Units ** Only required when costing source is Intercompany Transfer | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SupplyingPO									/*Supplying Purchase Office (ticpr007.cofc)  - Reference to tcmcs065 Purchase Offices ** Only required when costing source is Intercompany purchase | FALSE | null | 6 | |*/
	,1 AS SurchargesByItem														/*Surcharges By Item (ticpr007.spit) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS SurchargesByWH														/*Surcharges By Warehouse (ticpr007.vpwh) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,2 AS IncludeLandedCosts													/*Include Landed Costs (ticpr007.inlc) |  | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(12)) AS LandedCostsSet								/*Landed Costs Set (ticpr007.lcst) - Reference to tclct100 Landed Costs Sets |  | null | 12 | |*/
FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV3 = 1  )
	JOIN ZZZ_Italy.dbo.KPSourceSP kpp ON (itm.MG_CODICE = kpp.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV3 = 1  )

/* 28-02-2024 KL:  Map warehouse to warehouse from ZZZ_Italy.dbo.SCModelMap (scm) */ 
LEFT JOIN ZZZ_Italy.dbo.SCModelMap scm ON (kps.POV3 = scm.POV3 AND scm.Site = 'IT.POV.03')	

	
GO


