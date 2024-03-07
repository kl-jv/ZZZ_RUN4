USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_SubcontractingBOM]    Script Date: 3/7/2024 12:27:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vw_SubcontractingBOM] AS 

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

UNION ALL

/* UNION ALL FOR SPARE PATS POV 3 */

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
	LEFT JOIN ZZZ_Italy.dbo.SubContractorSupplier scs ON (kps.ItemLnCE = scs.Item AND scs.Type = 'Product')
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bps ON (scs.Subcontractor = bps.KPraktor)
	JOIN KPRAKTOR.SIAPR.ANAMAG its ON (bom.DB_CODICE_FIGLIO = its.MG_CODICE AND bom.DB_DITTA = its.MG_DITTA)	
	JOIN ZZZ_Italy.dbo.KPSource kpc ON (bom.DB_CODICE_FIGLIO = kpc.Item AND bom.DB_DITTA = 1 AND kps.Migrate = 1 AND kpc.Class NOT IN (4))
	LEFT JOIN ZZZ_Italy.dbo.UsageConversionFactors ucf ON (kpc.ItemLnCE = ucf.ItemlnCE)
	LEFT JOIN ZZZ_Italy.dbo.SubContractorSupplier scc ON (kpc.ItemLnCE = scc.Item AND scc.Type = 'Material')
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (scc.[Supplying BP] = bpc.KPraktor)
	LEFT JOIN ZZZ_Italy.dbo.SCModelMap sms ON (kps.POV3 = sms.POV3 AND sms.Site = 'IT.POV.03')
---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F tac ON (itm.MG_DITTA = tac.TED_DITTA AND itm.MG_ESPL_DB = tac.TED_ESPL_DB)
---	LEFT JOIN KPRAKTOR.dbo.TABESPLDB_F taf ON (its.MG_DITTA = taf.TED_DITTA AND its.MG_ESPL_DB = taf.TED_ESPL_DB)
WHERE
	bom.DB_DATA_FIN_VAL >= CONVERT(INT,GETDATE())
	AND kpp.SupplySource IN ('50')
	AND (kps.POV3 <> 0)




GO


