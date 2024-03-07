USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_WarehouseItem]    Script Date: 3/7/2024 1:17:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vw_WarehouseItem] as

SELECT
	CAST(scm.warehouse AS VARCHAR(6)) AS Warehouse													/*Warehouse (cwar)  Reference to tcmcs003 Warehouses	ERPLN table: whwmd210, whwmd215, whwmd216 | TRUE | null | 6 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS Project														/*Project segment of Item (item)  Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item														/*Item (item)  Reference to whwmd400 Items | TRUE | null | 38 | |*/
	,CAST(2 AS FLOAT) AS UseItemOrderingData														/*Use Item Ordering data (uidt) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(1 AS FLOAT) AS InventoryValuationMethod													/*Inventory Valuation Method (valm) | TRUE | 1 |  | 1;"Standard Cost (default)";2;"Moving Average Unit Cost (MAUC)";3;"First In First Out (FIFO)";4;"Last In First Out (LILO)";5;"Lot Price (Lot)";6;"Serial Price (Serial)"|*/
	,CAST(0 AS FLOAT) AS OrderInterval																/*Order Interval  (oint) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS OrderIntervalUnit															/*Order Interval Unit (oivu) | TRUE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS SafetyTime																	/*Safety Time (sftm) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS SafetyTimeUnit															/*Safety Time Unit (sftu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS InboundLeadTime															/*Inbound Lead Time (iltm) | TRUE | 0 |  | |*/
	,CAST(0 AS FLOAT) AS OutboundLeadTime															/*Outbound Lead Time (oltm) | TRUE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS LeadTimeUnit																/*Lead time Unit (iltu/oltu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(1 AS FLOAT) AS OrderMethod																/*Order Method (omth) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,CAST(NULL AS VARCHAR(1)) AS ABCcode															/*ABC Code (abcc) | FALSE | null | 1 | |*/
	,CAST(1 AS FLOAT) AS OrderQuantityIncrement														/*Order Quantity Increment (oqmf) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity														/*Minimum Order Quantity (mioq) | FALSE | 0 |  | |*/
	,CAST(99999999 AS FLOAT) AS MaximumOrderQuantity												/*Maximum Order Quantity (maoq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS FixedOrderQuantity															/*Fixed Order Quantity (fioq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS EconomicOrderQuantity														/*Economic Order Quantity (ecoq) | FALSE | 0 |  | |*/
	,CAST(999999999 AS FLOAT) AS MaximumInventory													/*Maximum Inventory (maxs) | FALSE | 999999999 |  | <1000000000|*/
	,CAST(0 AS FLOAT) AS ReorderPoint																/*Reorder Point (reop) |  | 0 |  | |*/
	,CAST(0 AS FLOAT) AS SafetyStock																/*Safety Stock (sfst) |  | 0 |  | |*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV1  <> 0 )
	LEFT JOIN KPRAKTOR.SIAPR.ANAGES pla ON (itm.MG_CODICE = pla.GE_CODICE_ART AND itm.MG_DITTA = pla.GE_DITTA)
	LEFT JOIN ZZZ_Italy.dbo.SCModelMap scm ON (kps.POV1 = scm.POV1 AND scm.Site = 'IT.POV.01')
	LEFT JOIN
		(
			 SELECT
				 itm.MG_CODICE
				,itm.MG_DITTA
				,CASE 
					WHEN kps.Itemgroup = 'DPMTO1' THEN 2
					WHEN kps.SupplySource = 50 THEN 2
					WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 
					ELSE 2
				END AS Phantom 												/*Production - Phantom (tiipf051.cpha) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
			FROM
				KPRAKTOR.SIAPR.ANAMAG itm
				JOIN ZZZ_Italy.dbo.KPsource kps ON ( kps.Item = itm.MG_CODICE )
				LEFT JOIN
					(
						SELECT
							 bom.DB_CODICE_PADRE AS Item
							,bom.DB_DITTA
							,COUNT(bom.DB_CODICE_FIGLIO) AS lines
						FROM
							KPRAKTOR.SIAPR.DISBASE bom
						WHERE
							bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
						GROUP BY
							bom.DB_CODICE_PADRE
							,bom.DB_DITTA
					)bol ON (itm.MG_CODICE = bol.Item AND itm.MG_DITTA = bol.DB_DITTA)
			)pha ON (itm.MG_CODICE = pha.MG_CODICE AND itm.MG_DITTA = pha.MG_DITTA)
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
WHERE
	pha.phantom = 2


UNION ALL

/* ----SPARE PARTS WAREHOUSE ---*/

SELECT
	 CAST(scm.warehouse AS VARCHAR(6)) AS Warehouse
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS Project														/*Project segment of Item (item)  Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item														/*Item (item)  Reference to whwmd400 Items | TRUE | null | 38 | |*/
	,CAST(2 AS FLOAT) AS UseItemOrderingData														/*Use Item Ordering data (uidt) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(1 AS FLOAT) AS InventoryValuationMethod													/*Inventory Valuation Method (valm) | TRUE | 1 |  | 1;"Standard Cost (default)";2;"Moving Average Unit Cost (MAUC)";3;"First In First Out (FIFO)";4;"Last In First Out (LILO)";5;"Lot Price (Lot)";6;"Serial Price (Serial)"|*/
	,CAST(0 AS FLOAT) AS OrderInterval																/*Order Interval  (oint) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS OrderIntervalUnit															/*Order Interval Unit (oivu) | TRUE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS SafetyTime																	/*Safety Time (sftm) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS SafetyTimeUnit															/*Safety Time Unit (sftu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS InboundLeadTime															/*Inbound Lead Time (iltm) | TRUE | 0 |  | |*/
	,CAST(0 AS FLOAT) AS OutboundLeadTime															/*Outbound Lead Time (oltm) | TRUE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS LeadTimeUnit																/*Lead time Unit (iltu/oltu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(1 AS FLOAT) AS OrderMethod																/*Order Method (omth) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,CAST(NULL AS VARCHAR(1)) AS ABCcode															/*ABC Code (abcc) | FALSE | null | 1 | |*/
	,CAST(1 AS FLOAT) AS OrderQuantityIncrement														/*Order Quantity Increment (oqmf) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity														/*Minimum Order Quantity (mioq) | FALSE | 0 |  | |*/
	,CAST(99999999 AS FLOAT) AS MaximumOrderQuantity												/*Maximum Order Quantity (maoq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS FixedOrderQuantity															/*Fixed Order Quantity (fioq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS EconomicOrderQuantity														/*Economic Order Quantity (ecoq) | FALSE | 0 |  | |*/
	,CAST(999999999 AS FLOAT) AS MaximumInventory													/*Maximum Inventory (maxs) | FALSE | 999999999 |  | <1000000000|*/
	,CAST(0 AS FLOAT) AS ReorderPoint																/*Reorder Point (reop) |  | 0 |  | |*/
	,CAST(0 AS FLOAT) AS SafetyStock																/*Safety Stock (sfst) |  | 0 |  | |*/
FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV3 <> 0) 
	JOIN ZZZ_Italy.dbo.KPSourceSP kpp on (kps.Item = kpp.Item)
	LEFT JOIN ZZZ_Italy.dbo.SCModelMap scm ON (kps.POV3 = scm.POV3 AND scm.Site = 'IT.POV.03')
	LEFT JOIN KPRAKTOR.SIAPR.ANAGES pla ON (itm.MG_CODICE = pla.GE_CODICE_ART AND itm.MG_DITTA = pla.GE_DITTA)
	LEFT JOIN
		(
			SELECT
				 itm.MG_CODICE
				,itm.MG_DITTA
				,CASE 
					WHEN kps.Itemgroup = 'DPMTO1' THEN 2
					WHEN kps.SupplySource = 50 THEN 2
					WHEN itm.MG_GEST_PROD = 'I' AND itm.MG_ESPL_DB IN ('00','01','02','03','06') THEN 1 
					ELSE 2
				END AS Phantom 												/*Production - Phantom (tiipf051.cpha) (HYVA) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
			FROM
				KPRAKTOR.SIAPR.ANAMAG itm
				JOIN ZZZ_Italy.dbo.KPsource kps ON ( kps.Item = itm.MG_CODICE )
				LEFT JOIN
					(
						SELECT
							 bom.DB_CODICE_PADRE AS Item
							,bom.DB_DITTA
							,COUNT(bom.DB_CODICE_FIGLIO) AS lines
						FROM
							KPRAKTOR.SIAPR.DISBASE bom
						WHERE
							bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
						GROUP BY
							bom.DB_CODICE_PADRE
							,bom.DB_DITTA
					)bol ON (itm.MG_CODICE = bol.Item AND itm.MG_DITTA = bol.DB_DITTA)
			)pha ON (itm.MG_CODICE = pha.MG_CODICE AND itm.MG_DITTA = pha.MG_DITTA)
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

WHERE
	kpp.Phantom = 2

UNION ALL

/* SITE IT.EXT.01 */

SELECT
	CAST(t1.Warehouse AS VARCHAR(6)) AS Warehouse													/*Warehouse (cwar)  Reference to tcmcs003 Warehouses	ERPLN table: whwmd210, whwmd215, whwmd216 | TRUE | null | 6 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS Project														/*Project segment of Item (item)  Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(t1.Item AS VARCHAR(38)) AS Item														/*Item (item)  Reference to whwmd400 Items | TRUE | null | 38 | |*/
	,CAST(2 AS FLOAT) AS UseItemOrderingData														/*Use Item Ordering data (uidt) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(1 AS FLOAT) AS InventoryValuationMethod													/*Inventory Valuation Method (valm) | TRUE | 1 |  | 1;"Standard Cost (default)";2;"Moving Average Unit Cost (MAUC)";3;"First In First Out (FIFO)";4;"Last In First Out (LILO)";5;"Lot Price (Lot)";6;"Serial Price (Serial)"|*/
	,CAST(0 AS FLOAT) AS OrderInterval																/*Order Interval  (oint) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS OrderIntervalUnit															/*Order Interval Unit (oivu) | TRUE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS SafetyTime																	/*Safety Time (sftm) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS SafetyTimeUnit															/*Safety Time Unit (sftu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS InboundLeadTime															/*Inbound Lead Time (iltm) | TRUE | 0 |  | |*/
	,CAST(0 AS FLOAT) AS OutboundLeadTime															/*Outbound Lead Time (oltm) | TRUE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS LeadTimeUnit																/*Lead time Unit (iltu/oltu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(1 AS FLOAT) AS OrderMethod																/*Order Method (omth) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,CAST(NULL AS VARCHAR(1)) AS ABCcode															/*ABC Code (abcc) | FALSE | null | 1 | |*/
	,CAST(1 AS FLOAT) AS OrderQuantityIncrement														/*Order Quantity Increment (oqmf) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity														/*Minimum Order Quantity (mioq) | FALSE | 0 |  | |*/
	,CAST(99999999 AS FLOAT) AS MaximumOrderQuantity												/*Maximum Order Quantity (maoq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS FixedOrderQuantity															/*Fixed Order Quantity (fioq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS EconomicOrderQuantity														/*Economic Order Quantity (ecoq) | FALSE | 0 |  | |*/
	,CAST(999999999 AS FLOAT) AS MaximumInventory													/*Maximum Inventory (maxs) | FALSE | 999999999 |  | <1000000000|*/
	,CAST(0 AS FLOAT) AS ReorderPoint																/*Reorder Point (reop) |  | 0 |  | |*/
	,CAST(0 AS FLOAT) AS SafetyStock																/*Safety Stock (sfst) |  | 0 |  | |*/
from
	(
		SELECT
			 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
			,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
			,CAST('IT.EXT.01' AS VARCHAR(9)) AS Site				/*Site (site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
			,CAST(scm.Warehouse AS VARCHAR(6)) AS Warehouse 	/*Ordering - Warehouse (tcibd250.cwar) - Reference to tcmcs003 Warehouses ** Mandatory for item ordering by Site | FALSE | null | 6 | |*/
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
	)t1

UNION ALL

/* SITE: IT.EXT.03  */


SELECT
	CAST(t1.Warehouse AS VARCHAR(6)) AS Warehouse													/*Warehouse (cwar)  Reference to tcmcs003 Warehouses	ERPLN table: whwmd210, whwmd215, whwmd216 | TRUE | null | 6 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS Project														/*Project segment of Item (item)  Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(t1.Item AS VARCHAR(38)) AS Item														/*Item (item)  Reference to whwmd400 Items | TRUE | null | 38 | |*/
	,CAST(2 AS FLOAT) AS UseItemOrderingData														/*Use Item Ordering data (uidt) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(1 AS FLOAT) AS InventoryValuationMethod													/*Inventory Valuation Method (valm) | TRUE | 1 |  | 1;"Standard Cost (default)";2;"Moving Average Unit Cost (MAUC)";3;"First In First Out (FIFO)";4;"Last In First Out (LILO)";5;"Lot Price (Lot)";6;"Serial Price (Serial)"|*/
	,CAST(0 AS FLOAT) AS OrderInterval																/*Order Interval  (oint) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS OrderIntervalUnit															/*Order Interval Unit (oivu) | TRUE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS SafetyTime																	/*Safety Time (sftm) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS SafetyTimeUnit															/*Safety Time Unit (sftu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS InboundLeadTime															/*Inbound Lead Time (iltm) | TRUE | 0 |  | |*/
	,CAST(0 AS FLOAT) AS OutboundLeadTime															/*Outbound Lead Time (oltm) | TRUE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS LeadTimeUnit																/*Lead time Unit (iltu/oltu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(1 AS FLOAT) AS OrderMethod																/*Order Method (omth) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,CAST(NULL AS VARCHAR(1)) AS ABCcode															/*ABC Code (abcc) | FALSE | null | 1 | |*/
	,CAST(1 AS FLOAT) AS OrderQuantityIncrement														/*Order Quantity Increment (oqmf) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity														/*Minimum Order Quantity (mioq) | FALSE | 0 |  | |*/
	,CAST(99999999 AS FLOAT) AS MaximumOrderQuantity												/*Maximum Order Quantity (maoq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS FixedOrderQuantity															/*Fixed Order Quantity (fioq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS EconomicOrderQuantity														/*Economic Order Quantity (ecoq) | FALSE | 0 |  | |*/
	,CAST(999999999 AS FLOAT) AS MaximumInventory													/*Maximum Inventory (maxs) | FALSE | 999999999 |  | <1000000000|*/
	,CAST(0 AS FLOAT) AS ReorderPoint																/*Reorder Point (reop) |  | 0 |  | |*/
	,CAST(0 AS FLOAT) AS SafetyStock																/*Safety Stock (sfst) |  | 0 |  | |*/
from
	(
		SELECT
			 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
			,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
			,CAST('IT.EXT.03' AS VARCHAR(9)) AS Site				/*Site (site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
			,CAST(scm.Warehouse AS VARCHAR(6)) AS Warehouse 	/*Ordering - Warehouse (tcibd250.cwar) - Reference to tcmcs003 Warehouses ** Mandatory for item ordering by Site | FALSE | null | 6 | |*/
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
	)t1

UNION ALL

/* SITE: IT.EXT.05 */

SELECT
	CAST(t1.Warehouse AS VARCHAR(6)) AS Warehouse													/*Warehouse (cwar)  Reference to tcmcs003 Warehouses	ERPLN table: whwmd210, whwmd215, whwmd216 | TRUE | null | 6 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS Project														/*Project segment of Item (item)  Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(t1.Item AS VARCHAR(38)) AS Item														/*Item (item)  Reference to whwmd400 Items | TRUE | null | 38 | |*/
	,CAST(2 AS FLOAT) AS UseItemOrderingData														/*Use Item Ordering data (uidt) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(1 AS FLOAT) AS InventoryValuationMethod													/*Inventory Valuation Method (valm) | TRUE | 1 |  | 1;"Standard Cost (default)";2;"Moving Average Unit Cost (MAUC)";3;"First In First Out (FIFO)";4;"Last In First Out (LILO)";5;"Lot Price (Lot)";6;"Serial Price (Serial)"|*/
	,CAST(0 AS FLOAT) AS OrderInterval																/*Order Interval  (oint) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS OrderIntervalUnit															/*Order Interval Unit (oivu) | TRUE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS SafetyTime																	/*Safety Time (sftm) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS SafetyTimeUnit															/*Safety Time Unit (sftu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS InboundLeadTime															/*Inbound Lead Time (iltm) | TRUE | 0 |  | |*/
	,CAST(0 AS FLOAT) AS OutboundLeadTime															/*Outbound Lead Time (oltm) | TRUE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS LeadTimeUnit																/*Lead time Unit (iltu/oltu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(1 AS FLOAT) AS OrderMethod																/*Order Method (omth) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,CAST(NULL AS VARCHAR(1)) AS ABCcode															/*ABC Code (abcc) | FALSE | null | 1 | |*/
	,CAST(1 AS FLOAT) AS OrderQuantityIncrement														/*Order Quantity Increment (oqmf) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity														/*Minimum Order Quantity (mioq) | FALSE | 0 |  | |*/
	,CAST(99999999 AS FLOAT) AS MaximumOrderQuantity												/*Maximum Order Quantity (maoq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS FixedOrderQuantity															/*Fixed Order Quantity (fioq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS EconomicOrderQuantity														/*Economic Order Quantity (ecoq) | FALSE | 0 |  | |*/
	,CAST(999999999 AS FLOAT) AS MaximumInventory													/*Maximum Inventory (maxs) | FALSE | 999999999 |  | <1000000000|*/
	,CAST(0 AS FLOAT) AS ReorderPoint																/*Reorder Point (reop) |  | 0 |  | |*/
	,CAST(0 AS FLOAT) AS SafetyStock																/*Safety Stock (sfst) |  | 0 |  | |*/
from
	(
		SELECT
			 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
			,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
			,CAST('IT.EXT.05' AS VARCHAR(9)) AS Site				/*Site (site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
			,CAST(scm.Warehouse AS VARCHAR(6)) AS Warehouse 	/*Ordering - Warehouse (tcibd250.cwar) - Reference to tcmcs003 Warehouses ** Mandatory for item ordering by Site | FALSE | null | 6 | |*/
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
	)t1

UNION ALL

/* SITE: IT.EXT.06 */

SELECT
	CAST(t1.Warehouse AS VARCHAR(6)) AS Warehouse													/*Warehouse (cwar)  Reference to tcmcs003 Warehouses	ERPLN table: whwmd210, whwmd215, whwmd216 | TRUE | null | 6 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS Project														/*Project segment of Item (item)  Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(t1.Item AS VARCHAR(38)) AS Item														/*Item (item)  Reference to whwmd400 Items | TRUE | null | 38 | |*/
	,CAST(2 AS FLOAT) AS UseItemOrderingData														/*Use Item Ordering data (uidt) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(1 AS FLOAT) AS InventoryValuationMethod													/*Inventory Valuation Method (valm) | TRUE | 1 |  | 1;"Standard Cost (default)";2;"Moving Average Unit Cost (MAUC)";3;"First In First Out (FIFO)";4;"Last In First Out (LILO)";5;"Lot Price (Lot)";6;"Serial Price (Serial)"|*/
	,CAST(0 AS FLOAT) AS OrderInterval																/*Order Interval  (oint) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS OrderIntervalUnit															/*Order Interval Unit (oivu) | TRUE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS SafetyTime																	/*Safety Time (sftm) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS SafetyTimeUnit															/*Safety Time Unit (sftu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS InboundLeadTime															/*Inbound Lead Time (iltm) | TRUE | 0 |  | |*/
	,CAST(0 AS FLOAT) AS OutboundLeadTime															/*Outbound Lead Time (oltm) | TRUE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS LeadTimeUnit																/*Lead time Unit (iltu/oltu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(1 AS FLOAT) AS OrderMethod																/*Order Method (omth) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,CAST(NULL AS VARCHAR(1)) AS ABCcode															/*ABC Code (abcc) | FALSE | null | 1 | |*/
	,CAST(1 AS FLOAT) AS OrderQuantityIncrement														/*Order Quantity Increment (oqmf) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity														/*Minimum Order Quantity (mioq) | FALSE | 0 |  | |*/
	,CAST(99999999 AS FLOAT) AS MaximumOrderQuantity												/*Maximum Order Quantity (maoq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS FixedOrderQuantity															/*Fixed Order Quantity (fioq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS EconomicOrderQuantity														/*Economic Order Quantity (ecoq) | FALSE | 0 |  | |*/
	,CAST(999999999 AS FLOAT) AS MaximumInventory													/*Maximum Inventory (maxs) | FALSE | 999999999 |  | <1000000000|*/
	,CAST(0 AS FLOAT) AS ReorderPoint																/*Reorder Point (reop) |  | 0 |  | |*/
	,CAST(0 AS FLOAT) AS SafetyStock																/*Safety Stock (sfst) |  | 0 |  | |*/
from
	(
		SELECT
			 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
			,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
			,CAST('IT.EXT.06' AS VARCHAR(9)) AS Site				/*Site (site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
			,CAST(scm.Warehouse AS VARCHAR(6)) AS Warehouse 	/*Ordering - Warehouse (tcibd250.cwar) - Reference to tcmcs003 Warehouses ** Mandatory for item ordering by Site | FALSE | null | 6 | |*/
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
	)t1

UNION ALL

/* SITE: IT.EXT.08 */

SELECT
	CAST(t1.Warehouse AS VARCHAR(6)) AS Warehouse													/*Warehouse (cwar)  Reference to tcmcs003 Warehouses	ERPLN table: whwmd210, whwmd215, whwmd216 | TRUE | null | 6 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS Project														/*Project segment of Item (item)  Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(t1.Item AS VARCHAR(38)) AS Item														/*Item (item)  Reference to whwmd400 Items | TRUE | null | 38 | |*/
	,CAST(2 AS FLOAT) AS UseItemOrderingData														/*Use Item Ordering data (uidt) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(1 AS FLOAT) AS InventoryValuationMethod													/*Inventory Valuation Method (valm) | TRUE | 1 |  | 1;"Standard Cost (default)";2;"Moving Average Unit Cost (MAUC)";3;"First In First Out (FIFO)";4;"Last In First Out (LILO)";5;"Lot Price (Lot)";6;"Serial Price (Serial)"|*/
	,CAST(0 AS FLOAT) AS OrderInterval																/*Order Interval  (oint) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS OrderIntervalUnit															/*Order Interval Unit (oivu) | TRUE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS SafetyTime																	/*Safety Time (sftm) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS SafetyTimeUnit															/*Safety Time Unit (sftu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS InboundLeadTime															/*Inbound Lead Time (iltm) | TRUE | 0 |  | |*/
	,CAST(0 AS FLOAT) AS OutboundLeadTime															/*Outbound Lead Time (oltm) | TRUE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS LeadTimeUnit																/*Lead time Unit (iltu/oltu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(1 AS FLOAT) AS OrderMethod																/*Order Method (omth) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,CAST(NULL AS VARCHAR(1)) AS ABCcode															/*ABC Code (abcc) | FALSE | null | 1 | |*/
	,CAST(1 AS FLOAT) AS OrderQuantityIncrement														/*Order Quantity Increment (oqmf) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity														/*Minimum Order Quantity (mioq) | FALSE | 0 |  | |*/
	,CAST(99999999 AS FLOAT) AS MaximumOrderQuantity												/*Maximum Order Quantity (maoq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS FixedOrderQuantity															/*Fixed Order Quantity (fioq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS EconomicOrderQuantity														/*Economic Order Quantity (ecoq) | FALSE | 0 |  | |*/
	,CAST(999999999 AS FLOAT) AS MaximumInventory													/*Maximum Inventory (maxs) | FALSE | 999999999 |  | <1000000000|*/
	,CAST(0 AS FLOAT) AS ReorderPoint																/*Reorder Point (reop) |  | 0 |  | |*/
	,CAST(0 AS FLOAT) AS SafetyStock																/*Safety Stock (sfst) |  | 0 |  | |*/
from
	(
		SELECT
			 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
			,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
			,CAST('IT.EXT.08' AS VARCHAR(9)) AS Site				/*Site (site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
			,CAST(scm.Warehouse AS VARCHAR(6)) AS Warehouse 		/*Ordering - Warehouse (tcibd250.cwar) - Reference to tcmcs003 Warehouses ** Mandatory for item ordering by Site | FALSE | null | 6 | |*/
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
	)t1

UNION ALL

/* SITE: IT.EXT.09 */

SELECT
	CAST(t1.Warehouse AS VARCHAR(6)) AS Warehouse													/*Warehouse (cwar)  Reference to tcmcs003 Warehouses	ERPLN table: whwmd210, whwmd215, whwmd216 | TRUE | null | 6 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS Project														/*Project segment of Item (item)  Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | "PROJEMPTY" | 9 | |*/
	,CAST(t1.Item AS VARCHAR(38)) AS Item														/*Item (item)  Reference to whwmd400 Items | TRUE | null | 38 | |*/
	,CAST(2 AS FLOAT) AS UseItemOrderingData														/*Use Item Ordering data (uidt) | FALSE | 2 |  | 1;"Yes";2;"No (default)"|*/
	,CAST(1 AS FLOAT) AS InventoryValuationMethod													/*Inventory Valuation Method (valm) | TRUE | 1 |  | 1;"Standard Cost (default)";2;"Moving Average Unit Cost (MAUC)";3;"First In First Out (FIFO)";4;"Last In First Out (LILO)";5;"Lot Price (Lot)";6;"Serial Price (Serial)"|*/
	,CAST(0 AS FLOAT) AS OrderInterval																/*Order Interval  (oint) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS OrderIntervalUnit															/*Order Interval Unit (oivu) | TRUE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS SafetyTime																	/*Safety Time (sftm) | FALSE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS SafetyTimeUnit															/*Safety Time Unit (sftu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(0 AS FLOAT) AS InboundLeadTime															/*Inbound Lead Time (iltm) | TRUE | 0 |  | |*/
	,CAST(0 AS FLOAT) AS OutboundLeadTime															/*Outbound Lead Time (oltm) | TRUE | 0 |  | |*/
	,CAST(10 AS FLOAT) AS LeadTimeUnit																/*Lead time Unit (iltu/oltu) | FALSE | 10 |  | 5;Hours;10;Days|*/
	,CAST(1 AS FLOAT) AS OrderMethod																/*Order Method (omth) | FALSE | 1 |  | 1;"Lot for Lot (default)";2;"Economic Order Quantity";3;"Fixed Order Quantity";4;"Replenish to MAX.Inv."|*/
	,CAST(NULL AS VARCHAR(1)) AS ABCcode															/*ABC Code (abcc) | FALSE | null | 1 | |*/
	,CAST(1 AS FLOAT) AS OrderQuantityIncrement														/*Order Quantity Increment (oqmf) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity														/*Minimum Order Quantity (mioq) | FALSE | 0 |  | |*/
	,CAST(99999999 AS FLOAT) AS MaximumOrderQuantity												/*Maximum Order Quantity (maoq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS FixedOrderQuantity															/*Fixed Order Quantity (fioq) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS EconomicOrderQuantity														/*Economic Order Quantity (ecoq) | FALSE | 0 |  | |*/
	,CAST(999999999 AS FLOAT) AS MaximumInventory													/*Maximum Inventory (maxs) | FALSE | 999999999 |  | <1000000000|*/
	,CAST(0 AS FLOAT) AS ReorderPoint																/*Reorder Point (reop) |  | 0 |  | |*/
	,CAST(0 AS FLOAT) AS SafetyStock																/*Safety Stock (sfst) |  | 0 |  | |*/
from
	(
		SELECT
			 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
			,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
			,CAST('IT.EXT.09' AS VARCHAR(9)) AS Site				/*Site (site) - Reference to tcemm050 Sites | FALSE | null | 9 | |*/
			,CAST(scm.Warehouse AS VARCHAR(6)) AS Warehouse 		/*Ordering - Warehouse (tcibd250.cwar) - Reference to tcmcs003 Warehouses ** Mandatory for item ordering by Site | FALSE | null | 6 | |*/
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
						,'IT.POV.09' AS Site														/*Site (tisub100/110.site) - References to tcemm050 Sites | FALSE | '' |Text | 9 | |*/
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
	)t1
GO


