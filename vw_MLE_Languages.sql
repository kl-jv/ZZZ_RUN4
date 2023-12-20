USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_MLE_Languages]    Script Date: 20/12/2023 12:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vw_MLE_Languages] as 

/* Version M202307062358 A2LN_CE202304 */

select
	 cast(null as varchar(255)) as [Language]						/*Available Languages | TRUE | null |Text | 255 | |*/
	,cast(null as varchar(255)) as Dsca								/*Description | FALSE | null |Text | 255 | |*/
	,cast(null as varchar(255)) as Stat								/*Status of the Language | FALSE | null |Byte |  | 1;"Available (default)";2;"Base Language"|*/
	,cast(null as varchar(255)) as LinkWithLang						/*Link with Column |  | null |Text | 255 | |*/
	,cast(null as varchar(255)) as Active							/*Active Language |  | null |Yes/No |  | |*/
GO


