USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_ItemsByOffice]    Script Date: 3/1/2024 1:46:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [dbo].[vw_ItemsByOffice] AS

		/* ---------PURCHASE OFFICE---------*/
SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
/* PUR HCE Italy POV-01 , H.C.E. S.r.l. */ 
	,CAST('IT2200' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,10 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/

/*	[PurchaseStatisticsGroup to PurchaseStatsGroup */
--  ,CAST(stc.StatisticsGroup AS VARCHAR(6)) AS PurchaseStatisticsGroup 	/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

/* 30-08-2023 When NULL fill with '------'  */		
--	,cast(stc.StatisticsGroup as varchar(6)) as  PurchaseStatsGroup 	/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST
		(CASE 
			WHEN stc.StatisticsGroup IS NULL THEN  '------' ELSE stc.StatisticsGroup
		END
			AS VARCHAR(6)
		) AS PurchaseStatisticsGroup						/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/



	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesPriceGroup			/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/

	

	,CAST(NULL AS VARCHAR(6)) AS SalesStatisticsGroup		/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/

	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(NULL AS VARCHAR(3)) AS Unit						/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(3)) AS PriceUnit					/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */


	/* SERVICE */

	,CAST(NULL AS VARCHAR(6)) AS OperationsDepartment		/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite					/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite				/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite				/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	
	
FROM
	KPRAKTOR.SIAPR.ANAMAG itm
/*  21-02-2024 : KL POV1 <> 0 ,  Remove POV2 , RD must be kept  */
--	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999') AND (kps.POV1 = 1 OR kps.POV2 = 1 OR kps.RD=1))
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999') AND (kps.POV1 <> 0 OR  kps.RD=1))


	LEFT JOIN ZZZ_Italy.dbo.StatisticsGroep_Conv stc ON (itm.MG_TIP_REC = stc.ProductType AND itm.MG_DITTA = 1)

UNION ALL

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
/* PUR HCE Italy Spare Parts , H.C.E. s.p.a. POV3 */ 
	,CAST('IT2250' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,10 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/
	
/* 30-08=2023 	When NULL fill with '------'  */
--	,CAST(stc.StatisticsGroup AS VARCHAR(6)) AS PurchaseStatisticsGroup 	/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	,CAST
		(CASE 
		 WHEN stc.StatisticsGroup IS NULL THEN  '------' ELSE stc.StatisticsGroup
		 END
		  AS VARCHAR(6)
		) AS PurchaseStatisticsGroup					/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/


	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesPriceGroup			/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesStatisticsGroup		/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(NULL AS VARCHAR(3)) AS Unit						/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(3)) AS PriceUnit					/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */


	/* SERVICE */

	,CAST(NULL AS VARCHAR(6)) AS OperationsDepartment		/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite					/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite				/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite				/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999') AND kps.POV3 = 1)
	LEFT JOIN ZZZ_Italy.dbo.StatisticsGroep_Conv stc ON (itm.MG_TIP_REC = stc.ProductType AND itm.MG_DITTA = 1)

UNION ALL

		/*---------SALES OFFICE---------*/

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/

/* SLS HCE Italy POV , H.C.E. S.r.l. */ 
	,CAST('IT1200' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,20 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/

/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup			/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/





	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'S10.10'
			WHEN 'COMAN2' THEN 'S10.10'
			WHEN 'DPMTO1' THEN 'S10.10'
			WHEN 'GEKIT6' THEN 'S10.10'
			WHEN 'GELCO1' THEN 'S10.10'
			WHEN 'GELTR2' THEN 'S10.10'
			WHEN 'GESCO3' THEN 'S10.10'
			WHEN 'GESTD5' THEN 'S10.10'
			WHEN 'GESTR4' THEN 'S10.10'
			WHEN 'PHMAN2' THEN 'S10.10'
			WHEN 'PHSAL1' THEN 'S10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'S90.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS SalesPriceGroup					/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS SalesStatisticsGroup	/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST(NULL AS VARCHAR(6)) AS OperationsDepartment		/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite					/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite				/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite				/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	/* 21-02-2024 : KL POV1 <> 0 ,  Remove POV2 , RD must be kept  */
--	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999','TOGEN1') AND (kps.POV1 = 1 OR kps.POV2 = 1 OR kps.RD=1))
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999','TOGEN1') AND (kps.POV1 <> 0 OR  kps.RD=1))

UNION ALL

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/

/* SLS Ferrari Italy POV , H.C.E. S.r.l. */ 
	,CAST('IT1210' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,20 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/
/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup			/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/


	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'S10.10'
			WHEN 'COMAN2' THEN 'S10.10'
			WHEN 'DPMTO1' THEN 'S10.10'
			WHEN 'GEKIT6' THEN 'S10.10'
			WHEN 'GELCO1' THEN 'S10.10'
			WHEN 'GELTR2' THEN 'S10.10'
			WHEN 'GESCO3' THEN 'S10.10'
			WHEN 'GESTD5' THEN 'S10.10'
			WHEN 'GESTR4' THEN 'S10.10'
			WHEN 'PHMAN2' THEN 'S10.10'
			WHEN 'PHSAL1' THEN 'S10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'S90.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS SalesPriceGroup					/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS SalesStatisticsGroup	/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST(NULL AS VARCHAR(6)) AS OperationsDepartment		/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite					/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite				/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite				/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm

/* 21-02-2024 : KL POV1 <> 0 ,  Remove POV2 , RD must be kept  */
--	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999','TOGEN1') AND (kps.POV1 = 1 OR kps.POV2 = 1 OR kps.RD=1))
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999','TOGEN1') AND (kps.POV1 <> 0 OR kps.RD=1))


UNION ALL

---------------------------------------- START IT1220  SLS Amco Veba Italy POV , H.C.E. S.r.l.  -----
SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
/* SLS Amco Veba Italy POV , H.C.E. S.r.l. */ 															
	,CAST('IT1220' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,20 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/


/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup			/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'S10.10'
			WHEN 'COMAN2' THEN 'S10.10'
			WHEN 'DPMTO1' THEN 'S10.10'
			WHEN 'GEKIT6' THEN 'S10.10'
			WHEN 'GELCO1' THEN 'S10.10'
			WHEN 'GELTR2' THEN 'S10.10'
			WHEN 'GESCO3' THEN 'S10.10'
			WHEN 'GESTD5' THEN 'S10.10'
			WHEN 'GESTR4' THEN 'S10.10'
			WHEN 'PHMAN2' THEN 'S10.10'
			WHEN 'PHSAL1' THEN 'S10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'S90.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS SalesPriceGroup					/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS SalesStatisticsGroup	/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST(NULL AS VARCHAR(6)) AS OperationsDepartment		/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite					/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite				/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite				/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
/* 21-02-2024 : KL POV1 <> 0 ,  Remove POV2 , RD must be kept  */
--	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999','TOGEN1') AND (kps.POV1 = 1 OR kps.POV2 = 1 OR kps.RD=1))
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999','TOGEN1') AND (kps.POV1 <> 0 OR kps.RD=1))

---------------------------------------- END IT1220  SLS Amco Veba Italy POV , H.C.E. S.r.l.  -----

UNION ALL

---------------------------------------- START IT1221 Sales Office Amco Veba MARINE
/* 23-07  */
SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
/* SLS Amco Veba Italy POV , H.C.E. S.r.l. */ 															
	,CAST('IT1221' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,20 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/

/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup			/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'S10.10'
			WHEN 'COMAN2' THEN 'S10.10'
			WHEN 'DPMTO1' THEN 'S10.10'
			WHEN 'GEKIT6' THEN 'S10.10'
			WHEN 'GELCO1' THEN 'S10.10'
			WHEN 'GELTR2' THEN 'S10.10'
			WHEN 'GESCO3' THEN 'S10.10'
			WHEN 'GESTD5' THEN 'S10.10'
			WHEN 'GESTR4' THEN 'S10.10'
			WHEN 'PHMAN2' THEN 'S10.10'
			WHEN 'PHSAL1' THEN 'S10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'S90.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS SalesPriceGroup					/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS SalesStatisticsGroup	/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST(NULL AS VARCHAR(6)) AS OperationsDepartment		/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite					/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite				/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite				/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
/* 21-02-2024 : KL POV1 <> 0 ,  Remove POV2 , RD must be kept  */
--	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999','TOGEN1') AND (kps.POV1 = 1 OR kps.POV2 = 1 OR kps.RD=1))
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999','TOGEN1') AND (kps.POV1 <> 0  OR kps.RD=1))


---------------------------------------- END IT1221 Sales Office Amco Veba MARINE



UNION ALL 

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
														

/* SLS Spare Parts Italy POV3 , H.C.E. s.p.a. POV3 */ 
	,CAST('IT1250' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,20 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/
/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup			/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'S10.10'
			WHEN 'COMAN2' THEN 'S10.10'
			WHEN 'DPMTO1' THEN 'S10.10'
			WHEN 'GEKIT6' THEN 'S10.10'
			WHEN 'GELCO1' THEN 'S10.10'
			WHEN 'GELTR2' THEN 'S10.10'
			WHEN 'GESCO3' THEN 'S10.10'
			WHEN 'GESTD5' THEN 'S10.10'
			WHEN 'GESTR4' THEN 'S10.10'
			WHEN 'PHMAN2' THEN 'S10.10'
			WHEN 'PHSAL1' THEN 'S10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'S90.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS SalesPriceGroup					/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS SalesStatisticsGroup	/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST(NULL AS VARCHAR(6)) AS OperationsDepartment		/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite					/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite				/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite				/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999','TOGEN1') AND (kps.POV3 = 1))

UNION ALL

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
															
/* SLS Spare Parts Ferrari Italy POV3 ,H.C.E. s.p.a. POV3 */ 

	,CAST('IT1260' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,20 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/

/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup			/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'S10.10'
			WHEN 'COMAN2' THEN 'S10.10'
			WHEN 'DPMTO1' THEN 'S10.10'
			WHEN 'GEKIT6' THEN 'S10.10'
			WHEN 'GELCO1' THEN 'S10.10'
			WHEN 'GELTR2' THEN 'S10.10'
			WHEN 'GESCO3' THEN 'S10.10'
			WHEN 'GESTD5' THEN 'S10.10'
			WHEN 'GESTR4' THEN 'S10.10'
			WHEN 'PHMAN2' THEN 'S10.10'
			WHEN 'PHSAL1' THEN 'S10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'S90.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS SalesPriceGroup					/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS SalesStatisticsGroup	/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST(NULL AS VARCHAR(6)) AS OperationsDepartment		/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite					/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite				/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite				/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999','TOGEN1') AND (kps.POV3 = 1))

UNION ALL

---------------------------------------- START IT1270  SLS Spare Parts Amco Veba Italy POV3 , H.C.E. s.p.a. POV3   -----

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
/* SLS Spare Parts Amco Veba Italy POV3 , H.C.E. s.p.a. POV3 */ 
	,CAST('IT1270' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,20 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/

/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup			/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'S10.10'
			WHEN 'COMAN2' THEN 'S10.10'
			WHEN 'DPMTO1' THEN 'S10.10'
			WHEN 'GEKIT6' THEN 'S10.10'
			WHEN 'GELCO1' THEN 'S10.10'
			WHEN 'GELTR2' THEN 'S10.10'
			WHEN 'GESCO3' THEN 'S10.10'
			WHEN 'GESTD5' THEN 'S10.10'
			WHEN 'GESTR4' THEN 'S10.10'
			WHEN 'PHMAN2' THEN 'S10.10'
			WHEN 'PHSAL1' THEN 'S10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'S90.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS SalesPriceGroup					/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS SalesStatisticsGroup	/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST(NULL AS VARCHAR(6)) AS OperationsDepartment		/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite					/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite				/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite				/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999','TOGEN1') AND (kps.POV3 = 1))

---------------------------------------- END IT1270  SLS Spare Parts Amco Veba Italy POV3 , H.C.E. s.p.a. POV3   -----
UNION ALL


/* 27-07 */

---------------------------------------- START IT1271  Sales Office Spare Parts Amco Veba MARINE  -----


SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
/* SLS Spare Parts Amco Veba Italy POV3 , H.C.E. s.p.a. POV3 */ 
	,CAST('IT1271' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,20 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/
/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup			/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(CASE kps.ItemGroup
			WHEN 'COGEN1' THEN 'S10.10'
			WHEN 'COMAN2' THEN 'S10.10'
			WHEN 'DPMTO1' THEN 'S10.10'
			WHEN 'GEKIT6' THEN 'S10.10'
			WHEN 'GELCO1' THEN 'S10.10'
			WHEN 'GELTR2' THEN 'S10.10'
			WHEN 'GESCO3' THEN 'S10.10'
			WHEN 'GESTD5' THEN 'S10.10'
			WHEN 'GESTR4' THEN 'S10.10'
			WHEN 'PHMAN2' THEN 'S10.10'
			WHEN 'PHSAL1' THEN 'S10.10'
			WHEN 'PI9999' THEN NULL
			WHEN 'CI0001' THEN 'S90.10'
			ELSE '------' 
	 END AS VARCHAR(6)) AS SalesPriceGroup					/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS SalesStatisticsGroup	/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST(NULL AS VARCHAR(6)) AS OperationsDepartment		/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite					/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse			/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite				/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse			/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite				/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse			/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('PHMAN2','PI9999','TOGEN1') AND (kps.POV3 = 1))


---------------------------------------- END IT1271  Sales Office Spare Parts Amco Veba MARINE  -----



UNION ALL




		/*---------SERVICE OFFICE---------*/
SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
/* SRV HCE Italy POV , ITS100 Service Warehouse POV1 */ 
	,CAST('IT3200' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,30 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/
/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup								/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesPriceGroup			/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesStatisticsGroup		/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST('IT3200' AS VARCHAR(6)) AS OperationsDepartment	/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite			/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse		/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite			/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse		/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite		/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse		/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
/* 21-02-2024 KL: POV1 <> 0 ,  Remove POV2 , RD must be kept  */
-- 	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('COGEN1','COMAN2','GEKIT6','PHMAN2','PHSAL1','PI9999','CI0001','COFLS4') AND (kps.POV1 = 1 OR kps.POV2 = 1 OR kps.RD=1))
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('COGEN1','COMAN2','GEKIT6','PHMAN2','PHSAL1','PI9999','CI0001','COFLS4') AND (kps.POV1 <> 0  OR kps.RD=1))

UNION ALL

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
/* SRV Ferrari Italy POV , ITS100  , Service Warehouse POV1 */ 
	,CAST('IT3210' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,30 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/
/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup								/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesPriceGroup			/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesStatisticsGroup		/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST('IT3210' AS VARCHAR(6)) AS OperationsDepartment	/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite			/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse		/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite			/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse		/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite		/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse		/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
/* 21-02-2024  KL:  POV1 <> 0 ,  Remove POV2 , RD must be kept  */
--	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('COGEN1','COMAN2','GEKIT6','PHMAN2','PHSAL1','PI9999','CI0001','COFLS4') AND (kps.POV1 = 1
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('COGEN1','COMAN2','GEKIT6','PHMAN2','PHSAL1','PI9999','CI0001','COFLS4') AND (kps.POV1 <> 0 OR kps.RD=1))

UNION ALL


/* ---------------------------------------- START IT3220  SRV Amco Veba Italy POV , ITS100 Service Warehouse POV1   -----*/

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
/* SRV Amco Veba Italy POV , ITS100 Service Warehouse POV1 */ 
	,CAST('IT3220' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,30 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/
/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup								/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesPriceGroup			/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesStatisticsGroup		/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST('IT3220' AS VARCHAR(6)) AS OperationsDepartment	/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite			/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse		/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite			/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse		/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite		/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse		/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
/* 21-02-2024 : KL POV1 <> 0 ,  Remove POV2 , RD must be kept  */
--	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('COGEN1','COMAN2','GEKIT6','PHMAN2','PHSAL1','PI9999','CI0001','COFLS4') AND (kps.POV1 = 1 OR kps.POV2 = 1 OR kps.RD=1))
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('COGEN1','COMAN2','GEKIT6','PHMAN2','PHSAL1','PI9999','CI0001','COFLS4') AND (kps.POV1 <> 0  OR kps.RD=1))


/* ---------------------------------------- END  IT3220  SRV Amco Veba Italy POV , ITS100 Service Warehouse POV1   -----*/



UNION ALL


/* ---------------------------------------- START  IT3221  Service Office Amco Veba MARINE   -----*/


SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
/* SRV Amco Veba Italy POV , ITS100 Service Warehouse POV1 */ 
	,CAST('IT3221' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,30 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/
/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup			/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesPriceGroup			/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesStatisticsGroup		/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST('IT3220' AS VARCHAR(6)) AS OperationsDepartment	/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite			/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse		/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite			/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse		/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite		/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse		/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
/* 21-02-2024 : KL POV1 <> 0 ,  Remove POV2 , RD must be kept  */
--	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('COGEN1','COMAN2','GEKIT6','PHMAN2','PHSAL1','PI9999','CI0001','COFLS4') AND (kps.POV1 = 1 OR kps.POV2 = 1 OR kps.RD=1))
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('COGEN1','COMAN2','GEKIT6','PHMAN2','PHSAL1','PI9999','CI0001','COFLS4') AND (kps.POV1 <> 0 OR kps.RD=1))

/* ---------------------------------------- END  IT3221  Service Office Amco Veba MARINE   -----*/

UNION ALL 

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
/* SRV Spare Parts Italy POV3 */ 
	,CAST('IT3250' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,30 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/

/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup								/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesPriceGroup			/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesStatisticsGroup		/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST('IT3250' AS VARCHAR(6)) AS OperationsDepartment	/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite			/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse		/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite			/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse		/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite		/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse		/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('COGEN1','COMAN2','GEKIT6','PHMAN2','PHSAL1','PI9999','CI0001','COFLS4') AND (kps.POV3 = 1))


UNION ALL

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
/* SRV Spare Parts Ferrari Italy POV3 */
	,CAST('IT3260' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,30 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/
/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup								/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesPriceGroup			/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesStatisticsGroup		/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST('IT3260' AS VARCHAR(6)) AS OperationsDepartment	/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite			/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse		/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite			/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse		/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite		/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse		/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('COGEN1','COMAN2','GEKIT6','PHMAN2','PHSAL1','PI9999','CI0001','COFLS4') AND (kps.POV3 = 1))

UNION ALL

---------------------------------------- START IT3270   SRV Spare Parts Amco Veba Italy POV3 */ -----

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects  ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
/* SRV Spare Parts Amco Veba Italy POV3 */ 
	,CAST('IT3270' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,30 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/
/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup								/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesPriceGroup			/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesStatisticsGroup		/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST('IT3270' AS VARCHAR(6)) AS OperationsDepartment	/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite			/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse		/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite			/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse		/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite		/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse		/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('COGEN1','COMAN2','GEKIT6','PHMAN2','PHSAL1','PI9999','CI0001','COFLS4') AND (kps.POV3 = 1))


---------------------------------------- END IT3270   SRV Spare Parts Amco Veba Italy POV3 */ -----



UNION ALL 

---------------------------------------- START IT3271   Service Office Spare Parts Amco Veba MARINE
/* 27-07 */
SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project				/*Project segment of Item (item)   - Reference to tcmcs052 Projects  ERPLN table: tdipu081, tdisa081, tsmdm220 | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item				/*Item segment of Item (item) | TRUE |  | 38 | |*/
/* SRV Spare Parts Amco Veba Italy POV3 */ 
	,CAST('IT3271' AS VARCHAR(6)) AS Office					/*Office (tdipu081.poff/tdisa081.soff/tsmdm220.soff) | FALSE | null | 6 | |*/
	,30 AS OfficeType										/*Office Type | FALSE | 20 |  | 10;"Purchase";20;"Sales";30;"Service"|*/

	/* PURCHASE */

	,CAST(NULL AS VARCHAR(9)) AS PurchaseTaxCode			/*Purchase Tax Code (tdipu081.cvat) - Reference to tcmcs037 Vat Codes | FALSE | null | 9 | |*/
/* 30-08=2023 	When NULL fill with '------'    */
--	,CAST(NULL AS VARCHAR(6)) AS PurchaseStatsGroup								/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/
	,CAST( '------' AS VARCHAR(6)) AS PurchaseStatsGroup		/*Purchase Statistics Group (tdipu081.csgp) - Reference to tcmcs044 Statistic groups | FALSE | null | 6 | |*/

	/* SALES */

	,CAST(NULL AS VARCHAR(9)) AS ShippingSite				/*Sales Shipping Site (tdisa081.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingWarehouse			/*Sales Shipping Warehouse (tdisa081.cwar) - Reference to tcmcs003 Warehouses | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesPriceGroup			/*Sales Price Group (cpgs)   - References tcmcs024 Price Groups | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS SalesStatisticsGroup		/*Sales Statistics Group (csgs)   - References tcmcs044 Statistical Groups | FALSE | null | 6 | |*/
	,0 AS SuggestedRetailPrice								/*Sales Suggested Retail Price (tdisa081.prir) | FALSE | 0 |  | |*/
	,10 AS ShippingConstraint								/*Sales - Shipping Constraint (tdisa081.scon) (HYVA) | FALSE | 10 |  | 1;"None";2;"Ship Line Complete";3;"Ship Set Complete";4;"Ship Order Complete";5;"Ship Line & Cancel";6;"Ship Kit Complete";10;"Not Applicable"|*/

	/* SALES SERVICE */

	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit			/*Sales/Service Unit (tdisa081.cuqs) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS PriceUnit		/*Sales/Service Price Unit (tdisa081.cups) - Reference to tcmcs001 Units | FALSE | null | 3 | |*/
	,0 AS Price												/*Sales/Service Price (tdisa081.pris) | FALSE | 0 |  | |*/
	,CAST('EUR' AS VARCHAR(3)) AS Currency					/*Sales/Service: Currency (tdisa081.ccur/tsmdm220.ccur)  - Reference to tcmcs002 Currencies | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(255)) AS ItemSalesText			/*Sales Text (tttxt010.ctxt) - | FALSE | Memo | | */
	,0 AS TextIDSales										/*Sales - Text ID  (tdisa081.txts) | FALSE | Long Interger | 0 | | */

	/* SERVICE */

	,CAST('IT3271' AS VARCHAR(6)) AS OperationsDepartment	/*Service: Operations Department(tsmdm220.mdpt)    - References tsmdm100 Service Centers (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RepairSite			/*Service: Repair Site (tsmdm220.sfsi) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS RepairWarehouse		/*Service: Repair Warehouse (tsmdm220.cwar) - Reference to tcmcs003 Warehouses |  | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS ReceiptSite			/*Service: Receipt Site (tsmdm220.rste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptWarehouse		/*Service: Receipt Warehouse (tsmdm220.rwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ReceiptLocation			/*Service: Receipt Location (tsmdm220.rloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS DeliverySite		/*Service: Delivery Site (tsmdm220.dste) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryWarehouse		/*Service: Delivery Warehouse (tsmdm220.dwrh) - Reference to tcmcs003 Warehouses (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS DeliveryLocation			/*Service: Delivery Location (tsmdm220.dloc) - Reference to tswcs025 Locations (HYVA) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(9)) AS MaterialSite				/*Service: Material Site (tsmdm220.mste) - Reference to tcemm050 Sites |  | null | 9 | |*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialWarehouse			/*Service - Material Warehouse (tsmdm220.mwrh) - Reference to tcmcs003 Warehouses | FALSE | Text | 6 | | */	


/*	/* EXIT TEMPLATE */

	,5 as ComponentHandling									/*Sales - Component Handling (tdisa081.cphl) (HYVA) | FALSE | 5 |  | 5;"Not Applicable";10;"Sales BOM";15;"Component Lines"|*/
	,0 as ProcessToServiceAfterDel							/*Service: Process to Service after Delivery (tsmdm220.upsd) (HYVA) | FALSE | 0 |  | |*/
*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.ItemGroup NOT IN ('COGEN1','COMAN2','GEKIT6','PHMAN2','PHSAL1','PI9999','CI0001','COFLS4') AND (kps.POV3 = 1))


---------------------------------------- END IT3271   Service Office Spare Parts Amco Veba MARINE


GO


