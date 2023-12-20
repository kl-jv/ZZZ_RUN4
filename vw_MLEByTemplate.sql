USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_MLEByTemplate]    Script Date: 20/12/2023 12:10:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vw_MLEByTemplate] as 

/* Version M202307062359 A2LN_CE202304 */

select
	 cast(null as varchar(255)) as TemplateName						/*TemplateName | TRUE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as TemplateField					/*TemplateField | FALSE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as TemplateKey						/*Key | FALSE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as Lang1							/*MLEfield Language1 | FALSE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as Lang2							/*MLEfield Language2 | FALSE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as Lang3							/*MLEfield Language3 | FALSE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as Lang4							/*MLEfield Language4 | FALSE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as Lang5							/*MLEfield Language5 | FALSE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as Lang6							/*MLEfield Language6 | FALSE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as Lang7							/*MLEfield Language7 | FALSE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as Lang8							/*MLEfield Language8 | FALSE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as Lang9							/*MLEfield Language9 |  | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as Lang10							/*MLEfield Language10 |  | cast(null as varchar(255)) |Text | 255 | |*/
GO


