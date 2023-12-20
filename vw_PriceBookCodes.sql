USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_PriceBookCodes]    Script Date: 20/12/2023 12:22:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER view [dbo].[vw_PriceBookCodes] as

/* Not yet finished */

select
	 cast('400000004' as varchar(9)) as PriceBook								/*Price Book (prbk)  ERPLN table: tdpcg011 | TRUE | null |Text | 9 | |*/
	,cast('Default Purchase prices - HCE' as varchar(50)) as Description		/*Description (dsca) | FALSE | null |Text | 30 | |*/
	,2 as Module																/*Module (modu) | FALSE | 1 |Text | 15 | 1;Sales (Default);2;Purchase|*/
	,cast(null as varchar(9)) as ResponsibleEmployee							/*Responsible Employee (remp) | TRUE | null |Text | 9 | |*/
	,cast(null as varchar(6)) as ResponsibleOffice								/*Responsible Office (rofc) |  | null |Text | 6 | |*/
	,1 as GeneralUse															/*Obsolete (usfg) |  | 2 |Text | 15 | 1;Yes;2;No (Default)|*/

/*
from
	KPRAKTOR.SIAPR.LISTFORN pri
	join KPRAKTOR.SIAPR.ANAMAG itm on (pri.LF_CODICE_ART = itm.MG_CODICE and pri.LF_DITTA = itm.MG_DITTA) --- and pri.LF_CODICE_CLIFOR = itm.MG_CODFOR_PREF)
	join ZZZ_Italy.dbo.KPSource kps on (itm.MG_CODICE = kps.Item and itm.MG_DITTA = 1 and kps.Migrate = 1)
	left join ZZZ_Italy.dbo.BP_Conv bp on (pri.LF_CODICE_CLIFOR = bp.KPraktor and pri.LF_DITTA = 1)
	left join KPRAKTOR.SIAPR.TABUTIN tal on (pri.LF_CODICE_FASE = tal.TN_CODICE and pri.LF_DITTA = tal.TN_DITTA and TN_TABELLA = 'FLAV')
*/
GO


