USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_ItemCodeSystem]    Script Date: 20/12/2023 11:54:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER view [dbo].[vw_ItemCodeSystem] as 

select
	 cast('BPB' as varchar(3)) as ItemCodeSystem								/*Item Code System (citt)                   ERPLN table: tcibd006 | FALSE | null |Text | 3 | |*/
	,cast('SUPPLIERS / PROVIDERS' as varchar(30)) as Description				/*Description (dsca) |  | null |Text | 30 | |*/
	,10 as Type																	/*Type (type) |  | 1 |Text | 16 | 1;"General";10;"Business Partner"|*/

UNION ALL

select
	 cast('BPA' as varchar(3)) as ItemCodeSystem								/*Item Code System (citt)                   ERPLN table: tcibd006 | FALSE | null |Text | 3 | |*/
	,cast('CUSTOMERS / CLIENTS' as varchar(30)) as Description					/*Description (dsca) |  | null |Text | 30 | |*/
	,10 as Type																	/*Type (type) |  | 1 |Text | 16 | 1;"General";10;"Business Partner"|*/

UNION ALL

select
	 cast('KEN' as varchar(3)) as ItemCodeSystem								/*Item Code System (citt)                   ERPLN table: tcibd006 | FALSE | null |Text | 3 | |*/
	,cast('KENNIS' as varchar(30)) as Description				/*Description (dsca) |  | null |Text | 30 | |*/
	,1 as Type																	/*Type (type) |  | 1 |Text | 16 | 1;"General";10;"Business Partner"|*/
GO


