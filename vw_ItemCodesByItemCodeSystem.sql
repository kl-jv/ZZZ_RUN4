USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_ItemCodesByItemCodeSystem]    Script Date: 3/8/2024 10:08:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vw_ItemCodesByItemCodeSystem] AS

SELECT
	 CAST('BPB' AS VARCHAR(3)) AS ItemCodeSystem									/*Item Code System (citt)   - Reference to tcibd006 Item Code Systems                                                                    ERPLN table: tcibd004 | TRUE | null | 3 | |*/
	,CAST(bpc.[Business Partner] AS VARCHAR(9)) AS BusinessPartner	   				    /*Business Partner (bpid)   - Reference to tccom100 Business Partners -- Mandatory if type of item code system is ?Business Partner?. If type is ?General? this field should be empty. | TRUE | null | 9 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS Project										/*Project segment of Item (item)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item										/*Item segment of Item (item)  -  Reference to tcibd001 General Item Data | FALSE | null | 38 | |*/	
	,CAST(ppn.SupplierItem AS VARCHAR(35)) AS AlternativeItemCode					/*Alternative Item Code (aitc) |  | null | 35 | |*/
	,CAST(NULL AS VARCHAR(30)) AS AlternativeItemCodeDescription					/*Alternative Item Code Description (aitd) |  | null | 30 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RevisionBusinessPartner							/*Business Partner Revision (tcibd014.revi)  If populated, record in tcbd014 will be created. |FALSE | Text |35	| */
	,CAST(NULL AS SMALLDATETIME) AS  RevisionEffectiveDate							/*Effective Date Revision (tcibd014.efdt) Effective date for tcibd014 | FALSE | Date/Time| | */

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1)
	JOIN ZZZ_Italy.dbo.PurchasePrices ppn ON (itm.MG_CODICE = ppn.Item AND itm.MG_DITTA = 1)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (ppn.LF_Supplier = bpc.KPraktor)
WHERE
	itm.MG_GEST_PROD IN ('A','N')
---	AND LEN(TRIM(MG_CODFOR_PREF)) >0
	AND bpc.[Business Partner] IS NOT NULL
	AND ppn.SupplierItem IS NOT NULL

UNION ALL

SELECT
	 CAST('KEN' AS VARCHAR(3)) AS ItemCodeSystem									/*Item Code System (citt)   - Reference to tcibd006 Item Code Systems                                                                    ERPLN table: tcibd004 | TRUE | null | 3 | |*/
	,CAST(NULL AS VARCHAR(9)) AS BusinessPartner
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS Project										/*Project segment of Item (item)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS Item										/*Item segment of Item (item)  -  Reference to tcibd001 General Item Data | FALSE | null | 38 | |*/	
	,CAST(ken.KENNIS AS VARCHAR(35)) AS AlternativeItemCode					/*Alternative Item Code (aitc) |  | null | 35 | |*/
	,CAST(ken.DESCRI AS VARCHAR(50)) AS AlternativeItemCodeDescription					/*Alternative Item Code Description (aitd) |  | null | 30 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RevisionBusinessPartner							/*Business Partner Revision (tcibd014.revi)  If populated, record in tcbd014 will be created. |FALSE | Text |35	| */
	,CAST(NULL AS SMALLDATETIME) AS  RevisionEffectiveDate							/*Effective Date Revision (tcibd014.efdt) Effective date for tcibd014 | FALSE | Date/Time| | */

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1 )
	JOIN
		(
			SELECT
				ken.*
			FROM
				ZZZ_Italy.dbo.Kennis_1 ken
				LEFT JOIN ZZZ_Italy.dbo.KPSource kps ON (ken.MG_CODICE = kps.Item)
			WHERE
				TRIM(ken.MG_CODICE) <> ken.KENNIS
		)ken ON (itm.MG_CODICE = ken.MG_CODICE AND itm.MG_DITTA = 1 )
GO


