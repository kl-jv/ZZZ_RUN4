USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_EngineeringItemRevision]    Script Date: 20/12/2023 11:47:38 ******/
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

Used the function for correct date calculation

*/




ALTER VIEW [dbo].[vw_EngineeringItemRevision] AS 

SELECT
	 CAST('PROJEMPTY' AS VARCHAR(9)) AS EngineeringProject							/*Project segment (eitm)  -Leave it empty because Customized items are not allowed in EDM!          Infor LN table: tiedm100 | TRUE | "PROJEMPTY" | Text | 9 | */
	,CAST(kps.ItemLnCE AS VARCHAR(38)) AS EngineeringItem							/*Item segment of Engineering Item (eitm) | TRUE |  | Text | 38 | */
	,CAST('000001' AS VARCHAR(6)) AS EngineeringItemRevision						/*Engineering Item Revision (revi) | TRUE |  | Text | 6 | */
	,CAST(
		CASE
			WHEN itm.MG_FLAG8 > 0 THEN CONVERT(VARCHAR(38), kps.ItemLnCE) + '-' + CAST(CAST(itm.MG_FLAG8 AS FLOAT) AS VARCHAR(3))
			ELSE 
				CASE
					WHEN LEN(TRIM(itm.MG_FLAG13)) > 0 THEN CONVERT(VARCHAR(38), kps.ItemLnCE) + '-' + TRIM(itm.MG_FLAG13)
					ELSE 'not defined'
				END
		END AS VARCHAR(30)
	) AS RevisionDescription
	,CAST('2023/01/01 00:00:00'AS SMALLDATETIME) AS EffectiveDate					/*Effective Date (indt) | FALSE |  | Date/Time |  | */
	,NULL  AS ExpiryDate															/*Expiry Date (exdt) | FALSE |  | Date/Time |  | */
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
		END AS VARCHAR(3)) AS  ItemSignal											/*Item Signal (csig)   - Reference to  tcmcs018 Item Signals | FALSE |  | Text | 3 | */		
	,CAST(NULL AS VARCHAR(9)) AS Engineer											/*Engineer (engi)   - Reference to  tccom001 Employees | TRUE |  | Text | 9 | */
	,4 AS Status																	/*Status (rele) | TRUE | 1 | Byte | 1;"In-Design";2;"Frozen";3;"Approved by Engineering";4;"Approved by Production" | */
	,1 AS BomQuantity																/*BOM Quantity (unom) | TRUE | 1 | Decimal |  | */
	,CAST('000010' AS VARCHAR(6)) AS UnitSet										/*Unit Set (uset)   - Reference to tcmcs006 Unit Sets | FALSE |  | Text | 6 | */
	,CAST(kps.InventoryUnit AS VARCHAR(3)) AS Unit									/*Unit (cuni)  - Reference to tcmcs001 Units | FALSE |  | Text | 3 | */
	,CAST(NULL AS VARCHAR(30)) AS Material											/*Material (dscb) | FALSE |  | Text | 30 | */
	,CAST(NULL AS VARCHAR(30)) AS Size												/*Size (dscc) | FALSE |  | Text | 30 | */
	,CAST(NULL AS VARCHAR(30)) AS [Standard]										/*Standard (dscd) | FALSE |  | Text | 30 | */
	,CAST('kg' AS VARCHAR(3)) AS WeightUnit											/*Weight Unit (cwun)   - Reference to tcmcs001 Units | FALSE |  | Text | 3 | */
	,CAST(kps.Weight AS FLOAT) AS [Weight]											/*Weight (wght) | FALSE | 0 | Decimal |  | */
	,CAST('2023/01/01 00:00:00'AS SMALLDATETIME) AS ApprovedByEngineering			/*Approved By Engineering (afed) - when Status is <= "Approved */
	,CAST('2023/01/01 00:00:00'AS SMALLDATETIME) AS ApprovedByProduction			/*Approved By Production (afpd) - when Status is <= "Approved by Production" | FALSE |  | Date/Time |  | */
	,CASE WHEN rev.txt IS NULL THEN '000001 Assinged as Engineering Item' ELSE rev.txt END AS EItemRevisionText		/*E-Item Revision Text (tttxt010.ctxt) |  |  | Memo |  | */
	,CASE WHEN rev.NA_CODICE IS NULL THEN 1 ELSE 1 END AS TextIDEItemRevision		/*Text ID E-Item Revision (tiedm100.txta) |  | 0 | Long Integer |  | */
FROM
	KPRAKTOR.SIAPR.ANAMAG itm
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.[E-Item] = 1 AND kps.ItemType = 30 AND kps.Migrate IN (0,1))
	LEFT JOIN KPRAKTOR.dbo.SIAPR_TABUTIX_UDM udm ON (itm.MG_UDM_UT = udm.TX_CODICE AND itm.MG_DITTA = udm.TX_DITTA)
	LEFT JOIN
		(
			SELECT 
				 rev.NA_CODICE
				,rev.NA_DITTA
				, STRING_AGG(RTRIM(CAST(rev.NA_PROG AS VARCHAR(10))) + ' | ' + CAST(TransActions.dbo.fn_NumberToDate(rev.NA_DATA_INS) AS VARCHAR(10)) + ' | ' + RTRIM(rev.NA_DESCRI), CHAR(13)) WITHIN GROUP (ORDER BY rev.NA_CODICE ASC, rev.NA_PROG DESC ) AS txt
			FROM 
				KPRAKTOR.SIAPR.NOTEART rev
			WHERE
				rev.NA_CLASSE = 'GEN' AND rev.NA_DATA_INS IS NOT NULL
			GROUP BY 
				rev.NA_CODICE
				,rev.NA_DITTA
		)rev ON (itm.MG_CODICE = rev.NA_CODICE AND itm.MG_DITTA = rev.NA_DITTA)
	LEFT JOIN
		(
			SELECT
				  app.NA_CODICE
				 ,app.NA_DITTA
				 ,app.NA_PROG
				,TransActions.dbo.fn_NumberToDate(app.NA_DATA_INS) AS Approval
			FROM
				(
					SELECT 
						 rev.NA_CODICE
						,rev.NA_DITTA
						,rev.NA_PROG
						,rev.NA_DATA_INS
						,rev.NA_DESCRI
						,ROW_NUMBER() OVER (PARTITION BY rev.NA_CODICE, rev.NA_DITTA  ORDER BY rev.NA_PROG DESC) RN 
					FROM 
						KPRAKTOR.SIAPR.NOTEART rev
					WHERE
						rev.NA_CLASSE = 'GEN' 
						AND rev.NA_DATA_INS IS NOT NULL 
				)app
			WHERE
				RN =1
		)app ON (itm.MG_CODICE = app.NA_CODICE AND itm.MG_DITTA = app.NA_DITTA)


		


GO


