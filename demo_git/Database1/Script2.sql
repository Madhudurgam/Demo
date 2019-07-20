/*---------------------------------------------------------------------
Created By:-	N Vamsi Rajesh
Description:-	RBAC- Inserting Group Permission association
Modified Date:-	2019-07-18
Comments:-		Adding records in GROUPPERMISSION table based on the Groups associating with Permission .
---------------------------------------------------------------------*/

Go

/*------------------------------------------------------------------------------------
Step 1. View Permission: - Adding view permissions for all groups.
----------------------------------------------------------------------------------------*/

DECLARE @ViewPermission Varchar(100)='%.View'

SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL AND 
(
	P.[NAMESPACE] LIKE @ViewPermission 
)
 AND  G.NAME LIKE 'NNA.%'	
AND  G.NAME NOT LIKE 'NNA.Apps.B2B%'
AND   G.NAME NOT LIKE 'NNA.Apps.ApiKey%'
    
GO
 
/*------------------------------------------------------------------------------------
Step 2. Create, Edit and Delete Permissions: - Adding Create, Edit and Delete permissions for below groups

Excel Group							Database Group(Mapping database record)		Group ID
----------------------------------------------------------------------------------------
Application Dev & BATeam User		NNA.Apps.IT.Eng.Head.Group					71
									NNA.Apps.IT.Eng.Staff.Group					2
----------------------------------------------------------------------------------------*/

DECLARE @ViewPermission Varchar(100)='%.View', @CreatePermission Varchar(100)='%.Create', @AddPermission Varchar(100)='%.Add'
DECLARE @EditPermission Varchar(100)='%.Edit', @DeletePermission Varchar(100)='%.Delete'
DECLARE @ManagePermission Varchar(100)='%.Manage', @DownloadPermission Varchar(100)='%.Download' , @RetrievePermission Varchar(100)='%.Retrieve'

SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL 
AND 
(
	
		P.[NAMESPACE] LIKE @CreatePermission 
		OR 
		P.[NAMESPACE] LIKE @EditPermission
		OR 
		P.[NAMESPACE] LIKE @DeletePermission 
		OR
		P.[NAMESPACE] LIKE @ViewPermission
		OR
		P.[NAMESPACE] LIKE @AddPermission
		OR
		P.[NAMESPACE] LIKE @ManagePermission
		OR
		P.[NAMESPACE] LIKE @DownloadPermission
		OR
		P.[NAMESPACE] LIKE @RetrievePermission
)
AND G.NAME IN 
(
	'NNA.Apps.IT.Eng.Head.Group',
	'NNA.Apps.IT.Eng.Staff.Group'
)

GO

/*------------------------------------------------------------------------------------
Step 3. Products and Offers:- Adding Create, Edit and Delete and View permissions for below groups

Excel Group							Database Group(Mapping database record)		Group ID
----------------------------------------------------------------------------------------
Product Management Team User		NNA.Apps.Marketing.Products.Staff.Group		43
									NNA.Apps.Marketing.Products.Head.Group		161
									NNA.Apps.Marketing.Admin.Admin.Group		209
									NNA.Apps.Admin.Group						230
									NNA.Apps.IT.Admin.Admin.Group				231
									NNA.Apps.IT.DevOps.Staff.Group				233
									NNA.Apps.IT.IS.Head.Group					234
									NNA.Apps.IT.DevOps.Head.Group				235
									NNA.Apps.IT.IS.Staff.Group					236
----------------------------------------------------------------------------------------*/

DECLARE @ProductsRole Varchar(100)='Products.%'
DECLARE @OffersRole Varchar(100)='Offers.%'
DECLARE @ViewPermission Varchar(100)='%.View'

SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL 
AND 
(
	
		P.[NAMESPACE] LIKE @ProductsRole 
		OR 
		P.[NAMESPACE] LIKE @OffersRole
	    OR
	    P.[NAMESPACE]  LIKE @ViewPermission
)
AND G.NAME IN 
(
	'NNA.Apps.Marketing.Products.Head.Group',
	'NNA.Apps.Marketing.Products.Staff.Group',
	'NNA.Apps.Marketing.Admin.Admin.Group',
	'NNA.Apps.Admin.Group',
	'NNA.Apps.IT.Admin.Admin.Group',
	'NNA.Apps.IT.IS.Head.Group',
	'NNA.Apps.IT.IS.Staff.Group',
	'NNA.Apps.IT.DevOps.Head.Group',
	'NNA.Apps.IT.DevOps.Staff.Group'
)

GO

/*------------------------------------------------------------------------------------
Step 4. Offers Permission: - Adding offers and View permissions to below groups

Excel Group							Database Group(Mapping database record)		Group ID
----------------------------------------------------------------------------------------
Marketing Team User					NNA.Apps.Marketing.Team.Head.Group			257
									NNA.Apps.Marketing.Team.Staff.Group			266
Marketing Analyst User				NNA.Apps.Marketing.Analyst.Staff.Group		241
									NNA.Apps.Marketing.Analyst.Head.Group		262
Business Development Team User		NNA.Apps.BusinessDevelopment.Head.Group		238
									NNA.Apps.BusinessDevelopment.Staff.Group	263
Trusted Notary Leadership  User		NNA.Apps.TrustedNotary.Head.Group			252
----------------------------------------------------------------------------------------*/

DECLARE @OffersRole Varchar(100)='Offers.%'
DECLARE @ViewPermission Varchar(100)='%.View'

SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL AND 
(
	P.[NAMESPACE] LIKE @OffersRole
	or
	P.[NAMESPACE]  LIKE @ViewPermission
)
AND G.NAME IN 
(
	'NNA.Apps.Marketing.Team.Head.Group',
	'NNA.Apps.Marketing.Team.Staff.Group',
	'NNA.Apps.Marketing.Analyst.Staff.Group',
	'NNA.Apps.Marketing.Analyst.Head.Group',
	'NNA.Apps.BusinessDevelopment.Head.Group',
	'NNA.Apps.BusinessDevelopment.Staff.Group',
	'NNA.Apps.TrustedNotary.Head.Group'
)

GO

/*----------------------------------------------------------------------------------------
Step 5. Admin Permission: - Create notaries, Create orders, Edit notaries and  Edit orders.

Excel Group									Database Group(Mapping database record)				Group ID
----------------------------------------------------------------------------------------
Customer Care & Hotline TQeam User			NNA.Apps.CustomerCare.Hotline.Head.Group			251
											NNA.Apps.CustomerCare.Hotline.Staff.Group			267
Customer Care Leadership  User				NNA.Apps.CustomerCare.CallCenter.Head.Group			256
											NNA.Apps.CustomerCare.CallCenter.Staff.Group		275
Finance Team User							NNA.Apps.Finance.Head.Group							249
											NNA.Apps.Finance.Staff.Group						273
Digital Marketing Team User					NNA.Apps.Marketing.Digital.Head.Group				60
											NNA.Apps.Marketing.Digital.Staff.Group				9
Marketing Analyst User						NNA.Apps.Marketing.Analyst.Staff.Group				241
											NNA.Apps.Marketing.Analyst.Head.Group				262
Applications Team User						NNA.Apps.CustomerCare.Applications.Staff.Group		258
											NNA.Apps.CustomerCare.Applications.Head.Group		271											
Releasing Team User							NNA.Apps.CustomerCare.Releasing.Staff.Group			250
											NNA.Apps.CustomerCare.Releasing.Head.Group			274
Insurance Team User							NNA.Apps.CustomerCare.Insurance.Staff.Group			240
											NNA.Apps.CustomerCare.Insurance.Head.Group			269
Order Entry & Mail Room Team User			NNA.Apps.CustomerCare.OrderEntry&MailRoom.Staff.Group	246
											NNA.Apps.CustomerCare.OrderEntry&MailRoom.Head.Group	247
Resolution Team User						NNA.Apps.CustomerCare.Resolution.Staff.Group		244
											NNA.Apps.CustomerCare.Resolution.Head.Group			260
Operations Team User						NNA.Apps.Operations.Staff.Group						243
											NNA.Apps.Operations.Head.Group						255
Seminar Instructor & Live Scanr Team User	NNA.Apps.Seminar.Instructor&LiveScan.Head.Group		248
											NNA.Apps.Seminar.Instructor&LiveScan.Staff.Group	270
Seminar Operations Team User				NNA.Apps.Seminar.Operations.Head.Group				242
											NNA.Apps.Seminar.Operations.Staff.Group				272
Business Development Team User				NNA.Apps.BusinessDevelopment.Head.Group				238
											NNA.Apps.BusinessDevelopment.Staff.Group			263
Trusted Notary Leadership  User				NNA.Apps.TrustedNotary.Head.Group					252
Trusted Notary Team User					NNA.Apps.TrustedNotary.Staff.Group					261
-------------------------------------------------------------------------------------------*/

DECLARE @AdminNotariesCreate Varchar(100)='Admin.Notaries.Create'
DECLARE @AdminNotariesEdit Varchar(100)='Admin.Notaries.Edit'
DECLARE @AdminOrdersCreate Varchar(100)='Admin.Orders.Create'
DECLARE @AdminOrdersEdit Varchar(100)='Admin.Orders.Edit'
DECLARE @ViewPermission Varchar(100)='%.View'

SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL AND 
(
	(
		P.[NAMESPACE] LIKE @AdminNotariesCreate
		OR 
		P.[NAMESPACE] LIKE @AdminOrdersCreate
		OR 
		P.[NAMESPACE] LIKE @AdminNotariesEdit
		OR 
		P.[NAMESPACE] LIKE @AdminOrdersEdit
		OR
		P.[NAMESPACE] LIKE @ViewPermission
		
	)
)
AND G.NAME IN 
(
		'NNA.Apps.CustomerCare.Hotline.Head.Group', 
		'NNA.Apps.CustomerCare.Hotline.Staff.Group',
		'NNA.Apps.CustomerCare.CallCenter.Head.Group', 
		'NNA.Apps.CustomerCare.CallCenter.Staff.Group',
		'NNA.Apps.Finance.Head.Group', 
		'NNA.Apps.Finance.Staff.Group',
		'NNA.Apps.Marketing.Digital.Head.Group', 
		'NNA.Apps.Marketing.Digital.Staff.Group',	
		'NNA.Apps.Marketing.Analyst.Staff.Group', 
		'NNA.Apps.Marketing.Analyst.Head.Group',
		'NNA.Apps.CustomerCare.Applications.Staff.Group', 
		'NNA.Apps.CustomerCare.Applications.Head.Group',
		'NNA.Apps.CustomerCare.Releasing.Staff.Group', 
		'NNA.Apps.CustomerCare.Releasing.Head.Group',
		'NNA.Apps.CustomerCare.Insurance.Staff.Group', 
		'NNA.Apps.CustomerCare.Insurance.Head.Group',
		'NNA.Apps.CustomerCare.OrderEntry&MailRoom.Staff.Group', 
		'NNA.Apps.CustomerCare.OrderEntry&MailRoom.Head.Group',
		'NNA.Apps.CustomerCare.Resolution.Staff.Group', 
		'NNA.Apps.CustomerCare.Resolution.Head.Group',
		'NNA.Apps.Operations.Staff.Group', 
		'NNA.Apps.Operations.Head.Group',
		'NNA.Apps.Seminar.Instructor&LiveScan.Head.Group', 
		'NNA.Apps.Seminar.Instructor&LiveScan.Staff.Group',
		'NNA.Apps.Seminar.Operations.Head.Group', 
		'NNA.Apps.Seminar.Operations.Staff.Group',
		'NNA.Apps.BusinessDevelopment.Head.Group', 
		'NNA.Apps.BusinessDevelopment.Staff.Group',
		'NNA.Apps.TrustedNotary.Head.Group', 
		'NNA.Apps.TrustedNotary.Staff.Group'		
)

GO

/*----------------------------------------------------------------------------------------
Step 6.Admin Permission: - Create organization , Create partners, Edit organization and Edit partners and View Permissions

Excel Group									Database Group(Mapping database record)				Group ID
----------------------------------------------------------------------------------------
Customer Care Leadership  User				NNA.Apps.CustomerCare.CallCenter.Head.Group			256
											NNA.Apps.CustomerCare.CallCenter.Staff.Group		275
Executive Management Team User				NNA.Apps.ExecutiveManagement.Staff.Group			245
											NNA.Apps.ExecutiveManagement.Head.Group				259
Finance Team User							NNA.Apps.Finance.Head.Group							249
											NNA.Apps.Finance.Staff.Group						273
Business Development Team User				NNA.Apps.BusinessDevelopment.Head.Group				238
											NNA.Apps.BusinessDevelopment.Staff.Group			263
Trusted Notary Leadership  User				NNA.Apps.TrustedNotary.Head.Group					252
----------------------------------------------------------------------------------------*/

DECLARE @AdminOrganizations Varchar(100)='Admin.Organizations.%',@AdminPartners Varchar(100)='Admin.Partners.%'
DECLARE @ViewPermission Varchar(100)='%.View', @DeletePermission Varchar(100)='%.Delete'


SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL AND 
(
	(
		P.[NAMESPACE] LIKE @AdminOrganizations
		OR 
		P.[NAMESPACE] LIKE @AdminPartners
		OR 
		P.[NAMESPACE]  LIKE @ViewPermission
	)
	
	AND P.[NAMESPACE] NOT LIKE @DeletePermission	
)
AND G.NAME IN 
(
	'NNA.Apps.CustomerCare.CallCenter.Head.Group',
	'NNA.Apps.CustomerCare.CallCenter.Staff.Group',
	'NNA.Apps.ExecutiveManagement.Staff.Group', 
	'NNA.Apps.ExecutiveManagement.Head.Group',
	'NNA.Apps.ExecutiveManagement.Staff.Group', 
	'NNA.Apps.ExecutiveManagement.Head.Group',
	'NNA.Apps.Finance.Head.Group', 
	'NNA.Apps.Finance.Staff.Group',
	'NNA.Apps.BusinessDevelopment.Head.Group', 
	'NNA.Apps.BusinessDevelopment.Staff.Group',
	'NNA.Apps.TrustedNotary.Head.Group'
)

GO

/*------------------------------------------------------------------------------------------
Step 7.Admin Permission: - Admin.Delete.Organizations - Delete (inactivate) organizations

Excel Group									Database Group(Mapping database record)				Group ID
----------------------------------------------------------------------------------------
Business Development Team User				NNA.Apps.BusinessDevelopment.Head.Group				238
											NNA.Apps.BusinessDevelopment.Staff.Group			263
Trusted Notary Leadership  User				NNA.Apps.TrustedNotary.Head.Group					252
----------------------------------------------------------------------------------------*/

DECLARE @AdminOrganizationsDelete Varchar(100)='Admin.Organizations.Delete'
DECLARE @ViewPermission Varchar(100)='%.View'


SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL AND 
(
	P.[NAMESPACE]=@AdminOrganizationsDelete
	OR
	P.[NAMESPACE] LIKE @ViewPermission
	
)
AND G.NAME IN 
(	
	'NNA.Apps.BusinessDevelopment.Head.Group', 
	'NNA.Apps.BusinessDevelopment.Staff.Group',
	'NNA.Apps.TrustedNotary.Head.Group'
)


GO

/*----------------------------------------------------------------------------------------
Step 8.Admin Permission: - Admin.Delete.Notaries - Delete (inactivate) notaries, Admin.Delete.Orders - Delete (inactivate) orders

Excel Group									Database Group(Mapping database record)				Group ID
----------------------------------------------------------------------------------------
Customer Care Leadership  User				NNA.Apps.CustomerCare.CallCenter.Head.Group			256
											NNA.Apps.CustomerCare.CallCenter.Staff.Group		275
Resolution Team User						NNA.Apps.CustomerCare.Resolution.Staff.Group		244
											NNA.Apps.CustomerCare.Resolution.Head.Group			260
Business Development Team User				NNA.Apps.BusinessDevelopment.Head.Group				238
											NNA.Apps.BusinessDevelopment.Staff.Group			263
Trusted Notary Leadership  User				NNA.Apps.TrustedNotary.Head.Group					252
Trusted Notary Team User					NNA.Apps.TrustedNotary.Staff.Group					261
----------------------------------------------------------------------------------------*/

DECLARE @AdminNotariesDelete Varchar(100)='Admin.Notaries.Delete'
DECLARE @AdminOrdersDelete Varchar(100)='Admin.Orders.Delete'
DECLARE @ViewPermission Varchar(100)='%.View'

SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL AND 
(
	P.[NAMESPACE]=@AdminNotariesDelete
	OR
	P.[NAMESPACE]=@AdminOrdersDelete
	OR
	P.[NAMESPACE] LIKE @ViewPermission
)
AND G.NAME IN 
(
	'NNA.Apps.CustomerCare.CallCenter.Head.Group',
	'NNA.Apps.CustomerCare.CallCenter.Staff.Group',
	'NNA.Apps.CustomerCare.Resolution.Staff.Group',
	'NNA.Apps.CustomerCare.Resolution.Head.Group',
	'NNA.Apps.BusinessDevelopment.Head.Group', 
	'NNA.Apps.BusinessDevelopment.Staff.Group',
	'NNA.Apps.TrustedNotary.Head.Group', 
	'NNA.Apps.TrustedNotary.Staff.Group'		
)

GO