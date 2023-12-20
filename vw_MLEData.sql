USE [ZZZ_RUN4]
GO

/****** Object:  View [dbo].[vw_MLEData]    Script Date: 20/12/2023 12:13:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vw_MLEData] as 

/* Version M202307062359 A2LN_CE202304 */

select
	 cast(null as varchar(255)) as TemplateName					/*TemplateName | TRUE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as TemplateField				/*TemplateField | TRUE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as TemplateKey					/*Key | FALSE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as [Language]						/*Language | FALSE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as MLEfield						/*MLE Field | FALSE | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as UUID							/*UUID(44) |  | cast(null as varchar(255)) |Text | 255 | |*/
	,cast(null as varchar(255)) as UUIDStatus					/*UUIDStatus |  | cast(null as varchar(255)) |Text | 255 | |*/
GO


