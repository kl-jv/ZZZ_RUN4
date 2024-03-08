USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_ItemPurchaseBPbyItem]    Script Date: 3/8/2024 10:55:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







ALTER VIEW [dbo].[vw_ItemPurchaseBPbyItem] AS 

				/* By Site */
				/* IT.POV.01 */
SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 General Projects.  *** This field must be filled with "PROJEMPTY"  if no project is used. | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item								/*Item segment of Item (item)   - Reference to tdipu001 Item Purchase Data | TRUE | null | 38 | |*/
	,CAST(CASE WHEN bpc.[Business Partner] IS NULL THEN NULL ELSE bpc.[Business Partner]  END AS VARCHAR(9)) AS BuyFromBusinessPartner	/*Buy-from Business Partner (otbp)   - Reference tccom120 Buy-from Business Partners | TRUE | null | 9 | |*/
	,CAST(CASE WHEN bpc.[Business Partner] IS NULL THEN NULL ELSE bpc.[Business Partner]  END AS VARCHAR(9)) AS ShipFromBusinessPartner	/*Ship-from Business Partner (sfbp)   - Reference tccom121 Ship-from Business Partners ** At least fill with same value as BuyFromBusinessPartner | TRUE | null | 9 | |*/
	,CAST('IT.POV.01' AS VARCHAR(9)) AS [Site]								/* Site (site) - Reference to tcemm050 Sites - to create record for tdipu090 Item - Purchase Business Partner by Site | TRUE |  |  | Text | 9 |*/
	,CAST(NULL AS VARCHAR(6)) AS PurchaseOffice								/* Purchase Office (tdipu010.cofc/tdipu090.poff)   - Reference to tdpur012 Purchase Offices ** If site concept is activated, a new record will be created in tdpu090 when purchase office is filled, else it will be used in tdipu010 | FALSE |  |  | Text | 6 |*/
	,CAST(NULL AS VARCHAR(6)) AS SitePurchaseOffice							/* Site Purchase Office (tdipu090.cofc)   - Reference to tdpur012 Purchase Offices ** Purchase office for Item purchase BP by site. | FALSE |  |  | Text | 6 |*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate			/*Effective Date (efdt) | TRUE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpDate									/*Expiry Date (exdt) | TRUE | null |  | |*/
	,1 AS Preferred															/*Preferred (pref) | TRUE | 1 |  | 1;"Preferred (default)";2;"Single Source"|*/
	,100 AS SourcingPercentage												/*Sourcing Percentage (srcp) | FALSE | 100 |  | >=0 And <=100|*/
	,2 AS ShipmentOrDeliveryBased											/*Shipment or Receipt Based (depu) | FALSE | 2 |  | 1;"Shipment Based";2;"Receipt Based (default)"|*/
	,CAST(mrp.GE_QTA_MIN_RIOR AS FLOAT) AS MinimumOrderQuantity				/*Minimum Order Quantity (tdiu010.qimi) | FALSE | 0 |  | |*/
	,CAST(mrp.GE_QTA_MULT_RIOR AS FLOAT) AS OrderQuantityIncrement			/*Order Quantity Increment (tdiu010.qimf) | FALSE | 0 |  | |*/
	,CAST(NULL AS VARCHAR(3)) AS Carrier									/*Carrier (cfrw)   - Reference to tcmcs080 Carriers | FALSE | null | 3 | |*/
	,CAST(mrp.GE_T_APPR_ACQ AS FLOAT) AS SupplyTime							/*Supply Time (suti) | FALSE | 0 |  | |*/
	,2 AS Inspection														/*Inspection (qual) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,10 AS ReleaseType														/*ReleaseType (scrd) ** Purchase Schedules: Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 10 |  | 1;"Material Release";2;"Shipping Schedule";4;"Shipping Schedule Only";10;"Not Applicable"|*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialReleasePattern						/*Material Release Issue Pattern (pttr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingSchedulePattern					/*Shipping Schedule Issue Pattern (ptss) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 6 | |*/
	,1 AS CommunicationChannel												/*Communication Channel (wcom) ** Purchase Schedules (scrd) **Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 1 |  | 1;""EDI"";4;""Internet"";5;""E-Mail"";7;""Post"";8;""BOD"";9;""Manual""|*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetMaterial							/*Segment Set for Material Release (ssmr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetShipping							/*Segment Set for Shipping Schedule (segs) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 3 | |*/
	,0 AS FrozenPeriodInc													/*Frozen Period for Increasing Quantity in days (freh) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
	,0 AS FrozenPeriodDec													/*Frozen Period for Decreasing Quantity in days (frel) ** Only applicable for Purchase Schedules |  | 0 |  | |*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm

/* 21-02-2024 : KL POV1 <> 0 ,  Remove POV2 , RD must be kept  */
--	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND (kps.POV1 = 1 OR kps.POV2 = 1 OR kps.RD = 1))

	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND (kps.POV1 <> 0))
	LEFT JOIN KPRAKTOR.SIAPR.ANAGES mrp ON (itm.MG_CODICE = mrp.GE_CODICE_ART AND itm.MG_DITTA = mrp.GE_DITTA)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (itm.MG_CODFOR_PREF = bpc.KPraktor AND itm.MG_DITTA = 1)
WHERE
	itm.MG_CODFOR_PREF NOT LIKE ''
	AND bpc.[Business Partner] IS NOT NULL

UNION ALL

		/* IT.POV.03 */

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 General Projects.  *** This field must be filled with "PROJEMPTY"  if no project is used. | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item
	,CAST(CASE WHEN bpc.[Business Partner] IS NULL THEN NULL ELSE bpc.[Business Partner]  END AS VARCHAR(9)) AS BuyFromBusinessPartner	/*Buy-from Business Partner (otbp)   - Reference tccom120 Buy-from Business Partners | TRUE | null | 9 | |*/
	,CAST(CASE WHEN bpc.[Business Partner] IS NULL THEN NULL ELSE bpc.[Business Partner]  END AS VARCHAR(9)) AS ShipFromBusinessPartner	/*Ship-from Business Partner (sfbp)   - Reference tccom121 Ship-from Business Partners ** At least fill with same value as BuyFromBusinessPartner | TRUE | null | 9 | |*/
	,CAST('IT.POV.03' AS VARCHAR(9)) AS [Site]								/* Site (site) - Reference to tcemm050 Sites - to create record for tdipu090 Item - Purchase Business Partner by Site | TRUE |  |  | Text | 9 |*/
	,CAST(NULL AS VARCHAR(6)) AS PurchaseOffice								/* Purchase Office (tdipu010.cofc/tdipu090.poff)   - Reference to tdpur012 Purchase Offices ** If site concept is activated, a new record will be created in tdpu090 when purchase office is filled, else it will be used in tdipu010 | FALSE |  |  | Text | 6 |*/
	,CAST(NULL AS VARCHAR(6)) AS SitePurchaseOffice							/* Site Purchase Office (tdipu090.cofc)   - Reference to tdpur012 Purchase Offices ** Purchase office for Item purchase BP by site. | FALSE |  |  | Text | 6 |*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate			/*Effective Date (efdt) | TRUE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpDate									/*Expiry Date (exdt) | TRUE | null |  | |*/
	,1 AS Preferred															/*Preferred (pref) | TRUE | 1 |  | 1;"Preferred (default)";2;"Single Source"|*/
	,100 AS SourcingPercentage												/*Sourcing Percentage (srcp) | FALSE | 100 |  | >=0 And <=100|*/
	,2 AS ShipmentOrDeliveryBased											/*Shipment or Receipt Based (depu) | FALSE | 2 |  | 1;"Shipment Based";2;"Receipt Based (default)"|*/
	,CAST(mrp.GE_QTA_MIN_RIOR AS FLOAT) AS MinimumOrderQuantity				/*Minimum Order Quantity (tdiu010.qimi) | FALSE | 0 |  | |*/
	,CAST(mrp.GE_QTA_MULT_RIOR AS FLOAT) AS OrderQuantityIncrement			/*Order Quantity Increment (tdiu010.qimf) | FALSE | 0 |  | |*/
	,CAST(NULL AS VARCHAR(3)) AS Carrier									/*Carrier (cfrw)   - Reference to tcmcs080 Carriers | FALSE | null | 3 | |*/
	,CAST(CASE WHEN kpp.SupplyTime IS NULL THEN 0 ELSE kpp.SupplyTime END AS FLOAT) AS SupplyTime							/*Supply Time (suti) | FALSE | 0 |  | |*/
	,2 AS Inspection														/*Inspection (qual) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,10 AS ReleaseType														/*ReleaseType (scrd) ** Purchase Schedules: Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 10 |  | 1;"Material Release";2;"Shipping Schedule";4;"Shipping Schedule Only";10;"Not Applicable"|*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialReleasePattern						/*Material Release Issue Pattern (pttr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingSchedulePattern					/*Shipping Schedule Issue Pattern (ptss) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 6 | |*/
	,1 AS CommunicationChannel												/*Communication Channel (wcom) ** Purchase Schedules (scrd) **Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 1 |  | 1;""EDI"";4;""Internet"";5;""E-Mail"";7;""Post"";8;""BOD"";9;""Manual""|*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetMaterial							/*Segment Set for Material Release (ssmr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetShipping							/*Segment Set for Shipping Schedule (segs) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 3 | |*/
	,0 AS FrozenPeriodInc													/*Frozen Period for Increasing Quantity in days (freh) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
	,0 AS FrozenPeriodDec													/*Frozen Period for Decreasing Quantity in days (frel) ** Only applicable for Purchase Schedules |  | 0 |  | |*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND kps.POV3 = 1)
	JOIN ZZZ_Italy.dbo.KPSourceSp kpp ON (kps.Item = kpp.Item)
	LEFT JOIN KPRAKTOR.SIAPR.ANAGES mrp ON (itm.MG_CODICE = mrp.GE_CODICE_ART AND itm.MG_DITTA = mrp.GE_DITTA)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (itm.MG_CODFOR_PREF = bpc.KPraktor AND itm.MG_DITTA = 1)
WHERE
	itm.MG_CODFOR_PREF NOT LIKE ''
	AND bpc.[Business Partner] IS NOT NULL

UNION ALL


/* SITE: IT.EXT.01 */

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 General Projects.  *** This field must be filled with "PROJEMPTY"  if no project is used. | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(t1.Item AS VARCHAR(38)) AS Item								/*Item segment of Item (item)   - Reference to tdipu001 Item Purchase Data | TRUE | null | 38 | |*/
	,CAST(CASE WHEN t1.PurchaseBuyFromBP IS NULL THEN NULL ELSE t1.PurchaseBuyFromBP END AS VARCHAR(9)) AS BuyFromBusinessPartner	/*Buy-from Business Partner (otbp)   - Reference tccom120 Buy-from Business Partners | TRUE | null | 9 | |*/
	,CAST(CASE WHEN t1.PurchaseBuyFromBP IS NULL THEN NULL ELSE t1.PurchaseBuyFromBP  END AS VARCHAR(9)) AS ShipFromBusinessPartner	/*Ship-from Business Partner (sfbp)   - Reference tccom121 Ship-from Business Partners ** At least fill with same value as BuyFromBusinessPartner | TRUE | null | 9 | |*/
	,CAST('IT.EXT.01' AS VARCHAR(9)) AS [Site]								/* Site (site) - Reference to tcemm050 Sites - to create record for tdipu090 Item - Purchase Business Partner by Site | TRUE |  |  | Text | 9 |*/
	,CAST(NULL AS VARCHAR(6)) AS PurchaseOffice								/* Purchase Office (tdipu010.cofc/tdipu090.poff)   - Reference to tdpur012 Purchase Offices ** If site concept is activated, a new record will be created in tdpu090 when purchase office is filled, else it will be used in tdipu010 | FALSE |  |  | Text | 6 |*/
	,CAST(NULL AS VARCHAR(6)) AS SitePurchaseOffice							/* Site Purchase Office (tdipu090.cofc)   - Reference to tdpur012 Purchase Offices ** Purchase office for Item purchase BP by site. | FALSE |  |  | Text | 6 |*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate			/*Effective Date (efdt) | TRUE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpDate									/*Expiry Date (exdt) | TRUE | null |  | |*/
	,1 AS Preferred															/*Preferred (pref) | TRUE | 1 |  | 1;"Preferred (default)";2;"Single Source"|*/
	,100 AS SourcingPercentage												/*Sourcing Percentage (srcp) | FALSE | 100 |  | >=0 And <=100|*/
	,2 AS ShipmentOrDeliveryBased											/*Shipment or Receipt Based (depu) | FALSE | 2 |  | 1;"Shipment Based";2;"Receipt Based (default)"|*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity								/*Minimum Order Quantity (tdiu010.qimi) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS OrderQuantityIncrement								/*Order Quantity Increment (tdiu010.qimf) | FALSE | 0 |  | |*/
	,CAST(NULL AS VARCHAR(3)) AS Carrier									/*Carrier (cfrw)   - Reference to tcmcs080 Carriers | FALSE | null | 3 | |*/
	,CAST(0 AS FLOAT) AS SupplyTime											/*Supply Time (suti) | FALSE | 0 |  | |*/
	,2 AS Inspection														/*Inspection (qual) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,10 AS ReleaseType														/*ReleaseType (scrd) ** Purchase Schedules: Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 10 |  | 1;"Material Release";2;"Shipping Schedule";4;"Shipping Schedule Only";10;"Not Applicable"|*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialReleasePattern						/*Material Release Issue Pattern (pttr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingSchedulePattern					/*Shipping Schedule Issue Pattern (ptss) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 6 | |*/
	,1 AS CommunicationChannel												/*Communication Channel (wcom) ** Purchase Schedules (scrd) **Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 1 |  | 1;""EDI"";4;""Internet"";5;""E-Mail"";7;""Post"";8;""BOD"";9;""Manual""|*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetMaterial							/*Segment Set for Material Release (ssmr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetShipping							/*Segment Set for Shipping Schedule (segs) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 3 | |*/
	,0 AS FrozenPeriodInc													/*Frozen Period for Increasing Quantity in days (freh) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
	,0 AS FrozenPeriodDec													/*Frozen Period for Decreasing Quantity in days (frel) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
FROM
	(
		SELECT
			 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
			,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
			,CAST(bpc.[Business Partner] AS VARCHAR(9)) AS PurchaseBuyFromBP					/*Purchase Buy-from Business Partner (tdipu081.otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | |*/
		FROM
			KPRAKTOR.SIAPR.ANAMAG itm
			JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 AND (kps.POV1 <> 0))
			JOIN 
				(
					SELECT
						DISTINCT 
						 t1.Subcontractor
						,t1.Item
					FROM
						(
					SELECT
						DISTINCT  
							 t1.Subcontractor AS Subcontractor
							,t1.ProductItem AS Item
					FROM
						(
					SELECT
						 'PROJEMPTY' AS ProductProject												/*Project segment of Product (tisub100/110.item) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                   Infor LN tables: tisub100, tisub110 | TRUE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tisub100/110.item) - References to tcibd001 Item General Data | TRUE | '' |Text | 38 | |*/	
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN NULL ELSE bps.[Business Partner] END AS VARCHAR(9)) AS Subcontractor														/*Subcontractor (tisub100/110.subc) - Reference tccom120 Buy-from Business Partners | TRUE | '' |Text | 9 | |*/
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN NULL ELSE bps.[Business Partner] END AS VARCHAR(9)) AS ShipFromBP  	/*Ship-from Business Partner (tisub100/110.sfbp) - Reference tccom121 Ship-from Business Partners ** At least fill with same value as Subcontractor | TRUE | '' |Text | 9 | |*/
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
						LEFT JOIN ZZZ_Italy.dbo.SubContractorSupplier scs ON (kps.ItemLnCE = scs.Item AND scs.Type = 'Product')
						LEFT JOIN ZZZ_Italy.dbo.BP_Conv bps ON (scs.Subcontractor = bps.KPraktor)
						JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)	
						JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kpc.Class NOT IN (4))
						LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
						LEFT JOIN ZZZ_Italy.dbo.SubContractorSupplier scc ON (kpc.ItemLnCE = scc.Item AND scc.Type = 'Material')
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

					SELECT
						DISTINCT  
							 t1.Subcontractor AS Subcontractor
							,t1.MaterialItem AS Item
					FROM
						(
					SELECT
						 'PROJEMPTY' AS ProductProject												/*Project segment of Product (tisub100/110.item) - References to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY".                   Infor LN tables: tisub100, tisub110 | TRUE | "PROJEMPTY" |Text | 9 | |*/
						,CAST(kps.ItemLnCE AS VARCHAR(38)) AS ProductItem							/*Item segment of Product (tisub100/110.item) - References to tcibd001 Item General Data | TRUE | '' |Text | 38 | |*/	
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN NULL ELSE bps.[Business Partner] END AS VARCHAR(9)) AS Subcontractor														/*Subcontractor (tisub100/110.subc) - Reference tccom120 Buy-from Business Partners | TRUE | '' |Text | 9 | |*/
						,CAST(CASE WHEN bps.[Business Partner] IS NULL THEN NULL ELSE bps.[Business Partner] END AS VARCHAR(9)) AS ShipFromBP  	/*Ship-from Business Partner (tisub100/110.sfbp) - Reference tccom121 Ship-from Business Partners ** At least fill with same value as Subcontractor | TRUE | '' |Text | 9 | |*/
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
where
	t1.PurchaseBuyFromBP is not null

UNION ALL


/* SITE: IT.EXT.03 */

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 General Projects.  *** This field must be filled with "PROJEMPTY"  if no project is used. | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(t1.Item AS VARCHAR(38)) AS Item								/*Item segment of Item (item)   - Reference to tdipu001 Item Purchase Data | TRUE | null | 38 | |*/
	,CAST(CASE WHEN t1.PurchaseBuyFromBP IS NULL THEN NULL ELSE t1.PurchaseBuyFromBP END AS VARCHAR(9)) AS BuyFromBusinessPartner	/*Buy-from Business Partner (otbp)   - Reference tccom120 Buy-from Business Partners | TRUE | null | 9 | |*/
	,CAST(CASE WHEN t1.PurchaseBuyFromBP IS NULL THEN NULL ELSE t1.PurchaseBuyFromBP  END AS VARCHAR(9)) AS ShipFromBusinessPartner	/*Ship-from Business Partner (sfbp)   - Reference tccom121 Ship-from Business Partners ** At least fill with same value as BuyFromBusinessPartner | TRUE | null | 9 | |*/
	,CAST('IT.EXT.03' AS VARCHAR(9)) AS [Site]								/* Site (site) - Reference to tcemm050 Sites - to create record for tdipu090 Item - Purchase Business Partner by Site | TRUE |  |  | Text | 9 |*/
	,CAST(NULL AS VARCHAR(6)) AS PurchaseOffice								/* Purchase Office (tdipu010.cofc/tdipu090.poff)   - Reference to tdpur012 Purchase Offices ** If site concept is activated, a new record will be created in tdpu090 when purchase office is filled, else it will be used in tdipu010 | FALSE |  |  | Text | 6 |*/
	,CAST(NULL AS VARCHAR(6)) AS SitePurchaseOffice							/* Site Purchase Office (tdipu090.cofc)   - Reference to tdpur012 Purchase Offices ** Purchase office for Item purchase BP by site. | FALSE |  |  | Text | 6 |*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate			/*Effective Date (efdt) | TRUE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpDate									/*Expiry Date (exdt) | TRUE | null |  | |*/
	,1 AS Preferred															/*Preferred (pref) | TRUE | 1 |  | 1;"Preferred (default)";2;"Single Source"|*/
	,100 AS SourcingPercentage												/*Sourcing Percentage (srcp) | FALSE | 100 |  | >=0 And <=100|*/
	,2 AS ShipmentOrDeliveryBased											/*Shipment or Receipt Based (depu) | FALSE | 2 |  | 1;"Shipment Based";2;"Receipt Based (default)"|*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity								/*Minimum Order Quantity (tdiu010.qimi) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS OrderQuantityIncrement								/*Order Quantity Increment (tdiu010.qimf) | FALSE | 0 |  | |*/
	,CAST(NULL AS VARCHAR(3)) AS Carrier									/*Carrier (cfrw)   - Reference to tcmcs080 Carriers | FALSE | null | 3 | |*/
	,CAST(0 AS FLOAT) AS SupplyTime											/*Supply Time (suti) | FALSE | 0 |  | |*/
	,2 AS Inspection														/*Inspection (qual) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,10 AS ReleaseType														/*ReleaseType (scrd) ** Purchase Schedules: Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 10 |  | 1;"Material Release";2;"Shipping Schedule";4;"Shipping Schedule Only";10;"Not Applicable"|*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialReleasePattern						/*Material Release Issue Pattern (pttr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingSchedulePattern					/*Shipping Schedule Issue Pattern (ptss) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 6 | |*/
	,1 AS CommunicationChannel												/*Communication Channel (wcom) ** Purchase Schedules (scrd) **Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 1 |  | 1;""EDI"";4;""Internet"";5;""E-Mail"";7;""Post"";8;""BOD"";9;""Manual""|*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetMaterial							/*Segment Set for Material Release (ssmr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetShipping							/*Segment Set for Shipping Schedule (segs) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 3 | |*/
	,0 AS FrozenPeriodInc													/*Frozen Period for Increasing Quantity in days (freh) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
	,0 AS FrozenPeriodDec													/*Frozen Period for Decreasing Quantity in days (frel) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
from
	(
		SELECT
			 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
			,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
			,CAST(bpc.[Business Partner] AS VARCHAR(9)) AS PurchaseBuyFromBP					/*Purchase Buy-from Business Partner (tdipu081.otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | |*/
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
where
	t1.PurchaseBuyFromBP is not null

UNION ALL


/* SITE: IT.EXT.05 */

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 General Projects.  *** This field must be filled with "PROJEMPTY"  if no project is used. | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(t1.Item AS VARCHAR(38)) AS Item								/*Item segment of Item (item)   - Reference to tdipu001 Item Purchase Data | TRUE | null | 38 | |*/
	,CAST(CASE WHEN t1.PurchaseBuyFromBP IS NULL THEN NULL ELSE t1.PurchaseBuyFromBP END AS VARCHAR(9)) AS BuyFromBusinessPartner	/*Buy-from Business Partner (otbp)   - Reference tccom120 Buy-from Business Partners | TRUE | null | 9 | |*/
	,CAST(CASE WHEN t1.PurchaseBuyFromBP IS NULL THEN NULL ELSE t1.PurchaseBuyFromBP  END AS VARCHAR(9)) AS ShipFromBusinessPartner	/*Ship-from Business Partner (sfbp)   - Reference tccom121 Ship-from Business Partners ** At least fill with same value as BuyFromBusinessPartner | TRUE | null | 9 | |*/
	,CAST('IT.EXT.05' AS VARCHAR(9)) AS [Site]								/* Site (site) - Reference to tcemm050 Sites - to create record for tdipu090 Item - Purchase Business Partner by Site | TRUE |  |  | Text | 9 |*/
	,CAST(NULL AS VARCHAR(6)) AS PurchaseOffice								/* Purchase Office (tdipu010.cofc/tdipu090.poff)   - Reference to tdpur012 Purchase Offices ** If site concept is activated, a new record will be created in tdpu090 when purchase office is filled, else it will be used in tdipu010 | FALSE |  |  | Text | 6 |*/
	,CAST(NULL AS VARCHAR(6)) AS SitePurchaseOffice							/* Site Purchase Office (tdipu090.cofc)   - Reference to tdpur012 Purchase Offices ** Purchase office for Item purchase BP by site. | FALSE |  |  | Text | 6 |*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate			/*Effective Date (efdt) | TRUE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpDate									/*Expiry Date (exdt) | TRUE | null |  | |*/
	,1 AS Preferred															/*Preferred (pref) | TRUE | 1 |  | 1;"Preferred (default)";2;"Single Source"|*/
	,100 AS SourcingPercentage												/*Sourcing Percentage (srcp) | FALSE | 100 |  | >=0 And <=100|*/
	,2 AS ShipmentOrDeliveryBased											/*Shipment or Receipt Based (depu) | FALSE | 2 |  | 1;"Shipment Based";2;"Receipt Based (default)"|*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity								/*Minimum Order Quantity (tdiu010.qimi) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS OrderQuantityIncrement								/*Order Quantity Increment (tdiu010.qimf) | FALSE | 0 |  | |*/
	,CAST(NULL AS VARCHAR(3)) AS Carrier									/*Carrier (cfrw)   - Reference to tcmcs080 Carriers | FALSE | null | 3 | |*/
	,CAST(0 AS FLOAT) AS SupplyTime											/*Supply Time (suti) | FALSE | 0 |  | |*/
	,2 AS Inspection														/*Inspection (qual) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,10 AS ReleaseType														/*ReleaseType (scrd) ** Purchase Schedules: Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 10 |  | 1;"Material Release";2;"Shipping Schedule";4;"Shipping Schedule Only";10;"Not Applicable"|*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialReleasePattern						/*Material Release Issue Pattern (pttr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingSchedulePattern					/*Shipping Schedule Issue Pattern (ptss) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 6 | |*/
	,1 AS CommunicationChannel												/*Communication Channel (wcom) ** Purchase Schedules (scrd) **Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 1 |  | 1;""EDI"";4;""Internet"";5;""E-Mail"";7;""Post"";8;""BOD"";9;""Manual""|*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetMaterial							/*Segment Set for Material Release (ssmr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetShipping							/*Segment Set for Shipping Schedule (segs) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 3 | |*/
	,0 AS FrozenPeriodInc													/*Frozen Period for Increasing Quantity in days (freh) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
	,0 AS FrozenPeriodDec													/*Frozen Period for Decreasing Quantity in days (frel) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
from
	(
		SELECT
			 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
			,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
			,CAST(bpc.[Business Partner] AS VARCHAR(9)) AS PurchaseBuyFromBP					/*Purchase Buy-from Business Partner (tdipu081.otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | |*/
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
where
	t1.PurchaseBuyFromBP is not null

UNION ALL

/* SITE: IT.EXT.06 */

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 General Projects.  *** This field must be filled with "PROJEMPTY"  if no project is used. | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(t1.Item AS VARCHAR(38)) AS Item								/*Item segment of Item (item)   - Reference to tdipu001 Item Purchase Data | TRUE | null | 38 | |*/
	,CAST(CASE WHEN t1.PurchaseBuyFromBP IS NULL THEN NULL ELSE t1.PurchaseBuyFromBP END AS VARCHAR(9)) AS BuyFromBusinessPartner	/*Buy-from Business Partner (otbp)   - Reference tccom120 Buy-from Business Partners | TRUE | null | 9 | |*/
	,CAST(CASE WHEN t1.PurchaseBuyFromBP IS NULL THEN NULL ELSE t1.PurchaseBuyFromBP  END AS VARCHAR(9)) AS ShipFromBusinessPartner	/*Ship-from Business Partner (sfbp)   - Reference tccom121 Ship-from Business Partners ** At least fill with same value as BuyFromBusinessPartner | TRUE | null | 9 | |*/
	,CAST('IT.EXT.06' AS VARCHAR(9)) AS [Site]								/* Site (site) - Reference to tcemm050 Sites - to create record for tdipu090 Item - Purchase Business Partner by Site | TRUE |  |  | Text | 9 |*/
	,CAST(NULL AS VARCHAR(6)) AS PurchaseOffice								/* Purchase Office (tdipu010.cofc/tdipu090.poff)   - Reference to tdpur012 Purchase Offices ** If site concept is activated, a new record will be created in tdpu090 when purchase office is filled, else it will be used in tdipu010 | FALSE |  |  | Text | 6 |*/
	,CAST(NULL AS VARCHAR(6)) AS SitePurchaseOffice							/* Site Purchase Office (tdipu090.cofc)   - Reference to tdpur012 Purchase Offices ** Purchase office for Item purchase BP by site. | FALSE |  |  | Text | 6 |*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate			/*Effective Date (efdt) | TRUE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpDate									/*Expiry Date (exdt) | TRUE | null |  | |*/
	,1 AS Preferred															/*Preferred (pref) | TRUE | 1 |  | 1;"Preferred (default)";2;"Single Source"|*/
	,100 AS SourcingPercentage												/*Sourcing Percentage (srcp) | FALSE | 100 |  | >=0 And <=100|*/
	,2 AS ShipmentOrDeliveryBased											/*Shipment or Receipt Based (depu) | FALSE | 2 |  | 1;"Shipment Based";2;"Receipt Based (default)"|*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity								/*Minimum Order Quantity (tdiu010.qimi) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS OrderQuantityIncrement								/*Order Quantity Increment (tdiu010.qimf) | FALSE | 0 |  | |*/
	,CAST(NULL AS VARCHAR(3)) AS Carrier									/*Carrier (cfrw)   - Reference to tcmcs080 Carriers | FALSE | null | 3 | |*/
	,CAST(0 AS FLOAT) AS SupplyTime											/*Supply Time (suti) | FALSE | 0 |  | |*/
	,2 AS Inspection														/*Inspection (qual) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,10 AS ReleaseType														/*ReleaseType (scrd) ** Purchase Schedules: Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 10 |  | 1;"Material Release";2;"Shipping Schedule";4;"Shipping Schedule Only";10;"Not Applicable"|*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialReleasePattern						/*Material Release Issue Pattern (pttr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingSchedulePattern					/*Shipping Schedule Issue Pattern (ptss) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 6 | |*/
	,1 AS CommunicationChannel												/*Communication Channel (wcom) ** Purchase Schedules (scrd) **Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 1 |  | 1;""EDI"";4;""Internet"";5;""E-Mail"";7;""Post"";8;""BOD"";9;""Manual""|*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetMaterial							/*Segment Set for Material Release (ssmr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetShipping							/*Segment Set for Shipping Schedule (segs) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 3 | |*/
	,0 AS FrozenPeriodInc													/*Frozen Period for Increasing Quantity in days (freh) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
	,0 AS FrozenPeriodDec													/*Frozen Period for Decreasing Quantity in days (frel) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
from
	(
		SELECT
			 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
			,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
			,CAST(bpc.[Business Partner] AS VARCHAR(9)) AS PurchaseBuyFromBP					/*Purchase Buy-from Business Partner (tdipu081.otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | |*/
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
where
	t1.PurchaseBuyFromBP is not null

UNION ALL

/* SITE: IT.EXT.08 */

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 General Projects.  *** This field must be filled with "PROJEMPTY"  if no project is used. | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(t1.Item AS VARCHAR(38)) AS Item								/*Item segment of Item (item)   - Reference to tdipu001 Item Purchase Data | TRUE | null | 38 | |*/
	,CAST(CASE WHEN t1.PurchaseBuyFromBP IS NULL THEN NULL ELSE t1.PurchaseBuyFromBP END AS VARCHAR(9)) AS BuyFromBusinessPartner	/*Buy-from Business Partner (otbp)   - Reference tccom120 Buy-from Business Partners | TRUE | null | 9 | |*/
	,CAST(CASE WHEN t1.PurchaseBuyFromBP IS NULL THEN NULL ELSE t1.PurchaseBuyFromBP  END AS VARCHAR(9)) AS ShipFromBusinessPartner	/*Ship-from Business Partner (sfbp)   - Reference tccom121 Ship-from Business Partners ** At least fill with same value as BuyFromBusinessPartner | TRUE | null | 9 | |*/
	,CAST('IT.EXT.08' AS VARCHAR(9)) AS [Site]								/* Site (site) - Reference to tcemm050 Sites - to create record for tdipu090 Item - Purchase Business Partner by Site | TRUE |  |  | Text | 9 |*/
	,CAST(NULL AS VARCHAR(6)) AS PurchaseOffice								/* Purchase Office (tdipu010.cofc/tdipu090.poff)   - Reference to tdpur012 Purchase Offices ** If site concept is activated, a new record will be created in tdpu090 when purchase office is filled, else it will be used in tdipu010 | FALSE |  |  | Text | 6 |*/
	,CAST(NULL AS VARCHAR(6)) AS SitePurchaseOffice							/* Site Purchase Office (tdipu090.cofc)   - Reference to tdpur012 Purchase Offices ** Purchase office for Item purchase BP by site. | FALSE |  |  | Text | 6 |*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate			/*Effective Date (efdt) | TRUE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpDate									/*Expiry Date (exdt) | TRUE | null |  | |*/
	,1 AS Preferred															/*Preferred (pref) | TRUE | 1 |  | 1;"Preferred (default)";2;"Single Source"|*/
	,100 AS SourcingPercentage												/*Sourcing Percentage (srcp) | FALSE | 100 |  | >=0 And <=100|*/
	,2 AS ShipmentOrDeliveryBased											/*Shipment or Receipt Based (depu) | FALSE | 2 |  | 1;"Shipment Based";2;"Receipt Based (default)"|*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity								/*Minimum Order Quantity (tdiu010.qimi) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS OrderQuantityIncrement								/*Order Quantity Increment (tdiu010.qimf) | FALSE | 0 |  | |*/
	,CAST(NULL AS VARCHAR(3)) AS Carrier									/*Carrier (cfrw)   - Reference to tcmcs080 Carriers | FALSE | null | 3 | |*/
	,CAST(0 AS FLOAT) AS SupplyTime											/*Supply Time (suti) | FALSE | 0 |  | |*/
	,2 AS Inspection														/*Inspection (qual) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,10 AS ReleaseType														/*ReleaseType (scrd) ** Purchase Schedules: Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 10 |  | 1;"Material Release";2;"Shipping Schedule";4;"Shipping Schedule Only";10;"Not Applicable"|*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialReleasePattern						/*Material Release Issue Pattern (pttr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingSchedulePattern					/*Shipping Schedule Issue Pattern (ptss) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 6 | |*/
	,1 AS CommunicationChannel												/*Communication Channel (wcom) ** Purchase Schedules (scrd) **Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 1 |  | 1;""EDI"";4;""Internet"";5;""E-Mail"";7;""Post"";8;""BOD"";9;""Manual""|*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetMaterial							/*Segment Set for Material Release (ssmr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetShipping							/*Segment Set for Shipping Schedule (segs) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 3 | |*/
	,0 AS FrozenPeriodInc													/*Frozen Period for Increasing Quantity in days (freh) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
	,0 AS FrozenPeriodDec													/*Frozen Period for Decreasing Quantity in days (frel) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
from
	(
		SELECT
			 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
			,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
			,CAST(bpc.[Business Partner] AS VARCHAR(9)) AS PurchaseBuyFromBP					/*Purchase Buy-from Business Partner (tdipu081.otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | |*/
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
where
	t1.PurchaseBuyFromBP is not null

UNION ALL

/* SITE: IT.EXT.08 */

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 General Projects.  *** This field must be filled with "PROJEMPTY"  if no project is used. | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(t1.Item AS VARCHAR(38)) AS Item								/*Item segment of Item (item)   - Reference to tdipu001 Item Purchase Data | TRUE | null | 38 | |*/
	,CAST(CASE WHEN t1.PurchaseBuyFromBP IS NULL THEN NULL ELSE t1.PurchaseBuyFromBP END AS VARCHAR(9)) AS BuyFromBusinessPartner	/*Buy-from Business Partner (otbp)   - Reference tccom120 Buy-from Business Partners | TRUE | null | 9 | |*/
	,CAST(CASE WHEN t1.PurchaseBuyFromBP IS NULL THEN NULL ELSE t1.PurchaseBuyFromBP  END AS VARCHAR(9)) AS ShipFromBusinessPartner	/*Ship-from Business Partner (sfbp)   - Reference tccom121 Ship-from Business Partners ** At least fill with same value as BuyFromBusinessPartner | TRUE | null | 9 | |*/
	,CAST('IT.EXT.09' AS VARCHAR(9)) AS [Site]								/* Site (site) - Reference to tcemm050 Sites - to create record for tdipu090 Item - Purchase Business Partner by Site | TRUE |  |  | Text | 9 |*/
	,CAST(NULL AS VARCHAR(6)) AS PurchaseOffice								/* Purchase Office (tdipu010.cofc/tdipu090.poff)   - Reference to tdpur012 Purchase Offices ** If site concept is activated, a new record will be created in tdpu090 when purchase office is filled, else it will be used in tdipu010 | FALSE |  |  | Text | 6 |*/
	,CAST(NULL AS VARCHAR(6)) AS SitePurchaseOffice							/* Site Purchase Office (tdipu090.cofc)   - Reference to tdpur012 Purchase Offices ** Purchase office for Item purchase BP by site. | FALSE |  |  | Text | 6 |*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate			/*Effective Date (efdt) | TRUE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpDate									/*Expiry Date (exdt) | TRUE | null |  | |*/
	,1 AS Preferred															/*Preferred (pref) | TRUE | 1 |  | 1;"Preferred (default)";2;"Single Source"|*/
	,100 AS SourcingPercentage												/*Sourcing Percentage (srcp) | FALSE | 100 |  | >=0 And <=100|*/
	,2 AS ShipmentOrDeliveryBased											/*Shipment or Receipt Based (depu) | FALSE | 2 |  | 1;"Shipment Based";2;"Receipt Based (default)"|*/
	,CAST(1 AS FLOAT) AS MinimumOrderQuantity								/*Minimum Order Quantity (tdiu010.qimi) | FALSE | 0 |  | |*/
	,CAST(1 AS FLOAT) AS OrderQuantityIncrement								/*Order Quantity Increment (tdiu010.qimf) | FALSE | 0 |  | |*/
	,CAST(NULL AS VARCHAR(3)) AS Carrier									/*Carrier (cfrw)   - Reference to tcmcs080 Carriers | FALSE | null | 3 | |*/
	,CAST(0 AS FLOAT) AS SupplyTime											/*Supply Time (suti) | FALSE | 0 |  | |*/
	,2 AS Inspection														/*Inspection (qual) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,10 AS ReleaseType														/*ReleaseType (scrd) ** Purchase Schedules: Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 10 |  | 1;"Material Release";2;"Shipping Schedule";4;"Shipping Schedule Only";10;"Not Applicable"|*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialReleasePattern						/*Material Release Issue Pattern (pttr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingSchedulePattern					/*Shipping Schedule Issue Pattern (ptss) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 6 | |*/
	,1 AS CommunicationChannel												/*Communication Channel (wcom) ** Purchase Schedules (scrd) **Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 1 |  | 1;""EDI"";4;""Internet"";5;""E-Mail"";7;""Post"";8;""BOD"";9;""Manual""|*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetMaterial							/*Segment Set for Material Release (ssmr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetShipping							/*Segment Set for Shipping Schedule (segs) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 3 | |*/
	,0 AS FrozenPeriodInc													/*Frozen Period for Increasing Quantity in days (freh) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
	,0 AS FrozenPeriodDec													/*Frozen Period for Decreasing Quantity in days (frel) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
from
	(
		SELECT
			 'PROJEMPTY'  AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 Projects                                    ERPLN table: tcibd0150, tcibd250, tdipu081, tdisa081, tiipd051, tsmdm220, whwmd404 | TRUE | "PROJEMPTY" | 9 | |*/
			,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item	
			,CAST(bpc.[Business Partner] AS VARCHAR(9)) AS PurchaseBuyFromBP					/*Purchase Buy-from Business Partner (tdipu081.otbp)   - References tcom120 Buy-from Business Partners | FALSE | null | 9 | |*/
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
	)t1
where
	t1.PurchaseBuyFromBP is not null

-----
UNION ALL

				/* Office */

/* Not all fields below are needd for then Office */

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 General Projects.  *** This field must be filled with "PROJEMPTY"  if no project is used. | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item								/*Item segment of Item (item)   - Reference to tdipu001 Item Purchase Data | TRUE | null | 38 | |*/																			
	,CAST(CASE WHEN bpc.[Business Partner] IS NULL THEN NULL ELSE bpc.[Business Partner]  END AS VARCHAR(9)) AS BuyFromBusinessPartner	/*Buy-from Business Partner (otbp)   - Reference tccom120 Buy-from Business Partners | TRUE | null | 9 | |*/
	,CAST(CASE WHEN bpc.[Business Partner] IS NULL THEN NULL ELSE bpc.[Business Partner]  END AS VARCHAR(9)) AS ShipFromBusinessPartner	/*Ship-from Business Partner (sfbp)   - Reference tccom121 Ship-from Business Partners ** At least fill with same value as BuyFromBusinessPartner | TRUE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(9)) AS [Site]										/* Site (site) - Reference to tcemm050 Sites - to create record for tdipu090 Item - Purchase Business Partner by Site | TRUE |  |  | Text | 9 |*/
	,CAST('IT2200' AS VARCHAR(6)) AS PurchaseOffice							/* Purchase Office (tdipu010.cofc/tdipu090.poff)   - Reference to tdpur012 Purchase Offices ** If site concept is activated, a new record will be created in tdpu090 when purchase office is filled, else it will be used in tdipu010 | FALSE |  |  | Text | 6 |*/
	,CAST(NULL AS VARCHAR(6)) AS SitePurchaseOffice							/* Site Purchase Office (tdipu090.cofc)   - Reference to tdpur012 Purchase Offices ** Purchase office for Item purchase BP by site. | FALSE |  |  | Text | 6 |*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate			/*Effective Date (efdt) | TRUE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpDate									/*Expiry Date (exdt) | TRUE | null |  | |*/
	,1 AS Preferred															/*Preferred (pref) | TRUE | 1 |  | 1;"Preferred (default)";2;"Single Source"|*/
	,100 AS SourcingPercentage												/*Sourcing Percentage (srcp) | FALSE | 100 |  | >=0 And <=100|*/
	,2 AS ShipmentOrDeliveryBased											/*Shipment or Receipt Based (depu) | FALSE | 2 |  | 1;"Shipment Based";2;"Receipt Based (default)"|*/
	,1 AS MinimumOrderQuantity												/*Minimum Order Quantity (tdiu010.qimi) | FALSE | 0 |  | |*/
	,1 AS OrderQuantityIncrement											/*Order Quantity Increment (tdiu010.qimf) | FALSE | 0 |  | |*/
	,CAST(NULL AS VARCHAR(3)) AS Carrier									/*Carrier (cfrw)   - Reference to tcmcs080 Carriers | FALSE | null | 3 | |*/
	,0 AS SupplyTime														/*Supply Time (suti) | FALSE | 0 |  | |*/
	,2 AS Inspection														/*Inspection (qual) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,10 AS ReleaseType														/*ReleaseType (scrd) ** Purchase Schedules: Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 10 |  | 1;"Material Release";2;"Shipping Schedule";4;"Shipping Schedule Only";10;"Not Applicable"|*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialReleasePattern						/*Material Release Issue Pattern (pttr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingSchedulePattern					/*Shipping Schedule Issue Pattern (ptss) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 6 | |*/
	,1 AS CommunicationChannel												/*Communication Channel (wcom) ** Purchase Schedules (scrd) **Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 1 |  | 1;""EDI"";4;""Internet"";5;""E-Mail"";7;""Post"";8;""BOD"";9;""Manual""|*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetMaterial							/*Segment Set for Material Release (ssmr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetShipping							/*Segment Set for Shipping Schedule (segs) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 3 | |*/
	,0 AS FrozenPeriodInc													/*Frozen Period for Increasing Quantity in days (freh) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
	,0 AS FrozenPeriodDec													/*Frozen Period for Decreasing Quantity in days (frel) ** Only applicable for Purchase Schedules |  | 0 |  | |*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1)
	LEFT JOIN KPRAKTOR.SIAPR.ANAGES mrp ON (itm.MG_CODICE = mrp.GE_CODICE_ART AND itm.MG_DITTA = mrp.GE_DITTA)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (itm.MG_CODFOR_PREF = bpc.KPraktor AND itm.MG_DITTA = 1)
WHERE
	itm.MG_CODFOR_PREF NOT LIKE ''
/* 21-02-2024 : KL */
--	AND (kps.POV1 = 1 OR kps.POV2 = 1 OR kps.RD = 1 )    
	AND (kps.POV1 <>  0  OR kps.RD = 1 )  
	AND bpc.[Business Partner] IS NOT NULL

UNION ALL

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS Project								/*Project segment of Item (item)   - Reference to tcmcs052 General Projects.  *** This field must be filled with "PROJEMPTY"  if no project is used. | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item								/*Item segment of Item (item)   - Reference to tdipu001 Item Purchase Data | TRUE | null | 38 | |*/
	,CAST(CASE WHEN bpc.[Business Partner] IS NULL THEN NULL ELSE bpc.[Business Partner]  END AS VARCHAR(9)) AS BuyFromBusinessPartner	/*Buy-from Business Partner (otbp)   - Reference tccom120 Buy-from Business Partners | TRUE | null | 9 | |*/
	,CAST(CASE WHEN bpc.[Business Partner] IS NULL THEN NULL ELSE bpc.[Business Partner]  END AS VARCHAR(9)) AS ShipFromBusinessPartner	/*Ship-from Business Partner (sfbp)   - Reference tccom121 Ship-from Business Partners ** At least fill with same value as BuyFromBusinessPartner | TRUE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(9)) AS [Site]										/* Site (site) - Reference to tcemm050 Sites - to create record for tdipu090 Item - Purchase Business Partner by Site | TRUE |  |  | Text | 9 |*/
	,CAST('IT2250' AS VARCHAR(6)) AS PurchaseOffice							/* Purchase Office (tdipu010.cofc/tdipu090.poff)   - Reference to tdpur012 Purchase Offices ** If site concept is activated, a new record will be created in tdpu090 when purchase office is filled, else it will be used in tdipu010 | FALSE |  |  | Text | 6 |*/
	,CAST(NULL AS VARCHAR(6)) AS SitePurchaseOffice							/* Site Purchase Office (tdipu090.cofc)   - Reference to tdpur012 Purchase Offices ** Purchase office for Item purchase BP by site. | FALSE |  |  | Text | 6 |*/
	,CAST('2023/01/01 00:00:00' AS SMALLDATETIME) AS EffectiveDate			/*Effective Date (efdt) | TRUE | null |  | |*/
	,CAST(NULL AS SMALLDATETIME) AS ExpDate									/*Expiry Date (exdt) | TRUE | null |  | |*/
	,1 AS Preferred															/*Preferred (pref) | TRUE | 1 |  | 1;"Preferred (default)";2;"Single Source"|*/
	,100 AS SourcingPercentage												/*Sourcing Percentage (srcp) | FALSE | 100 |  | >=0 And <=100|*/
	,2 AS ShipmentOrDeliveryBased											/*Shipment or Receipt Based (depu) | FALSE | 2 |  | 1;"Shipment Based";2;"Receipt Based (default)"|*/
	,1 AS MinimumOrderQuantity												/*Minimum Order Quantity (tdiu010.qimi) | FALSE | 0 |  | |*/
	,1 AS OrderQuantityIncrement											/*Order Quantity Increment (tdiu010.qimf) | FALSE | 0 |  | |*/
	,CAST(NULL AS VARCHAR(3)) AS Carrier									/*Carrier (cfrw)   - Reference to tcmcs080 Carriers | FALSE | null | 3 | |*/
	,0 AS SupplyTime														/*Supply Time (suti) | FALSE | 0 |  | |*/
	,2 AS Inspection														/*Inspection (qual) | FALSE | 2 |  | 1;"Yes";2;"No"|*/
	,10 AS ReleaseType														/*ReleaseType (scrd) ** Purchase Schedules: Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 10 |  | 1;"Material Release";2;"Shipping Schedule";4;"Shipping Schedule Only";10;"Not Applicable"|*/
	,CAST(NULL AS VARCHAR(6)) AS MaterialReleasePattern						/*Material Release Issue Pattern (pttr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 6 | |*/
	,CAST(NULL AS VARCHAR(6)) AS ShippingSchedulePattern					/*Shipping Schedule Issue Pattern (ptss) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 6 | |*/
	,1 AS CommunicationChannel												/*Communication Channel (wcom) ** Purchase Schedules (scrd) **Use value 1,2 or 4 when PurchaseSchedules is checked on item. | FALSE | 1 |  | 1;""EDI"";4;""Internet"";5;""E-Mail"";7;""Post"";8;""BOD"";9;""Manual""|*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetMaterial							/*Segment Set for Material Release (ssmr) ** Purchase Schedules: Mandatory if Release Type is 1 (Material Release) or 2 (Shipping Schedule) | FALSE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(3)) AS SegmentSetShipping							/*Segment Set for Shipping Schedule (segs) ** Purchase Schedules: Mandatory if Release Type is 2 (Shipping Schedule) or 4 (Shipping Schedule Only) | FALSE | null | 3 | |*/
	,0 AS FrozenPeriodInc													/*Frozen Period for Increasing Quantity in days (freh) ** Only applicable for Purchase Schedules |  | 0 |  | |*/
	,0 AS FrozenPeriodDec													/*Frozen Period for Decreasing Quantity in days (frel) ** Only applicable for Purchase Schedules |  | 0 |  | |*/

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1)
	LEFT JOIN KPRAKTOR.SIAPR.ANAGES mrp ON (itm.MG_CODICE = mrp.GE_CODICE_ART AND itm.MG_DITTA = mrp.GE_DITTA)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (itm.MG_CODFOR_PREF = bpc.KPraktor AND itm.MG_DITTA = 1)
WHERE
	itm.MG_CODFOR_PREF NOT LIKE ''
	AND kps.POV3 =1
	AND bpc.[Business Partner] IS NOT NULL
GO


