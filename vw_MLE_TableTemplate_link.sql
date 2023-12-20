USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_MLE_TableTemplate_link]    Script Date: 20/12/2023 12:08:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vw_MLE_TableTemplate_link] as 

/* Version M202307062359 A2LN_CE202304 */

select
	 cast(null as varchar(255)) as LNTable						/* | FALSE | null |Text | 255 | |*/
	,cast(null as varchar(255)) as LNTableField					/* | FALSE | null |Text | 255 | |*/
	,cast(null as varchar(255)) as TemplateName					/* |  | null |Text | 255 | |*/
	,cast(null as varchar(255)) as TemplateField				/* |  | null |Text | 255 | |*/

GO


