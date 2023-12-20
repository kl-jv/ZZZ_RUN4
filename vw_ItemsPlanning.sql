USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_ItemsPlanning]    Script Date: 20/12/2023 12:01:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[vw_ItemsPlanning] AS

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project					/*Project segment of Item (item)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                                                      ERPLN table: cprpd100 | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item					/*Item segment of Item (cprpd100.item)   - Reference to tcibd001 Items | TRUE | null | 38 | |*/
	,CAST('IT1' AS VARCHAR(3)) AS Cluster						/*Cluster (cprpd100.clus)   - Reference to tcemm135 Clusters | TRUE | null | 3 | |*/
/* 21-07  POV1/POV2/POV3/RD changes */
	,CAST
	(
	  CASE
		WHEN kps.POV1 = 1 THEN 'IT0110'
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
	) AS 	Warehouse															/*Warehouse (cprpd100.cwar)   - Reference to tcmcs003 Warehouses | TRUE | null | 6 | |*/		

	,CAST('IT.POV.01' AS VARCHAR(9)) AS OrderingSite			/*Site (cprpd100.site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,1 AS SupplySource											/*Default Supply Source (cprpd100.sour) | FALSE | 1 |  | 1;"Production/Purchase";2;"Distribution"|*/
	,9 AS PlanLevel												/*Plan Level (cprpd100.plvl) | TRUE | 1 |  | |*/
	,CAST (NULL AS VARCHAR(9)) AS Planner						/*Planner (cprpd100.plid)   - References tccom001 Employees | TRUE | null | 9 | |*/
	,2 AS MaintainMasterPlan									/*Maintain Master Plan (cprpd100.osys) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,2 AS CriticalInMasterPlan									/*Critical in Master Plan (cprpd100.crmp) | TRUE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 0
		WHEN 'COMAN2' THEN 0
		WHEN 'DPMTO1' THEN 30
		WHEN 'GEKIT6' THEN 0
		WHEN 'GELCO1' THEN 0
		WHEN 'GELTR2' THEN 0
		WHEN 'GESCO3' THEN 0
		WHEN 'GESTD5' THEN 0
		WHEN 'GESTR4' THEN 0
		WHEN 'PHMAN2' THEN 0
		WHEN 'PHSAL1' THEN 30
		WHEN 'PI9999' THEN 0
		WHEN 'CI0001' THEN 0
		WHEN 'TOGEN1' THEN 0
		WHEN 'COFLS4' THEN 0
		ELSE 0
		END AS TimeFence										/*Time Fence (cprpd100.tmfc) | FALSE | 0 |  | |*/
	,10 AS TimeFenceUnit										/*Time Fence Unit (cprpd100.tmfu) | FALSE | 10 |  | 5;"Hours";10;"Days (default)"|*/
	,0 AS ForecastTimeFence										/*Forecast Time Fence (cprpd100.fctf) | FALSE | 0 |  | |*/
	,CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 350
		WHEN 'COMAN2' THEN 350
		WHEN 'DPMTO1' THEN 999
		WHEN 'GEKIT6' THEN 999
		WHEN 'GELCO1' THEN 350
		WHEN 'GELTR2' THEN 350
		WHEN 'GESCO3' THEN 350
		WHEN 'GESTD5' THEN 350
		WHEN 'GESTR4' THEN 350
		WHEN 'PHMAN2' THEN 350
		WHEN 'PHSAL1' THEN 999
		WHEN 'PI9999' THEN 350
		WHEN 'CI0001' THEN 350
		WHEN 'TOGEN1' THEN 350
		WHEN 'COFLS4' THEN 350
		ELSE 0 
		END AS OrderHorizon											/*Order Horizon (cprpd100.otmf) | FALSE | 0 |  | |*/
	,CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 350
		WHEN 'COMAN2' THEN 350
		WHEN 'DPMTO1' THEN 999
		WHEN 'GEKIT6' THEN 999
		WHEN 'GELCO1' THEN 350
		WHEN 'GELTR2' THEN 350
		WHEN 'GESCO3' THEN 350
		WHEN 'GESTD5' THEN 350
		WHEN 'GESTR4' THEN 350
		WHEN 'PHMAN2' THEN 350
		WHEN 'PHSAL1' THEN 999
		WHEN 'PI9999' THEN 350
		WHEN 'CI0001' THEN 350
		WHEN 'TOGEN1' THEN 350
		WHEN 'COFLS4' THEN 350
		ELSE 0 
		END AS PlanningHorizon										/*Planning Horizon (cprpd100.ptmf) | TRUE | 0 |  | |*/
	,0 AS ExtraLeadTime											/*Extra Lead Time (cprpd100.eltm) | TRUE | 0 |  | |*/
	,10 AS UnitForExtraLeadTime									/*Unit for Extra Lead Time (cprpd100.eltu) | TRUE | 10 |  | 5;"Hours";10;"Days (default)"|*/
	,1 AS AutomateUpdateHorizons								/*Automate Update Horizons (cprpd100.upho) (HYVA) | TRUE | 1 |  | 1;"Yes";2;"No"|*/
	,1 AS OnlineATPUpdate										/*Online ATP Update (cprpd100.onat) (HYVA) | TRUE | 1 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 2
		WHEN 'COMAN2' THEN 2
		WHEN 'DPMTO1' THEN 1
		WHEN 'GEKIT6' THEN 1
		WHEN 'GELCO1' THEN 2
		WHEN 'GELTR2' THEN 2
		WHEN 'GESCO3' THEN 2
		WHEN 'GESTD5' THEN 2
		WHEN 'GESTR4' THEN 2
		WHEN 'PHMAN2' THEN 2
		WHEN 'PHSAL1' THEN 1
		WHEN 'PI9999' THEN 2
		WHEN 'CI0001' THEN 2
		WHEN 'TOGEN1' THEN 2
		WHEN 'COFLS4' THEN 2
		ELSE 2
		END AS CriticalInCTP											/*Critical in CTP (cprpd100.cria) (HYVA) | TRUE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 2
		WHEN 'COMAN2' THEN 2
		WHEN 'DPMTO1' THEN 1
		WHEN 'GEKIT6' THEN 1
		WHEN 'GELCO1' THEN 2
		WHEN 'GELTR2' THEN 2
		WHEN 'GESCO3' THEN 2
		WHEN 'GESTD5' THEN 2
		WHEN 'GESTR4' THEN 2
		WHEN 'PHMAN2' THEN 2
		WHEN 'PHSAL1' THEN 1
		WHEN 'PI9999' THEN 2
		WHEN 'CI0001' THEN 2
		WHEN 'TOGEN1' THEN 2
		WHEN 'COFLS4' THEN 2
		ELSE 2
		END AS ComponentCTP										/*Component CTP (cprpd100.coat) (HYVA) | TRUE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS CapacityCTP											/*Capacity CTP (cprpd100.catp) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS ChannelATP											/*Channel ATP (cprpd100.chat) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,0 AS CTPTimeFence											/*CTP Time Fence (cprpd100.tfat) (HYVA) | TRUE | 0 |  | |*/
	,CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 350
		WHEN 'COMAN2' THEN 350
		WHEN 'DPMTO1' THEN 999
		WHEN 'GEKIT6' THEN 350
		WHEN 'GELCO1' THEN 350
		WHEN 'GELTR2' THEN 350
		WHEN 'GESCO3' THEN 350
		WHEN 'GESTD5' THEN 350
		WHEN 'GESTR4' THEN 350
		WHEN 'PHMAN2' THEN 350
		WHEN 'PHSAL1' THEN 999
		WHEN 'PI9999' THEN 350
		WHEN 'CI0001' THEN 350
		WHEN 'TOGEN1' THEN 350
		WHEN 'COFLS4' THEN 350
		ELSE 0 
		END AS CTPHorizon											/*CTP Horizon (cprpd100.hoat) (HYVA) | FALSE | 0 |  | |*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PI9999','CI0001','TOGEN1','COFLS04') AND (kps.POV1 = 1 OR kps.POV2 = 1  OR kps.RD = 1))

UNION ALL

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project					/*Project segment of Item (item)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                                                      ERPLN table: cprpd100 | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item					/*Item segment of Item (cprpd100.item)   - Reference to tcibd001 Items | TRUE | null | 38 | |*/
	,CAST('IT3' AS VARCHAR(3)) AS Cluster						/*Cluster (cprpd100.clus)   - Reference to tcemm135 Clusters | TRUE | null | 3 | |*/
	,CAST(CASE WHEN kps.POV3 = 1 THEN 'IT0300'
		ELSE 'IT0300'
		END AS VARCHAR(6)) AS Warehouse							/*Warehouse (cprpd100.cwar)   - Reference to tcmcs003 Warehouses | TRUE | null | 6 | |*/
	,CAST('IT.POV.03' AS VARCHAR(9)) AS OrderingSite			/*Site (cprpd100.site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,1 AS SupplySource											/*Default Supply Source (cprpd100.sour) | FALSE | 1 |  | 1;"Production/Purchase";2;"Distribution"|*/
	,9 AS PlanLevel												/*Plan Level (cprpd100.plvl) | TRUE | 1 |  | |*/
	,CAST (NULL AS VARCHAR(9)) AS Planner						/*Planner (cprpd100.plid)   - References tccom001 Employees | TRUE | null | 9 | |*/
	,2 AS MaintainMasterPlan									/*Maintain Master Plan (cprpd100.osys) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,2 AS CriticalInMasterPlan									/*Critical in Master Plan (cprpd100.crmp) | TRUE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 0
		WHEN 'COMAN2' THEN 0
		WHEN 'DPMTO1' THEN 30
		WHEN 'GEKIT6' THEN 0
		WHEN 'GELCO1' THEN 0
		WHEN 'GELTR2' THEN 0
		WHEN 'GESCO3' THEN 0
		WHEN 'GESTD5' THEN 0
		WHEN 'GESTR4' THEN 0
		WHEN 'PHMAN2' THEN 0
		WHEN 'PHSAL1' THEN 30
		WHEN 'PI9999' THEN 0
		WHEN 'CI0001' THEN 0
		WHEN 'TOGEN1' THEN 0
		WHEN 'COFLS4' THEN 0
		ELSE 0
		END AS TimeFence										/*Time Fence (cprpd100.tmfc) | FALSE | 0 |  | |*/
	,10 AS TimeFenceUnit										/*Time Fence Unit (cprpd100.tmfu) | FALSE | 10 |  | 5;"Hours";10;"Days (default)"|*/
	,0 AS ForecastTimeFence										/*Forecast Time Fence (cprpd100.fctf) | FALSE | 0 |  | |*/
	,CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 350
		WHEN 'COMAN2' THEN 350
		WHEN 'DPMTO1' THEN 999
		WHEN 'GEKIT6' THEN 999
		WHEN 'GELCO1' THEN 350
		WHEN 'GELTR2' THEN 350
		WHEN 'GESCO3' THEN 350
		WHEN 'GESTD5' THEN 350
		WHEN 'GESTR4' THEN 350
		WHEN 'PHMAN2' THEN 350
		WHEN 'PHSAL1' THEN 999
		WHEN 'PI9999' THEN 350
		WHEN 'CI0001' THEN 350
		WHEN 'TOGEN1' THEN 350
		WHEN 'COFLS4' THEN 350
		ELSE 0 
		END AS OrderHorizon										/*Order Horizon (cprpd100.otmf) | FALSE | 0 |  | |*/
	,CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 350
		WHEN 'COMAN2' THEN 350
		WHEN 'DPMTO1' THEN 999
		WHEN 'GEKIT6' THEN 999
		WHEN 'GELCO1' THEN 350
		WHEN 'GELTR2' THEN 350
		WHEN 'GESCO3' THEN 350
		WHEN 'GESTD5' THEN 350
		WHEN 'GESTR4' THEN 350
		WHEN 'PHMAN2' THEN 350
		WHEN 'PHSAL1' THEN 999
		WHEN 'PI9999' THEN 350
		WHEN 'CI0001' THEN 350
		WHEN 'TOGEN1' THEN 350
		WHEN 'COFLS4' THEN 350
		ELSE 0 
		END AS PlanningHorizon									/*Planning Horizon (cprpd100.ptmf) | TRUE | 0 |  | |*/
	,0 AS ExtraLeadTime											/*Extra Lead Time (cprpd100.eltm) | TRUE | 0 |  | |*/
	,10 AS UnitForExtraLeadTime									/*Unit for Extra Lead Time (cprpd100.eltu) | TRUE | 10 |  | 5;"Hours";10;"Days (default)"|*/
	,1 AS AutomateUpdateHorizons								/*Automate Update Horizons (cprpd100.upho) (HYVA) | TRUE | 1 |  | 1;"Yes";2;"No"|*/
	,1 AS OnlineATPUpdate										/*Online ATP Update (cprpd100.onat) (HYVA) | TRUE | 1 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 2
		WHEN 'COMAN2' THEN 2
		WHEN 'DPMTO1' THEN 1
		WHEN 'GEKIT6' THEN 1
		WHEN 'GELCO1' THEN 2
		WHEN 'GELTR2' THEN 2
		WHEN 'GESCO3' THEN 2
		WHEN 'GESTD5' THEN 2
		WHEN 'GESTR4' THEN 2
		WHEN 'PHMAN2' THEN 2
		WHEN 'PHSAL1' THEN 1
		WHEN 'PI9999' THEN 2
		WHEN 'CI0001' THEN 2
		WHEN 'TOGEN1' THEN 2
		WHEN 'COFLS4' THEN 2
		ELSE 2
		END AS CriticalInCTP											/*Critical in CTP (cprpd100.cria) (HYVA) | TRUE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 2
		WHEN 'COMAN2' THEN 2
		WHEN 'DPMTO1' THEN 1
		WHEN 'GEKIT6' THEN 1
		WHEN 'GELCO1' THEN 2
		WHEN 'GELTR2' THEN 2
		WHEN 'GESCO3' THEN 2
		WHEN 'GESTD5' THEN 2
		WHEN 'GESTR4' THEN 2
		WHEN 'PHMAN2' THEN 2
		WHEN 'PHSAL1' THEN 1
		WHEN 'PI9999' THEN 2
		WHEN 'CI0001' THEN 2
		WHEN 'TOGEN1' THEN 2
		WHEN 'COFLS4' THEN 2
		ELSE 2
		END AS ComponentCTP										/*Component CTP (cprpd100.coat) (HYVA) | TRUE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS CapacityCTP											/*Capacity CTP (cprpd100.catp) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS ChannelATP											/*Channel ATP (cprpd100.chat) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,0 AS CTPTimeFence											/*CTP Time Fence (cprpd100.tfat) (HYVA) | TRUE | 0 |  | |*/
	,kpp.CTPHorizon 											/*CTP Horizon (cprpd100.hoat) (HYVA) | FALSE | 0 |  | |*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV3 = 1 AND kps.ItemGroup NOT IN ('PI9999','CI0001','TOGEN1','COFLS04'))
	JOIN ZZZ_Italy.dbo.KPSourceSP kpp ON (kps.Item = kpp.Item)
--	join ZZZ_Italy.dbo.KPSource kps on (itm.MG_CODICE = kps.Item and itm.MG_DITTA = 1 and kps.Migrate = 1 )	
GO


