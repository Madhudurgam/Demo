/*---------------------------------------------------------------------
Created By:-	N Vamsi Rajesh
Description:-	RBAC- Inserting Group Permission association for Events and Insurance.
Modified Date:-	2019-06-25
Comments:-		Events and Insurance adding records in GROUPPERMISSION table based on the Groups.
---------------------------------------------------------------------*/

Go

/*------------------------------------------------------------------------------------
Step 1. Adding View, Create, Edit and Delete permissions for Events and Insurance.

Excel Group							Database Group
----------------------------------------------------------------------------------------
Application Dev & BATeam User		NNA.Apps.IT.Eng.Head.Group					
									NNA.Apps.IT.Eng.Staff.Group
									NNA.Apps.IT.Admin.Admin.Group
----------------------------------------------------------------------------------------*/

DECLARE @EventPermissions Varchar(100)='Event.%'
DECLARE @InsurancePermissions Varchar(100)='Insurance.%'


--INSERT INTO [RBAC].[GROUPPERMISSION]
SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL 
AND 
(
	P.[NAMESPACE] LIKE @EventPermissions 
	OR 
	P.[NAMESPACE] LIKE @InsurancePermissions
)
AND G.NAME IN 
(
	'NNA.Apps.IT.Eng.Staff.Group',
	'NNA.Apps.IT.Eng.Head.Group',
	'NNA.Apps.IT.Admin.Admin.Group'	
)

GO

/*------------------------------------------------------------------------------------
Step 2. Adding View, Create, Edit and Delete permissions for Events.

Excel Group										Database Group
----------------------------------------------------------------------------------------
Seminar Operations Leadership User				NNA.Apps.Seminar.Operations.Head.Group					
Seminar Operations Team User					NNA.Apps.Seminar.Operations.Staff.Group
Seminar Instructor & Live Scan Leadership User	NNA.Apps.Seminar.Instructor&LiveScan.Head.Group
Seminar Instructor & Live Scan Team User		NNA.Apps.Seminar.Instructor&LiveScan.Staff.Group
----------------------------------------------------------------------------------------*/

DECLARE @EventPermissions Varchar(100)='Event.%'


--INSERT INTO [RBAC].[GROUPPERMISSION]
SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL 
AND P.[NAMESPACE] LIKE @EventPermissions
AND G.NAME IN 
(	
	'NNA.Apps.Seminar.Operations.Head.Group',
	'NNA.Apps.Seminar.Operations.Staff.Group',
	'NNA.Apps.Seminar.Instructor&LiveScan.Head.Group',
	'NNA.Apps.Seminar.Instructor&LiveScan.Staff.Group'	
)

Go

/*------------------------------------------------------------------------------------
Step 3. Adding View, Create, Edit and Delete permissions for Insurance.

Excel Group							Database Group
----------------------------------------------------------------------------------------
Insurance Team User					NNA.Apps.CustomerCare.Insurance.Staff.Group					
Insurance Team Leadership User		NNA.Apps.CustomerCare.Insurance.Head.Group
----------------------------------------------------------------------------------------*/

DECLARE @InsurancePermissions Varchar(100)='Insurance.%'


--INSERT INTO [RBAC].[GROUPPERMISSION]
SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL 
AND P.[NAMESPACE] LIKE @InsurancePermissions
AND G.NAME IN 
(	
	'NNA.Apps.CustomerCare.Insurance.Staff.Group',
	'NNA.Apps.CustomerCare.Insurance.Head.Group'
)