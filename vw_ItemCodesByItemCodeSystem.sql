USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_ItemCodesByItemCodeSystem]    Script Date: 20/12/2023 11:53:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







ALTER VIEW [dbo].[vw_ItemCodesByItemCodeSystem] AS

/*
		when 'A' then 'Purchase'
		when 'N' then 'Not Managed'
		when 'I' then 'Jobshop'
		when 'L' then 'Subcontract'
		when 'S' then 'Suspended'
*/


			/* SUPPLIERS/PROVIDERS  */
SELECT
	 CAST('BPB' AS VARCHAR(3)) AS ItemCodeSystem									/*Item Code System (citt)   - Reference to tcibd006 Item Code Systems                                                                    ERPLN table: tcibd004 | TRUE | null | 3 | |*/
/* 14-03-2023 BusinessPartner cannot be NULL , part of primary key */
/*	,cast(ppn.BusinessPartner as varchar(9)) as BusinessPartner	   */				/*Business Partner (bpid)   - Reference to tccom100 Business Partners -- Mandatory if type of item code system is ?Business Partner?. If type is ?General? this field should be empty. | TRUE | null | 9 | |*/
/* 31-08-2023 Bo Businesspartners with NULL possible see join :  AND ppn.BusinessPartner IS NOT NULL */ 
--	,CAST(CASE WHEN ppn.BusinessPartner IS NULL THEN '' ELSE  ppn.BusinessPartner END AS  VARCHAR(9)) AS BusinessPartner   /*Business Partner (bpid)   - Reference to tccom100 Business Partners -- Mandatory if type of item code system is ?Business Partner?. If type is ?General? this field should be filled with space. | TRUE | space | 9 | |*/
	,CAST(ppn.BusinessPartner as varchar(9)) as BusinessPartner	   				/*Business Partner (bpid)   - Reference to tccom100 Business Partners -- Mandatory if type of item code system is ?Business Partner?. If type is ?General? this field should be empty. | TRUE | null | 9 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS Project										/*Project segment of Item (item)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE as varchar(38)) as Item										/*Item segment of Item (item)  -  Reference to tcibd001 General Item Data | FALSE | null | 38 | |*/	
	,CAST(ppn.SupplierItem AS VARCHAR(35)) AS AlternativeItemCode					/*Alternative Item Code (aitc) |  | null | 35 | |*/
	,CAST(NULL AS VARCHAR(30)) AS AlternativeItemCodeDescription					/*Alternative Item Code Description (aitd) |  | null | 30 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RevisionBusinessPartner							/*Business Partner Revision (tcibd014.revi)  If populated, record in tcbd014 will be created. |FALSE | Text |35	| */
	,CAST(NULL AS SMALLDATETIME) AS  RevisionEffectiveDate							/*Effective Date Revision (tcibd014.efdt) Effective date for tcibd014 | FALSE | Date/Time| | */

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bpc ON (itm.MG_CODFOR_PREF = bpc.KPraktor AND itm.MG_DITTA = 1)
	JOIN ZZZ_Italy.dbo.PurchasePrices_New ppn ON (itm.MG_CODFOR_PREF = ppn.PrefSupplier AND itm.MG_CODICE = ppn.Item AND itm.MG_DITTA = 1 AND ppn.RN2 = 1)
WHERE
	itm.MG_GEST_PROD IN ('A','N')
	AND LEN(TRIM(MG_CODFOR_PREF)) >0
	AND ppn.BusinessPartner IS NOT NULL
	AND ppn.SupplierItem IS NOT NULL

UNION ALL

			/* KENNIS */
SELECT
	 CAST('KEN' AS VARCHAR(3)) AS ItemCodeSystem									/*Item Code System (citt)   - Reference to tcibd006 Item Code Systems                                                                    ERPLN table: tcibd004 | TRUE | null | 3 | |*/
/* 14-03-2023 BusinessPartner cannot be NULL , part of primary key */
/* 23-07 BP NOT relevant FOR tis TYPE OF ItemCodeSysems */
/* 31-08-2023 Fill BusinessPartner with NULL , CDM has been infomed that "empty" Business Partener must be accepted */ 
--	,CAST(CHAR(39) + ' ' AS VARCHAR(9)) AS BusinessPartner						/*Business Partner (bpid)   - Reference-- to tccom100 Business Partners -- Mandatory if type of item code system is ?Business Partner?. If type is ?General? this field should be empty. | TRUE | null | 9 | |*/
	,CAST(NULL AS VARCHAR(9)) AS BusinessPartner
/*	,cast(case when ppn.BusinessPartner is null then '' else  ppn.BusinessPartner end as  varchar(9)) as BusinessPartner */    --Inactivate this line  /*Business Partner (bpid)   - Reference to tccom100 Business Partners -- Mandatory if type of item code system is ?Business Partner?. If type is ?General? this field should be filled with space. | TRUE | space | 9 | |*/

	,CAST('PROJEMPTY' AS VARCHAR(9)) AS Project										/*Project segment of Item (item)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | TRUE | 'PROJEMPTY' | 9 | |*/
	,CAST(kps.ItemLnCE as varchar(38)) as Item										/*Item segment of Item (item)  -  Reference to tcibd001 General Item Data | FALSE | null | 38 | |*/	
	,CAST(ken.KENNIS AS VARCHAR(35)) AS AlternativeItemCode					/*Alternative Item Code (aitc) |  | null | 35 | |*/
	,CAST(ken.DESCRI AS VARCHAR(50)) AS AlternativeItemCodeDescription					/*Alternative Item Code Description (aitd) |  | null | 30 | |*/
	,CAST(NULL AS VARCHAR(9)) AS RevisionBusinessPartner							/*Business Partner Revision (tcibd014.revi)  If populated, record in tcbd014 will be created. |FALSE | Text |35	| */
	,CAST(NULL AS SMALLDATETIME) AS  RevisionEffectiveDate							/*Effective Date Revision (tcibd014.efdt) Effective date for tcibd014 | FALSE | Date/Time| | */

FROM
	KPRAKTOR.SIAPR.ANAMAG itm

/* 12-07-2023 Join added with KPsource for Item as Migrate should be 1 for Item  */

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
/* 14-03-2023 Left join added for BusinessPartner to fill with space if NULL */
/*	left join ZZZ_Italy.dbo.PurchasePrices_New ppn on (itm.MG_CODFOR_PREF = ppn.PrefSupplier and itm.MG_CODICE = ppn.Item and itm.MG_DITTA = 1 and ppn.RN2 = 1)  Not required */

GO


