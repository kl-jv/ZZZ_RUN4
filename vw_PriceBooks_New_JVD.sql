USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_PriceBooks_New_JVD]    Script Date: 20/12/2023 12:29:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






/* Business Partners has a link with KPRAKTOR, because some can be missing */


ALTER VIEW [dbo].[vw_PriceBooks_New_JVD] AS

SELECT
	 CAST(NULL AS VARCHAR(9)) AS PriceBook														/*Price Book (prbk)   - Reference to  tdpcg011                                                                                                   ERPLN table: tdpcg031 | TRUE | cast(null as varchar(9)) |  Text |9 | |*/
	,CAST('PROJEMPTY' AS VARCHAR(9)) AS Project													/*Project segment of Item (item)   - Reference to tcmcs052 General Projects. If Project field not used then fill field with "PROJEMPTY". | FALSE | "PROJEMPTY" |  Text |9 | |*/
	,CAST(kps.ItemLnCE as varchar(38)) as Item													/*Item segment of Item (item)   - Reference to tcibd001 | FALSE | cast(null as varchar(38)) |  Text |38 | | */
	,CASE WHEN bp.[Business Partner] IS NULL THEN TRIM(pri.LF_CODICE_CLIFOR) + '!' ELSE CAST(bp.[Business Partner] AS VARCHAR(9)) END AS BuyFromBusinessPartner								/*Buy-from Business Partner (otbp)   - Reference to tccom120 | TRUE | cast(null as varchar(9)) |  Text |9 | |*/
	,CASE WHEN bp.[Business Partner] IS NULL THEN TRIM(pri.LF_CODICE_CLIFOR) + '!' ELSE CAST(bp.[Business Partner] AS VARCHAR(9)) END AS ShipFromBusinessPartner							/*Ship-from Business Partner (sfbp)   - Reference to tccom121 | TRUE | cast(null as varchar(9)) |  Text |9 | |*/
	,CAST(TRIM(pri.LF_VALUTA) AS VARCHAR(3)) AS Currency										/*Currency (curn)    - Reference to tcmcs002 | FALSE | cast(null as varchar(3)) |  Text |3 | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NOT NULL THEN kps.PurchaseUnitUnit ELSE kps.InventoryUnit END AS VARCHAR(3)) AS QuantityUnit										/*Quantity Unit (qtun)    - Reference to tcmcs001 | TRUE | cast(null as varchar(3)) |  Text |3 | |*/
	,CAST(CASE WHEN pri.LF_FASCIA = 0  THEN 1 ELSE pri.LF_FASCIA END AS FLOAT) AS MinimumQuantity											/*Minimum Quantity (miqt) | TRUE | 0 |  Double | | |*/
	,CASE WHEN pri.LF_CODICE_FASE  = 0 THEN 10 ELSE 15 END AS PriceType							/*Price Type (prty) ** Only applicable when Module not Sales | TRUE | 5 |  Byte | | 5;"Not Applicable (Default)";10;"Buying";15;"Item Subcontracting";20;"Operation Subcontracting";25;"Service Subcontracting"|*/
	,TransActions.dbo.fn_NumberToSmallDateTime(pri.LF_DATA_DECORR) AS EffectiveDate			/*Effective Date (efdt) | FALSE | null |  Date/Time | | |*/
	,1 AS BreakType																				/*Break Type (brty) | FALSE | 1 |  Text |10 | 1;"Minimum (Default)";2;"Up To"|*/
	,TransActions.dbo.fn_NumberToSmallDateTime(pri.LF_DATA_TERMINE) AS ExpiryDate				/*Expiry Date (exdt) - If no time is specified, time will be 00:00. You can specify the time after the date e.g. 23:59:59 | FALSE | null |  Date/Time | | |*/
	,case when TransActions.dbo.fn_NumberToSmallDateTime(pri.LF_DATA_DECORR) > cast('2023-01-01 00:00:00' as smalldatetime) then TransActions.dbo.fn_NumberToSmallDateTime(pri.LF_DATA_DECORR) else cast('2023-01-01 00:00:00' as smalldatetime) end as EntryDate	/*Entry Date (endt) | TRUE |  |  Date/Time | | |*/
	,CAST(pri.LF_LIST_BASE AS FLOAT) AS Price													/*Price (bapr) | FALSE | 0 |  Double | | |*/
	,CAST(CASE WHEN kps.PurchaseUnitUnit IS NOT NULL THEN kps.PurchaseUnitUnit ELSE kps.InventoryUnit END AS VARCHAR(3)) AS PriceUnit											/*Price Unit (prun)    - Reference to tcmcs001 | TRUE | cast(null as varchar(3)) |  Text |3 | |*/
	,CAST(NULL AS VARCHAR(3)) AS DiscountSchedule												/*Discount Schedule (dssc) | TRUE | cast(null as varchar(3)) |  Text |9 | |*/
	,2 AS QuotationsOnly																		/*Quotations Only (quon) | FALSE | 2 |  Text |5 | 1;"Yes";2;"No (Default)"|*/
	,2 AS HighPriority																			/*High Priority (hipr) | FALSE | 2 |  Text |5 | 1;"Yes";2;"No (Default)"|*/
	,CAST(NULL AS VARCHAR(30)) AS Reference														/*Reference (refa) | TRUE | cast(null as varchar(30)) |  Text |30 | |*/
	,CAST('Manual' AS VARCHAR(30)) AS [Source]														/*Source (sour) | FALSE | cast(null as varchar(30)) |  Text |30 | |*/
	,2 AS BasePrice																				/*Base Price (dfpb) |  | 2 |  Text |5 | 1;"Yes";2;"No (Default)"|*/
	,2 AS UpdateOrderLineswithPrice																/*Update Order Lines with Price (uolp) |  | 2 |  Text |5 | 1;"Yes";2;"No (Default)"|*/
	,pri.LF_CODICE_CLIFOR
	,itm.MG_CODFOR_PREF
	,pri.LF_CODICE_FASE
	,tal.TN_DESCR
	,'IT' + RIGHT('0000000' + (CAST((RANK() OVER (PARTITION BY pri.LF_DITTA ORDER BY pri.LF_CODICE_CLIFOR ASC)) AS VARCHAR(5))),7) AS test

FROM
	KPRAKTOR.SIAPR.LISTFORN pri
	JOIN KPRAKTOR.SIAPR.ANAMAG itm ON (pri.LF_CODICE_ART = itm.MG_CODICE AND pri.LF_DITTA = itm.MG_DITTA) --- and pri.LF_CODICE_CLIFOR = itm.MG_CODFOR_PREF)
	JOIN ZZZ_Italy.dbo.KPSource kps ON (itm.MG_CODICE = kps.Item AND itm.MG_DITTA = 1 AND kps.Migrate = 1)
	LEFT JOIN ZZZ_Italy.dbo.BP_Conv bp ON (pri.LF_CODICE_CLIFOR = bp.KPraktor AND pri.LF_DITTA = 1)
	LEFT JOIN KPRAKTOR.SIAPR.TABUTIN tal ON (pri.LF_CODICE_FASE = tal.TN_CODICE AND pri.LF_DITTA = tal.TN_DITTA AND TN_TABELLA = 'FLAV')
WHERE
	pri.LF_DATA_TERMINE >= CONVERT(INT,GETDATE())
	AND LEN(TRIM(pri.LF_CODICE_ART))>0
	AND pri.LF_LIST_BASE <> 0
---	and pri.LF_CODICE_ART = 'T09131638



GO


