USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_Items]    Script Date: 2/26/2024 12:04:24 PM ******/
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

All items that are have the value Migrate  = 0 must have the ItemGroup PI9999 and the Signal Code must be '9999'. Check if Item Signal exist in Ln

*/

ALTER VIEW [dbo].[vw_Items] AS 



SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project									/*Project segment of Item (item)  - Reference to tcmcs052 Projects. If not used then fill with "PROJEMPTY".                   ERPLN table: tcibd001, tcibd100, cprpd100, cprpd120,tcibd200, tdipu001, tdisa001, tiipd001,ticpr007,tsmdm200, whwmd400, tppdm005 | TRUE | 'PROJEMPTY' | 9 | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item									/*Item segment of Item (item) | TRUE | null | 38 | 38 | |*/

	/* General */
	,CAST(CASE WHEN kps.ItemDescriptionGB IS NOT NULL THEN kps.ItemDescriptionGB 
		ELSE 
			CASE WHEN kps.ItemDescriptionIT IS NOT NULL THEN kps.ItemDescriptionIT
				ELSE SUBSTRING(KPRAKTOR.dbo.fn_ProperCase(KPRAKTOR.dbo.fn_RemoveMultipleSpaces(RTRIM(itm.MG_DESCRI) + ' ' + LTRIM(RTRIM(itm.MG_MISURE)))),1,60)
				END
		END AS VARCHAR(60)) AS ItemDescription									/*Description (tcibd001.dsca) | TRUE | null | 30 | 30 | |*/
	,kps.ItemType AS ItemType													/*Item Type (tcibd001.kitm) | FALSE | 30 |  |  | 30;"Product";40;"Tool";60;"Subcontracted Service";70;"Cost";80;"Service";90;"Generic"|*/		
	,kps.ItemGroup AS ItemGroup													/*Item Group (tcibd001.citg)  - Reference to tcmcs023 Item Groups | FALSE | null | 6 | 6 |  |*/
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
	 END AS ItemSalesData													/*Item Sales Data (tdisa001) | FALSE | 1 |  |  | 1;"Yes";2;"No"|*/
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
	 END AS ItemPurchaseData													/*Item Purchase Data (tdipu001) | FALSE | 1 |  |  | 1;"Yes";2;"No"|*/
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
		WHEN 'CI0001' THEN 2
		WHEN 'TOGEN1' THEN 2
		WHEN 'COFLS4' THEN 2
		ELSE  
			CASE WHEN kps.ItemGroup = 'PI9999' AND bol.lines >0 THEN 1
				ELSE 2
				END
	 END AS ItemProductionData													/*Item Production Data (tiipd001) | FALSE | 1 |  |  | 1;"Yes";2;"No"|*/
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
	 END AS ItemOrderingData													/*Item Ordering Data (tcibd200) | FALSE | 1 |  |  | 1;"Yes";2;"No"|*/
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
	 END AS ItemServiceData														/*Item Service Data (tsmdm200)   -- Package TS Service is implemented -- | FALSE | 2 |  |  | 1;"Yes";2;"No"|*/
	,2 AS ItemProjectData														/*Item Project Data (tppdm005)    -- Package TP Project is implemented -- | FALSE | 2 |  |  | 1;"Yes";2;"No"|*/
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
		WHEN 'CI0001' THEN 2
		WHEN 'TOGEN1' THEN 2
		WHEN 'COFLS4' THEN 2
		ELSE 2 
	 END AS ItemQualityData														/*Item Quality Data (qmptc018)    -- Package QM Quality Management is implemented -- | TRUE | 2 |  |  | 1;"Yes";2;"No"|*/
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
		WHEN 'CI0001' THEN 2
		WHEN 'TOGEN1' THEN 2
		WHEN 'COFLS4' THEN 2
		ELSE 2 
	 END AS ItemFreightData														/*Item Freight Data (fmfmd100)    -- Package FM Freight Management is implemented -- | TRUE | 2 |  |  | 1;"Yes";2;"No"|*/
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
		WHEN 'PI9999' THEN 9
		WHEN 'CI0001' THEN 9
		WHEN 'TOGEN1' THEN 9
		WHEN 'COFLS4' THEN 9 ---
		ELSE 2 
	 END AS OrderSystem															/*Order System (osys) | TRUE | 9 |  |  | 1;"SIC";2;"Planned";4;"FAS";9;"Manual (Default)"|*/
	,CAST('000010' AS VARCHAR(6)) AS UnitSet											/*Unit Set (tcibd001.uset)   - Reference to tcmcs006 Unit Sets | FALSE | null | 6 | 6 | |*/
	,CAST(kps.InventoryUnit	AS VARCHAR(3)) AS InventoryUnit								/*Inventory Unit (tcibd001.cuni)  - Reference to tcmcs001 Units | TRUE | null | 3 | 3 | |*/
	,CAST(CASE WHEN Migrate = 0 THEN '9999'
		ELSE
			CASE itm.MG_FLAG_FUORI_PROD
				WHEN 'M' THEN '180'
				WHEN 'N' THEN '' ---'000'
				WHEN 'O' THEN '016'
				WHEN 'P' THEN '170'
				WHEN 'Q' THEN '170'
				WHEN 'S' THEN '005'
				WHEN 'V' THEN '' ---'000'
				ELSE ''
			END
		END AS VARCHAR(3)) AS ItemSignal												/*Item Signal (tcibd001.csig)   - Reference to  tcmcs018 Item Signals | FALSE | null | 3 | 3 | |*/

/* 21-02-2024 KL  SearchKeyI and SearchKeyII set to NULL to avoid MLE on the key  	*/
/*	,SUBSTRING(CAST(CASE WHEN kps.ItemDescriptionGB IS NOT NULL THEN kps.ItemDescriptionGB 
		ELSE 
			CASE WHEN kps.ItemDescriptionIT IS NOT NULL THEN kps.ItemDescriptionIT
				ELSE SUBSTRING(KPRAKTOR.dbo.fn_ProperCase(KPRAKTOR.dbo.fn_RemoveMultipleSpaces(RTRIM(itm.MG_DESCRI) + ' ' + LTRIM(RTRIM(itm.MG_MISURE)))),1,60)
				END
		END AS VARCHAR(60)),1,16) AS SearchKeyI											/*Search Key I (tcibd001.seak) | FALSE | null | 16 | 16 | |*/
	,CAST (kps.ItemLnCe AS VARCHAR (16) ) AS SearchKeyII								/*Search Key II (tcibd001.seab) | FALSE | null | 16 | 16 | |*/
*/ 

	, CAST(NULL AS VARCHAR(16)) AS  SearchKeyI
	, CAST(NULL AS VARCHAR(16)) AS  SearchKeyII



	,CAST(CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 'LN-CM'
		WHEN 'COMAN2' THEN 'LN-CM'
		WHEN 'DPMTO1' THEN 'LN-CM'
		WHEN 'GEKIT6' THEN 'LN-CM'
		WHEN 'GELCO1' THEN 'LN-CM'
		WHEN 'GELTR2' THEN 'LN-CM'
		WHEN 'GESCO3' THEN 'LN-CM'
		WHEN 'GESTD5' THEN 'LN-CM'
		WHEN 'GESTR4' THEN 'LN-CM'
		WHEN 'PHMAN2' THEN 'LN-CM'
		WHEN 'PHSAL1' THEN 'LN-CM'
		WHEN 'PI9999' THEN NULL
		WHEN 'CI0001' THEN 'GC00.010'
		WHEN 'TOGEN1' THEN 'MC00.020'
		WHEN 'COFLS4' THEN 'LN-CM'
		ELSE NULL
	 END AS VARCHAR(8)) AS CostComponent									/*Cost Component (cpcp)  - Reference to  tcmcs048 Cost Components ** Mandatory for cost and service items, optional for other items | TRUE | null | 8 | 8 | |*/
	,CASE kps.ItemGroup
		WHEN 'GELCO1' THEN 1
		WHEN 'GELTR2' THEN 1
		ELSE 2 
		END AS LotControlled														/*Lot Controlled (tcibd001.ltct) | FALSE | 2 |  |  | 1;"Yes";2;"No"|*/
	,CASE kps.ItemGroup
		WHEN 'DPMTO1' THEN 1
		WHEN 'GESCO3' THEN 1
		WHEN 'GESTR4' THEN 1
		WHEN 'TOGEN1' THEN 1
		ELSE 2 
	 END AS Serialized														/*Serialized (tcibd001.seri) | TRUE | 2 |  |  | 1;"Yes";2;"No"|*/
	,CAST(kps.Weight AS FLOAT) AS [Weight]												/*Weight (tcibd001.wght) | FALSE | 0 |  |  | |*/
	,CAST('kg' AS VARCHAR(3)) AS WeightUnit												/*Weight Unit (tcibd001.cwun)   - Reference to tcmcs001 Units | FALSE | null | 3 | 3 | |*/
	,CAST(NULL AS VARCHAR(30)) AS Material												/*Material (tcibd001.dscb) | FALSE | null | 30 | 30 | |*/
	,CAST(NULL AS VARCHAR(30)) AS Size													/*Size (tcibd001.dscc) | FALSE | null | 30 | 30 | |*/
	,CAST(NULL AS VARCHAR(30)) AS [Standard]											/*Standard (tcibd001.dscd) | FALSE | null | 30 | 30 | |*/


/*  KL : 21-02-2024 ProductType from new table ProductLine_Type */
--	,CAST(prt.ProductType AS VARCHAR(3)) AS ProductType									/*Product Type (tcibd001.ctyp)   - Reference to tcmcs015 Product Types | FALSE | null | 3 | 3 | |*/
	,CAST(CASE WHEN (plt.ProductType)  IS NULL THEN '------' 
			   ELSE plt.ProductType 
		  END AS VARCHAR(3)) AS ProductType 		
	,CAST(NULL AS VARCHAR(6)) AS ProductClass											/*Product Class (tcibd001.cpcl)   - Reference to  tcmcs062 Product Classes | FALSE | null | 6 | 6 | |*/

	
/* 21-02-2024 KL : When ProductLine is NULL then ----  */ 	
--	,CAST(CASE WHEN LEN(TRIM(kps.ProductLine)) = 0 THEN '------' ELSE kps.ProductLine END AS VARCHAR(6)) AS ProductLine /*Product Line (tcibd001.cpln)   - Reference to tcmcs061 Product Lines | FALSE | null | 6 | 6 | |*/
	,CAST(CASE WHEN (kps.ProductLine) IS NULL THEN '------' ELSE kps.ProductLine END AS VARCHAR(6)) AS ProductLine 
	
	,CAST(NULL AS VARCHAR(6)) AS Manufacturer											/*Manufacturer (tcibd001.cmnf)   - Reference to  tcmcs060 Manufacturers | TRUE | null | 6 | 6 | |*/

/* 21-02-2024 KL:  Fill SelectionCode with ProductType */
---	,CAST(NULL AS VARCHAR(3)) AS SelectionCode											/*Selection Code (tcibd001.csel)   - Reference to tcmcs022 Selection Codes | FALSE | null | 3 | 3 | |*/

/* 26-02-2024 ProductType table has been chnaged to SelectionCode table (sec) */
	,CAST(sec.SelectionCode AS VARCHAR(3)) AS SelectionCode



	,CAST(NULL AS VARCHAR(9)) AS TechnicalCoordinator									/*Technical Coordinator (tcibd001.cood)   - Reference to  tccom001 Employees | FALSE | null | 9 | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ResponsibleDepartment									/*Responsible Department (tcibd001.rpdt)  - Reference to tcmcs065(Departments) | FALSE | null | 6 | 6 | |*/
	,2 AS CriticalSafetyItem															/*Critical Safety Item(tcibd001.icsi) | FALSE | 2 |  |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(3)) AS CountryOrigin											/*Country of Origin (tcibd001.ctyo)   - Reference to  tcmcs010 Countries | FALSE | null | 3 | 3 | |*/
	,CAST(NULL AS VARCHAR(14)) AS EANCode												/*EAN Code (tcibd001.cean) | FALSE | null | 14 | 14 | |*/
	,CAST(NULL AS VARCHAR(25)) AS CommodityCode											/*Harmonized System Code (ccde)   - Reference to tcmcs028 Harmonized System Codes | FALSE | null | 25 | 25 | |*/

	/* Ordering - Purchase */

	,CAST(NULL AS VARCHAR(6)) AS Warehouse												/*Warehouse (cwar)  - Reference to  tcmcs003 Warehouses ** Only when Item by Site functionality is not used. | TRUE | null | 6 | 6 | |*/

	/* Ordering */

	,1 AS OrderMethod																	/*Order Method (omth) | TRUE | 1 |  |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,10 AS OrderingTimeUnit																/*Ordering - Time Unit for OrderInterval, SafetyTime (tcibd200.oivu, tcibd200.tuni) | FALSE | | | 5;Hours;10;Days | */
	,0 AS OrderInterval																	/*Order Interval  (oint) | FALSE | 0 |  |  | 5;"Hours";10;"Days"|*/
	,0 AS SafetyStock																	/*Safety Stock (sfst) | FALSE | 0 |  |  | |*/
	,0 AS SafetyTime																	/*Safety Time (sftm) | FALSE | 0 |  |  | |*/
	,0 AS ReorderPoint																	/*Reorder Point (reop) | FALSE | 0 |  |  | |*/
	,CAST(NULL AS VARCHAR(9)) AS Planner												/*Ordering - Planner (tcibd200.cplb) - Reference to tccom001 Employees | FALSE | TEXT | 9 | | */
	,1 AS OrderQuantityIncrement														/*Order Quantity Increment (oqmf) | FALSE | 1 |  |  | |*/
	,1 AS MinimumOrderQuantity															/*Minimum Order Quantity (mioq) | FALSE | 0 |  |  | |*/
	,99999999.99 AS MaximumOrderQuantity												/*Maximum Order Quantity (maoq) | FALSE | 99999999.99 |  |  | <100000000|*/
	,1 AS FixedOrderQuantity															/*Fixed Order Quantity (fioq) | FALSE | 1 |  |  | |*/
	,2 AS LotSizeCalculationAllowed														/*Ordering - Lot Size Calculation Allowed (tcibd200.auso) | | | 1;"Yes";2;"No" */
	,1 AS EconomicOrderQuantity															/*Economic Order Quantity (ecoq) | FALSE | 1 |  |  | |*/
	,999999999 AS MaximumInventory														/*Maximum Inventory (maxs) | FALSE | 999999999 |  |  | <1000000000|*/

	/* Purchase */

	,CAST(NULL AS VARCHAR(9)) AS BuyFromBusinessPartner									/*Buy-from Business Partner (otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | 9 | |*/
	,CAST(NULL AS VARCHAR(9)) AS Buyer													/*Buyer (buyr)   - References tccom001 Employees | FALSE | null | 9 | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS PurchaseOffice											/*Purchase Office (cofc)   - References Purchase Offices | FALSE | null | 6 | 6 | |*/
/* Check Purchase Units */
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PurchaseUnit								/*Purchase Unit (tdipu001.cuqp)  - Reference to tcmcs001 Units ** Mandatory when ItemPurchaseData is selected | TRUE | null | 3 | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PurchasePriceUnit							/*Purchase Price Unit (tdipu001.cupp)  - Reference to tcmcs001 Units ** Mandatory when ItemPurchaseData is selected | TRUE | null | 3 | 3 | |*/
	,CAST('USD' AS VARCHAR(3)) AS PurchaseCurrency										/*Currency (tdipu001.ccur)  - Reference to tcmcs002 Currencies ** Mandatory when ItemPurchaseData is selected | TRUE | null | 3 | 3 | |*/
	,CAST(NULL AS VARCHAR(9)) AS TaxCodePurchase										/*Tax Code Purchase (cvat)    - Reference to tcmcs037 Tax Codes | FALSE | null | 9 | 9 | |*/
/* 29-08-2023 When NULL fill with '------'  */
--	,CAST(stc.StatisticsGroup AS VARCHAR(6)) AS PurchaseStatisticsGroup					/*Purchase Statistics Group (tdipu001.csgp)  - Reference to  tcmcs044 Statistical Groups ** Mandatory when ItemPurchaseData is selected | FALSE | null | 6 | 6 | |*/
	,CAST
		(CASE 
		 WHEN stc.StatisticsGroup IS NULL THEN  '------' ELSE stc.StatisticsGroup
		 END
		  AS VARCHAR(6)
		) AS PurchaseStatisticsGroup													/*Purchase Statistics Group (tdipu001.csgp)  - Reference to  tcmcs044 Statistical Groups ** Mandatory when ItemPurchaseData is selected | FALSE | null | 6 | 6 | |*/

	,0 AS PurchasePrice																	/*Purchase Price (prip) | FALSE | 0 |  |  | |*/
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
	 END AS VARCHAR(6)) AS PurchasePriceGroup											/*Purchase Price Group (tdipu001.cpgp)  - Reference to  tcmcs024 Price Groups ** Mandatory when ItemPurchaseData is selected | TRUE | null | 6 | 6 | |*/
	,2 AS PurchaseScheduleInUse															/*Purchase Schedule in Use (tdipu081.scus) | TRUE | 2 |  |  | 1;"Yes";2;"No (default)"|*/
	,1 AS ScheduleType																	/*Schedule Type (tdipu081.styp) | FALSE | 1 |  |  | 1;"Not Applicable (default)";2;"Pull Schedule";3;"Push Schedule"|*/
	,0 AS SupplyTime																	/*Supply Time (suti) | TRUE | 0 |  |  | |*/
/* 09-03-2022  New field : VendorRating */
	,1 AS VendorRating 												 					/*VendorRating (tdipu001.vryn) | FALSE | 1 |  |  |1;"Yes";2;"No" |*/
	,10 AS UnitforSupplyTime															/*Unit for Supply Time (sutu) | FALSE | 10 |  |  | 5;"Hours";10;"Days (default)"|*/
	,1 AS ReleaseToWarehousing															/*Purchase - Release to Warehousing (tdipu001.retw) ** NOTE: Only applicable for cost items. For other items types, this field will always be set to yes. | | | 1;"Yes";2;"No" | */
	,2 AS Inspection																	/*Inspection (tdipu001.qual) | FALSE | 2 |  |  | 1;"Yes";2;"No (default)"|*/

	/* Sales */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS SalesUnit									/*Sales Unit (tdisa001.cuqs)  - References tcmcs001 Units ** Mandatory when ItemSalesData is selected | TRUE | null | 3 | 3 | |*/
	,CAST('USD' AS VARCHAR(3)) AS SalesCurrency											/*Sales Currency (tdisa001.ccur)  - Reference to tcmcs002 Currencies ** Mandatory when ItemSalesData is selected | TRUE | null | 3 | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS SalesPriceUnit							/*Sales Price Unit (tdisa001.cups)  - References tcmcs001 Units ** Mandatory when ItemSalesData is selected | TRUE | null | 3 | 3 | |*/
	,0 AS SalesPrice																	/*Sales Price (pris) | FALSE | 0 |  |  | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'S10.10'
			WHEN 'COMAN2' THEN 'S10.10'
			WHEN 'DPMTO1' THEN 'S10.20'
			WHEN 'GEKIT6' THEN 'S10.30'
			WHEN 'GELCO1' THEN 'S10.10'
			WHEN 'GELTR2' THEN 'S10.10'
			WHEN 'GESCO3' THEN 'S10.10'
			WHEN 'GESTD5' THEN 'S10.10'
			WHEN 'GESTR4' THEN 'S10.10'
			WHEN 'PHMAN2' THEN 'S10.10'
			WHEN 'PHSAL1' THEN 'S10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'S90.10'
			WHEN 'TOGEN1' THEN NULL
			WHEN 'COFLS4' THEN 'S10.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS SalesPriceGroup												/*Sales Price Group (tdisa001.cpgs)   - References tcmcs024 Price Groups ** Mandatory when ItemSalesData is selected | TRUE | null | 6 | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS SalesStatisticsGroup								/*Sales Statistics Group (tdisa001.csgs)   - References tcmcs044 Statistical Groups ** Mandatory when ItemSalesData is selected | TRUE | null | 6 | 6 | |*/
	,0 AS SuggestedRetailPrice															/*Suggested Retail Price (prir) | FALSE | 0 |  |  | |*/
	,CAST(NULL AS VARCHAR(9)) AS TaxCodeSales											/*Tax Code Sales (cvat)   - Reference to tcmcs037 Tax Codes | FALSE | null | 9 | 9 | |*/

	/* Production */

	,0 AS BOMQuantity																	/*BOM Quantity (unom) | FALSE | 0 |  |  | |*/
	,0 AS RoutingQuantity																/*Routing Quantity (runi) | FALSE | 0 |  |  | |*/
	,0 AS OrderLeadTime																	/*Order Lead Time (oltm) | FALSE | 0 |  |  | |*/
	,10 AS OrderLeadTimeUnit															/*Order Lead Time Unit (oltu) | FALSE | 5 |  |  | 5;"Hours (default)";10;"Days"|*/
	,2 AS OutboundInspection															/*Production - Outbound Inspection (tiipd001.iima) | FALSE | |	1;"Yes";2;"No" |*/
	,2 AS CriticalForInventory															/*Production - Critical for Inventory (tiipf001.cick) |	FALSE | | 1;"Yes";2;"No" | */
/* 19-07 */
	,CASE WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06')  THEN 1 ELSE 2 END AS Phantom	/*Phantom (cpha) | FALSE | 2 |  |  | 1;"Yes";2;"No (default)"|*/
	
	,2 AS UsePhantomInventory															/*Use Phantom Inventory (phst) | FALSE | 2 |  |  | 1;"Yes";2;"No (default)"|*/
	,0 AS ScrapFactor																	/*Scrap Factor (scpf) | FALSE | 0 |  |  | |*/
	,0 AS ScrapQuantity																	/*Scrap Quantity (scpq) | FALSE | 0 |  |  | |*/
	,2 AS ReceiptInspection																/*Production - Receipt Inspection(tiipd001.iimf) | FALSE | | 1;"Yes";2;"No" |*/

/* 21-02-2024 KL  BackflusIfMaterial must be 2 ( Info Gideon ) */
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
		END AS BackflushIfMaterial														/*Backflush If Material (bfcp) | FALSE | 2 |  |  | 1;"Yes";2;"No (default)"|*/

/* 21-02-2024 KL  BackflusMaterial must be 2 ( Info Gideon ) */
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
		END AS BackflushMaterials														/*Backflush Materials (bfep) | FALSE | 2 |  |  | 1;"Yes";2;"No (default)"|*/
	,2 AS BackflushHours																/*Backflush Hours (bfhr) | FALSE | 2 |  |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(9)) AS ShopFloorPlanner										/*Shop Floor Planner (sfpl) | FALSE | null | 9 | 9 | |*/
 	,CAST ( '------' AS VARCHAR(6)) AS  SerializedItemGroup								/*Serialized Item Group (tsmdm200.sigr)   - References tscfg010 Object Groups ** Mandatory when ItemServiceData is selected | TRUE | null | 6 | 6 | |*/

	/* service */

	,CAST('USD' AS VARCHAR(3)) AS ServiceCurrency										/*Service Currency (tsmdm200.ccur)   - References tcsmcs002 Currencies ** Mandatory when ItemServiceData is selected | TRUE | null | 3 | 3 | |*/
	,CAST ( '------' AS VARCHAR(6)) AS ServiceItemGroup									/*Service Item Group (tsmdm200.csgr)   - References tsmdm210 Service Item Groups ** Mandatory when ItemServiceData is selected | FALSE | null | 6 | 6 | |*/

	,CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 2
		WHEN 'COMAN2' THEN 2
		WHEN 'DPMTO1' THEN 1
		WHEN 'GEKIT6' THEN 2
		WHEN 'GELCO1' THEN 2
		WHEN 'GELTR2' THEN 2
		WHEN 'GESCO3' THEN 1
		WHEN 'GESTD5' THEN 2
		WHEN 'GESTR4' THEN 1
		WHEN 'PHMAN2' THEN 2
		WHEN 'PHSAL1' THEN 2
		WHEN 'PI9999' THEN 2
		WHEN 'CI0001' THEN 2
		WHEN 'TOGEN1' THEN 1
		WHEN 'COFLS4' THEN 2
		ELSE 2 
	 END AS ConfigurationControlled												/*Configuration Controlled (tsmdm200.seri) | FALSE | 3 |  |  | 1;"Serialized";2;"Anonymous";3;"Consumable (default)"|*/
	,CAST(NULL AS VARCHAR(6)) AS ServiceDepartment										/*Service Department (cwoc)   - References tsmdm100 Service Centers | FALSE | null | 6 | 6 | |*/
	,0 AS ServicePrice																	/*Service Price (pris) | FALSE | 0 |  |  | |*/

	/* Warehouse */

	,1 AS LocationControlled															/*Location Controlled (whwmd400.locc) | FALSE | 1 |  |  | 1;"Yes (default)";2;"No"|*/
	,1 AS ProcessInvVariances															/*Warehousing - Process Inventory Variances Automatically (whwmd400.prva) | FALSE | | 1;"Yes";2;"No |*/
	,CAST(NULL AS VARCHAR(6)) AS ItemValuationGroup										/*Item Valuation Group (whwmd400.ivgr)   - Reference to whina101 Item Valuation Groups | FALSE | null | 6 | 6 | |*/
	,20 AS UseOrderingData																/*Warehousing - Use Item Ordering Data by Site (whwmd400.uidt)|FALSE | | 10;"Yes";20;"No";30;"Apply Warehouse Default" | */
	,70 AS DefaultSupplySystem															/*Default Supply System (whwmd400.dwhs) | FALSE | 70 |  |  | 10;"Time-Phased Order Point";20;"KANBAN";30;"Order Controlled/Batch";40;"Order Controlled/SILS";50;"Order Controlled/Single";60;"Apply Warehouse Defaults";70;"None (default)"|*/
	,2 AS GenerateOrderAdvices															/*Warehousing - Generate Order Advices (whwmd400.goad) - KANBAN	| FALSE	| Byte|	1;"Yes";2;"No" | */
	,2 AS CombineOrderAdvices															/*Warehousing - Combine Order Advices (whwmd400.coad) - KANBAN	| FALSE | Byte | |	1;"Yes";2;"No" |*/
	,2 AS ConfirmOrderAdvices															/*Warehousing - Automatically Confirm Order Advices (whwmd400.acoa) - KANBAN |FALSE	| Byte | | 1;"Yes";2;"No" |*/
	,2 AS HazardousMaterial																/*Hazardous Material (whwmd400.hama) | TRUE | 2 |  |  | 1;"Yes";2;"No (default)"|*/
	,CAST(NULL AS VARCHAR(200)) AS ClassOfRisk											/*Class of Risk (whwmd400.risk) | FALSE | null | 200 | 200 | |*/
	,CASE kps.ItemGroup
		WHEN 'COFLS4' THEN 1
		ELSE 2 END AS FloorStock														/*Floor Stock (whwmd400.pics) | FALSE | 2 |  |  | 1;"Yes";2;"No (default)"|*/
	,0 AS InventoryCarryingCosts														/*Inventory Carrying Costs (whwmd400.scst) | FALSE | 0 |  |  | |*/
	,0 AS Height																		/*Height (whwmd400.hght) | FALSE | 0 |  |  | |*/
	,0 AS Width																			/*Width (whwmd400.wdth) | FALSE | 0 |  |  | |*/
	,0 AS Depth																			/*Depth (whwmd400.dpth) | FALSE | 0 |  |  | |*/
	,0 AS ExpectedAnnualIssue															/*Expected Annual Issue (whwmd400.usab) | FALSE | 0 |  |  | |*/
	,CAST(NULL AS VARCHAR(1)) AS ABCcode												/*ABC Code (whwmd400.abcc) | FALSE | null | 1 | 1 | |*/
	,2 AS OutboundMethod																/*Outbound Method (whwmd400.obpr) | FALSE | 3 |  |  | 1;"LIFO";2;"FIFO";3;"By Location"|*/
	,2 AS LotPrice																		/*Lot Price (whwmd400.ltpr)   ** In case Inventory Valuation Method is "Lot Price (Lot)" field LotPrice must be set to "yes" | FALSE | 2 |  |  | 1;"Yes";2;"No (default)"|*/
	,CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 2
		WHEN 'COMAN2' THEN 2
		WHEN 'DPMTO1' THEN 2
		WHEN 'GEKIT6' THEN 2
		WHEN 'GELCO1' THEN 1
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
	 END AS LotsInInventory														/*Lots in Inventory (whwmd400.linv) ** In case Inventory Valuation Method is "Lot Price (Lot)" field LotsInInventory must be set to "yes" | FALSE | 2 |  |  | 1;"Yes";2;"No (default)"|*/
	,2 AS SerialPrice																	/*Serial Price (whwmd400.srpr) | FALSE | 2 |  |  | 1;"Yes";2;"No (default)"|*/
	,CASE kps.ItemGroup
		WHEN 'COGEN1' THEN 2
		WHEN 'COMAN2' THEN 2
		WHEN 'DPMTO1' THEN 1
		WHEN 'GEKIT6' THEN 2
		WHEN 'GELCO1' THEN 2
		WHEN 'GELTR2' THEN 2
		WHEN 'GESCO3' THEN 1
		WHEN 'GESTD5' THEN 2
		WHEN 'GESTR4' THEN 2
		WHEN 'PHMAN2' THEN 2
		WHEN 'PHSAL1' THEN 2
		WHEN 'PI9999' THEN 2
		WHEN 'CI0001' THEN 2
		WHEN 'TOGEN1' THEN 1
		WHEN 'COFLS4' THEN 2
		ELSE 2 
	 END AS SerialsInInventory													/*Serials in Inventory (whwmd400.sinv)   ** In case Inventory Valuation Method is "Serial Price (Serial)" field SerialsInInventory must be set to "yes" | TRUE | 2 |  |  | 1;"Yes";2;"No (default)"|*/
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
	 END AS HandlingUnitInUse													/*Handling Unit In Use (whwmd400.uhnd) | FALSE | 2 |  |  | 1;"Yes";2;"No (default)"|*/

	 /* Text variables */

	,CAST(NULL AS VARCHAR(200)) AS ItemGeneralText										/*Item Text (tttxt010.ctxt) | FALSE | null |  |  | |*/
	,CAST(NULL AS VARCHAR(200)) AS ItemPurchaseText										/*Item Purchase Text (tttxt010.ctxt) | FALSE | null |  |  | |*/
	,CAST(NULL AS VARCHAR(200)) AS ItemSalesText										/*Item Sales Text (tttxt010.ctxt) | FALSE | null |  |  | |*/
	,CAST(NULL AS VARCHAR(200)) AS ItemProductionText									/*Item Production Text (tttxt010.ctxt) | FALSE | null |  |  | |*/
	,0 AS TextIDGeneral																	/*Text ID General (tcibd001.txta) | FALSE | 0 |  |  | |*/
	,0 AS TextIDPurchase																/*Text ID Purchase (tdipu001.txtp) | FALSE | 0 |  |  | |*/
	,0 AS TextIDSales																	/*Text ID Sales (tdisa001.txts) | FALSE | 0 |  |  | |*/
	,0 AS TextIDProduction																/*Text ID Production (tiipd001.txta) | TRUE | 0 |  |  | |*/

	/* Projects */

	,CAST(NULL AS VARCHAR(9)) AS CCItemProjectSegment									/*Project segment of Control Code Material (tppdm005.ccit)   - Reference to tcmcs052 General Projects | TRUE | null | 9 | 9 | |*/
	,CAST(NULL AS VARCHAR(38)) AS CCItemItemSegment										/*Control Code Material (tppdm005.ccit)   - Reference to tcibd001 Items | TRUE | null | 38 | 38 | |*/
	,2 AS ControlFunction																/*Control Function (tppdm005.ccfu) | TRUE | 2 |  |  | 1;"Cost Object";2;"Cost Object/Control Code";3;"Control Code"|*/
	,9 AS ProjectOrderSystem															/*Project Order System (tppdm005.osys) | TRUE | 9 |  |  | 3;"PRP";9;"Manually"|*/
	,2 AS RegisterProgress																/*Register Progress (tppdm005.prre) | TRUE | 2 |  |  | 1;"Yes";2;"No"|*/
	,2 AS CostPriceType																	/*Cost Price Type (tppdm005.copt) | TRUE | 2 |  |  | 1;"Manually";2;"Inventory Valuation"|*/
	,CAST(NULL AS VARCHAR(3)) AS CostPriceCurrency										/*Cost Price Currency (tppdm005.ccur)   - Reference to tcmcs002 Currencies | TRUE | null | 3 | 3 | |*/
	,0 AS ManualCostPrice																/*Manual Cost Price (tppdm005.cprp) | TRUE | 0 |  |  | |*/
	,1 AS PricePolicy																	/*Price Policy (tppdm005.cppp) | TRUE | 1 |  |  | 1;"Cost Price";2;"Purchase Price"|*/
	,1 AS Billable																		/*Billable Item (tppdm005.blbl) | FALSE | 1 |  |  | 1;"Yes (default)";2;"No"|*/
	,2 AS UsedInSchedule																/*Used in Schedule (tppdm005.usyn) | TRUE | 2 |  |  | 1;"Yes";2;"No"|*/
	,CAST(NULL AS VARCHAR(9))AS ProjectSite												/*Project - Site (tppdm007.site) - Reference to tcemm050 Sites - only required when sites are active|FALSE	| Text | 9 | |*/	
	,CAST(NULL AS VARCHAR(6)) AS OrderingWarehouse										/*Project - Ordering Warehouse (tppdm007.cwar) - Reference to tcmcs003 Warehouses - only required when sites are active |FALSE | Text | 6 | |*/	

	/* Tools */

	,CAST(NULL AS VARCHAR(9)) AS ToolsPlanner											/*Planner in Tools (titrp001.emno)   - References tccom001 Employees | FALSE | null | 9 | 9 | |*/
	,CAST('USD' AS VARCHAR(3)) AS ToolsCurrency											/*Tools Currency (titrp001.ccur)  - Reference to tcmcs002 Currencies |  | null | 3 | 3 | |*/

	/* Access Field */

	,1 AS Exception																		/*Exception record which ignores Item Defaulting (Access field!) |  | 1 |  |  | 1;"Yes (default)";2;"No"|*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND  kps.Migrate IN (0,1))
/* 26-02-2024 KL ProductType tabel has become SelectionCode with files SelectionCode instead of ProductType */
--	LEFT JOIN ZZZ_Italy.dbo.ProductType prt ON (itm.MG_TIP_REC = prt.Code AND itm.MG_DITTA = 1)

	LEFT JOIN ZZZ_Italy.dbo.SelectionCode sec ON (itm.MG_TIP_REC = sec.Code AND itm.MG_DITTA = 1)


/*  KL : 15-02-2024 New table ProductLine_Type */ 

	LEFT JOIN ZZZ_Italy.dbo. ProductLine_Type plt ON ( plt.ProductLine = kps.ProductLine ) 
	 
	LEFT JOIN ZZZ_Italy.dbo.StatisticsGroep_Conv stc ON (itm.MG_TIP_REC = stc.ProductType AND itm.MG_DITTA = 1)



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



GO


