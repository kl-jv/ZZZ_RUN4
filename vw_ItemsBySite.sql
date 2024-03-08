USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_ItemsBySite]    Script Date: 3/8/2024 11:03:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[vw_ItemsBySite] AS

/* UNION SELECTION IT.POV.01 */

SELECT
	 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
	,CAST('IT.POV.01' AS VARCHAR(9)) AS Site				/*Site (site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/

	/* GENERAL */

	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2
	 END AS ItemOrdering									/*Item Ordering by Site (tcibd250) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 1 
			ELSE 2
		END AS ItemSales									/*Item Sales by Site (tdisa081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2 
		END AS ItemPurchase									/*Item Purchase by Site (tdipu081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2  
			ELSE 2
		 END AS ItemProduction									/*Item Production by Site (tiipd051) | FALSE | 2 |  | 1;"Yes";2;"No"|*/


	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 2 
			ELSE 2 
		 END AS ItemService										/*Item Service by Site (tsmdm220) | TRUE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1
			ELSE 2 
		END AS ItemWarehousing									/*Item Warehousing by Site (whwmd404) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,kps.SupplySource AS SupplySource							/*General - Default Supply Source (srce) ** Item type Product and Generic, use 20, 40, 50 or 60. Other item types, use 10 | FALSE | 10 |  | 10;"Not Applicable (default)";20;"Job Shop";40;"Purchase";50;"Subcontract";60;"Distribution"|*/
	,CAST(NULL AS VARCHAR(9)) AS ProductGroup	/*General - Product Group - Reference to tcmcs025 Product Groups (HYVA) | FALSE | null | 9 | |*/
	,CAST(CASE itm.MG_FLAG_FUORI_PROD
		WHEN 'M' THEN '180'
		WHEN 'N' THEN '' ---'000'
		WHEN 'O' THEN '016'
		WHEN 'P' THEN '170'
		WHEN 'Q' THEN '170'
		WHEN 'S' THEN '005'
		WHEN 'V' THEN '' ---'000'
		ELSE ''
		END AS VARCHAR(3)) AS ItemSignal						/*General - Item Signal (tcibd150.csig)   - Reference to  tcmcs018 Item Signals (HYVA) | FALSE | null | 3 | |*/
	,CAST(kps.CountryOrigin AS VARCHAR(3)) AS CountryOrigin		/*General - Country of Origin (tcibd150.ctyo)   - Reference to  tcmcs010 Countries (HYVA) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(25)) AS HSCode						/*General - Harmonized System Code (tcibd150.ccde)   - Reference to tcmcs028 Harmonized System Codes (HYVA) | FALSE | null | 25 | |*/

	/* ORDERING */

	,CAST(NULL AS VARCHAR(200)) AS ItemGeneralText								/*General - Item Text (tttxt010.ctxt)	FALSE | | | | */
	,0 AS TextIDGeneral											/*General - Text ID (tcibd150.txta)	FALSE |Long Integer| | */
	/*---- replaced 2024/02/14 by JVD ----*/
	,CAST(scm.Warehouse AS VARCHAR(6)) AS OrderingWarehouse 	/*Ordering - Warehouse (tcibd250.cwar) - Reference to tcmcs003 Warehouses ** Mandatory for item ordering by Site | FALSE | null | 6 | |*/
	,1 AS OrderMethod											/*Ordering - Order Method (tcibd250.omth) (HYVA) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,10 AS OrderingTimeUnit										/*Ordering - Time Unit for OrderInterval, SafetyTime (tcibd250.oivu, tcibd250.tuni) (Will set "Use Global Item" to no when value <> 99)	| FALSE	| Byte |5;Hours;10;Days;99;"Inherit from Item (defaults)" | */
	,CAST(1 AS FLOAT) AS OrderInterval										/*Ordering - Order Interval  (tcibd250.oint) (HYVA) | FALSE | 0 |  | |*/
	,CAST(CASE WHEN pla.GE_SCORTA_MIN <> 0 THEN pla.GE_SCORTA_MIN
		ELSE
			CASE WHEN pla.GE_PUNTO_RIORD <> 0 THEN pla.GE_PUNTO_RIORD
				ELSE 0
				END
		END AS FLOAT) AS SafetyStock						/*Ordering - Safety Stock (tcibd250.sfst)  (HYVA) | FALSE | 0 |  | |*/
	,CAST(pla.GE_T_SICURE AS FLOAT) AS SafetyTime			/*Ordering - Safety Time (tcibd250.sftm) (HYVA) | FALSE | 0 |  | |*/
	,CAST(CASE WHEN pla.GE_QTA_MULT_RIOR = 0 THEN 1 ELSE GE_QTA_MULT_RIOR END AS FLOAT) AS OrderQuantityIncrement
															/*Ordering - Order Quantity Increment (tcibd250.oqmf) (HYVA) | FALSE | 1 |  | |*/
	,CAST(CASE WHEN pla.GE_QTA_MIN_RIOR = 0 THEN 1 ELSE pla.GE_QTA_MIN_RIOR END AS FLOAT) AS MinimumOrderQuantity			
															/*Ordering - Minimum Order Quantity (tcibd250.mioq) (HYVA) | FALSE | 0 |  | |*/
	,CAST(CASE WHEN pla.GE_QTA_MAX_RIOR = 0 THEN 99999999.99 ELSE pla.GE_QTA_MAX_RIOR END AS FLOAT) AS MaximumOrderQuantity
															/*Ordering - Maximum Order Quantity (tcibd250.maoq) (HYVA) | FALSE | 99999999.99 |  | <100000000|*/
	,1 AS FixedOrderQuantity								/*Ordering - Fixed Order Quantity (tcibd250.fioq) (HYVA) | FALSE | 1 |  | |*/
	,CAST(CASE WHEN pla.GE_LOTTO_APPR >0 THEN pla.GE_LOTTO_APPR ELSE 1 END AS FLOAT) AS EconomicOrderQuantity
															/*Ordering - Economic Order Quantity (tcibd250.ecoq) (HYVA) | FALSE | 1 |  | |*/
	,0 AS ReorderPoint										/*Ordering - Reorder Point (tcibd250.reop) (HYVA) | FALSE | 0 |  | |*/

/* ATTENTION : TO BE REPLACED BY EMPLOYEE TABLE */
--	,CAST(NULL AS VARCHAR(9)) AS Planner					/*Ordering - Planner (tcibd250.cplb) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
--	, MAP.KPraktorSupplier
--	, map.KpraktorPlanner

	, map.LN_Employee_Planner	 AS Planner							/*Ordering - Planner (tcibd250.cplb) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/

--	, mab.KPraktorSupplier
--	, mab.KpraktorBuyer  AS Buyer	
--	, mab.LN_Employee_Buyer AS LN_buyer


	,2 AS LotSizeCalculationAllowed							/*Ordering - Lot Size Calculation Allowed (tcibd250.auso)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/

	/* SALES */
	/*---- replaced 2024/02/14 by JVD ----*/
	,CAST(scm.Warehouse AS VARCHAR(6)) AS  SalesWarehouse	/*Sales Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/

	
	/* PURCHASE */

	,CASE WHEN pup.Currency IS NULL THEN 'EUR' ELSE pup.Currency END AS PurchaseCurrency								/*Purchase Currency (tdipu081.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST (
    	CASE 
        	WHEN pup.NettPrice IS NULL THEN 0      /*  This will use GLOBAL ITEM then  ! ) */ 
        	ELSE CAST(pup.NettPrice AS FLOAT)
   		 END
    AS FLOAT
	) AS PurchasePrice								/*Purchase Price (tdipu081.prip) | FALSE | 0 |  | |*/


/* Check Purchase Units */
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchaseUnit	/*Purchase Unit (tdipu081.cuqp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchasePriceUnit	/*Purchase Price Unit (tdipu081.cupp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR (6)) AS SitePurchaseOffice		/*Purchase - Site Purchase Office (tdipu081.cofc) - Reference to tdpur012 Purchase Offices | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'P10.10'
			WHEN 'COMAN2' THEN 'P10.10'
			WHEN 'DPMTO1' THEN 'P10.10'
			WHEN 'GEKIT6' THEN 'P10.10'
			WHEN 'GELCO1' THEN 'P10.10'
			WHEN 'GELTR2' THEN 'P10.10'
			WHEN 'GESCO3' THEN 'P10.10'
			WHEN 'GESTD5' THEN 'P10.10'
			WHEN 'GESTR4' THEN 'P10.10'
			WHEN 'PHMAN2' THEN 'P10.10'
			WHEN 'PHSAL1' THEN 'P10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'P90.10'
			WHEN 'TOGEN1' THEN 'P20.30'
			WHEN 'COFLS4' THEN 'P10.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS PurchasePriceGroup				 /*Purchase Price Group (cpgp)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST
		(CASE 
			WHEN stc.StatisticsGroup IS NULL THEN  '------' ELSE stc.StatisticsGroup
		END
			AS VARCHAR(6)
		) AS PurchaseStatisticsGroup						/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	/*---- replaced 2024/02/14 by JVD ----*/
	,CAST(scm.Warehouse AS VARCHAR(6)) AS  PurchaseWarehouse									/*Purchase Warehouse (tdipu081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(CASE WHEN bpc.[Business Partner] IS NULL THEN NULL ELSE bpc.[Business Partner] END AS VARCHAR(9)) AS PurchaseBuyFromBP			/*Purchase Buy-from Business Partner (tdipu081.otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | |*/

	/* ATTENTION :  TO BE REPLACED BY EMPLOYEE TABLE */

--	,CAST(NULL AS VARCHAR(9)) AS Buyer						/*Purchase - Buyer (tdipu081.buyr)   - References tccom001 Employees | FALSE | null | 9 | |*/

--	, mab.KPraktorSupplier
--	, mab.KpraktorBuyer  AS Buyer	
	, mab.LN_Employee_Buyer AS Buyer

	,CAST (
    	CASE 
        	WHEN pus.NettPrice IS NULL 
				THEN 0   -- PUS 
        		ELSE CAST(pus.NettPrice AS FLOAT)
   		 END
    AS FLOAT
	) AS SubcontractingPrice
	,0 AS OperationSubcPrice								/*Purchase - Operation Subcontracting Purchase Price (tdipu081.scpr) (HYVA) | FALSE | 0 |  | |*/
	,2 AS PurchaseScheduleInUse								/*Purchase Schedule in Use (tdipu081.scus) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS PurchaseScheduleType								/*Purchase Schedule Type (tdiu081.styp) (HYVA) | FALSE | 1 |  | 1;"Not Applicable (default)";2;"Pull Schedule";3;"Push Schedule"|*/
	,1 AS VendorRating 										/*VendorRating (tdipu081.vryn) | FALSE | 1 |  |  |1;"Yes";2;"No"; ;99 (default);"Inherit from Item (defaults) |*/
	,CAST(CASE WHEN pla.GE_T_APPR_ACQ = 0 THEN 0 ELSE pla.GE_T_APPR_ACQ END AS FLOAT) AS SupplyTime
															/*Purchase - Supply Time (tdipu081.suti) | FALSE | 0 |  | |*/
	,CASE kps.ItemGroup
		WHEN 'CI0001' THEN 2
		ELSE 1
		END AS ReleaseToWarehousing							/*Purchase - Release to Warehousing (tdipu081.retw)  (HYVA) ** NOTE: Only applicable for cost items. For other items types, this field will always be set to yes. | FALSE | 1 |  | 1;"Yes";2;"No"|*/
	,2 AS Inspection										/*Purchase - Inspection (tdipu081.qual) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
/* 27-02-2024 KL:  Fill LatestPurchasePriceDate from ZZZ_Italy.dbo.PurchasePrices field Lastdate */ 
--	,CAST(NULL AS SMALLDATETIME) AS LatestPurchasePriceDate /*Purchase - LatestPurchasePriceDate (tdipu180.ltpp) | FALSE | null |  Date/Time | | |*/
	,CAST(pup.LastDate AS SMALLDATETIME ) AS LatestPurchasePriceDate /*Purchase - LatestPurchasePriceDate (tdipu180.ltpp) | FALSE | null |  Date/Time | | |*/

	,0 AS  AveragePurchasePrice 							/* Will create record when date is populated */
	,CAST (
    	CASE 
        	WHEN pup.NettPrice IS NULL THEN 0
        	ELSE CAST(pup.NettPrice AS FLOAT)
   		 END
    AS FLOAT
	) AS LatestPurchasePrice								/* Purchase - LatestPurchasePrice  |FALSE  |  |Decimal |  | |*/
    ,CAST(NULL AS VARCHAR(200)) AS ItemPurchaseText								/*Purchase - Item Text (tttxt010.ctxt)	FALSE |  Memo | | | */
	,0 AS TextIDPurchase									/*Purchase - Text ID  (tdipu081.txtp)	FALSE | Long Integer | | | */

	/* PRODUCTION */

	,2 AS ReceiptInspection									/*Production - Receipt Inspection(tiipd051.iimf) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS OutboundInspection								/*Production - Outbound Inspection (tiipd051.iima) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS CriticalForInventory								/*Production - Critical for Inventory (tiipf051.cick)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,0 AS ScrapPercentage									/*Production - Scrap Percentage (tiipf051.scpf) (HYVA) | FALSE | 0 |  | |*/
	,0 AS ScrapQuantity										/*Production - Scrap Quantity (tiipf051.scpq) (HYVA) | FALSE | 0 |  | |*/
	/*----  Changed 2024/02/14 JVD  ----*/
/*	,CASE WHEN kps.Itemgroup = 'DPMTO1' THEN 2
		ELSE
				CASE WHEN kps.SupplySource = 50 THEN 2
					ELSE
						CASE WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 
							ELSE 2
						END
				END 
		END AS Phantom										/*Production - Phantom (tiipf051.cpha) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
*/ 
/*  27-02-2024 KL: Phantom change by JVD , Changed Case Statement */ 
    , CASE 
        WHEN kps.Itemgroup = 'DPMTO1' THEN 2
        WHEN kps.SupplySource = 50 THEN 2
        WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 
        ELSE 2
    END AS Phantom												/*Production - Phantom (tiipf051.cpha) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(9)) AS ShopFloorPlanner			/*Production - Shop Floor Planner (tiipf051.sfpl) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
/* 22-02-2024 KL  BackflusIfMaterial must be 2 ( Info Gideon ) */
/* Keep ItemGroups for reference when needed , all values 1 changed to 2 */
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2	-- was 1 
			WHEN 'COMAN2' THEN 2	-- was 1
			WHEN 'DPMTO1' THEN 2	
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 2	-- was 1
			WHEN 'GELTR2' THEN 2	-- was 1
			WHEN 'GESCO3' THEN 2	
			WHEN 'GESTD5' THEN 2	-- was 1
			WHEN 'GESTR4' THEN 2	-- was 1
			WHEN 'PHMAN2' THEN 2	-- was 1
			WHEN 'PHSAL1' THEN 2	-- was 1
			WHEN 'PI9999' THEN 2	 
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2	-- was 1
			ELSE 2
		END AS BackflushIfMaterial							/*Production - Allow Backflushing (tiipf051.bfcp) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
/* 22-02-2024 KL:  BackflusMaterials must be 2 ( Info Gideon ) */
/* Keep ItemGroups for reference when needed , all values 1 changed to 2 */
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 2	-- was 1
			WHEN 'GEKIT6' THEN 2	-- was 1
			WHEN 'GELCO1' THEN 2
			WHEN 'GELTR2' THEN 2
			WHEN 'GESCO3' THEN 2
			WHEN 'GESTD5' THEN 2
			WHEN 'GESTR4' THEN 2
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS BackflushMaterials								/*Production - Backflush Materials (tiipf051.bfep) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS BackflushHours									/*Production - Backflush Hours (tiipd051.bfhr)  (Will set "Use Global Item" to no when value <> 99)	| FALSE |Byte| |1;"Yes";2;"No";99;"Inherit from Item (defaults)" */
/*	,CASE WHEN kps.Itemgroup = 'DPMTO1' THEN 1
		ELSE
				CASE WHEN kps.SupplySource = 50 THEN 1
					ELSE
						CASE WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 2 
							ELSE 1
						END
				END 
		END AS DirectInitiateInventoryIssue						/*Production - Direct Initiate Inventory Issue (tiipf051.drin) (HYVA) | FALSE | null |  | 1;"Yes";2;"No (default)"|*/
*/ 
/* 27-02-2024 KL :  Change by JVD Changed Case Statement */ 
	,CASE 
		WHEN kps.Itemgroup = 'DPMTO1' THEN 1
		WHEN kps.SupplySource = 50 THEN 1
		WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 2 
		ELSE 1
	 END AS DirectInitiateInventoryIssue						/*Production - Direct Initiate Inventory Issue (tiipf051.drin) (HYVA) | FALSE | null |  | 1;"Yes";2;"No (default)"|*/


	,2 AS DirectProcessWHOrderLine							/*Production - Direct Process Warehouse Order Line (tiipd051.dris) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/

	/* SERVICE */

	,CAST(NULL AS VARCHAR(9)) AS ServiceDepartment			/*Service Operations Department (tsmdm220.mdpt) - Reference to tdmdm100 Service Departments | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/

	/* WAREHOUSE */

	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ItemValuationGroup			/*Warehousing - Item Valuation Group (whwmd404.ivgr)   - Reference to whina101 Item Valuation Groups (HYVA) | FALSE | null | 6 | |*/
	,1 AS LocationControlled								/*Warehousing - Location Controlled (whwmd404.locc) (HYVA) | FALSE | 0 |  | 1;"Yes";2;"No"|*/
	,1 AS ProcessInvVariances								/*Warehousing - Process Inventory Variances Automatically (whwmd404.prva) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,20 AS UseOrderingData									/*Warehousing - Use Item Ordering Data by Site (whwmd404.uidt) (HYVA) | FALSE | 10 |  | 10;"Yes";20;"No";30;"Apply Warehouse Default"|*/
	,60 AS DefaultSupplySystem								/*Warehousing - Default Supply System (whwmd404.dwhs) (HYVA) | FALSE | 70 |  | 10;"Time-Phased Order Point";20;"KANBAN";30;"Order Controlled/Batch";40;"Order Controlled/SILS";50;"Order Controlled/Single";60;"Apply Warehouse Defaults";70;"None (default)"|*/
	,2 AS GenerateOrderAdvices								/*Warehousing - Generate Order Advices (whwmd404.goad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS CombineOrderAdvices								/*Warehousing - Combine Order Advices (whwmd404.coad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS ConfirmOrderAdvices								/*Warehousing - Automatically Confirm Order Advices (whwmd404.acoa) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,CAST(TRIM(itm.MG_CLASSE_ABC) AS VARCHAR(1)) AS ABCcode	/*Warehousing - ABC Code (whwmd404.abcc) (HYVA) | FALSE | null | 1 | |*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS HandlingUnitInUse								/*Warehousing - Handling Units in Use(whwmd404.uhnd) (HYVA) |  | 2 |  | 1;"Yes";2;"No"|*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND (kps.POV1 <> 0))
	LEFT JOIN KPRAKTOR.SIAPR.ANAGES pla ON (itm.MG_CODICE = pla.GE_CODICE_ART AND itm.MG_DITTA = pla.GE_DITTA)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (itm.MG_CODFOR_PREF = bpc.KPraktor AND itm.MG_DITTA = 1)
/*  06-03-2024 KL : RN2 has been deleted from PurchasePrices , deleted RN2 from JOIN */ 
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pup ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND  pup.Subcontract = 0)
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pus ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND   pup.Subcontract = 1)

/* 27-02-2024 KL: ProductType table has become SelectionCode with field SelectionCode instead of ProductType */
-- 	LEFT JOIN ZZZ_Italy.dbo.ProductType prt ON (itm.MG_TIP_REC = prt.Code AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.SelectionCode sec ON (itm.MG_TIP_REC = sec.Code AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.StatisticsGroep_Conv stc ON (itm.MG_TIP_REC = stc.ProductType AND itm.MG_DITTA = 1)
	/* ---- Added 2024/02/14 ----  */
	
	LEFT JOIN ZZZ_Italy.dbo.SCModelMap scm ON (kps.POV1 = scm.POV1 AND scm.Site = 'IT.POV.01')

	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] mab ON ( mab.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] map ON ( map.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
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
		)bol ON (kps.Item = bol.item)

-- ATTENTION : TO BE ADJUSTED WHEN ITEM WAREHOUSES PER ITEM ARE KNOWN 

--- 17-07-2023 RD added , RD is in POV1 



UNION ALL 

-- PART 2

/* UNION SELECTION FOR SPARE PARTS IT.POV.03 */

SELECT
	 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item
	,CAST('IT.POV.03' AS VARCHAR(9)) AS Site				/*Site (site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/

	/* GENERAL */

	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2
	 END AS ItemOrdering									/*Item Ordering by Site (tcibd250) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 1 
			ELSE 2
		END AS ItemSales									/*Item Sales by Site (tdisa081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1
			ELSE 2 
		END AS ItemPurchase									/*Item Purchase by Site (tdipu081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		 END AS ItemProduction									/*Item Production by Site (tiipd051) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 2 
			ELSE 2 
		 END AS ItemService										/*Item Service by Site (tsmdm220) | TRUE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 1
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1
			ELSE 2 
		END AS ItemWarehousing									/*Item Warehousing by Site (whwmd404) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CAST(kpp.SupplySource AS FLOAT) AS SupplySource			/*General - Default Supply Source (srce) ** Item type Product and Generic, use 20, 40, 50 or 60. Other item types, use 10 | FALSE | 10 |  | 10;"Not Applicable (default)";20;"Job Shop";40;"Purchase";50;"Subcontract";60;"Distribution"|*/
	,CAST(NULL AS VARCHAR(9)) AS ProductGroup					/*General - Product Group - Reference to tcmcs025 Product Groups (HYVA) | FALSE | null | 9 | |*/
	,CAST(CASE itm.MG_FLAG_FUORI_PROD
		WHEN 'M' THEN '180'
		WHEN 'N' THEN '' ---'000'
		WHEN 'O' THEN '016'
		WHEN 'P' THEN '170'
		WHEN 'Q' THEN '170'
		WHEN 'S' THEN '005'
		WHEN 'V' THEN '' ---'000'
		ELSE ''
		END AS VARCHAR(3)) AS ItemSignal						/*General - Item Signal (tcibd150.csig)   - Reference to  tcmcs018 Item Signals (HYVA) | FALSE | null | 3 | |*/
	,CAST(kps.CountryOrigin AS VARCHAR(3)) AS CountryOrigin		/*General - Country of Origin (tcibd150.ctyo)   - Reference to  tcmcs010 Countries (HYVA) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(25)) AS HSCode						/*General - Harmonized System Code (tcibd150.ccde)   - Reference to tcmcs028 Harmonized System Codes (HYVA) | FALSE | null | 25 | |*/

	/* ORDERING */

	,CAST(NULL AS VARCHAR(200)) AS ItemGeneralText								/*General - Item Text (tttxt010.ctxt)	FALSE | | | | */
	,0 AS TextIDGeneral										/*General - Text ID (tcibd150.txta)	FALSE |Long Integer| | */
	/*---- Changed 2024/02/14 JVD ----*/
	,CAST(scm.warehouse AS VARCHAR(6)) AS OrderingWarehouse			/*Ordering - Warehouse (tcibd250.cwar) - Reference to tcmcs003 Warehouses ** Mandatory for item ordering by Site | FALSE | null | 6 | |*/
	,1 AS OrderMethod										/*Ordering - Order Method (tcibd250.omth) (HYVA) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,10 AS OrderingTimeUnit									/*Ordering - Time Unit for OrderInterval, SafetyTime (tcibd250.oivu, tcibd250.tuni) (Will set "Use Global Item" to no when value <> 99)	| FALSE	| Byte |5;Hours;10;Days;99;"Inherit from Item (defaults)" | */
	,CAST(1 AS FLOAT) AS OrderInterval										/*Ordering - Order Interval  (tcibd250.oint) (HYVA) | FALSE | 0 |  | |*/
	,CAST(kpp.SafetyStock AS FLOAT) AS SafetyStock						/*Ordering - Safety Stock (tcibd250.sfst)  (HYVA) | FALSE | 0 |  | |*/



--	,CAST(kpp.SafetyTime AS FLOAT) AS SafetyTime			/*Ordering - Safety Time (tcibd250.sftm) (HYVA) | FALSE | 0 |  | |*/

/*	20-12-2023 KL : Adjustements requested by Belinda
	For supply source "distribution" (60 ) */
	,CAST (
	    CASE
	        WHEN kpp.SupplySource = 60 THEN 0
	        ELSE kpp.SafetyTime
	   END AS FLOAT
	) AS SafetyTime


-- 	,CAST(CASE WHEN pla.GE_QTA_MULT_RIOR = 0 THEN 1 ELSE GE_QTA_MULT_RIOR END AS FLOAT) AS OrderQuantityIncrement
															/*Ordering - Order Quantity Increment (tcibd250.oqmf) (HYVA) | FALSE | 1 |  | |*/
	, CAST (
	    CASE
			WHEN pla.GE_QTA_MULT_RIOR = 0 OR kpp.SupplySource = 60 THEN 1
			ELSE pla.GE_QTA_MULT_RIOR
		END AS FLOAT
	) AS OrderQuantityIncrement


--	,CAST(CASE WHEN pla.GE_QTA_MIN_RIOR = 0 THEN 1 ELSE pla.GE_QTA_MIN_RIOR END AS FLOAT) AS MinimumOrderQuantity			
															/*Ordering - Minimum Order Quantity (tcibd250.mioq) (HYVA) | FALSE | 0 |  | |*/

	,CAST(													/*Ordering - Minimum Order Quantity (tcibd250.mioq) (HYVA) | FALSE | 0 |  | |*/
		CASE 
			WHEN pla.GE_QTA_MIN_RIOR = 0  OR kpp.SupplySource = 60 THEN 1 
			ELSE pla.GE_QTA_MIN_RIOR 
		END AS FLOAT) AS MinimumOrderQuantity	

--	,CAST(CASE WHEN pla.GE_QTA_MAX_RIOR = 0 THEN 99999999.99 ELSE pla.GE_QTA_MAX_RIOR END AS FLOAT) AS MaximumOrderQuantity
															/*Ordering - Maximum Order Quantity (tcibd250.maoq) (HYVA) | FALSE | 99999999.99 |  | <100000000|*/

	,CAST(													/*Ordering - Maximum Order Quantity (tcibd250.maoq) (HYVA) | FALSE | 99999999.99 |  | <100000000|*/
		CASE 
			WHEN pla.GE_QTA_MAX_RIOR = 0 OR kpp.SupplySource = 60 THEN 99999999.99 
			ELSE pla.GE_QTA_MAX_RIOR 
		END AS FLOAT) AS MaximumOrderQuantity
	
	
	,1 AS FixedOrderQuantity								/*Ordering - Fixed Order Quantity (tcibd250.fioq) (HYVA) | FALSE | 1 |  | |*/


	,CAST(CASE WHEN pla.GE_LOTTO_APPR >0 THEN pla.GE_LOTTO_APPR ELSE 1 END AS FLOAT) AS EconomicOrderQuantity
															/*Ordering - Economic Order Quantity (tcibd250.ecoq) (HYVA) | FALSE | 1 |  | |*/
	,0 AS ReorderPoint										/*Ordering - Reorder Point (tcibd250.reop) (HYVA) | FALSE | 0 |  | |*/

--	,CAST(NULL AS VARCHAR(9)) AS Planner					/*Ordering - Planner (tcibd250.cplb) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/

	, map.LN_Employee_Planner AS Planner					/*Ordering - Planner (tcibd250.cplb) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/


	,2 AS LotSizeCalculationAllowed							/*Ordering - Lot Size Calculation Allowed (tcibd250.auso)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/

	/* SALES */
	/*---- Changed 2024/02/14 JVD ----*/
	,CAST(scm.warehouse AS VARCHAR(6)) AS SalesWarehouse				/*Sales Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/

	/* PURCHASE */

	,CASE WHEN pup.Currency IS NULL THEN 'EUR' ELSE pup.Currency END AS PurchaseCurrency								/*Purchase Currency (tdipu081.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,	CAST (
			CASE 
				WHEN pup.NettPrice IS NULL THEN 0
				ELSE CAST(pup.NettPrice AS FLOAT)
			END
		AS FLOAT
		) AS PurchasePrice								/*Purchase Price (tdipu081.prip) | FALSE | 0 |  | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchaseUnit	/*Purchase Unit (tdipu081.cuqp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchasePriceUnit	/*Purchase Price Unit (tdipu081.cupp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR (6)) AS SitePurchaseOffice		/*Purchase - Site Purchase Office (tdipu081.cofc) - Reference to tdpur012 Purchase Offices | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'P10.10'
			WHEN 'COMAN2' THEN 'P10.10'
			WHEN 'DPMTO1' THEN 'P10.10'
			WHEN 'GEKIT6' THEN 'P10.10'
			WHEN 'GELCO1' THEN 'P10.10'
			WHEN 'GELTR2' THEN 'P10.10'
			WHEN 'GESCO3' THEN 'P10.10'
			WHEN 'GESTD5' THEN 'P10.10'
			WHEN 'GESTR4' THEN 'P10.10'
			WHEN 'PHMAN2' THEN 'P10.10'
			WHEN 'PHSAL1' THEN 'P10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'P90.10'
			WHEN 'TOGEN1' THEN 'P20.30'
			WHEN 'COFLS4' THEN '' ------
			ELSE '------' 
	 END AS VARCHAR(6)) AS PurchasePriceGroup				 /*Purchase Price Group (cpgp)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST
		(CASE 
			WHEN stc.StatisticsGroup IS NULL THEN  '------' ELSE stc.StatisticsGroup
		END
			AS VARCHAR(6)
		) AS PurchaseStatisticsGroup						/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	/*---- Changed 2024/02/14 JVD ----*/
	,CAST(scm.warehouse AS VARCHAR(6)) AS PurchaseWarehouse				/*Purchase Warehouse (tdipu081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(CASE WHEN bpc.[Business Partner] IS NULL THEN NULL ELSE bpc.[Business Partner] END AS VARCHAR(9)) AS PurchaseBuyFromBP		/*Purchase Buy-from Business Partner (tdipu081.otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | |*/

--	,CAST(NULL AS VARCHAR(9)) AS Buyer						/*Purchase - Buyer (tdipu081.buyr)   - References tccom001 Employees | FALSE | null | 9 | |*/

	, mab.LN_Employee_Buyer AS Buyer				/*Purchase - Buyer (tdipu081.buyr)   - References tccom001 Employees | FALSE | null | 9 | |*/


	,CAST(CASE WHEN pla.GE_T_APPR_ACQ = 0 THEN 0 ELSE pla.GE_T_APPR_ACQ END AS FLOAT) AS SupplyTime	/*Purchase - Supply Time (tdipu081.suti) | FALSE | 0 |  | |*/
	,CAST (
			CASE 
				WHEN pus.NettPrice IS NULL THEN 0  
				ELSE CAST(pus.NettPrice AS FLOAT)
			END
			AS FLOAT
		) AS SubcontractingPrice
	,0 AS OperationSubcPrice								/*Purchase - Operation Subcontracting Purchase Price (tdipu081.scpr) (HYVA) | FALSE | 0 |  | |*/
	,2 AS PurchaseScheduleInUse								/*Purchase Schedule in Use (tdipu081.scus) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS PurchaseScheduleType								/*Purchase Schedule Type (tdiu081.styp) (HYVA) | FALSE | 1 |  | 1;"Not Applicable (default)";2;"Pull Schedule";3;"Push Schedule"|*/
	,1 AS VendorRating 										/*VendorRating (tdipu081.vryn) | FALSE | 1 |  |  |1;"Yes";2;"No"; ;99 (default);"Inherit from Item (defaults) |*/
	,CASE kps.ItemGroup
		WHEN 'CI0001' THEN 2
		ELSE 1
		END AS ReleaseToWarehousing							/*Purchase - Release to Warehousing (tdipu081.retw)  (HYVA) ** NOTE: Only applicable for cost items. For other items types, this field will always be set to yes. | FALSE | 1 |  | 1;"Yes";2;"No"|*/
	,2 AS Inspection										/*Purchase - Inspection (tdipu081.qual) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
/* 27-02-2024 KL:  Fill LatestPurchasePriceDate from ZZZ_Italy.dbo.PurchasePrices field Lastdate */ 
--	,CAST(NULL AS SMALLDATETIME) AS LatestPurchasePriceDate /*Purchase - LatestPurchasePriceDate (tdipu180.ltpp) | FALSE | null |  Date/Time | | |*/
 	,CAST(pup.LastDate as SMALLDATETIME ) AS LatestPurchasePriceDate /*Purchase - LatestPurchasePriceDate (tdipu180.ltpp) | FALSE | null |  Date/Time | | |*/                                                           /* Will create record when date is populated */
	,0 AS  AveragePurchasePrice
	,0 AS  LatestPurchasePrice

	,CAST(NULL AS VARCHAR(200)) AS ItemPurchaseText			/*Purchase - Item Text (tttxt010.ctxt)	FALSE |  Memo | | | */
	,0 AS TextIDPurchase									/*Purchase - Text ID  (tdipu081.txtp)	FALSE | Long Integer | | | */

	/* PRODUCTION */

	,2 AS ReceiptInspection									/*Production - Receipt Inspection(tiipd051.iimf) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS OutboundInspection								/*Production - Outbound Inspection (tiipd051.iima) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS CriticalForInventory								/*Production - Critical for Inventory (tiipf051.cick)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,0 AS ScrapPercentage									/*Production - Scrap Percentage (tiipf051.scpf) (HYVA) | FALSE | 0 |  | |*/
	,0 AS ScrapQuantity										/*Production - Scrap Quantity (tiipf051.scpq) (HYVA) | FALSE | 0 |  | |*/
	,CAST(kpp.Phantom AS FLOAT) AS Phantom  				/*Production - Phantom (tiipf051.cpha) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/

	,CAST(NULL AS VARCHAR(9)) AS ShopFloorPlanner			/*Production - Shop Floor Planner (tiipf051.sfpl) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
/* 22-02-2024 KL  BackflusIfMaterial must be 2 ( Info Gideon ) */
/* Keep ItemGroups for reference when needed , all values 1 changed to 2 */
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2	--	was 1
			WHEN 'COMAN2' THEN 2	--	was 1
			WHEN 'DPMTO1' THEN 2	
			WHEN 'GEKIT6' THEN 2	
			WHEN 'GELCO1' THEN 2	--	was 1
			WHEN 'GELTR2' THEN 2	--	was 1
			WHEN 'GESCO3' THEN 2
			WHEN 'GESTD5' THEN 2	--	was 1
			WHEN 'GESTR4' THEN 2	--	was 1
			WHEN 'PHMAN2' THEN 2	--	was 1
			WHEN 'PHSAL1' THEN 2	--	was 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2	--	was 1
			ELSE 2
		END AS BackflushIfMaterial							/*Production - Allow Backflushing (tiipf051.bfcp) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 2	--	was 1
			WHEN 'GEKIT6' THEN 2	--	was 1
			WHEN 'GELCO1' THEN 2
			WHEN 'GELTR2' THEN 2
			WHEN 'GESCO3' THEN 2 
			WHEN 'GESTD5' THEN 2
			WHEN 'GESTR4' THEN 2
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS BackflushMaterials							/*Production - Backflush Materials (tiipf051.bfep) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS BackflushHours									/*Production - Backflush Hours (tiipd051.bfhr)  (Will set "Use Global Item" to no when value <> 99)	| FALSE |Byte| |1;"Yes";2;"No";99;"Inherit from Item (defaults)" */
/* 27-02-2024 KL :  Change by JVD , Changed Case Statement */ 
-- 	,2 AS DirectInitiateInventoryIssue						/*Production - Direct Initiate Inventory Issue (tiipf051.drin) (HYVA) | FALSE | null |  | 1;"Yes";2;"No (default)"|*/
	,CASE 
		WHEN kps.Itemgroup = 'DPMTO1' THEN 1
		WHEN kps.SupplySource = 50 THEN 1
		WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 2 
		ELSE 1
	 END AS DirectInitiateInventoryIssue						/*Production - Direct Initiate Inventory Issue (tiipf051.drin) (HYVA) | FALSE | null |  | 1;"Yes";2;"No (default)"|*/

	,2 AS DirectProcessWHOrderLine							/*Production - Direct Process Warehouse Order Line (tiipd051.dris) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/

	/* SERVICE */

	,CAST(NULL AS VARCHAR(9)) AS ServiceDepartment			/*Service Operations Department (tsmdm220.mdpt) - Reference to tdmdm100 Service Departments | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/

	/* WAREHOUSE */

	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ItemValuationGroup			/*Warehousing - Item Valuation Group (whwmd404.ivgr)   - Reference to whina101 Item Valuation Groups (HYVA) | FALSE | null | 6 | |*/
	,1 AS LocationControlled								/*Warehousing - Location Controlled (whwmd404.locc) (HYVA) | FALSE | 0 |  | 1;"Yes";2;"No"|*/
	,1 AS ProcessInvVariances								/*Warehousing - Process Inventory Variances Automatically (whwmd404.prva) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,20 AS UseOrderingData									/*Warehousing - Use Item Ordering Data by Site (whwmd404.uidt) (HYVA) | FALSE | 10 |  | 10;"Yes";20;"No";30;"Apply Warehouse Default"|*/
	,70 AS DefaultSupplySystem								/*Warehousing - Default Supply System (whwmd404.dwhs) (HYVA) | FALSE | 70 |  | 10;"Time-Phased Order Point";20;"KANBAN";30;"Order Controlled/Batch";40;"Order Controlled/SILS";50;"Order Controlled/Single";60;"Apply Warehouse Defaults";70;"None (default)"|*/
	,2 AS GenerateOrderAdvices								/*Warehousing - Generate Order Advices (whwmd404.goad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS CombineOrderAdvices								/*Warehousing - Combine Order Advices (whwmd404.coad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS ConfirmOrderAdvices								/*Warehousing - Automatically Confirm Order Advices (whwmd404.acoa) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,CAST(TRIM(itm.MG_CLASSE_ABC) AS VARCHAR(1)) AS ABCcode	/*Warehousing - ABC Code (whwmd404.abcc) (HYVA) | FALSE | null | 1 | |*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS HandlingUnitInUse								/*Warehousing - Handling Units in Use(whwmd404.uhnd) (HYVA) |  | 2 |  | 1;"Yes";2;"No"|*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV3 = 1 )
	JOIN ZZZ_Italy.dbo.KPSourceSP kpp ON (kps.Item = kpp.Item)
	LEFT JOIN KPRAKTOR.SIAPR.ANAGES pla ON (itm.MG_CODICE = pla.GE_CODICE_ART AND itm.MG_DITTA = pla.GE_DITTA)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (itm.MG_CODFOR_PREF = bpc.KPraktor AND itm.MG_DITTA = 1)
/*  06-03-2024 KL : RN2 has been deleted from PurchasePrices , deleted RN2 from JOIN */ 	
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pup ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND  pup.Subcontract = 0)
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pus ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND  pup.Subcontract = 1)

/* 27-02-2024 KL: ProductType tabel has become SelectionCode with files SelectionCode instead of ProductType */
--	LEFT JOIN ZZZ_Italy.dbo.ProductType prt ON (itm.MG_TIP_REC = prt.Code AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.SelectionCode sec ON (itm.MG_TIP_REC = sec.Code AND itm.MG_DITTA = 1)

	LEFT JOIN ZZZ_Italy.dbo.StatisticsGroep_Conv stc ON (itm.MG_TIP_REC = stc.ProductType AND itm.MG_DITTA = 1)

	/* ---- Added 2024/02/14 ----  */
	LEFT JOIN ZZZ_Italy.dbo.SCModelMap scm ON (kps.POV3 = scm.POV3 AND scm.Site = 'IT.POV.03')

	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] mab ON ( mab.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] map ON ( map.KPraktorSupplier = itm.MG_CODFOR_PREF ) 

/*	LEFT JOIN
		(
			SELECT
				 noc.NT_CONTO
				,NT_DESCR AS Buyer
				,noc.NT_DITTA
			FROM
				KPRAKTOR.SIACG.NOTECLIFOR noc
			WHERE
				NT_CLASSE = 'GEST'
				AND LEN(TRIM(NT_DESCR))>0
		)buy ON (itm.MG_CODFOR_PREF =  buy.NT_CONTO AND itm.MG_DITTA = buy.NT_DITTA)
	LEFT JOIN
			(
			SELECT
				 noc.NT_CONTO
				,NT_DESCR AS Planner
				,noc.NT_DITTA
			FROM
				KPRAKTOR.SIACG.NOTECLIFOR noc
			WHERE
				NT_CLASSE = 'SOLL'
				AND LEN(TRIM(NT_DESCR))>0
		)sol ON (itm.MG_CODFOR_PREF =  sol.NT_CONTO AND itm.MG_DITTA = sol.NT_DITTA)


*/ 

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
		)bol ON (kps.Item = bol.item)

UNION ALL

/* SITE: IT.EXT.01 */

SELECT
	 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
	,CAST('IT.EXT.01' AS VARCHAR(9)) AS Site				/*Site (site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	/* GENERAL */

	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2
	 END AS ItemOrdering									/*Item Ordering by Site (tcibd250) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 1 
			ELSE 2
		END AS ItemSales									/*Item Sales by Site (tdisa081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2 
		END AS ItemPurchase									/*Item Purchase by Site (tdipu081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 2
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 2
			WHEN 'GELTR2' THEN 2
			WHEN 'GESCO3' THEN 2
			WHEN 'GESTD5' THEN 2
			WHEN 'GESTR4' THEN 2
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2  
			ELSE 2
		 END AS ItemProduction									/*Item Production by Site (tiipd051) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 2 
			ELSE 2 
		 END AS ItemService										/*Item Service by Site (tsmdm220) | TRUE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1
			ELSE 2 
		END AS ItemWarehousing									/*Item Warehousing by Site (whwmd404) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	/* Belinda list */
	,cast(40 as float) AS SupplySource							/*General - Default Supply Source (srce) ** Item type Product and Generic, use 20, 40, 50 or 60. Other item types, use 10 | FALSE | 10 |  | 10;"Not Applicable (default)";20;"Job Shop";40;"Purchase";50;"Subcontract";60;"Distribution"|*/
	,CAST(NULL AS VARCHAR(9)) AS ProductGroup	/*General - Product Group - Reference to tcmcs025 Product Groups (HYVA) | FALSE | null | 9 | |*/
	,CAST(CASE itm.MG_FLAG_FUORI_PROD
		WHEN 'M' THEN '180'
		WHEN 'N' THEN '' ---'000'
		WHEN 'O' THEN '016'
		WHEN 'P' THEN '170'
		WHEN 'Q' THEN '170'
		WHEN 'S' THEN '005'
		WHEN 'V' THEN '' ---'000'
		ELSE ''
		END AS VARCHAR(3)) AS ItemSignal						/*General - Item Signal (tcibd150.csig)   - Reference to  tcmcs018 Item Signals (HYVA) | FALSE | null | 3 | |*/
	,CAST(kps.CountryOrigin AS VARCHAR(3)) AS CountryOrigin		/*General - Country of Origin (tcibd150.ctyo)   - Reference to  tcmcs010 Countries (HYVA) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(25)) AS HSCode						/*General - Harmonized System Code (tcibd150.ccde)   - Reference to tcmcs028 Harmonized System Codes (HYVA) | FALSE | null | 25 | |*/

	/* ORDERING */

	,CAST(NULL AS VARCHAR(200)) AS ItemGeneralText								/*General - Item Text (tttxt010.ctxt)	FALSE | | | | */
	,0 AS TextIDGeneral											/*General - Text ID (tcibd150.txta)	FALSE |Long Integer| | */
	/*---- replaced 2024/02/14 by JVD ----*/
	,CAST(scm.Warehouse AS VARCHAR(6)) AS OrderingWarehouse 	/*Ordering - Warehouse (tcibd250.cwar) - Reference to tcmcs003 Warehouses ** Mandatory for item ordering by Site | FALSE | null | 6 | |*/
	,1 AS OrderMethod											/*Ordering - Order Method (tcibd250.omth) (HYVA) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,10 AS OrderingTimeUnit										/*Ordering - Time Unit for OrderInterval, SafetyTime (tcibd250.oivu, tcibd250.tuni) (Will set "Use Global Item" to no when value <> 99)	| FALSE	| Byte |5;Hours;10;Days;99;"Inherit from Item (defaults)" | */
	,CAST(1 AS FLOAT) AS OrderInterval										/*Ordering - Order Interval  (tcibd250.oint) (HYVA) | FALSE | 0 |  | |*/
	,CAST(0 AS FLOAT) AS SafetyStock							/*Ordering - Safety Stock (tcibd250.sfst)  (HYVA) | FALSE | 0 |  | |*/
	/* Belinda List */
	,CAST(5 AS FLOAT) AS SafetyTime								/*Ordering - Safety Time (tcibd250.sftm) (HYVA) | FALSE | 0 |  | |*/
	/* Belinda List */
	,CAST(1 as float) AS OrderQuantityIncrement
	/* Belinda List */										/*Ordering - Order Quantity Increment (tcibd250.oqmf) (HYVA) | FALSE | 1 |  | |*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity			
	/* Belinda List */															/*Ordering - Minimum Order Quantity (tcibd250.mioq) (HYVA) | FALSE | 0 |  | |*/
	,CAST(99999999.99 AS FLOAT) AS MaximumOrderQuantity
	/* Belinda List */															/*Ordering - Maximum Order Quantity (tcibd250.maoq) (HYVA) | FALSE | 99999999.99 |  | <100000000|*/
	,1 AS FixedOrderQuantity									/*Ordering - Fixed Order Quantity (tcibd250.fioq) (HYVA) | FALSE | 1 |  | |*/
	/* Belinda List */
	,CAST(1 as float) AS EconomicOrderQuantity
																/*Ordering - Economic Order Quantity (tcibd250.ecoq) (HYVA) | FALSE | 1 |  | |*/
	,0 AS ReorderPoint											/*Ordering - Reorder Point (tcibd250.reop) (HYVA) | FALSE | 0 |  | |*/
	, map.LN_Employee_Planner	 AS Planner						/*Ordering - Planner (tcibd250.cplb) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
	,2 AS LotSizeCalculationAllowed								/*Ordering - Lot Size Calculation Allowed (tcibd250.auso)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/

	/* SALES */

	,CAST(scm.Warehouse AS VARCHAR(6)) AS  SalesWarehouse	/*Sales Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	
	/* PURCHASE */

	,CASE WHEN pup.Currency IS NULL THEN 'EUR' ELSE pup.Currency END AS PurchaseCurrency								/*Purchase Currency (tdipu081.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	/* Belinda List */
	,CAST (0 AS FLOAT) AS PurchasePrice								/*Purchase Price (tdipu081.prip) | FALSE | 0 |  | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchaseUnit	/*Purchase Unit (tdipu081.cuqp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchasePriceUnit	/*Purchase Price Unit (tdipu081.cupp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR (6)) AS SitePurchaseOffice		/*Purchase - Site Purchase Office (tdipu081.cofc) - Reference to tdpur012 Purchase Offices | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'P10.10'
			WHEN 'COMAN2' THEN 'P10.10'
			WHEN 'DPMTO1' THEN 'P10.10'
			WHEN 'GEKIT6' THEN 'P10.10'
			WHEN 'GELCO1' THEN 'P10.10'
			WHEN 'GELTR2' THEN 'P10.10'
			WHEN 'GESCO3' THEN 'P10.10'
			WHEN 'GESTD5' THEN 'P10.10'
			WHEN 'GESTR4' THEN 'P10.10'
			WHEN 'PHMAN2' THEN 'P10.10'
			WHEN 'PHSAL1' THEN 'P10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'P90.10'
			WHEN 'TOGEN1' THEN 'P20.30'
			WHEN 'COFLS4' THEN 'P10.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS PurchasePriceGroup				 /*Purchase Price Group (cpgp)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST
		(CASE 
			WHEN stc.StatisticsGroup IS NULL THEN  '------' ELSE stc.StatisticsGroup
		END
			AS VARCHAR(6)
		) AS PurchaseStatisticsGroup								/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	,CAST(scm.Warehouse AS VARCHAR(6)) AS  PurchaseWarehouse									/*Purchase Warehouse (tdipu081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS PurchaseBuyFromBP					/*Purchase Buy-from Business Partner (tdipu081.otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | |*/
	, mab.LN_Employee_Buyer AS Buyer
	,CAST (null  AS FLOAT) AS SubcontractingPrice
	,0 AS OperationSubcPrice								/*Purchase - Operation Subcontracting Purchase Price (tdipu081.scpr) (HYVA) | FALSE | 0 |  | |*/
	,2 AS PurchaseScheduleInUse								/*Purchase Schedule in Use (tdipu081.scus) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS PurchaseScheduleType								/*Purchase Schedule Type (tdiu081.styp) (HYVA) | FALSE | 1 |  | 1;"Not Applicable (default)";2;"Pull Schedule";3;"Push Schedule"|*/
	,1 AS VendorRating 										/*VendorRating (tdipu081.vryn) | FALSE | 1 |  |  |1;"Yes";2;"No"; ;99 (default);"Inherit from Item (defaults) |*/
	/* Belinda List */
	,CAST(0 as float) AS SupplyTime									/*Purchase - Supply Time (tdipu081.suti) | FALSE | 0 |  | |*/
	,CASE kps.ItemGroup
		WHEN 'CI0001' THEN 2
		ELSE 1
		END AS ReleaseToWarehousing							/*Purchase - Release to Warehousing (tdipu081.retw)  (HYVA) ** NOTE: Only applicable for cost items. For other items types, this field will always be set to yes. | FALSE | 1 |  | 1;"Yes";2;"No"|*/
	,2 AS Inspection										/*Purchase - Inspection (tdipu081.qual) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	/* Belinda List */
	,CAST(null as SMALLDATETIME ) AS LatestPurchasePriceDate /*Purchase - LatestPurchasePriceDate (tdipu180.ltpp) | FALSE | null |  Date/Time | | |*/
	,0 AS  AveragePurchasePrice 							/* Will create record when date is populated */
	/* Belinda List */
	,CAST(null as float) AS LatestPurchasePrice						/* Purchase - LatestPurchasePrice  |FALSE  |  |Decimal |  | |*/
    ,CAST(NULL AS VARCHAR(200)) AS ItemPurchaseText								/*Purchase - Item Text (tttxt010.ctxt)	FALSE |  Memo | | | */
	,0 AS TextIDPurchase									/*Purchase - Text ID  (tdipu081.txtp)	FALSE | Long Integer | | | */

	/* PRODUCTION */

	,2 AS ReceiptInspection									/*Production - Receipt Inspection(tiipd051.iimf) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS OutboundInspection								/*Production - Outbound Inspection (tiipd051.iima) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS CriticalForInventory								/*Production - Critical for Inventory (tiipf051.cick)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,0 AS ScrapPercentage									/*Production - Scrap Percentage (tiipf051.scpf) (HYVA) | FALSE | 0 |  | |*/
	,0 AS ScrapQuantity										/*Production - Scrap Quantity (tiipf051.scpq) (HYVA) | FALSE | 0 |  | |*/
    , CASE 
        WHEN kps.Itemgroup = 'DPMTO1' THEN 2
        WHEN kps.SupplySource = 50 THEN 2
        WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 
        ELSE 2
    END AS Phantom												/*Production - Phantom (tiipf051.cpha) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(9)) AS ShopFloorPlanner			/*Production - Shop Floor Planner (tiipf051.sfpl) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2	-- was 1 
			WHEN 'COMAN2' THEN 2	-- was 1
			WHEN 'DPMTO1' THEN 2	
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 2	-- was 1
			WHEN 'GELTR2' THEN 2	-- was 1
			WHEN 'GESCO3' THEN 2	
			WHEN 'GESTD5' THEN 2	-- was 1
			WHEN 'GESTR4' THEN 2	-- was 1
			WHEN 'PHMAN2' THEN 2	-- was 1
			WHEN 'PHSAL1' THEN 2	-- was 1
			WHEN 'PI9999' THEN 2	 
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2	-- was 1
			ELSE 2
		END AS BackflushIfMaterial							/*Production - Allow Backflushing (tiipf051.bfcp) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 2	-- was 1
			WHEN 'GEKIT6' THEN 2	-- was 1
			WHEN 'GELCO1' THEN 2
			WHEN 'GELTR2' THEN 2
			WHEN 'GESCO3' THEN 2
			WHEN 'GESTD5' THEN 2
			WHEN 'GESTR4' THEN 2
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS BackflushMaterials								/*Production - Backflush Materials (tiipf051.bfep) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS BackflushHours									/*Production - Backflush Hours (tiipd051.bfhr)  (Will set "Use Global Item" to no when value <> 99)	| FALSE |Byte| |1;"Yes";2;"No";99;"Inherit from Item (defaults)" */
	,CASE 
		WHEN kps.Itemgroup = 'DPMTO1' THEN 1
		WHEN kps.SupplySource = 50 THEN 1
		WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 2 
		ELSE 1
	 END AS DirectInitiateInventoryIssue						/*Production - Direct Initiate Inventory Issue (tiipf051.drin) (HYVA) | FALSE | null |  | 1;"Yes";2;"No (default)"|*/
	,2 AS DirectProcessWHOrderLine							/*Production - Direct Process Warehouse Order Line (tiipd051.dris) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/

	/* SERVICE */

	,CAST(NULL AS VARCHAR(9)) AS ServiceDepartment			/*Service Operations Department (tsmdm220.mdpt) - Reference to tdmdm100 Service Departments | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/

	/* WAREHOUSE */

	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ItemValuationGroup			/*Warehousing - Item Valuation Group (whwmd404.ivgr)   - Reference to whina101 Item Valuation Groups (HYVA) | FALSE | null | 6 | |*/
	,1 AS LocationControlled								/*Warehousing - Location Controlled (whwmd404.locc) (HYVA) | FALSE | 0 |  | 1;"Yes";2;"No"|*/
	,1 AS ProcessInvVariances								/*Warehousing - Process Inventory Variances Automatically (whwmd404.prva) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,20 AS UseOrderingData									/*Warehousing - Use Item Ordering Data by Site (whwmd404.uidt) (HYVA) | FALSE | 10 |  | 10;"Yes";20;"No";30;"Apply Warehouse Default"|*/
	,60 AS DefaultSupplySystem								/*Warehousing - Default Supply System (whwmd404.dwhs) (HYVA) | FALSE | 70 |  | 10;"Time-Phased Order Point";20;"KANBAN";30;"Order Controlled/Batch";40;"Order Controlled/SILS";50;"Order Controlled/Single";60;"Apply Warehouse Defaults";70;"None (default)"|*/
	,2 AS GenerateOrderAdvices								/*Warehousing - Generate Order Advices (whwmd404.goad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS CombineOrderAdvices								/*Warehousing - Combine Order Advices (whwmd404.coad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS ConfirmOrderAdvices								/*Warehousing - Automatically Confirm Order Advices (whwmd404.acoa) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,CAST(null AS VARCHAR(1)) AS ABCcode					/*Warehousing - ABC Code (whwmd404.abcc) (HYVA) | FALSE | null | 1 | |*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS HandlingUnitInUse								/*Warehousing - Handling Units in Use(whwmd404.uhnd) (HYVA) |  | 2 |  | 1;"Yes";2;"No"|*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND (kps.POV1 <> 0))
	JOIN 
		(
			select
				distinct 
				 t1.Subcontractor
				,t1.Item
			from
				(
			select
				distinct  
					 t1.Subcontractor as Subcontractor
					,t1.ProductItem as Item
			from
				(
			SELECT
				 'PROJEMPTY' AS ProductProject												/*Project segment of Product (tisub100/110.item) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                   Infor LN tables: tisub100, tisub110 | TRUE | "PROJEMPTY" |Text | 9 | |*/
				,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tisub100/110.item) - References to tcibd001 Item General Data | TRUE | '' |Text | 38 | |*/	
				,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN null ELSE bps.[Business Partner] END AS VARCHAR(9)) AS Subcontractor														/*Subcontractor (tisub100/110.subc) - Reference tccom120 Buy-from Business Partners | TRUE | '' |Text | 9 | |*/
				,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN null ELSE bps.[Business Partner] END AS VARCHAR(9)) AS ShipFromBP  	/*Ship-from Business Partner (tisub100/110.sfbp) - Reference tccom121 Ship-from Business Partners ** At least fill with same value as Subcontractor | TRUE | '' |Text | 9 | |*/
				,'IT.POV.01' AS Site														/*Site (tisub100/110.site) - References to tcemm050 Sites | FALSE | '' |Text | 9 | |*/
				,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))* 10 AS Position																/*Position (tisub110.pono) | TRUE | 1 |Long Integer |  | |*/
				,20 AS Status																/*Subcontracting Model Status (tisub100.psta) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |Byte |  | 10;"New";20;"Approved";30;"Expired"|*/
				,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tisub100.efdt) | TRUE | null |Date/Time |  | |*/
				,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tisub100.exdt)  - When empty, date will be set to MAX | TRUE | null |Date/Time |  | |*/
				,CAST(bps.POV1 AS VARCHAR(6)) AS SubcontractorWarehouse						/*Subcontractor Warehouse (tisub100.cwar) - References tcmcs003 Warehouses | FALSE | '' |Text | 6 | |*/
				,1 AS BomQuantity															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,2 AS UseForCosting															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,2 AS UseForPlanning														/*Use for Planning (tisub100.crip) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,'PROJEMPTY' AS MaterialProject												/*Project segment of Material (tisub110.sitm) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | FALSE | "PROJEMPTY" |Text | 9 | |*/
				,CAST(kpc.ItemLnCE AS VARCHAR(38))  AS MaterialItem							/*Item segment of Sub Item (tisub110.sitm) - References to tcibd001 General Item Data | FALSE | '' |Text | 38 | |*/
				,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
					CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
						ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
						END		
					END AS FLOAT) AS  MaterialQuantity										/*Material Quantity (tisub110.qana) - Material Quantity | TRUE | 1 |Decimal |  | >0|*/
				,0 AS ScrapPercentage														/*Scrap Percentage (tisub110.scpf) |  | 0 |Decimal |  | |*/
				,CAST(sms.Warehouse AS VARCHAR(6)) AS  SupplyingWarehouse					/*Supplying Warehouse (tisub110.cwar)  - References tcmcs003 Warehouses |  | '' |Text | 6 | |*/
			---	,cast(scc.SupplySystem as float) as SupplySystem

			FROM
				KPRAKTOR.SIAPR.DISBASE bom
				JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)	
				JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1)
				Left join ZZZ_Italy.dbo.SubContractorSupplier scs on (kps.ItemLnCE = scs.Item and scs.Type = 'Product')
				LEFT JOIN ZZZ_Italy.dbo.BP_Conv bps ON (scs.Subcontractor = bps.KPraktor)
				JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)	
				JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kpc.Class NOT IN (4))
				LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
				Left join ZZZ_Italy.dbo.SubContractorSupplier scc on (kpc.ItemLnCE = scc.Item and scc.Type = 'Material')
				LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (scc.[Supplying BP] = bpc.KPraktor)
				LEFT JOIN ZZZ_Italy.dbo.SCModelMap sms ON (kps.POV1 = sms.POV1 AND sms.Site = 'IT.POV.01')
			---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F tac ON (itm.MG_DITTA = tac.TED_DITTA AND itm.MG_ESPL_DB = tac.TED_ESPL_DB)
			---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F taf ON (its.MG_DITTA = taf.TED_DITTA AND its.MG_ESPL_DB = taf.TED_ESPL_DB)
			WHERE
				bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
				AND kps.SupplySource IN ('50')
				AND (kps.POV1 <> 0)
			) t1

			UNION ALL

			select
				distinct  
					 t1.Subcontractor as Subcontractor
					,t1.MaterialItem as Item
			from
				(
			SELECT
				 'PROJEMPTY' AS ProductProject												/*Project segment of Product (tisub100/110.item) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                   Infor LN tables: tisub100, tisub110 | TRUE | "PROJEMPTY" |Text | 9 | |*/
				,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tisub100/110.item) - References to tcibd001 Item General Data | TRUE | '' |Text | 38 | |*/	
				,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN null ELSE bps.[Business Partner] END AS VARCHAR(9)) AS Subcontractor														/*Subcontractor (tisub100/110.subc) - Reference tccom120 Buy-from Business Partners | TRUE | '' |Text | 9 | |*/
				,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN null ELSE bps.[Business Partner] END AS VARCHAR(9)) AS ShipFromBP  	/*Ship-from Business Partner (tisub100/110.sfbp) - Reference tccom121 Ship-from Business Partners ** At least fill with same value as Subcontractor | TRUE | '' |Text | 9 | |*/
				,'IT.POV.01' AS Site														/*Site (tisub100/110.site) - References to tcemm050 Sites | FALSE | '' |Text | 9 | |*/
				,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))* 10 AS Position																/*Position (tisub110.pono) | TRUE | 1 |Long Integer |  | |*/
				,20 AS Status																/*Subcontracting Model Status (tisub100.psta) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |Byte |  | 10;"New";20;"Approved";30;"Expired"|*/
				,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tisub100.efdt) | TRUE | null |Date/Time |  | |*/
				,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tisub100.exdt)  - When empty, date will be set to MAX | TRUE | null |Date/Time |  | |*/
				,CAST(bps.POV1 AS VARCHAR(6)) AS SubcontractorWarehouse						/*Subcontractor Warehouse (tisub100.cwar) - References tcmcs003 Warehouses | FALSE | '' |Text | 6 | |*/
				,1 AS BomQuantity															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,2 AS UseForCosting															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,2 AS UseForPlanning														/*Use for Planning (tisub100.crip) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,'PROJEMPTY' AS MaterialProject												/*Project segment of Material (tisub110.sitm) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | FALSE | "PROJEMPTY" |Text | 9 | |*/
				,CAST(kpc.ItemLnCE AS VARCHAR(38))  AS MaterialItem							/*Item segment of Sub Item (tisub110.sitm) - References to tcibd001 General Item Data | FALSE | '' |Text | 38 | |*/
				,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
					CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
						ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
						END		
					END AS FLOAT) AS  MaterialQuantity										/*Material Quantity (tisub110.qana) - Material Quantity | TRUE | 1 |Decimal |  | >0|*/
				,0 AS ScrapPercentage														/*Scrap Percentage (tisub110.scpf) |  | 0 |Decimal |  | |*/
				,CAST(sms.Warehouse AS VARCHAR(6)) AS  SupplyingWarehouse					/*Supplying Warehouse (tisub110.cwar)  - References tcmcs003 Warehouses |  | '' |Text | 6 | |*/
			---	,cast(scc.SupplySystem as float) as SupplySystem

			FROM
				KPRAKTOR.SIAPR.DISBASE bom
				JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)	
				JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1)
				Left join ZZZ_Italy.dbo.SubContractorSupplier scs on (kps.ItemLnCE = scs.Item and scs.Type = 'Product')
				LEFT JOIN ZZZ_Italy.dbo.BP_Conv bps ON (scs.Subcontractor = bps.KPraktor)
				JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)	
				JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kpc.Class NOT IN (4))
				LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
				Left join ZZZ_Italy.dbo.SubContractorSupplier scc on (kpc.ItemLnCE = scc.Item and scc.Type = 'Material')
				LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (scc.[Supplying BP] = bpc.KPraktor)
				LEFT JOIN ZZZ_Italy.dbo.SCModelMap sms ON (kps.POV1 = sms.POV1 AND sms.Site = 'IT.POV.01')
			---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F tac ON (itm.MG_DITTA = tac.TED_DITTA AND itm.MG_ESPL_DB = tac.TED_ESPL_DB)
			---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F taf ON (its.MG_DITTA = taf.TED_DITTA AND its.MG_ESPL_DB = taf.TED_ESPL_DB)
			WHERE
				bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
				AND kps.SupplySource IN ('50')
				AND (kps.POV1 <> 0)
			) t1
			) t1
	)scs on (kps.ItemLnCE = scs.Item)
---	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpa on (scs.Subcontractor = bpa.[Business Partner])
	JOIN ZZZ_Italy.dbo.SCModelMap scm ON (scs. Subcontractor = scm.BusinessPartner and scm.Site = 'IT.EXT.01')
	LEFT JOIN KPRAKTOR.SIAPR.ANAGES pla ON (itm.MG_CODICE = pla.GE_CODICE_ART AND itm.MG_DITTA = pla.GE_DITTA)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (itm.MG_CODFOR_PREF = bpc.KPraktor AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pup ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND  pup.Subcontract = 0)
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pus ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND   pup.Subcontract = 1)
	LEFT JOIN ZZZ_Italy.dbo.SelectionCode sec ON (itm.MG_TIP_REC = sec.Code AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.StatisticsGroep_Conv stc ON (itm.MG_TIP_REC = stc.ProductType AND itm.MG_DITTA = 1)
	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] mab ON ( mab.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] map ON ( map.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
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
		)bol ON (kps.Item = bol.item)

UNION ALL

/* SITE IT.EXT.03 */

SELECT
	 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
	,CAST('IT.EXT.03' AS VARCHAR(9)) AS Site				/*Site (site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	/* GENERAL */

	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2
	 END AS ItemOrdering									/*Item Ordering by Site (tcibd250) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 1 
			ELSE 2
		END AS ItemSales									/*Item Sales by Site (tdisa081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2 
		END AS ItemPurchase									/*Item Purchase by Site (tdipu081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 2
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 2
			WHEN 'GELTR2' THEN 2
			WHEN 'GESCO3' THEN 2
			WHEN 'GESTD5' THEN 2
			WHEN 'GESTR4' THEN 2
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2  
			ELSE 2
		 END AS ItemProduction									/*Item Production by Site (tiipd051) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 2 
			ELSE 2 
		 END AS ItemService										/*Item Service by Site (tsmdm220) | TRUE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1
			ELSE 2 
		END AS ItemWarehousing									/*Item Warehousing by Site (whwmd404) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	/* Belinda list */
	,cast(40 as float) AS SupplySource							/*General - Default Supply Source (srce) ** Item type Product and Generic, use 20, 40, 50 or 60. Other item types, use 10 | FALSE | 10 |  | 10;"Not Applicable (default)";20;"Job Shop";40;"Purchase";50;"Subcontract";60;"Distribution"|*/
	,CAST(NULL AS VARCHAR(9)) AS ProductGroup	/*General - Product Group - Reference to tcmcs025 Product Groups (HYVA) | FALSE | null | 9 | |*/
	,CAST(CASE itm.MG_FLAG_FUORI_PROD
		WHEN 'M' THEN '180'
		WHEN 'N' THEN '' ---'000'
		WHEN 'O' THEN '016'
		WHEN 'P' THEN '170'
		WHEN 'Q' THEN '170'
		WHEN 'S' THEN '005'
		WHEN 'V' THEN '' ---'000'
		ELSE ''
		END AS VARCHAR(3)) AS ItemSignal						/*General - Item Signal (tcibd150.csig)   - Reference to  tcmcs018 Item Signals (HYVA) | FALSE | null | 3 | |*/
	,CAST(kps.CountryOrigin AS VARCHAR(3)) AS CountryOrigin		/*General - Country of Origin (tcibd150.ctyo)   - Reference to  tcmcs010 Countries (HYVA) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(25)) AS HSCode						/*General - Harmonized System Code (tcibd150.ccde)   - Reference to tcmcs028 Harmonized System Codes (HYVA) | FALSE | null | 25 | |*/

	/* ORDERING */

	,CAST(NULL AS VARCHAR(200)) AS ItemGeneralText								/*General - Item Text (tttxt010.ctxt)	FALSE | | | | */
	,0 AS TextIDGeneral											/*General - Text ID (tcibd150.txta)	FALSE |Long Integer| | */
	/*---- replaced 2024/02/14 by JVD ----*/
	,CAST(scm.Warehouse AS VARCHAR(6)) AS OrderingWarehouse 	/*Ordering - Warehouse (tcibd250.cwar) - Reference to tcmcs003 Warehouses ** Mandatory for item ordering by Site | FALSE | null | 6 | |*/
	,1 AS OrderMethod											/*Ordering - Order Method (tcibd250.omth) (HYVA) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,10 AS OrderingTimeUnit										/*Ordering - Time Unit for OrderInterval, SafetyTime (tcibd250.oivu, tcibd250.tuni) (Will set "Use Global Item" to no when value <> 99)	| FALSE	| Byte |5;Hours;10;Days;99;"Inherit from Item (defaults)" | */
	,CAST(1 AS FLOAT) AS OrderInterval										/*Ordering - Order Interval  (tcibd250.oint) (HYVA) | FALSE | 0 |  | |*/
	,CAST(0 AS FLOAT) AS SafetyStock							/*Ordering - Safety Stock (tcibd250.sfst)  (HYVA) | FALSE | 0 |  | |*/
	/* Belinda List */
	,CAST(5 AS FLOAT) AS SafetyTime								/*Ordering - Safety Time (tcibd250.sftm) (HYVA) | FALSE | 0 |  | |*/
	/* Belinda List */
	,CAST(1 as float) AS OrderQuantityIncrement
	/* Belinda List */										/*Ordering - Order Quantity Increment (tcibd250.oqmf) (HYVA) | FALSE | 1 |  | |*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity			
	/* Belinda List */															/*Ordering - Minimum Order Quantity (tcibd250.mioq) (HYVA) | FALSE | 0 |  | |*/
	,CAST(99999999.99 AS FLOAT) AS MaximumOrderQuantity
	/* Belinda List */															/*Ordering - Maximum Order Quantity (tcibd250.maoq) (HYVA) | FALSE | 99999999.99 |  | <100000000|*/
	,1 AS FixedOrderQuantity									/*Ordering - Fixed Order Quantity (tcibd250.fioq) (HYVA) | FALSE | 1 |  | |*/
	/* Belinda List */
	,CAST(1 as float) AS EconomicOrderQuantity
																/*Ordering - Economic Order Quantity (tcibd250.ecoq) (HYVA) | FALSE | 1 |  | |*/
	,0 AS ReorderPoint											/*Ordering - Reorder Point (tcibd250.reop) (HYVA) | FALSE | 0 |  | |*/
	, map.LN_Employee_Planner	 AS Planner						/*Ordering - Planner (tcibd250.cplb) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
	,2 AS LotSizeCalculationAllowed								/*Ordering - Lot Size Calculation Allowed (tcibd250.auso)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/

	/* SALES */

	,CAST(scm.Warehouse AS VARCHAR(6)) AS  SalesWarehouse	/*Sales Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	
	/* PURCHASE */

	,CASE WHEN pup.Currency IS NULL THEN 'EUR' ELSE pup.Currency END AS PurchaseCurrency								/*Purchase Currency (tdipu081.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	/* Belinda List */
	,CAST (0 AS FLOAT) AS PurchasePrice								/*Purchase Price (tdipu081.prip) | FALSE | 0 |  | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchaseUnit	/*Purchase Unit (tdipu081.cuqp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchasePriceUnit	/*Purchase Price Unit (tdipu081.cupp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR (6)) AS SitePurchaseOffice		/*Purchase - Site Purchase Office (tdipu081.cofc) - Reference to tdpur012 Purchase Offices | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'P10.10'
			WHEN 'COMAN2' THEN 'P10.10'
			WHEN 'DPMTO1' THEN 'P10.10'
			WHEN 'GEKIT6' THEN 'P10.10'
			WHEN 'GELCO1' THEN 'P10.10'
			WHEN 'GELTR2' THEN 'P10.10'
			WHEN 'GESCO3' THEN 'P10.10'
			WHEN 'GESTD5' THEN 'P10.10'
			WHEN 'GESTR4' THEN 'P10.10'
			WHEN 'PHMAN2' THEN 'P10.10'
			WHEN 'PHSAL1' THEN 'P10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'P90.10'
			WHEN 'TOGEN1' THEN 'P20.30'
			WHEN 'COFLS4' THEN 'P10.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS PurchasePriceGroup				 /*Purchase Price Group (cpgp)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST
		(CASE 
			WHEN stc.StatisticsGroup IS NULL THEN  '------' ELSE stc.StatisticsGroup
		END
			AS VARCHAR(6)
		) AS PurchaseStatisticsGroup								/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	,CAST(scm.Warehouse AS VARCHAR(6)) AS  PurchaseWarehouse									/*Purchase Warehouse (tdipu081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS PurchaseBuyFromBP					/*Purchase Buy-from Business Partner (tdipu081.otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | |*/
	, mab.LN_Employee_Buyer AS Buyer
	,CAST (null  AS FLOAT) AS SubcontractingPrice
	,0 AS OperationSubcPrice								/*Purchase - Operation Subcontracting Purchase Price (tdipu081.scpr) (HYVA) | FALSE | 0 |  | |*/
	,2 AS PurchaseScheduleInUse								/*Purchase Schedule in Use (tdipu081.scus) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS PurchaseScheduleType								/*Purchase Schedule Type (tdiu081.styp) (HYVA) | FALSE | 1 |  | 1;"Not Applicable (default)";2;"Pull Schedule";3;"Push Schedule"|*/
	,1 AS VendorRating 										/*VendorRating (tdipu081.vryn) | FALSE | 1 |  |  |1;"Yes";2;"No"; ;99 (default);"Inherit from Item (defaults) |*/
	/* Belinda List */
	,CAST(0 as float) AS SupplyTime									/*Purchase - Supply Time (tdipu081.suti) | FALSE | 0 |  | |*/
	,CASE kps.ItemGroup
		WHEN 'CI0001' THEN 2
		ELSE 1
		END AS ReleaseToWarehousing							/*Purchase - Release to Warehousing (tdipu081.retw)  (HYVA) ** NOTE: Only applicable for cost items. For other items types, this field will always be set to yes. | FALSE | 1 |  | 1;"Yes";2;"No"|*/
	,2 AS Inspection										/*Purchase - Inspection (tdipu081.qual) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	/* Belinda List */
	,CAST(null as SMALLDATETIME ) AS LatestPurchasePriceDate /*Purchase - LatestPurchasePriceDate (tdipu180.ltpp) | FALSE | null |  Date/Time | | |*/
	,0 AS  AveragePurchasePrice 							/* Will create record when date is populated */
	/* Belinda List */
	,CAST(null as float) AS LatestPurchasePrice						/* Purchase - LatestPurchasePrice  |FALSE  |  |Decimal |  | |*/
    ,CAST(NULL AS VARCHAR(200)) AS ItemPurchaseText								/*Purchase - Item Text (tttxt010.ctxt)	FALSE |  Memo | | | */
	,0 AS TextIDPurchase									/*Purchase - Text ID  (tdipu081.txtp)	FALSE | Long Integer | | | */

	/* PRODUCTION */

	,2 AS ReceiptInspection									/*Production - Receipt Inspection(tiipd051.iimf) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS OutboundInspection								/*Production - Outbound Inspection (tiipd051.iima) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS CriticalForInventory								/*Production - Critical for Inventory (tiipf051.cick)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,0 AS ScrapPercentage									/*Production - Scrap Percentage (tiipf051.scpf) (HYVA) | FALSE | 0 |  | |*/
	,0 AS ScrapQuantity										/*Production - Scrap Quantity (tiipf051.scpq) (HYVA) | FALSE | 0 |  | |*/
    , CASE 
        WHEN kps.Itemgroup = 'DPMTO1' THEN 2
        WHEN kps.SupplySource = 50 THEN 2
        WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 
        ELSE 2
    END AS Phantom												/*Production - Phantom (tiipf051.cpha) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(9)) AS ShopFloorPlanner			/*Production - Shop Floor Planner (tiipf051.sfpl) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2	-- was 1 
			WHEN 'COMAN2' THEN 2	-- was 1
			WHEN 'DPMTO1' THEN 2	
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 2	-- was 1
			WHEN 'GELTR2' THEN 2	-- was 1
			WHEN 'GESCO3' THEN 2	
			WHEN 'GESTD5' THEN 2	-- was 1
			WHEN 'GESTR4' THEN 2	-- was 1
			WHEN 'PHMAN2' THEN 2	-- was 1
			WHEN 'PHSAL1' THEN 2	-- was 1
			WHEN 'PI9999' THEN 2	 
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2	-- was 1
			ELSE 2
		END AS BackflushIfMaterial							/*Production - Allow Backflushing (tiipf051.bfcp) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 2	-- was 1
			WHEN 'GEKIT6' THEN 2	-- was 1
			WHEN 'GELCO1' THEN 2
			WHEN 'GELTR2' THEN 2
			WHEN 'GESCO3' THEN 2
			WHEN 'GESTD5' THEN 2
			WHEN 'GESTR4' THEN 2
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS BackflushMaterials								/*Production - Backflush Materials (tiipf051.bfep) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS BackflushHours									/*Production - Backflush Hours (tiipd051.bfhr)  (Will set "Use Global Item" to no when value <> 99)	| FALSE |Byte| |1;"Yes";2;"No";99;"Inherit from Item (defaults)" */
	,CASE 
		WHEN kps.Itemgroup = 'DPMTO1' THEN 1
		WHEN kps.SupplySource = 50 THEN 1
		WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 2 
		ELSE 1
	 END AS DirectInitiateInventoryIssue						/*Production - Direct Initiate Inventory Issue (tiipf051.drin) (HYVA) | FALSE | null |  | 1;"Yes";2;"No (default)"|*/
	,2 AS DirectProcessWHOrderLine							/*Production - Direct Process Warehouse Order Line (tiipd051.dris) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/

	/* SERVICE */

	,CAST(NULL AS VARCHAR(9)) AS ServiceDepartment			/*Service Operations Department (tsmdm220.mdpt) - Reference to tdmdm100 Service Departments | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/

	/* WAREHOUSE */

	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ItemValuationGroup			/*Warehousing - Item Valuation Group (whwmd404.ivgr)   - Reference to whina101 Item Valuation Groups (HYVA) | FALSE | null | 6 | |*/
	,1 AS LocationControlled								/*Warehousing - Location Controlled (whwmd404.locc) (HYVA) | FALSE | 0 |  | 1;"Yes";2;"No"|*/
	,1 AS ProcessInvVariances								/*Warehousing - Process Inventory Variances Automatically (whwmd404.prva) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,20 AS UseOrderingData									/*Warehousing - Use Item Ordering Data by Site (whwmd404.uidt) (HYVA) | FALSE | 10 |  | 10;"Yes";20;"No";30;"Apply Warehouse Default"|*/
	,60 AS DefaultSupplySystem								/*Warehousing - Default Supply System (whwmd404.dwhs) (HYVA) | FALSE | 70 |  | 10;"Time-Phased Order Point";20;"KANBAN";30;"Order Controlled/Batch";40;"Order Controlled/SILS";50;"Order Controlled/Single";60;"Apply Warehouse Defaults";70;"None (default)"|*/
	,2 AS GenerateOrderAdvices								/*Warehousing - Generate Order Advices (whwmd404.goad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS CombineOrderAdvices								/*Warehousing - Combine Order Advices (whwmd404.coad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS ConfirmOrderAdvices								/*Warehousing - Automatically Confirm Order Advices (whwmd404.acoa) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,CAST(null AS VARCHAR(1)) AS ABCcode					/*Warehousing - ABC Code (whwmd404.abcc) (HYVA) | FALSE | null | 1 | |*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS HandlingUnitInUse								/*Warehousing - Handling Units in Use(whwmd404.uhnd) (HYVA) |  | 2 |  | 1;"Yes";2;"No"|*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND (kps.POV3 <> 0))
	JOIN 
		(
			select
				distinct 
				 t1.Subcontractor
				,t1.Item
			from
				(
			select
				distinct  
					 t1.Subcontractor as Subcontractor
					,t1.ProductItem as Item
			from
				(
					SELECT
						 'PROJEMPTY' AS ProductProject												/*Project segment of Product (tisub100/110.item) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                   Infor LN tables: tisub100, tisub110 | TRUE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tisub100/110.item) - References to tcibd001 Item General Data | TRUE | '' |Text | 38 | |*/	
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN '' ELSE bps.[Business Partner] END AS VARCHAR(9)) AS Subcontractor														/*Subcontractor (tisub100/110.subc) - Reference tccom120 Buy-from Business Partners | TRUE | '' |Text | 9 | |*/
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN '' ELSE bps.[Business Partner] END AS VARCHAR(9)) AS ShipFromBP  	/*Ship-from Business Partner (tisub100/110.sfbp) - Reference tccom121 Ship-from Business Partners ** At least fill with same value as Subcontractor | TRUE | '' |Text | 9 | |*/
						,'IT.POV.03' AS Site														/*Site (tisub100/110.site) - References to tcemm050 Sites | FALSE | '' |Text | 9 | |*/
						,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))* 10 AS Position																/*Position (tisub110.pono) | TRUE | 1 |Long Integer |  | |*/
						,20 AS Status																/*Subcontracting Model Status (tisub100.psta) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |Byte |  | 10;"New";20;"Approved";30;"Expired"|*/
						,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tisub100.efdt) | TRUE | null |Date/Time |  | |*/
						,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tisub100.exdt)  - When empty, date will be set to MAX | TRUE | null |Date/Time |  | |*/
						,CAST(bps.POV3 AS VARCHAR(6)) AS SubcontractorWarehouse						/*Subcontractor Warehouse (tisub100.cwar) - References tcmcs003 Warehouses | FALSE | '' |Text | 6 | |*/
						,1 AS BomQuantity															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,2 AS UseForCosting															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,2 AS UseForPlanning														/*Use for Planning (tisub100.crip) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,'PROJEMPTY' AS MaterialProject												/*Project segment of Material (tisub110.sitm) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | FALSE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(kpc.ItemLnCE AS VARCHAR(38))  AS MaterialItem							/*Item segment of Sub Item (tisub110.sitm) - References to tcibd001 General Item Data | FALSE | '' |Text | 38 | |*/
						,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
							CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
								ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
								END		
							END AS FLOAT) AS  MaterialQuantity										/*Material Quantity (tisub110.qana) - Material Quantity | TRUE | 1 |Decimal |  | >0|*/
						,0 AS ScrapPercentage														/*Scrap Percentage (tisub110.scpf) |  | 0 |Decimal |  | |*/
						,CAST(sms.Warehouse AS VARCHAR(6)) AS  SupplyingWarehouse					/*Supplying Warehouse (tisub110.cwar)  - References tcmcs003 Warehouses |  | '' |Text | 6 | |*/
					---	,cast(scc.SupplySystem as float) as SupplySystem

					FROM
						KPRAKTOR.SIAPR.DISBASE bom
						JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)	
						JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1)
						JOIN ZZZ_Italy.dbo.KPSourceSP kpp ON (kps.Item = kpp.Item)
						Left join ZZZ_Italy.dbo.SubContractorSupplier scs on (kps.ItemLnCE = scs.Item and scs.Type = 'Product')
						LEFT JOIN ZZZ_Italy.dbo.BP_Conv bps ON (scs.Subcontractor = bps.KPraktor)
						JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)	
						JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kpc.Class NOT IN (4))
						LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
						Left join ZZZ_Italy.dbo.SubContractorSupplier scc on (kpc.ItemLnCE = scc.Item and scc.Type = 'Material')
						LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (scc.[Supplying BP] = bpc.KPraktor)
						LEFT JOIN ZZZ_Italy.dbo.SCModelMap sms ON (kps.POV3 = sms.POV3 AND sms.Site = 'IT.POV.03')
					---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F tac ON (itm.MG_DITTA = tac.TED_DITTA AND itm.MG_ESPL_DB = tac.TED_ESPL_DB)
					---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F taf ON (its.MG_DITTA = taf.TED_DITTA AND its.MG_ESPL_DB = taf.TED_ESPL_DB)
					WHERE
						bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
						AND kpp.SupplySource IN ('50')
						AND (kps.POV3 <> 0)
			) t1

			UNION ALL

			select
				distinct  
					 t1.Subcontractor as Subcontractor
					,t1.MaterialItem as Item
			from
				(
					SELECT
						 'PROJEMPTY' AS ProductProject												/*Project segment of Product (tisub100/110.item) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                   Infor LN tables: tisub100, tisub110 | TRUE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tisub100/110.item) - References to tcibd001 Item General Data | TRUE | '' |Text | 38 | |*/	
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN '' ELSE bps.[Business Partner] END AS VARCHAR(9)) AS Subcontractor														/*Subcontractor (tisub100/110.subc) - Reference tccom120 Buy-from Business Partners | TRUE | '' |Text | 9 | |*/
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN '' ELSE bps.[Business Partner] END AS VARCHAR(9)) AS ShipFromBP  	/*Ship-from Business Partner (tisub100/110.sfbp) - Reference tccom121 Ship-from Business Partners ** At least fill with same value as Subcontractor | TRUE | '' |Text | 9 | |*/
						,'IT.POV.03' AS Site														/*Site (tisub100/110.site) - References to tcemm050 Sites | FALSE | '' |Text | 9 | |*/
						,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))* 10 AS Position																/*Position (tisub110.pono) | TRUE | 1 |Long Integer |  | |*/
						,20 AS Status																/*Subcontracting Model Status (tisub100.psta) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |Byte |  | 10;"New";20;"Approved";30;"Expired"|*/
						,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tisub100.efdt) | TRUE | null |Date/Time |  | |*/
						,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tisub100.exdt)  - When empty, date will be set to MAX | TRUE | null |Date/Time |  | |*/
						,CAST(bps.POV3 AS VARCHAR(6)) AS SubcontractorWarehouse						/*Subcontractor Warehouse (tisub100.cwar) - References tcmcs003 Warehouses | FALSE | '' |Text | 6 | |*/
						,1 AS BomQuantity															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,2 AS UseForCosting															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,2 AS UseForPlanning														/*Use for Planning (tisub100.crip) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,'PROJEMPTY' AS MaterialProject												/*Project segment of Material (tisub110.sitm) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | FALSE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(kpc.ItemLnCE AS VARCHAR(38))  AS MaterialItem							/*Item segment of Sub Item (tisub110.sitm) - References to tcibd001 General Item Data | FALSE | '' |Text | 38 | |*/
						,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
							CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
								ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
								END		
							END AS FLOAT) AS  MaterialQuantity										/*Material Quantity (tisub110.qana) - Material Quantity | TRUE | 1 |Decimal |  | >0|*/
						,0 AS ScrapPercentage														/*Scrap Percentage (tisub110.scpf) |  | 0 |Decimal |  | |*/
						,CAST(sms.Warehouse AS VARCHAR(6)) AS  SupplyingWarehouse					/*Supplying Warehouse (tisub110.cwar)  - References tcmcs003 Warehouses |  | '' |Text | 6 | |*/
					---	,cast(scc.SupplySystem as float) as SupplySystem

					FROM
						KPRAKTOR.SIAPR.DISBASE bom
						JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)	
						JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1)
						JOIN ZZZ_Italy.dbo.KPSourceSP kpp ON (kps.Item = kpp.Item)
						Left join ZZZ_Italy.dbo.SubContractorSupplier scs on (kps.ItemLnCE = scs.Item and scs.Type = 'Product')
						LEFT JOIN ZZZ_Italy.dbo.BP_Conv bps ON (scs.Subcontractor = bps.KPraktor)
						JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)	
						JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kpc.Class NOT IN (4))
						LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
						Left join ZZZ_Italy.dbo.SubContractorSupplier scc on (kpc.ItemLnCE = scc.Item and scc.Type = 'Material')
						LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (scc.[Supplying BP] = bpc.KPraktor)
						LEFT JOIN ZZZ_Italy.dbo.SCModelMap sms ON (kps.POV3 = sms.POV3 AND sms.Site = 'IT.POV.03')
					---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F tac ON (itm.MG_DITTA = tac.TED_DITTA AND itm.MG_ESPL_DB = tac.TED_ESPL_DB)
					---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F taf ON (its.MG_DITTA = taf.TED_DITTA AND its.MG_ESPL_DB = taf.TED_ESPL_DB)
					WHERE
						bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
						AND kpp.SupplySource IN ('50')
						AND (kps.POV3 <> 0)
			) t1
			) t1
	)scs on (kps.ItemLnCE = scs.Item)
---	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpa on (scs.Subcontractor = bpa.[Business Partner])
	JOIN ZZZ_Italy.dbo.SCModelMap scm ON (scs. Subcontractor = scm.BusinessPartner and scm.Site = 'IT.EXT.03')
	LEFT JOIN KPRAKTOR.SIAPR.ANAGES pla ON (itm.MG_CODICE = pla.GE_CODICE_ART AND itm.MG_DITTA = pla.GE_DITTA)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (itm.MG_CODFOR_PREF = bpc.KPraktor AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pup ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND pup.Subcontract = 0)
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pus ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND pup.Subcontract = 1)
	LEFT JOIN ZZZ_Italy.dbo.SelectionCode sec ON (itm.MG_TIP_REC = sec.Code AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.StatisticsGroep_Conv stc ON (itm.MG_TIP_REC = stc.ProductType AND itm.MG_DITTA = 1)
	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] mab ON ( mab.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] map ON ( map.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
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
		)bol ON (kps.Item = bol.item)

UNION ALL

/* SITE IT.EXT.05 */

SELECT
	 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
	,CAST('IT.EXT.05' AS VARCHAR(9)) AS Site				/*Site (site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	/* GENERAL */

	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2
	 END AS ItemOrdering									/*Item Ordering by Site (tcibd250) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 1 
			ELSE 2
		END AS ItemSales									/*Item Sales by Site (tdisa081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2 
		END AS ItemPurchase									/*Item Purchase by Site (tdipu081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 2
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 2
			WHEN 'GELTR2' THEN 2
			WHEN 'GESCO3' THEN 2
			WHEN 'GESTD5' THEN 2
			WHEN 'GESTR4' THEN 2
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2  
			ELSE 2
		 END AS ItemProduction									/*Item Production by Site (tiipd051) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 2 
			ELSE 2 
		 END AS ItemService										/*Item Service by Site (tsmdm220) | TRUE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1
			ELSE 2 
		END AS ItemWarehousing									/*Item Warehousing by Site (whwmd404) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	/* Belinda list */
	,cast(40 as float) AS SupplySource							/*General - Default Supply Source (srce) ** Item type Product and Generic, use 20, 40, 50 or 60. Other item types, use 10 | FALSE | 10 |  | 10;"Not Applicable (default)";20;"Job Shop";40;"Purchase";50;"Subcontract";60;"Distribution"|*/
	,CAST(NULL AS VARCHAR(9)) AS ProductGroup	/*General - Product Group - Reference to tcmcs025 Product Groups (HYVA) | FALSE | null | 9 | |*/
	,CAST(CASE itm.MG_FLAG_FUORI_PROD
		WHEN 'M' THEN '180'
		WHEN 'N' THEN '' ---'000'
		WHEN 'O' THEN '016'
		WHEN 'P' THEN '170'
		WHEN 'Q' THEN '170'
		WHEN 'S' THEN '005'
		WHEN 'V' THEN '' ---'000'
		ELSE ''
		END AS VARCHAR(3)) AS ItemSignal						/*General - Item Signal (tcibd150.csig)   - Reference to  tcmcs018 Item Signals (HYVA) | FALSE | null | 3 | |*/
	,CAST(kps.CountryOrigin AS VARCHAR(3)) AS CountryOrigin		/*General - Country of Origin (tcibd150.ctyo)   - Reference to  tcmcs010 Countries (HYVA) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(25)) AS HSCode						/*General - Harmonized System Code (tcibd150.ccde)   - Reference to tcmcs028 Harmonized System Codes (HYVA) | FALSE | null | 25 | |*/

	/* ORDERING */

	,CAST(NULL AS VARCHAR(200)) AS ItemGeneralText								/*General - Item Text (tttxt010.ctxt)	FALSE | | | | */
	,0 AS TextIDGeneral											/*General - Text ID (tcibd150.txta)	FALSE |Long Integer| | */
	/*---- replaced 2024/02/14 by JVD ----*/
	,CAST(scm.Warehouse AS VARCHAR(6)) AS OrderingWarehouse 	/*Ordering - Warehouse (tcibd250.cwar) - Reference to tcmcs003 Warehouses ** Mandatory for item ordering by Site | FALSE | null | 6 | |*/
	,1 AS OrderMethod											/*Ordering - Order Method (tcibd250.omth) (HYVA) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,10 AS OrderingTimeUnit										/*Ordering - Time Unit for OrderInterval, SafetyTime (tcibd250.oivu, tcibd250.tuni) (Will set "Use Global Item" to no when value <> 99)	| FALSE	| Byte |5;Hours;10;Days;99;"Inherit from Item (defaults)" | */
	,CAST(1 AS FLOAT) AS OrderInterval										/*Ordering - Order Interval  (tcibd250.oint) (HYVA) | FALSE | 0 |  | |*/
	,CAST(0 AS FLOAT) AS SafetyStock							/*Ordering - Safety Stock (tcibd250.sfst)  (HYVA) | FALSE | 0 |  | |*/
	/* Belinda List */
	,CAST(5 AS FLOAT) AS SafetyTime								/*Ordering - Safety Time (tcibd250.sftm) (HYVA) | FALSE | 0 |  | |*/
	/* Belinda List */
	,CAST(1 as float) AS OrderQuantityIncrement
	/* Belinda List */										/*Ordering - Order Quantity Increment (tcibd250.oqmf) (HYVA) | FALSE | 1 |  | |*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity			
	/* Belinda List */															/*Ordering - Minimum Order Quantity (tcibd250.mioq) (HYVA) | FALSE | 0 |  | |*/
	,CAST(99999999.99 AS FLOAT) AS MaximumOrderQuantity
	/* Belinda List */															/*Ordering - Maximum Order Quantity (tcibd250.maoq) (HYVA) | FALSE | 99999999.99 |  | <100000000|*/
	,1 AS FixedOrderQuantity									/*Ordering - Fixed Order Quantity (tcibd250.fioq) (HYVA) | FALSE | 1 |  | |*/
	/* Belinda List */
	,CAST(1 as float) AS EconomicOrderQuantity
																/*Ordering - Economic Order Quantity (tcibd250.ecoq) (HYVA) | FALSE | 1 |  | |*/
	,0 AS ReorderPoint											/*Ordering - Reorder Point (tcibd250.reop) (HYVA) | FALSE | 0 |  | |*/
	, map.LN_Employee_Planner	 AS Planner						/*Ordering - Planner (tcibd250.cplb) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
	,2 AS LotSizeCalculationAllowed								/*Ordering - Lot Size Calculation Allowed (tcibd250.auso)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/

	/* SALES */

	,CAST(scm.Warehouse AS VARCHAR(6)) AS  SalesWarehouse	/*Sales Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	
	/* PURCHASE */

	,CASE WHEN pup.Currency IS NULL THEN 'EUR' ELSE pup.Currency END AS PurchaseCurrency								/*Purchase Currency (tdipu081.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	/* Belinda List */
	,CAST (0 AS FLOAT) AS PurchasePrice								/*Purchase Price (tdipu081.prip) | FALSE | 0 |  | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchaseUnit	/*Purchase Unit (tdipu081.cuqp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchasePriceUnit	/*Purchase Price Unit (tdipu081.cupp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR (6)) AS SitePurchaseOffice		/*Purchase - Site Purchase Office (tdipu081.cofc) - Reference to tdpur012 Purchase Offices | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'P10.10'
			WHEN 'COMAN2' THEN 'P10.10'
			WHEN 'DPMTO1' THEN 'P10.10'
			WHEN 'GEKIT6' THEN 'P10.10'
			WHEN 'GELCO1' THEN 'P10.10'
			WHEN 'GELTR2' THEN 'P10.10'
			WHEN 'GESCO3' THEN 'P10.10'
			WHEN 'GESTD5' THEN 'P10.10'
			WHEN 'GESTR4' THEN 'P10.10'
			WHEN 'PHMAN2' THEN 'P10.10'
			WHEN 'PHSAL1' THEN 'P10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'P90.10'
			WHEN 'TOGEN1' THEN 'P20.30'
			WHEN 'COFLS4' THEN 'P10.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS PurchasePriceGroup				 /*Purchase Price Group (cpgp)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST
		(CASE 
			WHEN stc.StatisticsGroup IS NULL THEN  '------' ELSE stc.StatisticsGroup
		END
			AS VARCHAR(6)
		) AS PurchaseStatisticsGroup								/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	,CAST(scm.Warehouse AS VARCHAR(6)) AS  PurchaseWarehouse									/*Purchase Warehouse (tdipu081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS PurchaseBuyFromBP					/*Purchase Buy-from Business Partner (tdipu081.otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | |*/
	, mab.LN_Employee_Buyer AS Buyer
	,CAST (null  AS FLOAT) AS SubcontractingPrice
	,0 AS OperationSubcPrice								/*Purchase - Operation Subcontracting Purchase Price (tdipu081.scpr) (HYVA) | FALSE | 0 |  | |*/
	,2 AS PurchaseScheduleInUse								/*Purchase Schedule in Use (tdipu081.scus) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS PurchaseScheduleType								/*Purchase Schedule Type (tdiu081.styp) (HYVA) | FALSE | 1 |  | 1;"Not Applicable (default)";2;"Pull Schedule";3;"Push Schedule"|*/
	,1 AS VendorRating 										/*VendorRating (tdipu081.vryn) | FALSE | 1 |  |  |1;"Yes";2;"No"; ;99 (default);"Inherit from Item (defaults) |*/
	/* Belinda List */
	,CAST(0 as float) AS SupplyTime									/*Purchase - Supply Time (tdipu081.suti) | FALSE | 0 |  | |*/
	,CASE kps.ItemGroup
		WHEN 'CI0001' THEN 2
		ELSE 1
		END AS ReleaseToWarehousing							/*Purchase - Release to Warehousing (tdipu081.retw)  (HYVA) ** NOTE: Only applicable for cost items. For other items types, this field will always be set to yes. | FALSE | 1 |  | 1;"Yes";2;"No"|*/
	,2 AS Inspection										/*Purchase - Inspection (tdipu081.qual) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	/* Belinda List */
	,CAST(null as SMALLDATETIME ) AS LatestPurchasePriceDate /*Purchase - LatestPurchasePriceDate (tdipu180.ltpp) | FALSE | null |  Date/Time | | |*/
	,0 AS  AveragePurchasePrice 							/* Will create record when date is populated */
	/* Belinda List */
	,CAST(null as float) AS LatestPurchasePrice						/* Purchase - LatestPurchasePrice  |FALSE  |  |Decimal |  | |*/
    ,CAST(NULL AS VARCHAR(200)) AS ItemPurchaseText								/*Purchase - Item Text (tttxt010.ctxt)	FALSE |  Memo | | | */
	,0 AS TextIDPurchase									/*Purchase - Text ID  (tdipu081.txtp)	FALSE | Long Integer | | | */

	/* PRODUCTION */

	,2 AS ReceiptInspection									/*Production - Receipt Inspection(tiipd051.iimf) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS OutboundInspection								/*Production - Outbound Inspection (tiipd051.iima) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS CriticalForInventory								/*Production - Critical for Inventory (tiipf051.cick)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,0 AS ScrapPercentage									/*Production - Scrap Percentage (tiipf051.scpf) (HYVA) | FALSE | 0 |  | |*/
	,0 AS ScrapQuantity										/*Production - Scrap Quantity (tiipf051.scpq) (HYVA) | FALSE | 0 |  | |*/
    , CASE 
        WHEN kps.Itemgroup = 'DPMTO1' THEN 2
        WHEN kps.SupplySource = 50 THEN 2
        WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 
        ELSE 2
    END AS Phantom												/*Production - Phantom (tiipf051.cpha) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(9)) AS ShopFloorPlanner			/*Production - Shop Floor Planner (tiipf051.sfpl) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2	-- was 1 
			WHEN 'COMAN2' THEN 2	-- was 1
			WHEN 'DPMTO1' THEN 2	
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 2	-- was 1
			WHEN 'GELTR2' THEN 2	-- was 1
			WHEN 'GESCO3' THEN 2	
			WHEN 'GESTD5' THEN 2	-- was 1
			WHEN 'GESTR4' THEN 2	-- was 1
			WHEN 'PHMAN2' THEN 2	-- was 1
			WHEN 'PHSAL1' THEN 2	-- was 1
			WHEN 'PI9999' THEN 2	 
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2	-- was 1
			ELSE 2
		END AS BackflushIfMaterial							/*Production - Allow Backflushing (tiipf051.bfcp) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 2	-- was 1
			WHEN 'GEKIT6' THEN 2	-- was 1
			WHEN 'GELCO1' THEN 2
			WHEN 'GELTR2' THEN 2
			WHEN 'GESCO3' THEN 2
			WHEN 'GESTD5' THEN 2
			WHEN 'GESTR4' THEN 2
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS BackflushMaterials								/*Production - Backflush Materials (tiipf051.bfep) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS BackflushHours									/*Production - Backflush Hours (tiipd051.bfhr)  (Will set "Use Global Item" to no when value <> 99)	| FALSE |Byte| |1;"Yes";2;"No";99;"Inherit from Item (defaults)" */
	,CASE 
		WHEN kps.Itemgroup = 'DPMTO1' THEN 1
		WHEN kps.SupplySource = 50 THEN 1
		WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 2 
		ELSE 1
	 END AS DirectInitiateInventoryIssue						/*Production - Direct Initiate Inventory Issue (tiipf051.drin) (HYVA) | FALSE | null |  | 1;"Yes";2;"No (default)"|*/
	,2 AS DirectProcessWHOrderLine							/*Production - Direct Process Warehouse Order Line (tiipd051.dris) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/

	/* SERVICE */

	,CAST(NULL AS VARCHAR(9)) AS ServiceDepartment			/*Service Operations Department (tsmdm220.mdpt) - Reference to tdmdm100 Service Departments | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/

	/* WAREHOUSE */

	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ItemValuationGroup			/*Warehousing - Item Valuation Group (whwmd404.ivgr)   - Reference to whina101 Item Valuation Groups (HYVA) | FALSE | null | 6 | |*/
	,1 AS LocationControlled								/*Warehousing - Location Controlled (whwmd404.locc) (HYVA) | FALSE | 0 |  | 1;"Yes";2;"No"|*/
	,1 AS ProcessInvVariances								/*Warehousing - Process Inventory Variances Automatically (whwmd404.prva) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,20 AS UseOrderingData									/*Warehousing - Use Item Ordering Data by Site (whwmd404.uidt) (HYVA) | FALSE | 10 |  | 10;"Yes";20;"No";30;"Apply Warehouse Default"|*/
	,60 AS DefaultSupplySystem								/*Warehousing - Default Supply System (whwmd404.dwhs) (HYVA) | FALSE | 70 |  | 10;"Time-Phased Order Point";20;"KANBAN";30;"Order Controlled/Batch";40;"Order Controlled/SILS";50;"Order Controlled/Single";60;"Apply Warehouse Defaults";70;"None (default)"|*/
	,2 AS GenerateOrderAdvices								/*Warehousing - Generate Order Advices (whwmd404.goad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS CombineOrderAdvices								/*Warehousing - Combine Order Advices (whwmd404.coad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS ConfirmOrderAdvices								/*Warehousing - Automatically Confirm Order Advices (whwmd404.acoa) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,CAST(null AS VARCHAR(1)) AS ABCcode					/*Warehousing - ABC Code (whwmd404.abcc) (HYVA) | FALSE | null | 1 | |*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS HandlingUnitInUse								/*Warehousing - Handling Units in Use(whwmd404.uhnd) (HYVA) |  | 2 |  | 1;"Yes";2;"No"|*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND (kps.POV1 <> 0))
	JOIN 
		(
			select
				distinct 
				 t1.Subcontractor
				,t1.Item
			from
				(
			select
				distinct  
					 t1.Subcontractor as Subcontractor
					,t1.ProductItem as Item
			from
				(
			SELECT
				 'PROJEMPTY' AS ProductProject												/*Project segment of Product (tisub100/110.item) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                   Infor LN tables: tisub100, tisub110 | TRUE | "PROJEMPTY" |Text | 9 | |*/
				,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tisub100/110.item) - References to tcibd001 Item General Data | TRUE | '' |Text | 38 | |*/	
				,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN null ELSE bps.[Business Partner] END AS VARCHAR(9)) AS Subcontractor														/*Subcontractor (tisub100/110.subc) - Reference tccom120 Buy-from Business Partners | TRUE | '' |Text | 9 | |*/
				,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN null ELSE bps.[Business Partner] END AS VARCHAR(9)) AS ShipFromBP  	/*Ship-from Business Partner (tisub100/110.sfbp) - Reference tccom121 Ship-from Business Partners ** At least fill with same value as Subcontractor | TRUE | '' |Text | 9 | |*/
				,'IT.POV.01' AS Site														/*Site (tisub100/110.site) - References to tcemm050 Sites | FALSE | '' |Text | 9 | |*/
				,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))* 10 AS Position																/*Position (tisub110.pono) | TRUE | 1 |Long Integer |  | |*/
				,20 AS Status																/*Subcontracting Model Status (tisub100.psta) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |Byte |  | 10;"New";20;"Approved";30;"Expired"|*/
				,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tisub100.efdt) | TRUE | null |Date/Time |  | |*/
				,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tisub100.exdt)  - When empty, date will be set to MAX | TRUE | null |Date/Time |  | |*/
				,CAST(bps.POV1 AS VARCHAR(6)) AS SubcontractorWarehouse						/*Subcontractor Warehouse (tisub100.cwar) - References tcmcs003 Warehouses | FALSE | '' |Text | 6 | |*/
				,1 AS BomQuantity															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,2 AS UseForCosting															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,2 AS UseForPlanning														/*Use for Planning (tisub100.crip) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,'PROJEMPTY' AS MaterialProject												/*Project segment of Material (tisub110.sitm) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | FALSE | "PROJEMPTY" |Text | 9 | |*/
				,CAST(kpc.ItemLnCE AS VARCHAR(38))  AS MaterialItem							/*Item segment of Sub Item (tisub110.sitm) - References to tcibd001 General Item Data | FALSE | '' |Text | 38 | |*/
				,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
					CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
						ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
						END		
					END AS FLOAT) AS  MaterialQuantity										/*Material Quantity (tisub110.qana) - Material Quantity | TRUE | 1 |Decimal |  | >0|*/
				,0 AS ScrapPercentage														/*Scrap Percentage (tisub110.scpf) |  | 0 |Decimal |  | |*/
				,CAST(sms.Warehouse AS VARCHAR(6)) AS  SupplyingWarehouse					/*Supplying Warehouse (tisub110.cwar)  - References tcmcs003 Warehouses |  | '' |Text | 6 | |*/
			---	,cast(scc.SupplySystem as float) as SupplySystem

			FROM
				KPRAKTOR.SIAPR.DISBASE bom
				JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)	
				JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1)
				Left join ZZZ_Italy.dbo.SubContractorSupplier scs on (kps.ItemLnCE = scs.Item and scs.Type = 'Product')
				LEFT JOIN ZZZ_Italy.dbo.BP_Conv bps ON (scs.Subcontractor = bps.KPraktor)
				JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)	
				JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kpc.Class NOT IN (4))
				LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
				Left join ZZZ_Italy.dbo.SubContractorSupplier scc on (kpc.ItemLnCE = scc.Item and scc.Type = 'Material')
				LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (scc.[Supplying BP] = bpc.KPraktor)
				LEFT JOIN ZZZ_Italy.dbo.SCModelMap sms ON (kps.POV1 = sms.POV1 AND sms.Site = 'IT.POV.01')
			---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F tac ON (itm.MG_DITTA = tac.TED_DITTA AND itm.MG_ESPL_DB = tac.TED_ESPL_DB)
			---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F taf ON (its.MG_DITTA = taf.TED_DITTA AND its.MG_ESPL_DB = taf.TED_ESPL_DB)
			WHERE
				bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
				AND kps.SupplySource IN ('50')
				AND (kps.POV1 <> 0)
			) t1

			UNION ALL

			select
				distinct  
					 t1.Subcontractor as Subcontractor
					,t1.MaterialItem as Item
			from
				(
			SELECT
				 'PROJEMPTY' AS ProductProject												/*Project segment of Product (tisub100/110.item) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                   Infor LN tables: tisub100, tisub110 | TRUE | "PROJEMPTY" |Text | 9 | |*/
				,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tisub100/110.item) - References to tcibd001 Item General Data | TRUE | '' |Text | 38 | |*/	
				,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN null ELSE bps.[Business Partner] END AS VARCHAR(9)) AS Subcontractor														/*Subcontractor (tisub100/110.subc) - Reference tccom120 Buy-from Business Partners | TRUE | '' |Text | 9 | |*/
				,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN null ELSE bps.[Business Partner] END AS VARCHAR(9)) AS ShipFromBP  	/*Ship-from Business Partner (tisub100/110.sfbp) - Reference tccom121 Ship-from Business Partners ** At least fill with same value as Subcontractor | TRUE | '' |Text | 9 | |*/
				,'IT.POV.01' AS Site														/*Site (tisub100/110.site) - References to tcemm050 Sites | FALSE | '' |Text | 9 | |*/
				,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))* 10 AS Position																/*Position (tisub110.pono) | TRUE | 1 |Long Integer |  | |*/
				,20 AS Status																/*Subcontracting Model Status (tisub100.psta) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |Byte |  | 10;"New";20;"Approved";30;"Expired"|*/
				,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tisub100.efdt) | TRUE | null |Date/Time |  | |*/
				,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tisub100.exdt)  - When empty, date will be set to MAX | TRUE | null |Date/Time |  | |*/
				,CAST(bps.POV1 AS VARCHAR(6)) AS SubcontractorWarehouse						/*Subcontractor Warehouse (tisub100.cwar) - References tcmcs003 Warehouses | FALSE | '' |Text | 6 | |*/
				,1 AS BomQuantity															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,2 AS UseForCosting															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,2 AS UseForPlanning														/*Use for Planning (tisub100.crip) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,'PROJEMPTY' AS MaterialProject												/*Project segment of Material (tisub110.sitm) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | FALSE | "PROJEMPTY" |Text | 9 | |*/
				,CAST(kpc.ItemLnCE AS VARCHAR(38))  AS MaterialItem							/*Item segment of Sub Item (tisub110.sitm) - References to tcibd001 General Item Data | FALSE | '' |Text | 38 | |*/
				,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
					CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
						ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
						END		
					END AS FLOAT) AS  MaterialQuantity										/*Material Quantity (tisub110.qana) - Material Quantity | TRUE | 1 |Decimal |  | >0|*/
				,0 AS ScrapPercentage														/*Scrap Percentage (tisub110.scpf) |  | 0 |Decimal |  | |*/
				,CAST(sms.Warehouse AS VARCHAR(6)) AS  SupplyingWarehouse					/*Supplying Warehouse (tisub110.cwar)  - References tcmcs003 Warehouses |  | '' |Text | 6 | |*/
			---	,cast(scc.SupplySystem as float) as SupplySystem

			FROM
				KPRAKTOR.SIAPR.DISBASE bom
				JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)	
				JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1)
				Left join ZZZ_Italy.dbo.SubContractorSupplier scs on (kps.ItemLnCE = scs.Item and scs.Type = 'Product')
				LEFT JOIN ZZZ_Italy.dbo.BP_Conv bps ON (scs.Subcontractor = bps.KPraktor)
				JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)	
				JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kpc.Class NOT IN (4))
				LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
				Left join ZZZ_Italy.dbo.SubContractorSupplier scc on (kpc.ItemLnCE = scc.Item and scc.Type = 'Material')
				LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (scc.[Supplying BP] = bpc.KPraktor)
				LEFT JOIN ZZZ_Italy.dbo.SCModelMap sms ON (kps.POV1 = sms.POV1 AND sms.Site = 'IT.POV.01')
			---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F tac ON (itm.MG_DITTA = tac.TED_DITTA AND itm.MG_ESPL_DB = tac.TED_ESPL_DB)
			---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F taf ON (its.MG_DITTA = taf.TED_DITTA AND its.MG_ESPL_DB = taf.TED_ESPL_DB)
			WHERE
				bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
				AND kps.SupplySource IN ('50')
				AND (kps.POV1 <> 0)
			) t1
			) t1
	)scs on (kps.ItemLnCE = scs.Item)
---	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpa on (scs.Subcontractor = bpa.[Business Partner])
	JOIN ZZZ_Italy.dbo.SCModelMap scm ON (scs. Subcontractor = scm.BusinessPartner and scm.Site = 'IT.EXT.05')
	LEFT JOIN KPRAKTOR.SIAPR.ANAGES pla ON (itm.MG_CODICE = pla.GE_CODICE_ART AND itm.MG_DITTA = pla.GE_DITTA)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (itm.MG_CODFOR_PREF = bpc.KPraktor AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pup ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND  pup.Subcontract = 0)
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pus ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND   pup.Subcontract = 1)
	LEFT JOIN ZZZ_Italy.dbo.SelectionCode sec ON (itm.MG_TIP_REC = sec.Code AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.StatisticsGroep_Conv stc ON (itm.MG_TIP_REC = stc.ProductType AND itm.MG_DITTA = 1)
	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] mab ON ( mab.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] map ON ( map.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
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
		)bol ON (kps.Item = bol.item)

UNION ALL

/* SITE IT.EXT.06 */

SELECT
	 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
	,CAST('IT.EXT.06' AS VARCHAR(9)) AS Site				/*Site (site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	/* GENERAL */

	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2
	 END AS ItemOrdering									/*Item Ordering by Site (tcibd250) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 1 
			ELSE 2
		END AS ItemSales									/*Item Sales by Site (tdisa081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2 
		END AS ItemPurchase									/*Item Purchase by Site (tdipu081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 2
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 2
			WHEN 'GELTR2' THEN 2
			WHEN 'GESCO3' THEN 2
			WHEN 'GESTD5' THEN 2
			WHEN 'GESTR4' THEN 2
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2  
			ELSE 2
		 END AS ItemProduction									/*Item Production by Site (tiipd051) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 2 
			ELSE 2 
		 END AS ItemService										/*Item Service by Site (tsmdm220) | TRUE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1
			ELSE 2 
		END AS ItemWarehousing									/*Item Warehousing by Site (whwmd404) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	/* Belinda list */
	,cast(40 as float) AS SupplySource							/*General - Default Supply Source (srce) ** Item type Product and Generic, use 20, 40, 50 or 60. Other item types, use 10 | FALSE | 10 |  | 10;"Not Applicable (default)";20;"Job Shop";40;"Purchase";50;"Subcontract";60;"Distribution"|*/
	,CAST(NULL AS VARCHAR(9)) AS ProductGroup	/*General - Product Group - Reference to tcmcs025 Product Groups (HYVA) | FALSE | null | 9 | |*/
	,CAST(CASE itm.MG_FLAG_FUORI_PROD
		WHEN 'M' THEN '180'
		WHEN 'N' THEN '' ---'000'
		WHEN 'O' THEN '016'
		WHEN 'P' THEN '170'
		WHEN 'Q' THEN '170'
		WHEN 'S' THEN '005'
		WHEN 'V' THEN '' ---'000'
		ELSE ''
		END AS VARCHAR(3)) AS ItemSignal						/*General - Item Signal (tcibd150.csig)   - Reference to  tcmcs018 Item Signals (HYVA) | FALSE | null | 3 | |*/
	,CAST(kps.CountryOrigin AS VARCHAR(3)) AS CountryOrigin		/*General - Country of Origin (tcibd150.ctyo)   - Reference to  tcmcs010 Countries (HYVA) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(25)) AS HSCode						/*General - Harmonized System Code (tcibd150.ccde)   - Reference to tcmcs028 Harmonized System Codes (HYVA) | FALSE | null | 25 | |*/

	/* ORDERING */

	,CAST(NULL AS VARCHAR(200)) AS ItemGeneralText								/*General - Item Text (tttxt010.ctxt)	FALSE | | | | */
	,0 AS TextIDGeneral											/*General - Text ID (tcibd150.txta)	FALSE |Long Integer| | */
	/*---- replaced 2024/02/14 by JVD ----*/
	,CAST(scm.Warehouse AS VARCHAR(6)) AS OrderingWarehouse 	/*Ordering - Warehouse (tcibd250.cwar) - Reference to tcmcs003 Warehouses ** Mandatory for item ordering by Site | FALSE | null | 6 | |*/
	,1 AS OrderMethod											/*Ordering - Order Method (tcibd250.omth) (HYVA) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,10 AS OrderingTimeUnit										/*Ordering - Time Unit for OrderInterval, SafetyTime (tcibd250.oivu, tcibd250.tuni) (Will set "Use Global Item" to no when value <> 99)	| FALSE	| Byte |5;Hours;10;Days;99;"Inherit from Item (defaults)" | */
	,CAST(1 AS FLOAT) AS OrderInterval										/*Ordering - Order Interval  (tcibd250.oint) (HYVA) | FALSE | 0 |  | |*/
	,CAST(0 AS FLOAT) AS SafetyStock							/*Ordering - Safety Stock (tcibd250.sfst)  (HYVA) | FALSE | 0 |  | |*/
	/* Belinda List */
	,CAST(5 AS FLOAT) AS SafetyTime								/*Ordering - Safety Time (tcibd250.sftm) (HYVA) | FALSE | 0 |  | |*/
	/* Belinda List */
	,CAST(1 as float) AS OrderQuantityIncrement
	/* Belinda List */										/*Ordering - Order Quantity Increment (tcibd250.oqmf) (HYVA) | FALSE | 1 |  | |*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity			
	/* Belinda List */															/*Ordering - Minimum Order Quantity (tcibd250.mioq) (HYVA) | FALSE | 0 |  | |*/
	,CAST(99999999.99 AS FLOAT) AS MaximumOrderQuantity
	/* Belinda List */															/*Ordering - Maximum Order Quantity (tcibd250.maoq) (HYVA) | FALSE | 99999999.99 |  | <100000000|*/
	,1 AS FixedOrderQuantity									/*Ordering - Fixed Order Quantity (tcibd250.fioq) (HYVA) | FALSE | 1 |  | |*/
	/* Belinda List */
	,CAST(1 as float) AS EconomicOrderQuantity
																/*Ordering - Economic Order Quantity (tcibd250.ecoq) (HYVA) | FALSE | 1 |  | |*/
	,0 AS ReorderPoint											/*Ordering - Reorder Point (tcibd250.reop) (HYVA) | FALSE | 0 |  | |*/
	, map.LN_Employee_Planner	 AS Planner						/*Ordering - Planner (tcibd250.cplb) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
	,2 AS LotSizeCalculationAllowed								/*Ordering - Lot Size Calculation Allowed (tcibd250.auso)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/

	/* SALES */

	,CAST(scm.Warehouse AS VARCHAR(6)) AS  SalesWarehouse	/*Sales Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	
	/* PURCHASE */

	,CASE WHEN pup.Currency IS NULL THEN 'EUR' ELSE pup.Currency END AS PurchaseCurrency								/*Purchase Currency (tdipu081.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	/* Belinda List */
	,CAST (0 AS FLOAT) AS PurchasePrice								/*Purchase Price (tdipu081.prip) | FALSE | 0 |  | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchaseUnit	/*Purchase Unit (tdipu081.cuqp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchasePriceUnit	/*Purchase Price Unit (tdipu081.cupp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR (6)) AS SitePurchaseOffice		/*Purchase - Site Purchase Office (tdipu081.cofc) - Reference to tdpur012 Purchase Offices | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'P10.10'
			WHEN 'COMAN2' THEN 'P10.10'
			WHEN 'DPMTO1' THEN 'P10.10'
			WHEN 'GEKIT6' THEN 'P10.10'
			WHEN 'GELCO1' THEN 'P10.10'
			WHEN 'GELTR2' THEN 'P10.10'
			WHEN 'GESCO3' THEN 'P10.10'
			WHEN 'GESTD5' THEN 'P10.10'
			WHEN 'GESTR4' THEN 'P10.10'
			WHEN 'PHMAN2' THEN 'P10.10'
			WHEN 'PHSAL1' THEN 'P10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'P90.10'
			WHEN 'TOGEN1' THEN 'P20.30'
			WHEN 'COFLS4' THEN 'P10.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS PurchasePriceGroup				 /*Purchase Price Group (cpgp)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST
		(CASE 
			WHEN stc.StatisticsGroup IS NULL THEN  '------' ELSE stc.StatisticsGroup
		END
			AS VARCHAR(6)
		) AS PurchaseStatisticsGroup								/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	,CAST(scm.Warehouse AS VARCHAR(6)) AS  PurchaseWarehouse									/*Purchase Warehouse (tdipu081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS PurchaseBuyFromBP					/*Purchase Buy-from Business Partner (tdipu081.otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | |*/
	, mab.LN_Employee_Buyer AS Buyer
	,CAST (null  AS FLOAT) AS SubcontractingPrice
	,0 AS OperationSubcPrice								/*Purchase - Operation Subcontracting Purchase Price (tdipu081.scpr) (HYVA) | FALSE | 0 |  | |*/
	,2 AS PurchaseScheduleInUse								/*Purchase Schedule in Use (tdipu081.scus) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS PurchaseScheduleType								/*Purchase Schedule Type (tdiu081.styp) (HYVA) | FALSE | 1 |  | 1;"Not Applicable (default)";2;"Pull Schedule";3;"Push Schedule"|*/
	,1 AS VendorRating 										/*VendorRating (tdipu081.vryn) | FALSE | 1 |  |  |1;"Yes";2;"No"; ;99 (default);"Inherit from Item (defaults) |*/
	/* Belinda List */
	,CAST(0 as float) AS SupplyTime									/*Purchase - Supply Time (tdipu081.suti) | FALSE | 0 |  | |*/
	,CASE kps.ItemGroup
		WHEN 'CI0001' THEN 2
		ELSE 1
		END AS ReleaseToWarehousing							/*Purchase - Release to Warehousing (tdipu081.retw)  (HYVA) ** NOTE: Only applicable for cost items. For other items types, this field will always be set to yes. | FALSE | 1 |  | 1;"Yes";2;"No"|*/
	,2 AS Inspection										/*Purchase - Inspection (tdipu081.qual) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	/* Belinda List */
	,CAST(null as SMALLDATETIME ) AS LatestPurchasePriceDate /*Purchase - LatestPurchasePriceDate (tdipu180.ltpp) | FALSE | null |  Date/Time | | |*/
	,0 AS  AveragePurchasePrice 							/* Will create record when date is populated */
	/* Belinda List */
	,CAST(null as float) AS LatestPurchasePrice						/* Purchase - LatestPurchasePrice  |FALSE  |  |Decimal |  | |*/
    ,CAST(NULL AS VARCHAR(200)) AS ItemPurchaseText								/*Purchase - Item Text (tttxt010.ctxt)	FALSE |  Memo | | | */
	,0 AS TextIDPurchase									/*Purchase - Text ID  (tdipu081.txtp)	FALSE | Long Integer | | | */

	/* PRODUCTION */

	,2 AS ReceiptInspection									/*Production - Receipt Inspection(tiipd051.iimf) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS OutboundInspection								/*Production - Outbound Inspection (tiipd051.iima) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS CriticalForInventory								/*Production - Critical for Inventory (tiipf051.cick)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,0 AS ScrapPercentage									/*Production - Scrap Percentage (tiipf051.scpf) (HYVA) | FALSE | 0 |  | |*/
	,0 AS ScrapQuantity										/*Production - Scrap Quantity (tiipf051.scpq) (HYVA) | FALSE | 0 |  | |*/
    , CASE 
        WHEN kps.Itemgroup = 'DPMTO1' THEN 2
        WHEN kps.SupplySource = 50 THEN 2
        WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 
        ELSE 2
    END AS Phantom												/*Production - Phantom (tiipf051.cpha) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(9)) AS ShopFloorPlanner			/*Production - Shop Floor Planner (tiipf051.sfpl) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2	-- was 1 
			WHEN 'COMAN2' THEN 2	-- was 1
			WHEN 'DPMTO1' THEN 2	
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 2	-- was 1
			WHEN 'GELTR2' THEN 2	-- was 1
			WHEN 'GESCO3' THEN 2	
			WHEN 'GESTD5' THEN 2	-- was 1
			WHEN 'GESTR4' THEN 2	-- was 1
			WHEN 'PHMAN2' THEN 2	-- was 1
			WHEN 'PHSAL1' THEN 2	-- was 1
			WHEN 'PI9999' THEN 2	 
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2	-- was 1
			ELSE 2
		END AS BackflushIfMaterial							/*Production - Allow Backflushing (tiipf051.bfcp) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 2	-- was 1
			WHEN 'GEKIT6' THEN 2	-- was 1
			WHEN 'GELCO1' THEN 2
			WHEN 'GELTR2' THEN 2
			WHEN 'GESCO3' THEN 2
			WHEN 'GESTD5' THEN 2
			WHEN 'GESTR4' THEN 2
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS BackflushMaterials								/*Production - Backflush Materials (tiipf051.bfep) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS BackflushHours									/*Production - Backflush Hours (tiipd051.bfhr)  (Will set "Use Global Item" to no when value <> 99)	| FALSE |Byte| |1;"Yes";2;"No";99;"Inherit from Item (defaults)" */
	,CASE 
		WHEN kps.Itemgroup = 'DPMTO1' THEN 1
		WHEN kps.SupplySource = 50 THEN 1
		WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 2 
		ELSE 1
	 END AS DirectInitiateInventoryIssue						/*Production - Direct Initiate Inventory Issue (tiipf051.drin) (HYVA) | FALSE | null |  | 1;"Yes";2;"No (default)"|*/
	,2 AS DirectProcessWHOrderLine							/*Production - Direct Process Warehouse Order Line (tiipd051.dris) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/

	/* SERVICE */

	,CAST(NULL AS VARCHAR(9)) AS ServiceDepartment			/*Service Operations Department (tsmdm220.mdpt) - Reference to tdmdm100 Service Departments | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/

	/* WAREHOUSE */

	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ItemValuationGroup			/*Warehousing - Item Valuation Group (whwmd404.ivgr)   - Reference to whina101 Item Valuation Groups (HYVA) | FALSE | null | 6 | |*/
	,1 AS LocationControlled								/*Warehousing - Location Controlled (whwmd404.locc) (HYVA) | FALSE | 0 |  | 1;"Yes";2;"No"|*/
	,1 AS ProcessInvVariances								/*Warehousing - Process Inventory Variances Automatically (whwmd404.prva) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,20 AS UseOrderingData									/*Warehousing - Use Item Ordering Data by Site (whwmd404.uidt) (HYVA) | FALSE | 10 |  | 10;"Yes";20;"No";30;"Apply Warehouse Default"|*/
	,60 AS DefaultSupplySystem								/*Warehousing - Default Supply System (whwmd404.dwhs) (HYVA) | FALSE | 70 |  | 10;"Time-Phased Order Point";20;"KANBAN";30;"Order Controlled/Batch";40;"Order Controlled/SILS";50;"Order Controlled/Single";60;"Apply Warehouse Defaults";70;"None (default)"|*/
	,2 AS GenerateOrderAdvices								/*Warehousing - Generate Order Advices (whwmd404.goad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS CombineOrderAdvices								/*Warehousing - Combine Order Advices (whwmd404.coad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS ConfirmOrderAdvices								/*Warehousing - Automatically Confirm Order Advices (whwmd404.acoa) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,CAST(null AS VARCHAR(1)) AS ABCcode					/*Warehousing - ABC Code (whwmd404.abcc) (HYVA) | FALSE | null | 1 | |*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS HandlingUnitInUse								/*Warehousing - Handling Units in Use(whwmd404.uhnd) (HYVA) |  | 2 |  | 1;"Yes";2;"No"|*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND (kps.POV1 <> 0))
	JOIN 
		(
			select
				distinct 
				 t1.Subcontractor
				,t1.Item
			from
				(
			select
				distinct  
					 t1.Subcontractor as Subcontractor
					,t1.ProductItem as Item
			from
				(
			SELECT
				 'PROJEMPTY' AS ProductProject												/*Project segment of Product (tisub100/110.item) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                   Infor LN tables: tisub100, tisub110 | TRUE | "PROJEMPTY" |Text | 9 | |*/
				,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tisub100/110.item) - References to tcibd001 Item General Data | TRUE | '' |Text | 38 | |*/	
				,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN null ELSE bps.[Business Partner] END AS VARCHAR(9)) AS Subcontractor														/*Subcontractor (tisub100/110.subc) - Reference tccom120 Buy-from Business Partners | TRUE | '' |Text | 9 | |*/
				,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN null ELSE bps.[Business Partner] END AS VARCHAR(9)) AS ShipFromBP  	/*Ship-from Business Partner (tisub100/110.sfbp) - Reference tccom121 Ship-from Business Partners ** At least fill with same value as Subcontractor | TRUE | '' |Text | 9 | |*/
				,'IT.POV.01' AS Site														/*Site (tisub100/110.site) - References to tcemm050 Sites | FALSE | '' |Text | 9 | |*/
				,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))* 10 AS Position																/*Position (tisub110.pono) | TRUE | 1 |Long Integer |  | |*/
				,20 AS Status																/*Subcontracting Model Status (tisub100.psta) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |Byte |  | 10;"New";20;"Approved";30;"Expired"|*/
				,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tisub100.efdt) | TRUE | null |Date/Time |  | |*/
				,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tisub100.exdt)  - When empty, date will be set to MAX | TRUE | null |Date/Time |  | |*/
				,CAST(bps.POV1 AS VARCHAR(6)) AS SubcontractorWarehouse						/*Subcontractor Warehouse (tisub100.cwar) - References tcmcs003 Warehouses | FALSE | '' |Text | 6 | |*/
				,1 AS BomQuantity															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,2 AS UseForCosting															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,2 AS UseForPlanning														/*Use for Planning (tisub100.crip) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,'PROJEMPTY' AS MaterialProject												/*Project segment of Material (tisub110.sitm) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | FALSE | "PROJEMPTY" |Text | 9 | |*/
				,CAST(kpc.ItemLnCE AS VARCHAR(38))  AS MaterialItem							/*Item segment of Sub Item (tisub110.sitm) - References to tcibd001 General Item Data | FALSE | '' |Text | 38 | |*/
				,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
					CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
						ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
						END		
					END AS FLOAT) AS  MaterialQuantity										/*Material Quantity (tisub110.qana) - Material Quantity | TRUE | 1 |Decimal |  | >0|*/
				,0 AS ScrapPercentage														/*Scrap Percentage (tisub110.scpf) |  | 0 |Decimal |  | |*/
				,CAST(sms.Warehouse AS VARCHAR(6)) AS  SupplyingWarehouse					/*Supplying Warehouse (tisub110.cwar)  - References tcmcs003 Warehouses |  | '' |Text | 6 | |*/
			---	,cast(scc.SupplySystem as float) as SupplySystem

			FROM
				KPRAKTOR.SIAPR.DISBASE bom
				JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)	
				JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1)
				Left join ZZZ_Italy.dbo.SubContractorSupplier scs on (kps.ItemLnCE = scs.Item and scs.Type = 'Product')
				LEFT JOIN ZZZ_Italy.dbo.BP_Conv bps ON (scs.Subcontractor = bps.KPraktor)
				JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)	
				JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kpc.Class NOT IN (4))
				LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
				Left join ZZZ_Italy.dbo.SubContractorSupplier scc on (kpc.ItemLnCE = scc.Item and scc.Type = 'Material')
				LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (scc.[Supplying BP] = bpc.KPraktor)
				LEFT JOIN ZZZ_Italy.dbo.SCModelMap sms ON (kps.POV1 = sms.POV1 AND sms.Site = 'IT.POV.01')
			---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F tac ON (itm.MG_DITTA = tac.TED_DITTA AND itm.MG_ESPL_DB = tac.TED_ESPL_DB)
			---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F taf ON (its.MG_DITTA = taf.TED_DITTA AND its.MG_ESPL_DB = taf.TED_ESPL_DB)
			WHERE
				bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
				AND kps.SupplySource IN ('50')
				AND (kps.POV1 <> 0)
			) t1

			UNION ALL

			select
				distinct  
					 t1.Subcontractor as Subcontractor
					,t1.MaterialItem as Item
			from
				(
			SELECT
				 'PROJEMPTY' AS ProductProject												/*Project segment of Product (tisub100/110.item) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                   Infor LN tables: tisub100, tisub110 | TRUE | "PROJEMPTY" |Text | 9 | |*/
				,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tisub100/110.item) - References to tcibd001 Item General Data | TRUE | '' |Text | 38 | |*/	
				,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN null ELSE bps.[Business Partner] END AS VARCHAR(9)) AS Subcontractor														/*Subcontractor (tisub100/110.subc) - Reference tccom120 Buy-from Business Partners | TRUE | '' |Text | 9 | |*/
				,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN null ELSE bps.[Business Partner] END AS VARCHAR(9)) AS ShipFromBP  	/*Ship-from Business Partner (tisub100/110.sfbp) - Reference tccom121 Ship-from Business Partners ** At least fill with same value as Subcontractor | TRUE | '' |Text | 9 | |*/
				,'IT.POV.01' AS Site														/*Site (tisub100/110.site) - References to tcemm050 Sites | FALSE | '' |Text | 9 | |*/
				,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))* 10 AS Position																/*Position (tisub110.pono) | TRUE | 1 |Long Integer |  | |*/
				,20 AS Status																/*Subcontracting Model Status (tisub100.psta) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |Byte |  | 10;"New";20;"Approved";30;"Expired"|*/
				,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tisub100.efdt) | TRUE | null |Date/Time |  | |*/
				,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tisub100.exdt)  - When empty, date will be set to MAX | TRUE | null |Date/Time |  | |*/
				,CAST(bps.POV1 AS VARCHAR(6)) AS SubcontractorWarehouse						/*Subcontractor Warehouse (tisub100.cwar) - References tcmcs003 Warehouses | FALSE | '' |Text | 6 | |*/
				,1 AS BomQuantity															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,2 AS UseForCosting															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,2 AS UseForPlanning														/*Use for Planning (tisub100.crip) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
				,'PROJEMPTY' AS MaterialProject												/*Project segment of Material (tisub110.sitm) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | FALSE | "PROJEMPTY" |Text | 9 | |*/
				,CAST(kpc.ItemLnCE AS VARCHAR(38))  AS MaterialItem							/*Item segment of Sub Item (tisub110.sitm) - References to tcibd001 General Item Data | FALSE | '' |Text | 38 | |*/
				,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
					CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
						ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
						END		
					END AS FLOAT) AS  MaterialQuantity										/*Material Quantity (tisub110.qana) - Material Quantity | TRUE | 1 |Decimal |  | >0|*/
				,0 AS ScrapPercentage														/*Scrap Percentage (tisub110.scpf) |  | 0 |Decimal |  | |*/
				,CAST(sms.Warehouse AS VARCHAR(6)) AS  SupplyingWarehouse					/*Supplying Warehouse (tisub110.cwar)  - References tcmcs003 Warehouses |  | '' |Text | 6 | |*/
			---	,cast(scc.SupplySystem as float) as SupplySystem

			FROM
				KPRAKTOR.SIAPR.DISBASE bom
				JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)	
				JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1)
				Left join ZZZ_Italy.dbo.SubContractorSupplier scs on (kps.ItemLnCE = scs.Item and scs.Type = 'Product')
				LEFT JOIN ZZZ_Italy.dbo.BP_Conv bps ON (scs.Subcontractor = bps.KPraktor)
				JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)	
				JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kpc.Class NOT IN (4))
				LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
				Left join ZZZ_Italy.dbo.SubContractorSupplier scc on (kpc.ItemLnCE = scc.Item and scc.Type = 'Material')
				LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (scc.[Supplying BP] = bpc.KPraktor)
				LEFT JOIN ZZZ_Italy.dbo.SCModelMap sms ON (kps.POV1 = sms.POV1 AND sms.Site = 'IT.POV.01')
			---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F tac ON (itm.MG_DITTA = tac.TED_DITTA AND itm.MG_ESPL_DB = tac.TED_ESPL_DB)
			---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F taf ON (its.MG_DITTA = taf.TED_DITTA AND its.MG_ESPL_DB = taf.TED_ESPL_DB)
			WHERE
				bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
				AND kps.SupplySource IN ('50')
				AND (kps.POV1 <> 0)
			) t1
			) t1
	)scs on (kps.ItemLnCE = scs.Item)
---	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpa on (scs.Subcontractor = bpa.[Business Partner])
	JOIN ZZZ_Italy.dbo.SCModelMap scm ON (scs. Subcontractor = scm.BusinessPartner and scm.Site = 'IT.EXT.06')
	LEFT JOIN KPRAKTOR.SIAPR.ANAGES pla ON (itm.MG_CODICE = pla.GE_CODICE_ART AND itm.MG_DITTA = pla.GE_DITTA)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (itm.MG_CODFOR_PREF = bpc.KPraktor AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pup ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND  pup.Subcontract = 0)
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pus ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND   pup.Subcontract = 1)
	LEFT JOIN ZZZ_Italy.dbo.SelectionCode sec ON (itm.MG_TIP_REC = sec.Code AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.StatisticsGroep_Conv stc ON (itm.MG_TIP_REC = stc.ProductType AND itm.MG_DITTA = 1)
	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] mab ON ( mab.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] map ON ( map.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
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
		)bol ON (kps.Item = bol.item)

UNION ALL

/* SITE IT.EXT.08 */

SELECT
	 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
	,CAST('IT.EXT.08' AS VARCHAR(9)) AS Site				/*Site (site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	/* GENERAL */

	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2
	 END AS ItemOrdering									/*Item Ordering by Site (tcibd250) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 1 
			ELSE 2
		END AS ItemSales									/*Item Sales by Site (tdisa081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2 
		END AS ItemPurchase									/*Item Purchase by Site (tdipu081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 2
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 2
			WHEN 'GELTR2' THEN 2
			WHEN 'GESCO3' THEN 2
			WHEN 'GESTD5' THEN 2
			WHEN 'GESTR4' THEN 2
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2  
			ELSE 2
		 END AS ItemProduction									/*Item Production by Site (tiipd051) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 2 
			ELSE 2 
		 END AS ItemService										/*Item Service by Site (tsmdm220) | TRUE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1
			ELSE 2 
		END AS ItemWarehousing									/*Item Warehousing by Site (whwmd404) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	/* Belinda list */
	,cast(40 as float) AS SupplySource							/*General - Default Supply Source (srce) ** Item type Product and Generic, use 20, 40, 50 or 60. Other item types, use 10 | FALSE | 10 |  | 10;"Not Applicable (default)";20;"Job Shop";40;"Purchase";50;"Subcontract";60;"Distribution"|*/
	,CAST(NULL AS VARCHAR(9)) AS ProductGroup	/*General - Product Group - Reference to tcmcs025 Product Groups (HYVA) | FALSE | null | 9 | |*/
	,CAST(CASE itm.MG_FLAG_FUORI_PROD
		WHEN 'M' THEN '180'
		WHEN 'N' THEN '' ---'000'
		WHEN 'O' THEN '016'
		WHEN 'P' THEN '170'
		WHEN 'Q' THEN '170'
		WHEN 'S' THEN '005'
		WHEN 'V' THEN '' ---'000'
		ELSE ''
		END AS VARCHAR(3)) AS ItemSignal						/*General - Item Signal (tcibd150.csig)   - Reference to  tcmcs018 Item Signals (HYVA) | FALSE | null | 3 | |*/
	,CAST(kps.CountryOrigin AS VARCHAR(3)) AS CountryOrigin		/*General - Country of Origin (tcibd150.ctyo)   - Reference to  tcmcs010 Countries (HYVA) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(25)) AS HSCode						/*General - Harmonized System Code (tcibd150.ccde)   - Reference to tcmcs028 Harmonized System Codes (HYVA) | FALSE | null | 25 | |*/

	/* ORDERING */

	,CAST(NULL AS VARCHAR(200)) AS ItemGeneralText								/*General - Item Text (tttxt010.ctxt)	FALSE | | | | */
	,0 AS TextIDGeneral											/*General - Text ID (tcibd150.txta)	FALSE |Long Integer| | */
	/*---- replaced 2024/02/14 by JVD ----*/
	,CAST(scm.Warehouse AS VARCHAR(6)) AS OrderingWarehouse 	/*Ordering - Warehouse (tcibd250.cwar) - Reference to tcmcs003 Warehouses ** Mandatory for item ordering by Site | FALSE | null | 6 | |*/
	,1 AS OrderMethod											/*Ordering - Order Method (tcibd250.omth) (HYVA) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,10 AS OrderingTimeUnit										/*Ordering - Time Unit for OrderInterval, SafetyTime (tcibd250.oivu, tcibd250.tuni) (Will set "Use Global Item" to no when value <> 99)	| FALSE	| Byte |5;Hours;10;Days;99;"Inherit from Item (defaults)" | */
	,CAST(1 AS FLOAT) AS OrderInterval										/*Ordering - Order Interval  (tcibd250.oint) (HYVA) | FALSE | 0 |  | |*/
	,CAST(0 AS FLOAT) AS SafetyStock							/*Ordering - Safety Stock (tcibd250.sfst)  (HYVA) | FALSE | 0 |  | |*/
	/* Belinda List */
	,CAST(5 AS FLOAT) AS SafetyTime								/*Ordering - Safety Time (tcibd250.sftm) (HYVA) | FALSE | 0 |  | |*/
	/* Belinda List */
	,CAST(1 as float) AS OrderQuantityIncrement
	/* Belinda List */										/*Ordering - Order Quantity Increment (tcibd250.oqmf) (HYVA) | FALSE | 1 |  | |*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity			
	/* Belinda List */															/*Ordering - Minimum Order Quantity (tcibd250.mioq) (HYVA) | FALSE | 0 |  | |*/
	,CAST(99999999.99 AS FLOAT) AS MaximumOrderQuantity
	/* Belinda List */															/*Ordering - Maximum Order Quantity (tcibd250.maoq) (HYVA) | FALSE | 99999999.99 |  | <100000000|*/
	,1 AS FixedOrderQuantity									/*Ordering - Fixed Order Quantity (tcibd250.fioq) (HYVA) | FALSE | 1 |  | |*/
	/* Belinda List */
	,CAST(1 as float) AS EconomicOrderQuantity
																/*Ordering - Economic Order Quantity (tcibd250.ecoq) (HYVA) | FALSE | 1 |  | |*/
	,0 AS ReorderPoint											/*Ordering - Reorder Point (tcibd250.reop) (HYVA) | FALSE | 0 |  | |*/
	, map.LN_Employee_Planner	 AS Planner						/*Ordering - Planner (tcibd250.cplb) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
	,2 AS LotSizeCalculationAllowed								/*Ordering - Lot Size Calculation Allowed (tcibd250.auso)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/

	/* SALES */

	,CAST(scm.Warehouse AS VARCHAR(6)) AS  SalesWarehouse	/*Sales Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	
	/* PURCHASE */

	,CASE WHEN pup.Currency IS NULL THEN 'EUR' ELSE pup.Currency END AS PurchaseCurrency								/*Purchase Currency (tdipu081.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	/* Belinda List */
	,CAST (0 AS FLOAT) AS PurchasePrice								/*Purchase Price (tdipu081.prip) | FALSE | 0 |  | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchaseUnit	/*Purchase Unit (tdipu081.cuqp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchasePriceUnit	/*Purchase Price Unit (tdipu081.cupp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR (6)) AS SitePurchaseOffice		/*Purchase - Site Purchase Office (tdipu081.cofc) - Reference to tdpur012 Purchase Offices | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'P10.10'
			WHEN 'COMAN2' THEN 'P10.10'
			WHEN 'DPMTO1' THEN 'P10.10'
			WHEN 'GEKIT6' THEN 'P10.10'
			WHEN 'GELCO1' THEN 'P10.10'
			WHEN 'GELTR2' THEN 'P10.10'
			WHEN 'GESCO3' THEN 'P10.10'
			WHEN 'GESTD5' THEN 'P10.10'
			WHEN 'GESTR4' THEN 'P10.10'
			WHEN 'PHMAN2' THEN 'P10.10'
			WHEN 'PHSAL1' THEN 'P10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'P90.10'
			WHEN 'TOGEN1' THEN 'P20.30'
			WHEN 'COFLS4' THEN 'P10.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS PurchasePriceGroup				 /*Purchase Price Group (cpgp)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST
		(CASE 
			WHEN stc.StatisticsGroup IS NULL THEN  '------' ELSE stc.StatisticsGroup
		END
			AS VARCHAR(6)
		) AS PurchaseStatisticsGroup								/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	,CAST(scm.Warehouse AS VARCHAR(6)) AS  PurchaseWarehouse									/*Purchase Warehouse (tdipu081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS PurchaseBuyFromBP					/*Purchase Buy-from Business Partner (tdipu081.otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | |*/
	, mab.LN_Employee_Buyer AS Buyer
	,CAST (null  AS FLOAT) AS SubcontractingPrice
	,0 AS OperationSubcPrice								/*Purchase - Operation Subcontracting Purchase Price (tdipu081.scpr) (HYVA) | FALSE | 0 |  | |*/
	,2 AS PurchaseScheduleInUse								/*Purchase Schedule in Use (tdipu081.scus) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS PurchaseScheduleType								/*Purchase Schedule Type (tdiu081.styp) (HYVA) | FALSE | 1 |  | 1;"Not Applicable (default)";2;"Pull Schedule";3;"Push Schedule"|*/
	,1 AS VendorRating 										/*VendorRating (tdipu081.vryn) | FALSE | 1 |  |  |1;"Yes";2;"No"; ;99 (default);"Inherit from Item (defaults) |*/
	/* Belinda List */
	,CAST(0 as float) AS SupplyTime									/*Purchase - Supply Time (tdipu081.suti) | FALSE | 0 |  | |*/
	,CASE kps.ItemGroup
		WHEN 'CI0001' THEN 2
		ELSE 1
		END AS ReleaseToWarehousing							/*Purchase - Release to Warehousing (tdipu081.retw)  (HYVA) ** NOTE: Only applicable for cost items. For other items types, this field will always be set to yes. | FALSE | 1 |  | 1;"Yes";2;"No"|*/
	,2 AS Inspection										/*Purchase - Inspection (tdipu081.qual) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	/* Belinda List */
	,CAST(null as SMALLDATETIME ) AS LatestPurchasePriceDate /*Purchase - LatestPurchasePriceDate (tdipu180.ltpp) | FALSE | null |  Date/Time | | |*/
	,0 AS  AveragePurchasePrice 							/* Will create record when date is populated */
	/* Belinda List */
	,CAST(null as float) AS LatestPurchasePrice						/* Purchase - LatestPurchasePrice  |FALSE  |  |Decimal |  | |*/
    ,CAST(NULL AS VARCHAR(200)) AS ItemPurchaseText								/*Purchase - Item Text (tttxt010.ctxt)	FALSE |  Memo | | | */
	,0 AS TextIDPurchase									/*Purchase - Text ID  (tdipu081.txtp)	FALSE | Long Integer | | | */

	/* PRODUCTION */

	,2 AS ReceiptInspection									/*Production - Receipt Inspection(tiipd051.iimf) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS OutboundInspection								/*Production - Outbound Inspection (tiipd051.iima) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS CriticalForInventory								/*Production - Critical for Inventory (tiipf051.cick)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,0 AS ScrapPercentage									/*Production - Scrap Percentage (tiipf051.scpf) (HYVA) | FALSE | 0 |  | |*/
	,0 AS ScrapQuantity										/*Production - Scrap Quantity (tiipf051.scpq) (HYVA) | FALSE | 0 |  | |*/
    , CASE 
        WHEN kps.Itemgroup = 'DPMTO1' THEN 2
        WHEN kps.SupplySource = 50 THEN 2
        WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 
        ELSE 2
    END AS Phantom												/*Production - Phantom (tiipf051.cpha) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(9)) AS ShopFloorPlanner			/*Production - Shop Floor Planner (tiipf051.sfpl) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2	-- was 1 
			WHEN 'COMAN2' THEN 2	-- was 1
			WHEN 'DPMTO1' THEN 2	
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 2	-- was 1
			WHEN 'GELTR2' THEN 2	-- was 1
			WHEN 'GESCO3' THEN 2	
			WHEN 'GESTD5' THEN 2	-- was 1
			WHEN 'GESTR4' THEN 2	-- was 1
			WHEN 'PHMAN2' THEN 2	-- was 1
			WHEN 'PHSAL1' THEN 2	-- was 1
			WHEN 'PI9999' THEN 2	 
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2	-- was 1
			ELSE 2
		END AS BackflushIfMaterial							/*Production - Allow Backflushing (tiipf051.bfcp) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 2	-- was 1
			WHEN 'GEKIT6' THEN 2	-- was 1
			WHEN 'GELCO1' THEN 2
			WHEN 'GELTR2' THEN 2
			WHEN 'GESCO3' THEN 2
			WHEN 'GESTD5' THEN 2
			WHEN 'GESTR4' THEN 2
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS BackflushMaterials								/*Production - Backflush Materials (tiipf051.bfep) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS BackflushHours									/*Production - Backflush Hours (tiipd051.bfhr)  (Will set "Use Global Item" to no when value <> 99)	| FALSE |Byte| |1;"Yes";2;"No";99;"Inherit from Item (defaults)" */
	,CASE 
		WHEN kps.Itemgroup = 'DPMTO1' THEN 1
		WHEN kps.SupplySource = 50 THEN 1
		WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 2 
		ELSE 1
	 END AS DirectInitiateInventoryIssue						/*Production - Direct Initiate Inventory Issue (tiipf051.drin) (HYVA) | FALSE | null |  | 1;"Yes";2;"No (default)"|*/
	,2 AS DirectProcessWHOrderLine							/*Production - Direct Process Warehouse Order Line (tiipd051.dris) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/

	/* SERVICE */

	,CAST(NULL AS VARCHAR(9)) AS ServiceDepartment			/*Service Operations Department (tsmdm220.mdpt) - Reference to tdmdm100 Service Departments | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/

	/* WAREHOUSE */

	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ItemValuationGroup			/*Warehousing - Item Valuation Group (whwmd404.ivgr)   - Reference to whina101 Item Valuation Groups (HYVA) | FALSE | null | 6 | |*/
	,1 AS LocationControlled								/*Warehousing - Location Controlled (whwmd404.locc) (HYVA) | FALSE | 0 |  | 1;"Yes";2;"No"|*/
	,1 AS ProcessInvVariances								/*Warehousing - Process Inventory Variances Automatically (whwmd404.prva) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,20 AS UseOrderingData									/*Warehousing - Use Item Ordering Data by Site (whwmd404.uidt) (HYVA) | FALSE | 10 |  | 10;"Yes";20;"No";30;"Apply Warehouse Default"|*/
	,60 AS DefaultSupplySystem								/*Warehousing - Default Supply System (whwmd404.dwhs) (HYVA) | FALSE | 70 |  | 10;"Time-Phased Order Point";20;"KANBAN";30;"Order Controlled/Batch";40;"Order Controlled/SILS";50;"Order Controlled/Single";60;"Apply Warehouse Defaults";70;"None (default)"|*/
	,2 AS GenerateOrderAdvices								/*Warehousing - Generate Order Advices (whwmd404.goad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS CombineOrderAdvices								/*Warehousing - Combine Order Advices (whwmd404.coad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS ConfirmOrderAdvices								/*Warehousing - Automatically Confirm Order Advices (whwmd404.acoa) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,CAST(null AS VARCHAR(1)) AS ABCcode					/*Warehousing - ABC Code (whwmd404.abcc) (HYVA) | FALSE | null | 1 | |*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS HandlingUnitInUse								/*Warehousing - Handling Units in Use(whwmd404.uhnd) (HYVA) |  | 2 |  | 1;"Yes";2;"No"|*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND (kps.POV3 <> 0))
	JOIN 
		(
			select
				distinct 
				 t1.Subcontractor
				,t1.Item
			from
				(
			select
				distinct  
					 t1.Subcontractor as Subcontractor
					,t1.ProductItem as Item
			from
				(
					SELECT
						 'PROJEMPTY' AS ProductProject												/*Project segment of Product (tisub100/110.item) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                   Infor LN tables: tisub100, tisub110 | TRUE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tisub100/110.item) - References to tcibd001 Item General Data | TRUE | '' |Text | 38 | |*/	
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN '' ELSE bps.[Business Partner] END AS VARCHAR(9)) AS Subcontractor														/*Subcontractor (tisub100/110.subc) - Reference tccom120 Buy-from Business Partners | TRUE | '' |Text | 9 | |*/
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN '' ELSE bps.[Business Partner] END AS VARCHAR(9)) AS ShipFromBP  	/*Ship-from Business Partner (tisub100/110.sfbp) - Reference tccom121 Ship-from Business Partners ** At least fill with same value as Subcontractor | TRUE | '' |Text | 9 | |*/
						,'IT.POV.03' AS Site														/*Site (tisub100/110.site) - References to tcemm050 Sites | FALSE | '' |Text | 9 | |*/
						,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))* 10 AS Position																/*Position (tisub110.pono) | TRUE | 1 |Long Integer |  | |*/
						,20 AS Status																/*Subcontracting Model Status (tisub100.psta) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |Byte |  | 10;"New";20;"Approved";30;"Expired"|*/
						,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tisub100.efdt) | TRUE | null |Date/Time |  | |*/
						,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tisub100.exdt)  - When empty, date will be set to MAX | TRUE | null |Date/Time |  | |*/
						,CAST(bps.POV3 AS VARCHAR(6)) AS SubcontractorWarehouse						/*Subcontractor Warehouse (tisub100.cwar) - References tcmcs003 Warehouses | FALSE | '' |Text | 6 | |*/
						,1 AS BomQuantity															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,2 AS UseForCosting															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,2 AS UseForPlanning														/*Use for Planning (tisub100.crip) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,'PROJEMPTY' AS MaterialProject												/*Project segment of Material (tisub110.sitm) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | FALSE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(kpc.ItemLnCE AS VARCHAR(38))  AS MaterialItem							/*Item segment of Sub Item (tisub110.sitm) - References to tcibd001 General Item Data | FALSE | '' |Text | 38 | |*/
						,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
							CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
								ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
								END		
							END AS FLOAT) AS  MaterialQuantity										/*Material Quantity (tisub110.qana) - Material Quantity | TRUE | 1 |Decimal |  | >0|*/
						,0 AS ScrapPercentage														/*Scrap Percentage (tisub110.scpf) |  | 0 |Decimal |  | |*/
						,CAST(sms.Warehouse AS VARCHAR(6)) AS  SupplyingWarehouse					/*Supplying Warehouse (tisub110.cwar)  - References tcmcs003 Warehouses |  | '' |Text | 6 | |*/
					---	,cast(scc.SupplySystem as float) as SupplySystem

					FROM
						KPRAKTOR.SIAPR.DISBASE bom
						JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)	
						JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1)
						JOIN ZZZ_Italy.dbo.KPSourceSP kpp ON (kps.Item = kpp.Item)
						Left join ZZZ_Italy.dbo.SubContractorSupplier scs on (kps.ItemLnCE = scs.Item and scs.Type = 'Product')
						LEFT JOIN ZZZ_Italy.dbo.BP_Conv bps ON (scs.Subcontractor = bps.KPraktor)
						JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)	
						JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kpc.Class NOT IN (4))
						LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
						Left join ZZZ_Italy.dbo.SubContractorSupplier scc on (kpc.ItemLnCE = scc.Item and scc.Type = 'Material')
						LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (scc.[Supplying BP] = bpc.KPraktor)
						LEFT JOIN ZZZ_Italy.dbo.SCModelMap sms ON (kps.POV3 = sms.POV3 AND sms.Site = 'IT.POV.03')
					---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F tac ON (itm.MG_DITTA = tac.TED_DITTA AND itm.MG_ESPL_DB = tac.TED_ESPL_DB)
					---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F taf ON (its.MG_DITTA = taf.TED_DITTA AND its.MG_ESPL_DB = taf.TED_ESPL_DB)
					WHERE
						bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
						AND kpp.SupplySource IN ('50')
						AND (kps.POV3 <> 0)
			) t1

			UNION ALL

			select
				distinct  
					 t1.Subcontractor as Subcontractor
					,t1.MaterialItem as Item
			from
				(
					SELECT
						 'PROJEMPTY' AS ProductProject												/*Project segment of Product (tisub100/110.item) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                   Infor LN tables: tisub100, tisub110 | TRUE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tisub100/110.item) - References to tcibd001 Item General Data | TRUE | '' |Text | 38 | |*/	
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN '' ELSE bps.[Business Partner] END AS VARCHAR(9)) AS Subcontractor														/*Subcontractor (tisub100/110.subc) - Reference tccom120 Buy-from Business Partners | TRUE | '' |Text | 9 | |*/
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN '' ELSE bps.[Business Partner] END AS VARCHAR(9)) AS ShipFromBP  	/*Ship-from Business Partner (tisub100/110.sfbp) - Reference tccom121 Ship-from Business Partners ** At least fill with same value as Subcontractor | TRUE | '' |Text | 9 | |*/
						,'IT.POV.03' AS Site														/*Site (tisub100/110.site) - References to tcemm050 Sites | FALSE | '' |Text | 9 | |*/
						,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))* 10 AS Position																/*Position (tisub110.pono) | TRUE | 1 |Long Integer |  | |*/
						,20 AS Status																/*Subcontracting Model Status (tisub100.psta) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |Byte |  | 10;"New";20;"Approved";30;"Expired"|*/
						,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tisub100.efdt) | TRUE | null |Date/Time |  | |*/
						,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tisub100.exdt)  - When empty, date will be set to MAX | TRUE | null |Date/Time |  | |*/
						,CAST(bps.POV3 AS VARCHAR(6)) AS SubcontractorWarehouse						/*Subcontractor Warehouse (tisub100.cwar) - References tcmcs003 Warehouses | FALSE | '' |Text | 6 | |*/
						,1 AS BomQuantity															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,2 AS UseForCosting															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,2 AS UseForPlanning														/*Use for Planning (tisub100.crip) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,'PROJEMPTY' AS MaterialProject												/*Project segment of Material (tisub110.sitm) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | FALSE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(kpc.ItemLnCE AS VARCHAR(38))  AS MaterialItem							/*Item segment of Sub Item (tisub110.sitm) - References to tcibd001 General Item Data | FALSE | '' |Text | 38 | |*/
						,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
							CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
								ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
								END		
							END AS FLOAT) AS  MaterialQuantity										/*Material Quantity (tisub110.qana) - Material Quantity | TRUE | 1 |Decimal |  | >0|*/
						,0 AS ScrapPercentage														/*Scrap Percentage (tisub110.scpf) |  | 0 |Decimal |  | |*/
						,CAST(sms.Warehouse AS VARCHAR(6)) AS  SupplyingWarehouse					/*Supplying Warehouse (tisub110.cwar)  - References tcmcs003 Warehouses |  | '' |Text | 6 | |*/
					---	,cast(scc.SupplySystem as float) as SupplySystem

					FROM
						KPRAKTOR.SIAPR.DISBASE bom
						JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)	
						JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1)
						JOIN ZZZ_Italy.dbo.KPSourceSP kpp ON (kps.Item = kpp.Item)
						Left join ZZZ_Italy.dbo.SubContractorSupplier scs on (kps.ItemLnCE = scs.Item and scs.Type = 'Product')
						LEFT JOIN ZZZ_Italy.dbo.BP_Conv bps ON (scs.Subcontractor = bps.KPraktor)
						JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)	
						JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kpc.Class NOT IN (4))
						LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
						Left join ZZZ_Italy.dbo.SubContractorSupplier scc on (kpc.ItemLnCE = scc.Item and scc.Type = 'Material')
						LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (scc.[Supplying BP] = bpc.KPraktor)
						LEFT JOIN ZZZ_Italy.dbo.SCModelMap sms ON (kps.POV3 = sms.POV3 AND sms.Site = 'IT.POV.03')
					---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F tac ON (itm.MG_DITTA = tac.TED_DITTA AND itm.MG_ESPL_DB = tac.TED_ESPL_DB)
					---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F taf ON (its.MG_DITTA = taf.TED_DITTA AND its.MG_ESPL_DB = taf.TED_ESPL_DB)
					WHERE
						bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
						AND kpp.SupplySource IN ('50')
						AND (kps.POV3 <> 0)
			) t1
			) t1
	)scs on (kps.ItemLnCE = scs.Item)
---	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpa on (scs.Subcontractor = bpa.[Business Partner])
	JOIN ZZZ_Italy.dbo.SCModelMap scm ON (scs. Subcontractor = scm.BusinessPartner and scm.Site = 'IT.EXT.08')
	LEFT JOIN KPRAKTOR.SIAPR.ANAGES pla ON (itm.MG_CODICE = pla.GE_CODICE_ART AND itm.MG_DITTA = pla.GE_DITTA)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (itm.MG_CODFOR_PREF = bpc.KPraktor AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pup ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND pup.Subcontract = 0)
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pus ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND pup.Subcontract = 1)
	LEFT JOIN ZZZ_Italy.dbo.SelectionCode sec ON (itm.MG_TIP_REC = sec.Code AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.StatisticsGroep_Conv stc ON (itm.MG_TIP_REC = stc.ProductType AND itm.MG_DITTA = 1)
	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] mab ON ( mab.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] map ON ( map.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
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
		)bol ON (kps.Item = bol.item)

UNION ALL

/* SITE IT.EXT.09 */

SELECT
	 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
	,CAST('IT.EXT.09' AS VARCHAR(9)) AS Site				/*Site (site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	/* GENERAL */

	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2
	 END AS ItemOrdering									/*Item Ordering by Site (tcibd250) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 1 
			ELSE 2
		END AS ItemSales									/*Item Sales by Site (tdisa081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 1
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1 
			ELSE 2 
		END AS ItemPurchase									/*Item Purchase by Site (tdipu081) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 2
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 2
			WHEN 'GELTR2' THEN 2
			WHEN 'GESCO3' THEN 2
			WHEN 'GESTD5' THEN 2
			WHEN 'GESTR4' THEN 2
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2  
			ELSE 2
		 END AS ItemProduction									/*Item Production by Site (tiipd051) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 2 
			ELSE 2 
		 END AS ItemService										/*Item Service by Site (tsmdm220) | TRUE | 2 |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 1
			WHEN 'COFLS4' THEN 1
			ELSE 2 
		END AS ItemWarehousing									/*Item Warehousing by Site (whwmd404) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	/* Belinda list */
	,cast(40 as float) AS SupplySource							/*General - Default Supply Source (srce) ** Item type Product and Generic, use 20, 40, 50 or 60. Other item types, use 10 | FALSE | 10 |  | 10;"Not Applicable (default)";20;"Job Shop";40;"Purchase";50;"Subcontract";60;"Distribution"|*/
	,CAST(NULL AS VARCHAR(9)) AS ProductGroup	/*General - Product Group - Reference to tcmcs025 Product Groups (HYVA) | FALSE | null | 9 | |*/
	,CAST(CASE itm.MG_FLAG_FUORI_PROD
		WHEN 'M' THEN '180'
		WHEN 'N' THEN '' ---'000'
		WHEN 'O' THEN '016'
		WHEN 'P' THEN '170'
		WHEN 'Q' THEN '170'
		WHEN 'S' THEN '005'
		WHEN 'V' THEN '' ---'000'
		ELSE ''
		END AS VARCHAR(3)) AS ItemSignal						/*General - Item Signal (tcibd150.csig)   - Reference to  tcmcs018 Item Signals (HYVA) | FALSE | null | 3 | |*/
	,CAST(kps.CountryOrigin AS VARCHAR(3)) AS CountryOrigin		/*General - Country of Origin (tcibd150.ctyo)   - Reference to  tcmcs010 Countries (HYVA) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(25)) AS HSCode						/*General - Harmonized System Code (tcibd150.ccde)   - Reference to tcmcs028 Harmonized System Codes (HYVA) | FALSE | null | 25 | |*/

	/* ORDERING */

	,CAST(NULL AS VARCHAR(200)) AS ItemGeneralText								/*General - Item Text (tttxt010.ctxt)	FALSE | | | | */
	,0 AS TextIDGeneral											/*General - Text ID (tcibd150.txta)	FALSE |Long Integer| | */
	/*---- replaced 2024/02/14 by JVD ----*/
	,CAST(scm.Warehouse AS VARCHAR(6)) AS OrderingWarehouse 	/*Ordering - Warehouse (tcibd250.cwar) - Reference to tcmcs003 Warehouses ** Mandatory for item ordering by Site | FALSE | null | 6 | |*/
	,1 AS OrderMethod											/*Ordering - Order Method (tcibd250.omth) (HYVA) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,10 AS OrderingTimeUnit										/*Ordering - Time Unit for OrderInterval, SafetyTime (tcibd250.oivu, tcibd250.tuni) (Will set "Use Global Item" to no when value <> 99)	| FALSE	| Byte |5;Hours;10;Days;99;"Inherit from Item (defaults)" | */
	,CAST(1 AS FLOAT) AS OrderInterval										/*Ordering - Order Interval  (tcibd250.oint) (HYVA) | FALSE | 0 |  | |*/
	,CAST(0 AS FLOAT) AS SafetyStock							/*Ordering - Safety Stock (tcibd250.sfst)  (HYVA) | FALSE | 0 |  | |*/
	/* Belinda List */
	,CAST(5 AS FLOAT) AS SafetyTime								/*Ordering - Safety Time (tcibd250.sftm) (HYVA) | FALSE | 0 |  | |*/
	/* Belinda List */
	,CAST(1 as float) AS OrderQuantityIncrement
	/* Belinda List */										/*Ordering - Order Quantity Increment (tcibd250.oqmf) (HYVA) | FALSE | 1 |  | |*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity			
	/* Belinda List */															/*Ordering - Minimum Order Quantity (tcibd250.mioq) (HYVA) | FALSE | 0 |  | |*/
	,CAST(99999999.99 AS FLOAT) AS MaximumOrderQuantity
	/* Belinda List */															/*Ordering - Maximum Order Quantity (tcibd250.maoq) (HYVA) | FALSE | 99999999.99 |  | <100000000|*/
	,1 AS FixedOrderQuantity									/*Ordering - Fixed Order Quantity (tcibd250.fioq) (HYVA) | FALSE | 1 |  | |*/
	/* Belinda List */
	,CAST(1 as float) AS EconomicOrderQuantity
																/*Ordering - Economic Order Quantity (tcibd250.ecoq) (HYVA) | FALSE | 1 |  | |*/
	,0 AS ReorderPoint											/*Ordering - Reorder Point (tcibd250.reop) (HYVA) | FALSE | 0 |  | |*/
	, map.LN_Employee_Planner	 AS Planner						/*Ordering - Planner (tcibd250.cplb) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
	,2 AS LotSizeCalculationAllowed								/*Ordering - Lot Size Calculation Allowed (tcibd250.auso)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/

	/* SALES */

	,CAST(scm.Warehouse AS VARCHAR(6)) AS  SalesWarehouse	/*Sales Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	
	/* PURCHASE */

	,CASE WHEN pup.Currency IS NULL THEN 'EUR' ELSE pup.Currency END AS PurchaseCurrency								/*Purchase Currency (tdipu081.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	/* Belinda List */
	,CAST (0 AS FLOAT) AS PurchasePrice								/*Purchase Price (tdipu081.prip) | FALSE | 0 |  | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchaseUnit	/*Purchase Unit (tdipu081.cuqp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NULL THEN kps.InventoryUnit ELSE kps.PurchaseUnitUnit END AS VARCHAR(3)) AS PurchasePriceUnit	/*Purchase Price Unit (tdipu081.cupp) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR (6)) AS SitePurchaseOffice		/*Purchase - Site Purchase Office (tdipu081.cofc) - Reference to tdpur012 Purchase Offices | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'P10.10'
			WHEN 'COMAN2' THEN 'P10.10'
			WHEN 'DPMTO1' THEN 'P10.10'
			WHEN 'GEKIT6' THEN 'P10.10'
			WHEN 'GELCO1' THEN 'P10.10'
			WHEN 'GELTR2' THEN 'P10.10'
			WHEN 'GESCO3' THEN 'P10.10'
			WHEN 'GESTD5' THEN 'P10.10'
			WHEN 'GESTR4' THEN 'P10.10'
			WHEN 'PHMAN2' THEN 'P10.10'
			WHEN 'PHSAL1' THEN 'P10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'P90.10'
			WHEN 'TOGEN1' THEN 'P20.30'
			WHEN 'COFLS4' THEN 'P10.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS PurchasePriceGroup				 /*Purchase Price Group (cpgp)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST
		(CASE 
			WHEN stc.StatisticsGroup IS NULL THEN  '------' ELSE stc.StatisticsGroup
		END
			AS VARCHAR(6)
		) AS PurchaseStatisticsGroup								/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	,CAST(scm.Warehouse AS VARCHAR(6)) AS  PurchaseWarehouse									/*Purchase Warehouse (tdipu081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS PurchaseBuyFromBP					/*Purchase Buy-from Business Partner (tdipu081.otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | |*/
	, mab.LN_Employee_Buyer AS Buyer
	,CAST (null  AS FLOAT) AS SubcontractingPrice
	,0 AS OperationSubcPrice								/*Purchase - Operation Subcontracting Purchase Price (tdipu081.scpr) (HYVA) | FALSE | 0 |  | |*/
	,2 AS PurchaseScheduleInUse								/*Purchase Schedule in Use (tdipu081.scus) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS PurchaseScheduleType								/*Purchase Schedule Type (tdiu081.styp) (HYVA) | FALSE | 1 |  | 1;"Not Applicable (default)";2;"Pull Schedule";3;"Push Schedule"|*/
	,1 AS VendorRating 										/*VendorRating (tdipu081.vryn) | FALSE | 1 |  |  |1;"Yes";2;"No"; ;99 (default);"Inherit from Item (defaults) |*/
	/* Belinda List */
	,CAST(0 as float) AS SupplyTime									/*Purchase - Supply Time (tdipu081.suti) | FALSE | 0 |  | |*/
	,CASE kps.ItemGroup
		WHEN 'CI0001' THEN 2
		ELSE 1
		END AS ReleaseToWarehousing							/*Purchase - Release to Warehousing (tdipu081.retw)  (HYVA) ** NOTE: Only applicable for cost items. For other items types, this field will always be set to yes. | FALSE | 1 |  | 1;"Yes";2;"No"|*/
	,2 AS Inspection										/*Purchase - Inspection (tdipu081.qual) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	/* Belinda List */
	,CAST(null as SMALLDATETIME ) AS LatestPurchasePriceDate /*Purchase - LatestPurchasePriceDate (tdipu180.ltpp) | FALSE | null |  Date/Time | | |*/
	,0 AS  AveragePurchasePrice 							/* Will create record when date is populated */
	/* Belinda List */
	,CAST(null as float) AS LatestPurchasePrice						/* Purchase - LatestPurchasePrice  |FALSE  |  |Decimal |  | |*/
    ,CAST(NULL AS VARCHAR(200)) AS ItemPurchaseText								/*Purchase - Item Text (tttxt010.ctxt)	FALSE |  Memo | | | */
	,0 AS TextIDPurchase									/*Purchase - Text ID  (tdipu081.txtp)	FALSE | Long Integer | | | */

	/* PRODUCTION */

	,2 AS ReceiptInspection									/*Production - Receipt Inspection(tiipd051.iimf) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS OutboundInspection								/*Production - Outbound Inspection (tiipd051.iima) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,2 AS CriticalForInventory								/*Production - Critical for Inventory (tiipf051.cick)  (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,0 AS ScrapPercentage									/*Production - Scrap Percentage (tiipf051.scpf) (HYVA) | FALSE | 0 |  | |*/
	,0 AS ScrapQuantity										/*Production - Scrap Quantity (tiipf051.scpq) (HYVA) | FALSE | 0 |  | |*/
    , CASE 
        WHEN kps.Itemgroup = 'DPMTO1' THEN 2
        WHEN kps.SupplySource = 50 THEN 2
        WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 
        ELSE 2
    END AS Phantom												/*Production - Phantom (tiipf051.cpha) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(9)) AS ShopFloorPlanner			/*Production - Shop Floor Planner (tiipf051.sfpl) - Reference to tccom001 Employees (HYVA) | FALSE | null | 9 | |*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2	-- was 1 
			WHEN 'COMAN2' THEN 2	-- was 1
			WHEN 'DPMTO1' THEN 2	
			WHEN 'GEKIT6' THEN 2
			WHEN 'GELCO1' THEN 2	-- was 1
			WHEN 'GELTR2' THEN 2	-- was 1
			WHEN 'GESCO3' THEN 2	
			WHEN 'GESTD5' THEN 2	-- was 1
			WHEN 'GESTR4' THEN 2	-- was 1
			WHEN 'PHMAN2' THEN 2	-- was 1
			WHEN 'PHSAL1' THEN 2	-- was 1
			WHEN 'PI9999' THEN 2	 
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2	-- was 1
			ELSE 2
		END AS BackflushIfMaterial							/*Production - Allow Backflushing (tiipf051.bfcp) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 2
			WHEN 'COMAN2' THEN 2
			WHEN 'DPMTO1' THEN 2	-- was 1
			WHEN 'GEKIT6' THEN 2	-- was 1
			WHEN 'GELCO1' THEN 2
			WHEN 'GELTR2' THEN 2
			WHEN 'GESCO3' THEN 2
			WHEN 'GESTD5' THEN 2
			WHEN 'GESTR4' THEN 2
			WHEN 'PHMAN2' THEN 2
			WHEN 'PHSAL1' THEN 2
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS BackflushMaterials								/*Production - Backflush Materials (tiipf051.bfep) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,1 AS BackflushHours									/*Production - Backflush Hours (tiipd051.bfhr)  (Will set "Use Global Item" to no when value <> 99)	| FALSE |Byte| |1;"Yes";2;"No";99;"Inherit from Item (defaults)" */
	,CASE 
		WHEN kps.Itemgroup = 'DPMTO1' THEN 1
		WHEN kps.SupplySource = 50 THEN 1
		WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 2 
		ELSE 1
	 END AS DirectInitiateInventoryIssue						/*Production - Direct Initiate Inventory Issue (tiipf051.drin) (HYVA) | FALSE | null |  | 1;"Yes";2;"No (default)"|*/
	,2 AS DirectProcessWHOrderLine							/*Production - Direct Process Warehouse Order Line (tiipd051.dris) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/

	/* SERVICE */

	,CAST(NULL AS VARCHAR(9)) AS ServiceDepartment			/*Service Operations Department (tsmdm220.mdpt) - Reference to tdmdm100 Service Departments | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/

	/* WAREHOUSE */

	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ItemValuationGroup			/*Warehousing - Item Valuation Group (whwmd404.ivgr)   - Reference to whina101 Item Valuation Groups (HYVA) | FALSE | null | 6 | |*/
	,1 AS LocationControlled								/*Warehousing - Location Controlled (whwmd404.locc) (HYVA) | FALSE | 0 |  | 1;"Yes";2;"No"|*/
	,1 AS ProcessInvVariances								/*Warehousing - Process Inventory Variances Automatically (whwmd404.prva) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,20 AS UseOrderingData									/*Warehousing - Use Item Ordering Data by Site (whwmd404.uidt) (HYVA) | FALSE | 10 |  | 10;"Yes";20;"No";30;"Apply Warehouse Default"|*/
	,60 AS DefaultSupplySystem								/*Warehousing - Default Supply System (whwmd404.dwhs) (HYVA) | FALSE | 70 |  | 10;"Time-Phased Order Point";20;"KANBAN";30;"Order Controlled/Batch";40;"Order Controlled/SILS";50;"Order Controlled/Single";60;"Apply Warehouse Defaults";70;"None (default)"|*/
	,2 AS GenerateOrderAdvices								/*Warehousing - Generate Order Advices (whwmd404.goad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS CombineOrderAdvices								/*Warehousing - Combine Order Advices (whwmd404.coad) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,2 AS ConfirmOrderAdvices								/*Warehousing - Automatically Confirm Order Advices (whwmd404.acoa) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No"|  KANBAN*/
	,CAST(null AS VARCHAR(1)) AS ABCcode					/*Warehousing - ABC Code (whwmd404.abcc) (HYVA) | FALSE | null | 1 | |*/
	,CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 1
			WHEN 'COMAN2' THEN 1
			WHEN 'DPMTO1' THEN 1
			WHEN 'GEKIT6' THEN 1
			WHEN 'GELCO1' THEN 1
			WHEN 'GELTR2' THEN 1
			WHEN 'GESCO3' THEN 1
			WHEN 'GESTD5' THEN 1
			WHEN 'GESTR4' THEN 1
			WHEN 'PHMAN2' THEN 1
			WHEN 'PHSAL1' THEN 1
			WHEN 'PI9999' THEN 2
			WHEN 'CI0001' THEN 2
			WHEN 'TOGEN1' THEN 2
			WHEN 'COFLS4' THEN 2
			ELSE 2
		END AS HandlingUnitInUse								/*Warehousing - Handling Units in Use(whwmd404.uhnd) (HYVA) |  | 2 |  | 1;"Yes";2;"No"|*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND (kps.POV3 <> 0))
	JOIN 
		(
			select
				distinct 
				 t1.Subcontractor
				,t1.Item
			from
				(
			select
				distinct  
					 t1.Subcontractor as Subcontractor
					,t1.ProductItem as Item
			from
				(
					SELECT
						 'PROJEMPTY' AS ProductProject												/*Project segment of Product (tisub100/110.item) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                   Infor LN tables: tisub100, tisub110 | TRUE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tisub100/110.item) - References to tcibd001 Item General Data | TRUE | '' |Text | 38 | |*/	
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN '' ELSE bps.[Business Partner] END AS VARCHAR(9)) AS Subcontractor														/*Subcontractor (tisub100/110.subc) - Reference tccom120 Buy-from Business Partners | TRUE | '' |Text | 9 | |*/
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN '' ELSE bps.[Business Partner] END AS VARCHAR(9)) AS ShipFromBP  	/*Ship-from Business Partner (tisub100/110.sfbp) - Reference tccom121 Ship-from Business Partners ** At least fill with same value as Subcontractor | TRUE | '' |Text | 9 | |*/
						,'IT.POV.03' AS Site														/*Site (tisub100/110.site) - References to tcemm050 Sites | FALSE | '' |Text | 9 | |*/
						,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))* 10 AS Position																/*Position (tisub110.pono) | TRUE | 1 |Long Integer |  | |*/
						,20 AS Status																/*Subcontracting Model Status (tisub100.psta) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |Byte |  | 10;"New";20;"Approved";30;"Expired"|*/
						,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tisub100.efdt) | TRUE | null |Date/Time |  | |*/
						,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tisub100.exdt)  - When empty, date will be set to MAX | TRUE | null |Date/Time |  | |*/
						,CAST(bps.POV3 AS VARCHAR(6)) AS SubcontractorWarehouse						/*Subcontractor Warehouse (tisub100.cwar) - References tcmcs003 Warehouses | FALSE | '' |Text | 6 | |*/
						,1 AS BomQuantity															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,2 AS UseForCosting															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,2 AS UseForPlanning														/*Use for Planning (tisub100.crip) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,'PROJEMPTY' AS MaterialProject												/*Project segment of Material (tisub110.sitm) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | FALSE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(kpc.ItemLnCE AS VARCHAR(38))  AS MaterialItem							/*Item segment of Sub Item (tisub110.sitm) - References to tcibd001 General Item Data | FALSE | '' |Text | 38 | |*/
						,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
							CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
								ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
								END		
							END AS FLOAT) AS  MaterialQuantity										/*Material Quantity (tisub110.qana) - Material Quantity | TRUE | 1 |Decimal |  | >0|*/
						,0 AS ScrapPercentage														/*Scrap Percentage (tisub110.scpf) |  | 0 |Decimal |  | |*/
						,CAST(sms.Warehouse AS VARCHAR(6)) AS  SupplyingWarehouse					/*Supplying Warehouse (tisub110.cwar)  - References tcmcs003 Warehouses |  | '' |Text | 6 | |*/
					---	,cast(scc.SupplySystem as float) as SupplySystem

					FROM
						KPRAKTOR.SIAPR.DISBASE bom
						JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)	
						JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1)
						JOIN ZZZ_Italy.dbo.KPSourceSP kpp ON (kps.Item = kpp.Item)
						Left join ZZZ_Italy.dbo.SubContractorSupplier scs on (kps.ItemLnCE = scs.Item and scs.Type = 'Product')
						LEFT JOIN ZZZ_Italy.dbo.BP_Conv bps ON (scs.Subcontractor = bps.KPraktor)
						JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)	
						JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kpc.Class NOT IN (4))
						LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
						Left join ZZZ_Italy.dbo.SubContractorSupplier scc on (kpc.ItemLnCE = scc.Item and scc.Type = 'Material')
						LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (scc.[Supplying BP] = bpc.KPraktor)
						LEFT JOIN ZZZ_Italy.dbo.SCModelMap sms ON (kps.POV3 = sms.POV3 AND sms.Site = 'IT.POV.03')
					---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F tac ON (itm.MG_DITTA = tac.TED_DITTA AND itm.MG_ESPL_DB = tac.TED_ESPL_DB)
					---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F taf ON (its.MG_DITTA = taf.TED_DITTA AND its.MG_ESPL_DB = taf.TED_ESPL_DB)
					WHERE
						bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
						AND kpp.SupplySource IN ('50')
						AND (kps.POV3 <> 0)
			) t1

			UNION ALL

			select
				distinct  
					 t1.Subcontractor as Subcontractor
					,t1.MaterialItem as Item
			from
				(
					SELECT
						 'PROJEMPTY' AS ProductProject												/*Project segment of Product (tisub100/110.item) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                   Infor LN tables: tisub100, tisub110 | TRUE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tisub100/110.item) - References to tcibd001 Item General Data | TRUE | '' |Text | 38 | |*/	
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN '' ELSE bps.[Business Partner] END AS VARCHAR(9)) AS Subcontractor														/*Subcontractor (tisub100/110.subc) - Reference tccom120 Buy-from Business Partners | TRUE | '' |Text | 9 | |*/
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN '' ELSE bps.[Business Partner] END AS VARCHAR(9)) AS ShipFromBP  	/*Ship-from Business Partner (tisub100/110.sfbp) - Reference tccom121 Ship-from Business Partners ** At least fill with same value as Subcontractor | TRUE | '' |Text | 9 | |*/
						,'IT.POV.03' AS Site														/*Site (tisub100/110.site) - References to tcemm050 Sites | FALSE | '' |Text | 9 | |*/
						,(ROW_NUMBER() OVER (PARTITION BY bom.DB_CODICE_PADRE, bom.DB_DITTA  ORDER BY bom.DB_CODICE_PADRE, bom.DB_SEQ, bom.DB_CODICE_FIGLIO ASC))* 10 AS Position																/*Position (tisub110.pono) | TRUE | 1 |Long Integer |  | |*/
						,20 AS Status																/*Subcontracting Model Status (tisub100.psta) When loading with DAL, use status 10 (new) and approve as post conversion action. | TRUE | 20 |Byte |  | 10;"New";20;"Approved";30;"Expired"|*/
						,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate				/*Effective Date (tisub100.efdt) | TRUE | null |Date/Time |  | |*/
						,CAST(NULL AS SMALLDATETIME) AS ExpiryDate									/*Expiry Date (tisub100.exdt)  - When empty, date will be set to MAX | TRUE | null |Date/Time |  | |*/
						,CAST(bps.POV3 AS VARCHAR(6)) AS SubcontractorWarehouse						/*Subcontractor Warehouse (tisub100.cwar) - References tcmcs003 Warehouses | FALSE | '' |Text | 6 | |*/
						,1 AS BomQuantity															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,2 AS UseForCosting															/*Use for Planning (tisub100.sufc) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,2 AS UseForPlanning														/*Use for Planning (tisub100.crip) | TRUE | 2 |Byte |  | 1;"Yes";2;"No (default)"|*/
						,'PROJEMPTY' AS MaterialProject												/*Project segment of Material (tisub110.sitm) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | FALSE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(kpc.ItemLnCE AS VARCHAR(38))  AS MaterialItem							/*Item segment of Sub Item (tisub110.sitm) - References to tcibd001 General Item Data | FALSE | '' |Text | 38 | |*/
						,CAST(CASE WHEN kps.Class IN (4) THEN 0 ELSE 
							CASE WHEN ucf.ItemLnCe IS NULL THEN bom.DB_QTA_UTILIZZO
								ELSE bom.DB_QTA_UTILIZZO * ucf.Factor
								END		
							END AS FLOAT) AS  MaterialQuantity										/*Material Quantity (tisub110.qana) - Material Quantity | TRUE | 1 |Decimal |  | >0|*/
						,0 AS ScrapPercentage														/*Scrap Percentage (tisub110.scpf) |  | 0 |Decimal |  | |*/
						,CAST(sms.Warehouse AS VARCHAR(6)) AS  SupplyingWarehouse					/*Supplying Warehouse (tisub110.cwar)  - References tcmcs003 Warehouses |  | '' |Text | 6 | |*/
					---	,cast(scc.SupplySystem as float) as SupplySystem

					FROM
						KPRAKTOR.SIAPR.DISBASE bom
						JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (bom.DB_CODICE_PADRE = itm.MG_CODICE AND bom.DB_DITTA = itm.MG_DITTA)	
						JOIN ZZZ_Italy.dbo.KPSource kps ON (bom.DB_CODICE_PADRE = kps.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1)
						JOIN ZZZ_Italy.dbo.KPSourceSP kpp ON (kps.Item = kpp.Item)
						Left join ZZZ_Italy.dbo.SubContractorSupplier scs on (kps.ItemLnCE = scs.Item and scs.Type = 'Product')
						LEFT JOIN ZZZ_Italy.dbo.BP_Conv bps ON (scs.Subcontractor = bps.KPraktor)
						JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)	
						JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kpc.Class NOT IN (4))
						LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
						Left join ZZZ_Italy.dbo.SubContractorSupplier scc on (kpc.ItemLnCE = scc.Item and scc.Type = 'Material')
						LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (scc.[Supplying BP] = bpc.KPraktor)
						LEFT JOIN ZZZ_Italy.dbo.SCModelMap sms ON (kps.POV3 = sms.POV3 AND sms.Site = 'IT.POV.03')
					---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F tac ON (itm.MG_DITTA = tac.TED_DITTA AND itm.MG_ESPL_DB = tac.TED_ESPL_DB)
					---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F taf ON (its.MG_DITTA = taf.TED_DITTA AND its.MG_ESPL_DB = taf.TED_ESPL_DB)
					WHERE
						bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
						AND kpp.SupplySource IN ('50')
						AND (kps.POV3 <> 0)
			) t1
			) t1
	)scs on (kps.ItemLnCE = scs.Item)
---	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpa on (scs.Subcontractor = bpa.[Business Partner])
	JOIN ZZZ_Italy.dbo.SCModelMap scm ON (scs. Subcontractor = scm.BusinessPartner and scm.Site = 'IT.EXT.09')
	LEFT JOIN KPRAKTOR.SIAPR.ANAGES pla ON (itm.MG_CODICE = pla.GE_CODICE_ART AND itm.MG_DITTA = pla.GE_DITTA)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (itm.MG_CODFOR_PREF = bpc.KPraktor AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pup ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND pup.Subcontract = 0)
	LEFT JOIN ZZZ_Italy.dbo.PurchasePrices pus ON (itm.MG_CODICE =  pup.Item AND itm.MG_DITTA = 1 AND pup.Subcontract = 1)
	LEFT JOIN ZZZ_Italy.dbo.SelectionCode sec ON (itm.MG_TIP_REC = sec.Code AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.StatisticsGroep_Conv stc ON (itm.MG_TIP_REC = stc.ProductType AND itm.MG_DITTA = 1)
	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] mab ON ( mab.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
	LEFT JOIN [ZZZ_Italy].[dbo].[MappingPlannerBuyer] map ON ( map.KPraktorSupplier = itm.MG_CODFOR_PREF ) 
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
		)bol ON (kps.Item = bol.item)


GO


