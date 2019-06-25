/*---------------------------------------------------------------------
CREATED BY: -		N Vamsi Rajesh
DESCRIPTION: -		Migrating non Office 365 OAuthAccount Claims To Groups.
MODIFIED DATE: -	2019-06-19
COMMENTS: -			Regarding PLAT-2862, Consolidated script for migrating OAuthAccount Claims to Groups.
						STEP-1: - Create new Groups for OAuthAccount						
						STEP-2: - OAuthAccount associate to Groups
						STEP-3: - Create new Trusted Notary Permission
						STEP-4: - Added Trusted Notary Permissions association to Operation
						STEP-5: - Added Trusted Notary Permissions association to Groups.

CHID	Name            Date              Description                        
----	----------      ---------------   ------------                          
1		Vamsi Rajesh    2019-05-10		  Created
2		Vamsi Rajesh	2019-06-13		  Modified script for not associated users With Patner and added except condition for 'Welsfargo' and 'Punchout' claims.
---------------------------------------------------------------------*/

PRINT 'STEP-1: - Create new Groups for OAuthAccount'
PRINT 'START'
GO

DECLARE @GroupName VARCHAR(200)='NNA.Apps.B2B.Administrator.Group'
IF NOT EXISTS (SELECT 1 FROM [rbac].[Group] (NOLOCK) WHERE [Name] = @GroupName)
BEGIN
	INSERT INTO [rbac].[Group] ([IssuerId], [ObjectId], [Name],[Mail],[Description],[CreatedAtUtc]) 
	SELECT 1 [IssuerId],null [ObjectId],@GroupName [Name],Null [Mail],NULL [Description],GETUTCDATE() [CreatedAtUtc]	
END

Go

DECLARE @GroupName VARCHAR(200)='NNA.Apps.B2B.NotaryUser.Group'
IF NOT EXISTS (SELECT 1 FROM [rbac].[Group] (NOLOCK) WHERE [Name] = @GroupName)
BEGIN
	INSERT INTO [rbac].[Group] ([IssuerId], [ObjectId], [Name],[Mail],[Description],[CreatedAtUtc]) 
	SELECT 1 [IssuerId],null [ObjectId],@GroupName [Name],Null [Mail],NULL [Description],GETUTCDATE() [CreatedAtUtc]
END

Go

DECLARE @GroupName VARCHAR(200)='NNA.Apps.B2B.NotaryUserWithOrderCred.Group'
IF NOT EXISTS (SELECT 1 FROM [rbac].[Group] (NOLOCK) WHERE [Name] = @GroupName)
BEGIN
	INSERT INTO [rbac].[Group] ([IssuerId], [ObjectId], [Name],[Mail],[Description],[CreatedAtUtc]) 
	SELECT 1 [IssuerId],null [ObjectId],@GroupName [Name],Null [Mail],NULL [Description],GETUTCDATE() [CreatedAtUtc]
END

Go

DECLARE @GroupName VARCHAR(200)='NNA.Apps.B2B.PunchoutUser.Group'

IF NOT EXISTS (SELECT 1 FROM [rbac].[Group] (NOLOCK) WHERE [Name] = @GroupName)
BEGIN
	INSERT INTO [rbac].[Group] ([IssuerId], [ObjectId], [Name],[Mail],[Description],[CreatedAtUtc]) 
	SELECT 1 [IssuerId],null [ObjectId],@GroupName [Name],Null [Mail],NULL [Description],GETUTCDATE() [CreatedAtUtc]
END

Go

DECLARE @GroupName VARCHAR(200)='NNA.Apps.B2B.WellsFargoUser.Group'

IF NOT EXISTS (SELECT 1 FROM [rbac].[Group] (NOLOCK) WHERE [Name] = @GroupName)
BEGIN
	INSERT INTO [rbac].[Group] ([IssuerId], [ObjectId], [Name],[Mail],[Description],[CreatedAtUtc]) 
	SELECT 1 [IssuerId],null [ObjectId],@GroupName [Name],Null [Mail],NULL [Description],GETUTCDATE() [CreatedAtUtc]
END

GO
PRINT '------------------------END-----------------------------------'

PRINT 'STEP-2: - OAuthAccount associate to Groups'
PRINT 'START'

Go

PRINT 'Associate Administrator + Customer to Groups'

DECLARE @GroupName VARCHAR(100)='NNA.Apps.B2B.Administrator.Group'

INSERT INTO [rbac].[OAuthAccountGroup] ([OAuthAccountId], [GroupId])
SELECT OAA.OAuthAccountId,G.Id 
FROM [idm].[USER] U (NOLOCK)
INNER JOIN [idm].[OAuthAccount] OAA (NOLOCK) ON U.UserGUID = OAA.UserID
INNER JOIN 
(
    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Administrator'

    INTERSECT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Customer'
		
	EXCEPT 

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='WellsFargo' --CHID-2

	EXCEPT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='PunchOut' --CHID-2
		
) migrationClaims ON migrationClaims.SubjectGUID = OAA.OAuthAccountGUID
INNER JOIN [nna].[Person] PE (NOLOCK) ON PE.PersonGUID = OAA.SubjectGUID
INNER JOIN [idm].[Organization] O (NOLOCK) ON OAA.OrganizationID = O.OrganizationID
INNER JOIN [nna].[Partner] P (NOLOCK) ON O.OrganizationID = P.PartnerOrganizationID
INNER JOIN [rbac].[Group] G (NOLOCK) ON G.[Name] = @GroupName
LEFT JOIN [rbac].[OAuthAccountGroup] OG (NOLOCK) ON OAA.OAuthAccountId = OG.OAuthAccountID
WHERE OG.OAuthAccountId IS NULL AND O.OrganizationID >1 




PRINT 'Associate Administrator + Organization to Groups' --CHID-2

INSERT INTO [rbac].[OAuthAccountGroup] ([OAuthAccountId], [GroupId])
SELECT OAA.OAuthAccountId,G.Id 
FROM [idm].[USER] U (NOLOCK)
INNER JOIN [idm].[OAuthAccount] OAA (NOLOCK) ON U.UserGUID = OAA.UserID
INNER JOIN 
(
    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Administrator'

    INTERSECT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Organization'
		
	EXCEPT 

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK) --CHID-2
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='WellsFargo'

	EXCEPT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK) --CHID-2
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='PunchOut'
		
) migrationClaims ON migrationClaims.SubjectGUID = OAA.OAuthAccountGUID
INNER JOIN [nna].[Person] PE (NOLOCK) ON PE.PersonGUID = OAA.SubjectGUID
INNER JOIN [idm].[Organization] O (NOLOCK) ON OAA.OrganizationID = O.OrganizationID
INNER JOIN [nna].[Partner] P (NOLOCK) ON O.OrganizationID = P.PartnerOrganizationID
INNER JOIN [rbac].[Group] G (NOLOCK) ON G.[Name] = @GroupName
LEFT JOIN [rbac].[OAuthAccountGroup] OG (NOLOCK) ON OAA.OAuthAccountId = OG.OAuthAccountID
WHERE OG.OAuthAccountId IS NULL AND O.OrganizationID >1 

GO

PRINT 'Associate User + Customer + Employee to Groups'

DECLARE @GroupName VARCHAR(100)='NNA.Apps.B2B.NotaryUser.Group'

INSERT INTO [rbac].[OAuthAccountGroup] ([OAuthAccountId], [GroupId])
SELECT OAA.OAuthAccountId,G.Id 
FROM [idm].[USER] U (NOLOCK)
INNER JOIN [idm].[OAuthAccount] OAA (NOLOCK) ON U.UserGUID = OAA.UserID
INNER JOIN 
(
    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='User'

    INTERSECT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Customer'

	INTERSECT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Employee'
		
	EXCEPT 

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='NNA.Orders.Place'

	EXCEPT 

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Administrator'

	EXCEPT 

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='WellsFargo' --CHID-2

	EXCEPT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='PunchOut' --CHID-2
		
) migrationClaims ON migrationClaims.SubjectGUID = OAA.OAuthAccountGUID
INNER JOIN [nna].[Person] PE (NOLOCK) ON PE.PersonGUID = OAA.SubjectGUID
INNER JOIN [idm].[Organization] O (NOLOCK) ON OAA.OrganizationID = O.OrganizationID
INNER JOIN [nna].[Partner] P (NOLOCK) ON O.OrganizationID = P.PartnerOrganizationID
INNER JOIN [rbac].[Group] G (NOLOCK) ON G.[Name] = @GroupName
LEFT JOIN [rbac].[OAuthAccountGroup] OG (NOLOCK) ON OAA.OAuthAccountId = OG.OAuthAccountID
WHERE OG.OAuthAccountId IS NULL AND O.OrganizationID >1 

PRINT 'Associate User claims except Admin +Order place to Groups' --CHID-2

INSERT INTO [rbac].[OAuthAccountGroup] ([OAuthAccountId], [GroupId])
SELECT OAA.OAuthAccountId,G.Id 
FROM [idm].[USER] U (NOLOCK)
INNER JOIN [idm].[OAuthAccount] OAA (NOLOCK) ON U.UserGUID = OAA.UserID
INNER JOIN 
(
    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='User'

	EXCEPT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Administrator'
  		
	EXCEPT 

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='NNA.Orders.Place'

	EXCEPT

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK) --CHID-2
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='WellsFargo'

	EXCEPT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK) --CHID-2
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='PunchOut'
		
) migrationClaims ON migrationClaims.SubjectGUID = OAA.OAuthAccountGUID
INNER JOIN [nna].[Person] PE (NOLOCK) ON PE.PersonGUID = OAA.SubjectGUID
INNER JOIN [idm].[Organization] O (NOLOCK) ON OAA.OrganizationID = O.OrganizationID
INNER JOIN [nna].[Partner] P (NOLOCK) ON O.OrganizationID = P.PartnerOrganizationID
INNER JOIN [rbac].[Group] G (NOLOCK) ON G.[Name] = @GroupName
LEFT JOIN [rbac].[OAuthAccountGroup] OG (NOLOCK) ON OAA.OAuthAccountId = OG.OAuthAccountID
WHERE OG.OAuthAccountId IS NULL AND O.OrganizationID >1 

GO

PRINT 'Associate User + Customer + NNA.Orders.Place to Groups'

DECLARE @GroupName VARCHAR(100)='NNA.Apps.B2B.NotaryUserWithOrderCred.Group'

INSERT INTO [rbac].[OAuthAccountGroup] ([OAuthAccountId], [GroupId])
SELECT OAA.OAuthAccountId,G.Id 
FROM [idm].[USER] U (NOLOCK)
INNER JOIN [idm].[OAuthAccount] OAA (NOLOCK) ON U.UserGUID = OAA.UserID
INNER JOIN 
(
    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='User'

    INTERSECT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Customer'

	INTERSECT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Employee'
		
	INTERSECT 

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='NNA.Orders.Place'

	EXCEPT 

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Administrator'

	EXCEPT 

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='WellsFargo' --CHID-2

	EXCEPT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='PunchOut' --CHID-2
		
) migrationClaims ON migrationClaims.SubjectGUID = OAA.OAuthAccountGUID
INNER JOIN [nna].[Person] PE (NOLOCK) ON PE.PersonGUID = OAA.SubjectGUID
INNER JOIN [idm].[Organization] O (NOLOCK) ON OAA.OrganizationID = O.OrganizationID
INNER JOIN [nna].[Partner] P (NOLOCK) ON O.OrganizationID = P.PartnerOrganizationID
INNER JOIN [rbac].[Group] G (NOLOCK) ON G.[Name] = @GroupName
LEFT JOIN [rbac].[OAuthAccountGroup] OG (NOLOCK) ON OAA.OAuthAccountId = OG.OAuthAccountID
WHERE OG.OAuthAccountId IS NULL AND O.OrganizationID >1 

PRINT 'Associate NNA.Orders.Place excluding Administrator  to Groups' --CHID-2

INSERT INTO [rbac].[OAuthAccountGroup] ([OAuthAccountId], [GroupId])
SELECT OAA.OAuthAccountId,G.Id 
FROM [idm].[USER] U (NOLOCK)
INNER JOIN [idm].[OAuthAccount] OAA (NOLOCK) ON U.UserGUID = OAA.UserID
INNER JOIN 
(
    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='NNA.Orders.Place'

	EXCEPT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Administrator'
   		
	EXCEPT 

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK) --CHID-2
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='WellsFargo'

	EXCEPT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK) --CHID-2
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='PunchOut'
		
) migrationClaims ON migrationClaims.SubjectGUID = OAA.OAuthAccountGUID
INNER JOIN [nna].[Person] PE (NOLOCK) ON PE.PersonGUID = OAA.SubjectGUID
INNER JOIN [idm].[Organization] O (NOLOCK) ON OAA.OrganizationID = O.OrganizationID
INNER JOIN [nna].[Partner] P (NOLOCK) ON O.OrganizationID = P.PartnerOrganizationID
INNER JOIN [rbac].[Group] G (NOLOCK) ON G.[Name] = @GroupName
LEFT JOIN [rbac].[OAuthAccountGroup] OG (NOLOCK) ON OAA.OAuthAccountId = OG.OAuthAccountID
WHERE OG.OAuthAccountId IS NULL AND O.OrganizationID >1 


GO

PRINT 'Associate PunchOut to Groups'

DECLARE @GroupName VARCHAR(100)='NNA.Apps.B2B.PunchoutUser.Group'

INSERT INTO [rbac].[OAuthAccountGroup] ([OAuthAccountId], [GroupId])
SELECT OAA.OAuthAccountId,G.Id 
FROM [idm].[USER] U (NOLOCK)
INNER JOIN [idm].[OAuthAccount] OAA (NOLOCK) ON U.UserGUID = OAA.UserID
INNER JOIN 
(

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Administrator'

	INTERSECT

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='User'

    INTERSECT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Customer'

	INTERSECT 

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='NNA.Orders.Place'

	INTERSECT 

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='PunchOut'
		
) migrationClaims ON migrationClaims.SubjectGUID = OAA.OAuthAccountGUID
INNER JOIN [nna].[Person] PE (NOLOCK) ON PE.PersonGUID = OAA.SubjectGUID
INNER JOIN [idm].[Organization] O (NOLOCK) ON OAA.OrganizationID = O.OrganizationID
INNER JOIN [nna].[Partner] P (NOLOCK) ON O.OrganizationID = P.PartnerOrganizationID
INNER JOIN [rbac].[Group] G (NOLOCK) ON G.[Name] = @GroupName
LEFT JOIN [rbac].[OAuthAccountGroup] OG (NOLOCK) ON OAA.OAuthAccountId = OG.OAuthAccountID
WHERE OG.OAuthAccountId IS NULL AND O.OrganizationID >1

Go

PRINT 'Associate WellsFargo to Groups'

DECLARE @GroupName VARCHAR(100)='NNA.Apps.B2B.WellsFargoUser.Group'

INSERT INTO [rbac].[OAuthAccountGroup] ([OAuthAccountId], [GroupId])
SELECT OAA.OAuthAccountId,G.Id 
FROM [idm].[USER] U (NOLOCK)
INNER JOIN [idm].[OAuthAccount] OAA (NOLOCK) ON U.UserGUID = OAA.UserID
INNER JOIN 
(

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='User'

    INTERSECT

	SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='Customer'

	INTERSECT 

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='NNA.Orders.Place'

	INTERSECT 

    SELECT DISTINCT SubjectGUID FROM [idm].SubjectClaim s (NOLOCK)
	INNER JOIN [idm].[Claim] c (NOLOCK) ON s.ClaimId = c.ClaimId
	WHERE c.ClaimValue='WellsFargo'		
		
) migrationClaims ON migrationClaims.SubjectGUID = OAA.OAuthAccountGUID
INNER JOIN [nna].[Person] PE (NOLOCK) ON PE.PersonGUID = OAA.SubjectGUID
INNER JOIN [idm].[Organization] O (NOLOCK) ON OAA.OrganizationID = O.OrganizationID
INNER JOIN [nna].[Partner] P (NOLOCK) ON O.OrganizationID = P.PartnerOrganizationID
INNER JOIN [rbac].[Group] G (NOLOCK) ON G.[Name] = @GroupName
LEFT JOIN [rbac].[OAuthAccountGroup] OG (NOLOCK) ON OAA.OAuthAccountId = OG.OAuthAccountID
WHERE OG.OAuthAccountId IS NULL AND O.OrganizationID >1 

GO
PRINT '------------------------END-----------------------------------'

PRINT 'STEP-3: - Create new Trusted Notary Permission'
PRINT 'START'

Go

INSERT INTO [rbac].[Permission] (IssuerId, [Namespace], CreatedAtUtc)
SELECT [TNPermission].IssuerId, [TNPermission].[Namespace], GETUTCDATE() CreatedAtUtc FROM 
(

	SELECT 	1 IssuerId,'User.Profile.Edit' [Namespace] UNION
	SELECT 	1,'Organization.Notaries.View' UNION
	SELECT 	1,'Organization.Orders.View' UNION
	SELECT 	1,'Organization.NotaryOrders.Create' UNION
	SELECT 	1,'Organization.Notaries.Create' UNION
	SELECT 	1,'User.ResetPassword.Edit' UNION
	SELECT 	1,'User.ForgotPassword.Edit' UNION
	SELECT 	1,'Organization.Notaries.Download' UNION
	SELECT 	1,'Organization.Notaries.Edit' UNION
	SELECT 	1,'Organization.Notaries.Delete'

) [TNPermission]
LEFT JOIN [RBAC].[Permission] p on p.[Namespace] = [TNPermission].[Namespace]
WHERE P.[Namespace] IS NULL

GO
PRINT '------------------------END-----------------------------------'

PRINT 'STEP-4: - Added Trusted Notary Permissions association to Operation'
PRINT 'START'

Go
					

INSERT INTO [rbac].[PermissionOperation] ([PermissionId], [OperationId])
SELECT DISTINCT [NewPO].PermissionId, [NewPO].OperationId  FROM 
(

	SELECT 	P. Id 'PermissionId', O.Id 'OperationId' FROM [RBAC].[Permission] p INNER JOIN [RBAC].[Operation] O On O.[Resource]='NNA.Services.Profiles.Controllers.NotariesController' 
	WHERE P.[Namespace]='User.Profile.Edit' AND O.[Action]='Update'
	UNION

	SELECT 	P. Id , O.Id FROM [RBAC].[Permission] p INNER JOIN [RBAC].[Operation] O On O.[Resource]='NNA.Services.Orders.Controllers.OrdersController' 
	WHERE P.[Namespace]='Organization.Notaries.View' AND O.[Action]='GetOrdersByOrganization'
	UNION

	SELECT 	P. Id , O.Id FROM [RBAC].[Permission] p INNER JOIN [RBAC].[Operation] O On O.[Resource]='NNA.Services.Orders.Controllers.OrdersController' 
	WHERE P.[Namespace]='Organization.Orders.View' AND O.[Action]='Get'
	UNION

	SELECT 	P. Id , O.Id FROM [RBAC].[Permission] p INNER JOIN [RBAC].[Operation] O On O.[Resource]='NNA.Services.Orders.Controllers.OrdersController' 
	WHERE P.[Namespace]='Organization.NotaryOrders.Create' AND O.[Action]='Place'
	UNION

	SELECT 	P. Id , O.Id FROM [RBAC].[Permission] p INNER JOIN [RBAC].[Operation] O On O.[Resource]='NNA.Services.Identity.Controllers.UserInvitationsController' 
	WHERE P.[Namespace]='Organization.Notaries.Create' AND O.[Action]='Add'
	UNION

	SELECT 	P. Id , O.Id FROM [RBAC].[Permission] p INNER JOIN [RBAC].[Operation] O On O.[Resource]='NNA.Services.Identity.Controllers.PasswordsController' 
	WHERE P.[Namespace]='User.ResetPassword.Edit' AND O.[Action]='Update'
	UNION

	SELECT 	P. Id , O.Id FROM [RBAC].[Permission] p INNER JOIN [RBAC].[Operation] O On O.[Resource]='NNA.Services.Identity.Controllers.PasscodesController' 
	WHERE P.[Namespace]='User.ForgotPassword.Edit' AND O.[Action]='RequestCode'
	UNION

	SELECT 	P. Id , O.Id FROM [RBAC].[Permission] p INNER JOIN [RBAC].[Operation] O On O.[Resource]='NNA.Services.Profiles.Controllers.PartnersController' 
	WHERE P.[Namespace]='Organization.Notaries.Download' AND O.[Action]='InstantNotaryDownload'
	UNION

	SELECT 	P. Id , O.Id FROM [RBAC].[Permission] p INNER JOIN [RBAC].[Operation] O On O.[Resource]='NNA.Services.Profiles.Controllers.NotariesController' 
	WHERE P.[Namespace]='Organization.Notaries.Edit' AND O.[Action]='Update'
	UNION

	SELECT 	P. Id , O.Id FROM [RBAC].[Permission] p INNER JOIN [RBAC].[Operation] O On O.[Resource]='NNA.Services.Profiles.Controllers.OrganizationsController' 
	WHERE P.[Namespace]='Organization.Notaries.Delete' AND O.[Action]='RemoveNotary'

) [NewPO]
LEFT JOIN [rbac].[PermissionOperation] po on po.[PermissionId] = [NewPO].[PermissionId] AND po.[OperationId] = [NewPO].[OperationId]
WHERE po.[PermissionId] IS NULL

GO
PRINT '------------------------END-----------------------------------'

PRINT 'STEP-5: - Added Trusted Notary Permissions association to Groups.'
PRINT 'START'

Go

INSERT INTO [RBAC].[GROUPPERMISSION]
SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL 
AND P.[NAMESPACE] IN
(
	'Offers.Packages.View',
	'Offers.Catalogs.View',
	'Admin.Orders.Create',
	'Admin.Notaries.Create',
	'Organization.Notaries.Download',
	'Organization.Notaries.View',
	'Organization.Notaries.Create',
	'Organization.Notaries.Delete',
	'Organization.Notaries.Edit',
	'Organization.NotaryOrders.Create',
	'Organization.Orders.View',
	'User.ForgotPassword.Edit',
	'User.Profile.Edit',
	'User.ResetPassword.Edit'
)
AND G.NAME = 'NNA.Apps.B2B.Administrator.Group'

Go

INSERT INTO [RBAC].[GROUPPERMISSION]
SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL 
AND P.[NAMESPACE] IN
(
	'User.ForgotPassword.Edit',
	'User.Profile.Edit',
	'User.ResetPassword.Edit'
)
AND G.NAME = 'NNA.Apps.B2B.NotaryUser.Group'

Go

INSERT INTO [RBAC].[GROUPPERMISSION]
SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL 
AND P.[NAMESPACE] IN
(
	'Offers.Packages.View',
	'Offers.Catalogs.View',
	'Admin.Orders.Create',
	'User.ForgotPassword.Edit',
	'User.Profile.Edit',
	'User.ResetPassword.Edit'
)
AND G.NAME = 'NNA.Apps.B2B.NotaryUserWithOrderCred.Group'

Go

INSERT INTO [RBAC].[GROUPPERMISSION]
SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL 
AND P.[NAMESPACE] IN
(
	'Offers.Packages.View',
	'Offers.Catalogs.View',
	'Admin.Orders.Create',	
	'User.Profile.Edit',
	'Organization.Notaries.View',
	'Admin.Notaries.Create',	
	'Organization.NotaryOrders.Create',
	'Organization.Notaries.Edit',
	'Organization.Notaries.Delete'
)
AND G.NAME = 'NNA.Apps.B2B.PunchoutUser.Group'

Go

INSERT INTO [RBAC].[GROUPPERMISSION]
SELECT G.ID 'GROUPID', P.ID 'PERMISSIONID' FROM [RBAC].[GROUP] G (NOLOCK)
CROSS JOIN [RBAC].[PERMISSION] P (NOLOCK)
LEFT JOIN [RBAC].[GROUPPERMISSION] GP (NOLOCK) ON G.ID = GP.GROUPID AND P.ID = GP.PERMISSIONID
WHERE GP.GROUPID IS NULL 
AND P.[NAMESPACE] IN
(
	'Offers.Packages.View',
	'Offers.Catalogs.View',
	'Admin.Orders.Create',	
	'User.Profile.Edit'
)
AND G.NAME = 'NNA.Apps.B2B.WellsFargoUser.Group'

GO
PRINT '------------------------END-----------------------------------'

