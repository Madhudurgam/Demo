/*---------------------------------------------------------------------
CREATED BY:-	N Vamsi Rajesh
MODIFIED DATE:-	2019-04-09
COMMENTS:-		PLAT-4982: Associate Operations/endpoints with existing Permissions
					STEP 1:- Products Permission associate Operations/endpoints.
					SETP 2:- Offers Permission associate Operations/endpoints.
					SETP 3:- Administrative Permission associate Operations/endpoints.
					STEP 4:- Events Permission associate Operations/endpoints.
					STEP 5:- DevOps Administrative Permission associate Operations/endpoints.
---------------------------------------------------------------------*/
GO
/*---------------------------------------------------------------------
STEP 1:- Products Permission associate Operations/endpoints.						
		1.	Lines (CateUNIONries)
		2.	Families (ProductTypes)
		3.	CateUNIONries (ProductTypes)				
		4.	Products 
		5.	Attributes (options)
		6.	Bulk Pricing (Prices)
---------------------------------------------------------------------*/
PRINT 'STEP 1:- Products Permission associate Operations/endpoints.'
GO
INSERT INTO [rbac].[PermissionOperation]
SELECT PermissionId,OperationId FROM
(
	--1: Lines View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Lines.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%CategoriesController' AND Method='Get'

	UNION

	--2: Families View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Families.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%ProductTypesController' AND Method='Get'
	
	UNION

	--3: Families Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Families.Create'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%ProductTypesController' AND Method='POST'

	UNION

	--4: Families Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Families.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%ProductTypesController' AND Method='PUT'

	UNION

	--5: Families Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Families.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%ProductTypesController' AND Method='DELETE'

	UNION

	--6: Categories View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Categories.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%ProductTypesController' AND Method='Get'

	UNION

	--7: Categories Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Categories.Create'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%ProductTypesController' AND Method='POST'

	UNION

	--8: Categories Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Categories.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%ProductTypesController' AND Method='PUT'

	UNION

	--9: Categories Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Categories.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%ProductsController' AND Method='DELETE'

	UNION

	--10: Products View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Products.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%ProductsController' AND Method='Get'

	UNION

	--11: Products Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Products.Create'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%ProductsController' AND Method='POST'

	UNION

	--12: Products Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Products.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%ProductsController' AND Method='PUT'

	UNION

	--13: Products Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Products.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID 
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%ProductsController' AND Method='DELETE'

	UNION

	--14: Attributes View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Attributes.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID 
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%OptionsController' AND Method='Get'

	UNION

	--15: Attributes Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Attributes.Create'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID 
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%OptionsController' AND Method='POST'

	UNION

	--16: Attributes Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Attributes.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID 
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%OptionsController' AND Method='PUT'

	UNION

	--17: Attributes Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK) 
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.Attributes.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%OptionsController' AND Method='DELETE'

	UNION

	--18: BulkPricing View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.BulkPricing.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%PricesController' AND Method='Get'

	UNION

	--19: BulkPricing Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.BulkPricing.Create'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID 
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%PricesController' AND Method='POST'

	UNION

	--20: BulkPricing Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.BulkPricing.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID 
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%PricesController' AND Method='PUT'

	UNION

	--21: BulkPricing Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Products.BulkPricing.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID 
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND O.[Resource] like '%PricesController' AND Method='DELETE'

) T
GO
/*---------------------------------------------------------------------
SETP 2:- Offers Permission associate Operations/endpoints.
		1. Packages
		2. Catalogs
---------------------------------------------------------------------*/
PRINT 'SETP 2:- Offers Permission associate Operations/endpoints.'
GO
INSERT INTO [rbac].[PermissionOperation]
SELECT PermissionId,OperationId FROM
(
	-- 1: Packages View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Offers.Packages.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND 
	(
		O.[Resource] like '%PackagesController' OR
		O.[Resource] like '%BrandsController' OR
		O.[Resource] like '%TagsController'OR
		O.[Resource] like '%DiscountsController' OR
		O.[Resource] like '%FeesController' OR
		O.[Resource] like '%FeeTypesController' OR
		O.[Resource] like '%PriceCalculatorController' OR
		O.[Resource] like '%PriceListsController' OR
		O.[Resource] like '%RestrictionsController' OR
		O.[Resource] like '%RestrictionTypesController' OR
		O.[Resource] like '%SubjectsController' OR
		O.[Resource] like '%UnitsOfMeasureController' OR
		O.[Resource] like '%WebhooksController'
	) 
	AND Method='Get'

	UNION

	-- 2: Packages Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Offers.Packages.Create'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND 
	(
		O.[Resource] like '%PackagesController'
	)
	AND Method='POST'

	UNION

	-- 3: Packages Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Offers.Packages.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND 
	(
		O.[Resource] like '%PackagesController'
	)  
	AND Method='PUT'

	UNION

	-- 4: Packages Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Offers.Packages.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND 
	(
		O.[Resource] like '%PackagesController'
	) 
	AND Method='DELETE'

	UNION

	-- 5: Catalogs View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Offers.Catalogs.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%CatalogsController' AND Method='Get'

	UNION

	-- 6: Catalogs Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Offers.Catalogs.Create'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%CatalogsController' AND Method='POST'

	UNION

	-- 7: Catalogs Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Offers.Catalogs.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%CatalogsController' AND Method='PUT'

	UNION

	-- 8: Catalogs Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Offers.Catalogs.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%CatalogsController' AND Method='DELETE'

) T
GO
/*---------------------------------------------------------------------
SETP 3:- Administrative Permission associate Operations/endpoints.
		1. Notaries
		2. Organizations
		3. Partners
		4. Orders
		5. People (Persons)
		6. SyncStatus (Sync)
		7. Reprocess (Processor)
---------------------------------------------------------------------*/
PRINT 'SETP 3:- Administrative Permission associate Operations/endpoints.'
GO
INSERT INTO [rbac].[PermissionOperation]
SELECT PermissionId,OperationId FROM
(
	-- 1: Notaries View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Notaries.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND (O.[Resource] like '%NotariesController' OR  O.[Resource] like '%NotariesQualificationsController') 
	AND Method='Get'

	UNION

	-- 2: Notaries Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Notaries.Create'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND (O.[Resource] like '%NotariesController' OR  O.[Resource] like '%NotariesQualificationsController')  
	AND Method='POST'

	UNION

	-- 3: Notaries Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Notaries.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND (O.[Resource] like '%NotariesController' OR  O.[Resource] like '%NotariesQualificationsController')  
	AND Method='PUT'

	UNION

	-- 4: Notaries Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Notaries.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND (O.[Resource] like '%NotariesController' OR  O.[Resource] like '%NotariesQualificationsController')  
	AND Method='DELETE'

	UNION

	-- 5: Organizations View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Organizations.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%OrganizationsController'  AND Method='Get'

	UNION

	-- 6: Organizations Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Organizations.Create'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%OrganizationsController'  AND Method='POST'

	UNION

	-- 7: Organizations Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Organizations.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%OrganizationsController' AND Method='PUT'

	UNION

	-- 8: Organizations Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Organizations.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE 
	P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%OrganizationsController' AND Method='DELETE'

	UNION

	-- 9: Partners View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Partners.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND (O.[Resource] like '%PartnersController' OR  O.[Resource] like '%PartnersQualificationsController') 
	AND Method='Get'

	UNION

	-- 10: Partners Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Partners.Create'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL
	AND (O.[Resource] like '%PartnersController' OR  O.[Resource] like '%PartnersQualificationsController') 
	AND Method='POST'

	UNION

	-- 11: Partners Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Partners.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND (O.[Resource] like '%PartnersController' OR  O.[Resource] like '%PartnersQualificationsController') 
	AND Method='PUT'

	UNION

	-- 12: Partners Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Partners.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND (O.[Resource] like '%PartnersController' OR  O.[Resource] like '%PartnersQualificationsController') 
	AND Method='DELETE'

	UNION

	-- 13: Orders View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Orders.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE 
	P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND (O.[Resource] like '%OrdersController' OR  O.[Resource] like '%CartsController') 
	AND Method='Get'

	UNION

	-- 14: Orders Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Orders.Create'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND (O.[Resource] like '%OrdersController' OR  O.[Resource] like '%CartsController')  
	AND Method='POST'

	UNION

	-- 15: Orders Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Orders.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND (O.[Resource] like '%OrdersController' OR  O.[Resource] like '%CartsController')  
	AND Method='PUT'

	UNION

	-- 16: Orders Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Orders.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND (O.[Resource] like '%OrdersController' OR  O.[Resource] like '%CartsController')  
	AND Method='DELETE'

	UNION

	-- 17: People View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.People.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%PersonsController' AND Method='Get'

	UNION

	-- 18: People Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.People.Create'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%PersonsController' AND Method='POST'

	UNION

	-- 19: People Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.People.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%PersonsController' AND Method='PUT'

	UNION

	-- 20: People Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.People.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%PersonsController' AND Method='DELETE'

	UNION

	-- 21: SyncStatus View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.SyncStatus.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%SyncController' AND Method='Get'

	UNION

	-- 22: SyncStatus Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.SyncStatus.Create'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%SyncController' AND Method='POST'

	UNION

	-- 23: SyncStatus Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.SyncStatus.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE 
	P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%SyncController' AND Method='PUT'

	UNION

	-- 24: SyncStatus Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.SyncStatus.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE 
	P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%SyncController' AND Method='DELETE'

	UNION

	-- 25: Reprocess View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Reprocess.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%ProcessorController' AND Method='Get'

	UNION

	-- 26: Reprocess Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Reprocess.Create'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%ProcessorController' AND Method='POST'

	UNION

	-- 27: Reprocess Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Reprocess.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%ProcessorController' AND Method='PUT'

	UNION

	-- 28: Reprocess Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Reprocess.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%ProcessorController' AND Method='DELETE'

) T
GO
/*---------------------------------------------------------------------
STEP 4:- Events Permission associate Operations/endpoints.
		1.	Events
		2.	Venues
		3.	Staff
		4.	EventTemplates
---------------------------------------------------------------------*/
PRINT 'STEP 4:- Events Permission associate Operations/endpoints.'
Go
INSERT INTO [rbac].[PermissionOperation]
SELECT PermissionId,OperationId FROM
(

	-- 1: Events View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.Events.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND 
	(
		O.[Resource] like '%EventsController' OR
		O.[Resource] like '%EventStatusesController' OR
		O.[Resource] like '%EventTypesController'
	)
	AND Method='Get' AND O.[Uri] NOT LIKE '%Staff%'
	
	UNION

	-- 2: Events Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.Events.Add'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND 
	(
		O.[Resource] like '%EventsController' OR
		O.[Resource] like '%EventStatusesController' OR
		O.[Resource] like '%EventTypesController'
	) 
	AND Method='POST' AND O.[Uri] NOT LIKE '%Staff%'

	UNION

	-- 3: Events Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.Events.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND 
	(
		O.[Resource] like '%EventsController' OR
		O.[Resource] like '%EventStatusesController' OR
		O.[Resource] like '%EventTypesController'
	)
	AND Method='PUT' AND O.[Uri] NOT LIKE '%Staff%'

	UNION

	-- 4: Events Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.Events.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND 
	(
		O.[Resource] like '%EventsController' OR
		O.[Resource] like '%EventStatusesController' OR
		O.[Resource] like '%EventTypesController'
	)
	AND Method='DELETE' AND O.[Uri] NOT LIKE '%Staff%'
	
	UNION

	-- 5: Venues View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.Venues.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%VenuesController' AND Method='Get'
	
	UNION

	-- 6: Venues Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.Venues.Add'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%VenuesController' AND Method='POST'
		
	UNION

	-- 7: Venues Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.Venues.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%VenuesController' AND Method='PUT'

	UNION

	-- 8: Venues Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.Venues.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%VenuesController' AND Method='DELETE'

	UNION

	-- 9: Staff View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.Staff.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND 
	(
		O.[Resource] like '%EventsController' OR 
		O.[Resource] like '%StaffsController'
	)
	AND Method='Get' AND O.[Uri] like '%Staff%'
	
	UNION

	-- 10: Staff Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.Staff.Add'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND 
	(
		O.[Resource] like '%EventsController' OR 
		O.[Resource] like '%StaffsController'
	)
	AND Method='POST' AND O.[Uri] like '%Staff%'

	UNION

	-- 11: Staff Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.Staff.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND 
	(
		O.[Resource] like '%EventsController' OR 
		O.[Resource] like '%StaffsController'
	)
	AND Method='PUT' AND O.[Uri] like '%Staff%'

	UNION

	-- 12: Staff Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.Staff.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND 
	(
		O.[Resource] like '%EventsController' OR 
		O.[Resource] like '%StaffsController'
	)
	AND Method='DELETE'	AND O.[Uri] like '%Staff%'
	
	UNION

	-- 13: EventTemplates View Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.EventTemplates.View'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%TemplatesController' AND Method='Get'
	
	UNION

	-- 14: EventTemplates Create Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.EventTemplates.Add'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%TemplatesController' AND Method='POST'

	UNION

	-- 15: EventTemplates Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.EventTemplates.Edit'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%TemplatesController' AND Method='PUT'

	UNION

	-- 16: EventTemplates Delete Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Event.EventTemplates.Delete'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL 
	AND O.[Resource] like '%TemplatesController' AND Method='DELETE'

) T
GO
/*---------------------------------------------------------------------
STEP 5:- DevOps Administrative Permission associate Operations/endpoints.
		1. Impersonate users	- Admin.Users.Impersonate - AuthorizationController
		2. Administer RBAC system	- RBAC.System.Manage - AuthorizationController
		3. Administer RBAC Groups	- RBAC.Groups.Manage - RbacGroupsController
		4. Administer RBAC Permissions	- RBAC.Permissions.Manage -  RbacPermissionsController
		5. Administer RBAC Operations	- RBAC.Operations.Manage - RbacOperationsController
---------------------------------------------------------------------*/
PRINT 'STEP 5:- DevOps Administrative Permission associate Operations/endpoints.'
Go
INSERT INTO [rbac].[PermissionOperation]
SELECT PermissionId,OperationId FROM
(

	--Step 1: Impersonate Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'Admin.Users.Impersonate'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL  
	AND O.[Resource] like '%AuthorizationController' 
	AND O.[Uri] like '%Impersonate%'

	UNION

	--Step 2: Administer RBAC system Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'RBAC.System.Manage'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL  
	AND O.[Resource] like '%AuthorizationController'
	AND O.[Uri] not like '%Impersonate%'

	UNION

	--Step 3: Administer RBAC Groups Edit Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'RBAC.Groups.Manage'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL  
	AND O.[Resource] like '%RbacGroupsController'

	UNION

	--Step 4: Administer RBAC Permissions
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'RBAC.Permissions.Managee'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL  
	AND O.[Resource] like '%RbacPermissionsController'

	UNION

	--Step 5: Administer RBAC Operations Permission
	SELECT P.ID 'PermissionId', O.ID 'OperationId' FROM [rbac].[Operation] O (NOLOCK)
	LEFT JOIN [rbac].[Permission] P (NOLOCK) ON P.[Namespace] = 'RBAC.Operations.Manage'
	LEFT JOIN [rbac].[PermissionOperation] PO (NOLOCK) ON O.ID = PO.OperationID AND PO.PermissionId=P.ID	
	WHERE P.ID IS NOT NULL AND PO.PermissionId IS NULL  
	AND O.[Resource] like '%RbacOperationsController'

) T
Go