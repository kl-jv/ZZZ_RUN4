USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_EngineeringItems]    Script Date: 2/26/2024 12:32:51 PM ******/
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


*/




ALTER VIEW [dbo].[vw_EngineeringItems] AS 

                  
SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS EngineeringProject								/*Project segment (eitm) Infor LN table: tiedm010 | TRUE | "PROJEMPTY" | 9 | 9 | */
	,CAST (kps.ItemLnCE AS VARCHAR(38)) AS EngineeringItem	

	,CAST(CASE WHEN kps.ItemDescriptionGB IS NOT NULL THEN kps.ItemDescriptionGB 
		ELSE 
			CASE WHEN kps.ItemDescriptionIT IS NOT NULL THEN kps.ItemDescriptionIT
				ELSE SUBSTRING(KPRAKTOR.dbo.fn_ProperCase(KPRAKTOR.dbo.fn_RemoveMultipleSpaces(RTRIM(itm.MG_DESCRI) + ' ' + LTRIM(RTRIM(itm.MG_MISURE)))),1,60)
				END
		END AS VARCHAR(60)) AS [Description]											/*Description (dsca) | FALSE |  | 30 | 30 | */

/* 21-02-2024 SearchKeyI and SearchKeyII set to NULL to avoid MLE on the key  	*/
/*	,SUBSTRING(CAST(CASE WHEN kps.ItemDescriptionGB IS NOT NULL THEN kps.ItemDescriptionGB 
		ELSE 
			CASE WHEN kps.ItemDescriptionIT IS NOT NULL THEN kps.ItemDescriptionIT
				ELSE SUBSTRING(KPRAKTOR.dbo.fn_ProperCase(KPRAKTOR.dbo.fn_RemoveMultipleSpaces(RTRIM(itm.MG_DESCRI) + ' ' + LTRIM(RTRIM(itm.MG_MISURE)))),1,60)
				END
		END AS VARCHAR(60)),1,16) AS SearchKeyI											/*Search Key I (seak) | FALSE |  | 16 | 16 | */
	, CAST ( kps.ItemLnCE AS VARCHAR ( 16 )) AS SearchKeyII							--	/* No need for cast(substring(kps.ItemLnCE,1,16) */
*/ 
	, CAST(NULL AS VARCHAR(16)) AS  SearchKeyI
	, CAST(NULL AS VARCHAR(16)) AS  SearchKeyII

	,'Migrated from K-Praktor' AS EItemReference										/*E-Item Reference (dref) | FALSE |  | 30 | 30 | */
	,2 AS Customizable																	/*Customizable (opol) | FALSE | 2 |  |  | */

-- 	, kps.ProductLine  -- Added Just for  checking

/*  KL : 21-02-2024 ProductType from new table ProductLine_Type */
-- 	,CAST(prt.ProductType AS VARCHAR(3)) AS ProductType									/*Product Type (ctyp)   - Reference to tcmcs015 Product Types | TRUE |  | 3 | 3 | */

	,CAST(CASE WHEN (plt.ProductType)  IS NULL THEN '---' 
			   ELSE plt.ProductType 
		  END AS VARCHAR(3)) AS ProductType 		


							/*Selection Code (csel)   - Reference to tcmcs022 Selection Codes | FALSE |  | 3 | 3 | */

-- Fill SelectionCode with ProductType 
--	,CAST(NULL AS VARCHAR(3)) AS SelectionCode	*/ 
/* 26-02-2024 KL: Now from SelectionCode table with field SelectionCode ) */ 
	,CAST(sec.SelectionCode AS VARCHAR(3)) AS SelectionCode				/*Selection Code (csel)   - Reference to tcmcs022 Selection Codes | FALSE |  | 3 | 3 | */
																		-- Fill Selection Code with "Old" productType 

--	,CAST(plt.ProductType AS VARCHAR(3)) AS SelectionCode_new_table		-- Will Be NULL If ProductLine is Empty Fill Selection Code with "Old" productType 


	,kps.ItemGroup AS ItemGroup															/*Item Group (citg)  - Reference to tcmcs023 Item Groups  - Item Type is always 'Product' | FALSE |  | 6 | 6 | */
	,2 AS AssemblyBOM																	/*Assembly BOM (abom) | FALSE | 2 |  |  | */
	,2 AS UnitEffective																	/*Unit Effective (unef) | FALSE | 2 |  |  | */
	,2 AS Interchangeable																/*Interchangeable (ichg) | FALSE | 2 |  |  | */
	,2 AS ChmControl																	/*CHM Control (chma) | FALSE | 2 |  |  | */
	,2 AS EffectivityDatesByCO															/*Effectivity Dates By CO (edco) | FALSE | 2 |  |  | */
	,2 AS MultipleCOs																	/*Multiple CO's (mcoa) | FALSE | 2 |  |  | */
	,2 AS NewRevisionAllowed															/*New Revision Allowed (cfpa) | FALSE | 2 |  |  | */
	,CAST(NULL AS VARCHAR(8)) AS ExtraInformation										/*Extra Information (exin) | FALSE |  | 8 | 8 | */
	,CAST(NULL AS VARCHAR(8)) AS EngineeringItemText									/*E-Item Text (tttxt010.ctxt) |  |  |  |  | */
	,0 AS TextIDEngineering																/*Text ID E-Item (tiedm010.txta) |  | 0 |  |  | */

FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.[E-Item] = 1 AND kps.ItemType = 30 AND kps.Migrate IN (0,1))
/* 26-02-2024 KL ProductType tabel has become SelectionCode with files SelectionCode instead of ProductType */
--	LEFT JOIN ZZZ_Italy.dbo.ProductType prt ON (itm.MG_TIP_REC = prt.Code AND itm.MG_DITTA = 1)
LEFT JOIN ZZZ_Italy.dbo.SelectionCode sec ON (itm.MG_TIP_REC = sec.Code AND itm.MG_DITTA = 1)

/*  KL : 21-02-2024 New table ProductLine_Type */ 
	LEFT JOIN ZZZ_Italy.dbo. ProductLine_Type plt ON ( plt.ProductLine = kps.ProductLine ) 



GO


