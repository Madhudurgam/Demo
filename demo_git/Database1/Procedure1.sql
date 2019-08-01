using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.DataContracts;
using NNA.Services.Common.Cache;
using NNA.Services.Identity.Data.Entities.IdentityEntities;
using NNA.Services.Identity.Graph.Services;
using NNA.Services.Identity.Repositories.Properties;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Core.Mapping;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using NNA.Services.Common.Audit;
using NNA.Services.Common.Audit.Model;
using NNA.Services.Identity.Model.RBAC;
using Unity.Attributes;
using Group = NNA.Services.Identity.Data.Entities.IdentityEntities.Group;
using Host = NNA.Services.Identity.Data.Entities.IdentityEntities.Host;
using Issuer = NNA.Services.Identity.Data.Entities.IdentityEntities.Issuer;
using Operation = NNA.Services.Identity.Data.Entities.IdentityEntities.Operation;
using Permission = NNA.Services.Identity.Data.Entities.IdentityEntities.Permission;
using NNA.Services.Identity.Common.RBAC;
using NNA.Services.Common;
using System.Linq.Expressions;

namespace NNA.Services.Identity.Repositories.RBAC
{
    public class GraphRbacRepository : IGraphRbacRepository
    {
        private readonly TelemetryClient _telemetry = new TelemetryClient();
        private readonly IAuditService _auditService;


        //private const string GroupClaimTypeUri = "urn:nna:security:rbac:claims:201502:group";

        public GraphRbacRepository(TelemetryClient telemetry, IAuditService auditService)
        {
            _telemetry = telemetry;
            _auditService = auditService;
        }

        #region Groups

        public bool IsGroupRegistered(Model.RBAC.Contracts.IGroup group)
        {
            return FindGroupEntity(group) != null;
        }

        public async Task<bool> IsGroupRegisteredAsync(Model.RBAC.Contracts.IGroup group)
        {
            return await FindGroupEntityAsync(group) != null;
        }

        public IEnumerable<Group> GetAllGroupEntities()
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryableGroups(context).AsNoTracking().ToList();
            }
        }
        public async Task<IEnumerable<Group>> GetAllGroupEntitiesAsync()
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryableGroups(context).AsNoTracking().ToListAsync();
            }
        }

        public IEnumerable<Group> GetAllGroupEntities(IEnumerable<Model.RBAC.Group> groups)
        {
            using (var context = new IdentityEntities())
            {
                var groupIds = groups.Select(g => g.Id);

                return GetQueryableGroups(context)
                    .AsNoTracking()
                    .Where(x => groupIds.Contains(x.Id))
                    .ToList();
            }
        }
        public async Task<IEnumerable<Group>> GetAllGroupEntitiesAsync(IEnumerable<Model.RBAC.Group> groups)
        {
            using (var context = new IdentityEntities())
            {
                var groupIds = groups.Select(g => g.Id);

                return await GetQueryableGroups(context)
                    .AsNoTracking()
                    .Where(x => groupIds.Contains(x.Id))
                    .ToListAsync();
            }
        }

        public Group GetGroupEntityById(int groupId)
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryableGroups(context)
                   .AsNoTracking()
                    .FirstOrDefault(g => g.Id == groupId);
            }
        }

        public async Task<Group> GetGroupEntityByIdAsync(int groupId)
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryableGroups(context)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(g => g.Id == groupId);
            }
        }


        public Group GetGroupEntity(Expression<Func<Group, bool>> predicate, bool tracking = false)
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryableGroups(context, tracking).FirstOrDefault(predicate);
            }
        }
        public async Task<Group> GetGroupEntityAsync(Expression<Func<Group, bool>> predicate, bool tracking = false)
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryableGroups(context, tracking).FirstOrDefaultAsync(predicate);
            }
        }
        public IEnumerable<Group> GetGroupEntities(Expression<Func<Group, bool>> predicate, bool tracking = false)
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryableGroups(context, tracking).Where(predicate);
            }
        }
        public async Task<IEnumerable<Group>> GetGroupEntitiesAsync(Expression<Func<Group, bool>> predicate, bool tracking = false)
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryableGroups(context, tracking).Where(predicate).ToListAsync();
            }
        }



        public string GetScopeByGroupId(int groupId)
        {
            using (var context = new IdentityEntities())
            {
                return context.Permissions
                   .Include(p => p.Groups)
                   .AsNoTracking()
                   .FirstOrDefault(p => p.Namespace == RbacUtils.ScopeUniversalAccess &&
                   p.Groups.Any(x => x.Id == groupId))?.Namespace;
            }
        }

        public async Task<string> GetScopeByGroupIdAsync(int groupId)
        {
            using (var context = new IdentityEntities())
            {
                return (await context.Permissions
                   .Include(p => p.Groups)
                   .AsNoTracking()
                   .FirstOrDefaultAsync(p => p.Namespace == RbacUtils.ScopeUniversalAccess &&
                   p.Groups.Any(x => x.Id == groupId)))?.Namespace;
            }
        }


        public Group GetGroupEntityByObjectId(Guid graphObjectId)
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryableGroups(context)
                   .AsNoTracking()
                    .FirstOrDefault(g => g.ObjectId == graphObjectId);
            }
        }
        public async Task<Group> GetGroupEntityByObjectIdAsync(Guid graphObjectId)
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryableGroups(context)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(g => g.ObjectId == graphObjectId);
            }
        }


        public Group FindGroupEntity(Model.RBAC.Contracts.IGroup group)
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryableGroups(context)
                    .AsNoTracking()
                    .FirstOrDefault(g =>
                        g.ObjectId == group.ObjectId ||
                        (!string.IsNullOrEmpty(group.Name) && g.Name.Equals(group.Name, StringComparison.InvariantCultureIgnoreCase)) ||
                        (!string.IsNullOrEmpty(group.Mail) && g.Mail.Equals(group.Mail, StringComparison.InvariantCultureIgnoreCase))
                    );
            }
        }

        public async Task<Group> FindGroupEntityAsync(Model.RBAC.Contracts.IGroup group)
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryableGroups(context)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(g =>
                        (group.ObjectId != null && g.ObjectId == group.ObjectId) ||
                        (!string.IsNullOrEmpty(group.Name) && g.Name.Equals(group.Name, StringComparison.InvariantCultureIgnoreCase)) ||
                        (!string.IsNullOrEmpty(group.Mail) && g.Mail.Equals(group.Mail, StringComparison.InvariantCultureIgnoreCase))
                    );
            }
        }


        public Group AddGraphGroupEntity(Model.RBAC.Contracts.IGroup group)
        {
            if (IsGroupRegistered(group))
                throw new Exception(
                    $"Group '{group.Name}' is already registered in database.");

            var groupEntity = new Identity.Data.Entities.IdentityEntities.Group()
            {
                IssuerId = 3,
                ObjectId = group.ObjectId,
                Name = group.Name,
                Mail = group.Mail,
                Description = group.Description,
                CreatedAtUtc = DateTime.UtcNow
            };

            using (var context = new IdentityEntities())
            {
                context.Groups.Add(groupEntity);

                int recordsAffected = context.SaveChanges();
                if (recordsAffected <= 0)
                    return null;
            }

            return groupEntity;
        }

        public async Task<Group> AddGraphGroupEntityAsync(Model.RBAC.Contracts.IGroup group)
        {
            if (IsGroupRegistered(group))
                throw new Exception(
                    $"Group '{group.Name}' is already registered in database.");

            var groupEntity = new Group()
            {
                IssuerId = 3,
                ObjectId = group.ObjectId,
                Name = group.Name,
                Mail = group.Mail,
                Description = group.Description,
                CreatedAtUtc = group.DateCreated ?? DateTime.UtcNow,
            };

            using (var context = new IdentityEntities())
            {
                context.Groups.Add(groupEntity);

                int recordsAffected = await context.SaveChangesAsync();
                if (recordsAffected <= 0)
                    return null;
            }

            return groupEntity;
        }


        public Identity.Data.Entities.IdentityEntities.Group AddGroupEntity(Model.RBAC.Group group)
        {
            var groupEntity = (Group) group;

            // set defaults if we're missing values
            if (groupEntity.IssuerId == 0)
                groupEntity.IssuerId = 3;

            if (!groupEntity.CreatedAtUtc.HasValue)
                groupEntity.CreatedAtUtc = DateTime.UtcNow;


            // TODO: reference permissions

            using (var context = new IdentityEntities())
            {
                context.Groups.Add(groupEntity);

                int recordsAffected = context.SaveChanges();
                if (recordsAffected <= 0)
                    return null;

                _auditService.TrackActivity(null, group, ActivityType.Create, EntityType.Permission, groupEntity.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);

                return groupEntity;
            }
        }

        public async Task<Group> AddGroupEntityAsync(Model.RBAC.Group group)
        {
            var groupEntity = (Group)group;

            // set defaults if we're missing values
            if (groupEntity.IssuerId == 0)
                groupEntity.IssuerId = 3;

            if (!groupEntity.CreatedAtUtc.HasValue)
                groupEntity.CreatedAtUtc = DateTime.UtcNow;

            // TODO: reference permissions

            using (var context = new IdentityEntities())
            {
                context.Groups.Add(groupEntity);

                int recordsAffected = await context.SaveChangesAsync();
                if (recordsAffected <= 0)
                    return null;

                await _auditService.TrackActivityAsync(null, group, ActivityType.Create, EntityType.Permission, groupEntity.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);

                return groupEntity;
            }
        }


        /// <summary>
        /// Compare properties of Graph Group to those of its corresponding entity in database and updates any changes.
        /// </summary>
        /// <param name="group">Graph group to compare with Group entity in database.</param>
        /// <returns>Number of properties that required an update.</returns>
        //public int UpdateExistingGroupEntity(Graph.DataObjects.Group group)
        public int UpdateGraphGroupEntity(Model.RBAC.Contracts.IGroup group)
        {
            using (var context = new IdentityEntities())
            {
                var groupEntity = context.Groups
                    .FirstOrDefault(g => g.ObjectId.HasValue && g.ObjectId == group.ObjectId);

                if (groupEntity == null)
                    throw new Exception(
                        $"A registered Group entity was not found in database for Group '{group.Name} ({group.Mail})' with Graph Id {group.ObjectId}.");


                int changes = UpdateGroupEntityChanges(group, ref groupEntity);

                if (changes > 0)
                {
                    int recordsAffected = context.SaveChanges();
                    if (recordsAffected <= 0)
                    {
                        _telemetry.TrackTrace(
                            $"Found differences between Graph Group and its corresponding record in database, but calling SaveChanges() on the database context resulted in no records affected.",
                            SeverityLevel.Warning, new Dictionary<string, string>()
                            {
                                {"Changes Detected", changes.ToString()},
                                {"Group GraphId", group.ObjectId.ToString()},
                                {"Group Name", group.Name},
                                {"Group EmailAddress", group.Mail}
                            });

                        changes = 0;
                    }
                }

                return changes;
            }
        }

        /// <summary>
        /// Compare properties of Graph Group to those of its corresponding entity in database and updates any changes.
        /// </summary>
        /// <param name="group">Graph group to compare with Group entity in database.</param>
        /// <returns>Number of properties that required an update.</returns>        
        public int UpdateGroupEntity(Model.RBAC.Group group)
        {
            int detectedChanges = 0;
            
            try
            {
                using (var context = new IdentityEntities())
                {
                    var groupEntity = context.Groups
                        .Include(g => g.Permissions)
                        .Include(g => g.Issuer)
                        .FirstOrDefault(g =>
                            g.Id > 0 ? g.Id == group.Id : g.ObjectId.HasValue && g.ObjectId == group.ObjectId);

                    if (groupEntity == null)
                        throw new Exception(
                            $"A valid Group entity was not found in database for Group '{group.Name}' with Id {group.Id}.");



                    // convert entity to data object that implements IAuditable so we can automatically track changes to it
                    var unchangedObject = (Model.RBAC.Group)groupEntity;

                    // make changes to object being audited
                    detectedChanges = UpdateGroupEntityChanges(group, ref groupEntity);

                    // convert entity to new auditable object, thereby copying anything that was changed
                    var modifiedObject = (Model.RBAC.Group)groupEntity;

                    // set our unchangedObject property so we can automatically detect changes
                    modifiedObject.AuditableUnchangedObject = unchangedObject;



                    if (groupEntity.IssuerId != group.IssuerId)
                    {
                        groupEntity.IssuerId = group.IssuerId;
                        detectedChanges++;
                    }


                    // Save changes to Group's permissions:

                    // ensure child permission collections are not null
                    group.Permissions = group.Permissions ?? new List<Model.RBAC.Permission>();
                    groupEntity.Permissions = groupEntity.Permissions ?? new List<Permission>();


                    // detect changes
                    bool permissionsChanged = group.Permissions.Count != groupEntity.Permissions.Count ||
                                              !groupEntity.Permissions.Select(p => p.Id)
                                                  .SequenceEqual(group.Permissions.Select(p => p.Id));

                    if (permissionsChanged)
                    {
                        var removedPermissionIds = groupEntity.Permissions.Select(p => p.Id).Except(group.Permissions.Select(p => p.Id));
                        var permissionsToRemove = groupEntity.Permissions.Where(p => removedPermissionIds.Contains(p.Id)).ToList();

                        var addedPermissionIds = group.Permissions.Select(p => p.Id).Except(groupEntity.Permissions.Select(p => p.Id));
                        var permissionsToAdd = context.Permissions.Where(p => addedPermissionIds.Contains(p.Id)).ToList();


                        // remove excluded permissions
                        foreach (var permission in permissionsToRemove)
                        {
                            if (groupEntity.Permissions.Remove(permission))
                                detectedChanges++;
                            else
                                _telemetry.TrackException(new Exception($"Unable to remove permission with Id {permission.Id} from Group {group.Id} Permissions collection."));

                        }

                        // add included permissions
                        foreach (var permission in permissionsToAdd)
                        {
                            groupEntity.Permissions.Add(permission);
                            detectedChanges++;
                        }
                    }


                    int recordsAffected = 0;

                    if (detectedChanges > 0)
                    {
                        recordsAffected = context.SaveChanges();

                        if (recordsAffected <= 0)
                            throw new Exception($"Found {detectedChanges} differences between submitted Group and its corresponding record in database, but calling SaveChanges() on the database context resulted in no records affected.");

                        // capture update activity in audit
                        _auditService.TrackActivity(modifiedObject, ActivityType.Update, EntityType.Group, modifiedObject.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);
                    }

                    return recordsAffected;
                }
            }
            catch (Exception ex)
            {
                _telemetry.TrackException(ex, new Dictionary<string, string>()
                {
                    {"Changes Detected", detectedChanges.ToString()},
                    {"Group GraphId", group.ObjectId.ToString()},
                    {"Group Name", group.Name},
                    {"Group EmailAddress", group.Mail}
                });

                throw;
            }
        }
        /// <summary>
        /// Compare properties of Graph Group to those of its corresponding entity in database and updates any changes.
        /// </summary>
        /// <param name="group">Graph group to compare with Group entity in database.</param>
        /// <returns>Number of properties that required an update.</returns>
        //public int UpdateExistingGroupEntity(Graph.DataObjects.Group group)
        public async Task<int> UpdateGroupEntityAsync(Model.RBAC.Group group)
        {
            int detectedChanges = 0;

            try
            {
                using (var context = new IdentityEntities())
                {
                    var groupEntity = await context.Groups
                        .Include(g => g.Permissions)
                        .Include(g => g.Issuer)
                        .FirstOrDefaultAsync(g =>
                            g.Id > 0 ? g.Id == group.Id : g.ObjectId.HasValue && g.ObjectId == group.ObjectId);

                    if (groupEntity == null)
                        throw new Exception(
                            $"A valid Group entity was not found in database for Group '{group.Name}' with Id {group.Id}.");


                    // convert entity to data object that implements IAuditable so we can automatically track changes to it
                    var unchangedObject = (Model.RBAC.Group)groupEntity;

                    // make changes to object being audited
                    detectedChanges = UpdateGroupEntityChanges(group, ref groupEntity);

                    // convert entity to new auditable object, thereby copying anything that was changed
                    var modifiedObject = (Model.RBAC.Group)groupEntity;

                    // set our unchangedObject property so we can automatically detect changes
                    modifiedObject.AuditableUnchangedObject = unchangedObject;



                    if (groupEntity.IssuerId != group.IssuerId)
                    {
                        groupEntity.IssuerId = group.IssuerId;
                        detectedChanges++;
                    }


                    // Save changes to Group's permissions:

                    // ensure child permission collections are not null
                    group.Permissions = group.Permissions ?? new List<Model.RBAC.Permission>();
                    groupEntity.Permissions = groupEntity.Permissions ?? new List<Permission>();


                    // detect changes
                    bool permissionsChanged = group.Permissions.Count != groupEntity.Permissions.Count ||
                                              !groupEntity.Permissions.Select(p => p.Id)
                                                  .SequenceEqual(group.Permissions.Select(p => p.Id));

                    if (permissionsChanged)
                    {
                        var removedPermissionIds = groupEntity.Permissions.Select(p => p.Id).Except(group.Permissions.Select(p => p.Id));
                        var permissionsToRemove = groupEntity.Permissions.Where(p => removedPermissionIds.Contains(p.Id)).ToList();

                        var addedPermissionIds = group.Permissions.Select(p => p.Id).Except(groupEntity.Permissions.Select(p => p.Id));
                        var permissionsToAdd = await context.Permissions.Where(p => addedPermissionIds.Contains(p.Id)).ToListAsync();


                        // remove excluded permissions
                        foreach (var permission in permissionsToRemove)
                        {
                            if (groupEntity.Permissions.Remove(permission))
                                detectedChanges++;
                            else
                                _telemetry.TrackException(new Exception($"Unable to remove permission with Id {permission.Id} from Group {group.Id} Permissions collection."));

                        }

                        // add included permissions
                        foreach (var permission in permissionsToAdd)
                        {
                            groupEntity.Permissions.Add(permission);
                            detectedChanges++;
                        }
                    }


                    int recordsAffected = 0;

                    if (detectedChanges > 0)
                    {
                        recordsAffected = await context.SaveChangesAsync();

                        if (recordsAffected <= 0)
                            throw new Exception($"Found {detectedChanges} differences between updated Group and its corresponding record in database, but calling SaveChanges() on the database context resulted in 0 records affected.");

                        // capture update activity in audit
                        await _auditService.TrackActivityAsync(modifiedObject, ActivityType.Update, EntityType.Group, modifiedObject.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);
                    }

                    return recordsAffected;
                }
            }
            catch (Exception ex)
            {
                _telemetry.TrackException(ex, new Dictionary<string, string>()
                {
                    {"Changes Detected", detectedChanges.ToString()},
                    {"Group GraphId", group.ObjectId.ToString()},
                    {"Group Name", group.Name},
                    {"Group EmailAddress", group.Mail}
                });

                throw;
            }
        }

        public void AddOAuthAccountEntityToGroup(int groupId, Guid authorizationUserId)
        {
            try
            {
                using (var context = new IdentityEntities())
                {
                    var groupEntity = context.Groups.Find(groupId);

                    if (groupEntity == null)
                        throw new Exception($"Group not found for '{groupId}'.");

                    var oAuthAccountsEntity = context.OAuthAccounts
                        .Include(x => x.Groups)
                        .FirstOrDefault(x => x.OAuthAccountGuid == authorizationUserId);

                    if (oAuthAccountsEntity == null)
                        throw new Exception($"OAuthAccount not found for '{authorizationUserId}'.");

                    if (oAuthAccountsEntity.Groups?.Any(x => x.Id == groupEntity.Id) ?? false)
                        throw new Exception($"OAuthAccount '{authorizationUserId}' already associated to Group.");

                    oAuthAccountsEntity.Groups.Add(groupEntity);

                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                _telemetry.TrackException(ex);
                throw;
            }
        }

        public async Task AddOAuthAccountEntityToGroupAsync(int groupId, Guid authorizationUserId)
        {
            try
            {
                using (var context = new IdentityEntities())
                {
                    var groupEntity = await context.Groups.FindAsync(groupId);

                    if (groupEntity == null)
                        throw new Exception($"Group not found for '{groupId}'.");

                    var oAuthAccountsEntity = await context.OAuthAccounts
                        .Include(x => x.Groups)
                        .FirstOrDefaultAsync(x => x.OAuthAccountGuid == authorizationUserId);

                    if (oAuthAccountsEntity == null)
                        throw new Exception($"OAuthAccount not found for '{authorizationUserId}'.");

                    if (oAuthAccountsEntity.Groups?.Any(x => x.Id == groupEntity.Id) ?? false)
                        throw new Exception($"OAuthAccount '{authorizationUserId}' already associated to Group.");

                    oAuthAccountsEntity.Groups.Clear();

                    oAuthAccountsEntity.Groups.Add(groupEntity);

                    await context.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                _telemetry.TrackException(ex);
                throw;
            }
        }

        public async Task AddApiKeyToGroupAsync(int groupId, Guid apiKeyId)
        {
            try
            {
                using (var context = new IdentityEntities())
                {
                    var groupEntity = await context.Groups.FindAsync(groupId);

                    if (groupEntity == null)
                        throw new Exception($"Group not found for '{groupId}'.");

                    var apiKeys = await context.ApiKeys
                        .Include(x => x.Groups)
                        .FirstOrDefaultAsync(x => x.ApiKeyId == apiKeyId);

                    if (apiKeys == null)
                        throw new Exception($"ApiKey not found for '{apiKeyId}'.");

                    if (apiKeys.Groups?.Any(x => x.Id == groupEntity.Id) ?? false)
                        throw new Exception($"ApiKey '{apiKeyId}' already associated to Group.");

                    apiKeys.Groups.Add(groupEntity);

                    await context.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                _telemetry.TrackException(ex);
                throw;
            }
        }

        #endregion

        #region Permissions


        public IEnumerable<Permission> GetAllPermissionEntities()
        {
            //using (var context = new IdentityEntities())
            //{
            //    return GetQueryablePermissions(context).AsNoTracking().ToList();
            //}
            return GetGroupPermissionEntities();
        }
        public async Task<IEnumerable<Permission>> GetAllPermissionEntitiesAsync()
        {
            //using (var context = new IdentityEntities())
            //{
            //    return await GetQueryablePermissions(context).AsNoTracking().ToListAsync();
            //}
            return await GetGroupPermissionEntitiesAsync();
        }

        public IEnumerable<Permission> GetAllPermissionEntities(IEnumerable<Model.RBAC.Permission> permissions)
        {
            using (var context = new IdentityEntities())
            {
                var permissionIds = permissions.Select(p => p.Id);
                return GetQueryablePermissions(context)
                    .AsNoTracking()
                    .Where(x => permissionIds.Contains(x.Id))
                    .ToList();
            }
        }
        public async Task<IEnumerable<Permission>> GetAllPermissionEntitiesAsync(IEnumerable<Model.RBAC.Permission> permissions)
        {
            using (var context = new IdentityEntities())
            {
                var permissionIds = permissions.Select(p => p.Id);
                return await GetQueryablePermissions(context)
                    .AsNoTracking()
                    .Where(x => permissionIds.Contains(x.Id))
                    .ToListAsync();
            }
        }

        public Permission GetPermissionEntityById(int id)
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryablePermissions(context)
                    .AsNoTracking()
                    .FirstOrDefault(p => p.Id == id);
            }
        }
        public async Task<Permission> GetPermissionEntityByIdAsync(int id)
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryablePermissions(context)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(p => p.Id == id);
            }
        }

        

        public Permission GetPermissionEntity(Expression<Func<Permission, bool>> predicate, bool tracking = false)
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryablePermissions(context, tracking).FirstOrDefault(predicate);
            }
        }
        public async Task<Permission> GetPermissionEntityAsync(Expression<Func<Permission, bool>> predicate, bool tracking = false)
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryablePermissions(context, tracking).FirstOrDefaultAsync(predicate);
            }
        }
        public IEnumerable<Permission> GetPermissionEntities(Expression<Func<Permission, bool>> predicate, bool tracking = false)
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryablePermissions(context, tracking).Where(predicate);
            }
        }
        public async Task<IEnumerable<Permission>> GetPermissionEntitiesAsync(Expression<Func<Permission, bool>> predicate, bool tracking = false)
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryablePermissions(context, tracking).Where(predicate).ToListAsync();
            }
        }



        public IEnumerable<Permission> GetGroupPermissionEntities(params Model.RBAC.Contracts.IGroup[] groups)
        {
            using (var context = new IdentityEntities())
            {
                //return GetQueryablePermissions(context).AsNoTracking().Where(p => !groups.Any() ||
                //    p.Groups.Any(g => groups.Select(gg => gg.ObjectId).Contains(g.ObjectId)));

                if (groups == null || !groups.Any() || groups.All(g => g == null))
                    return GetQueryablePermissions(context).AsNoTracking().ToList();

                var objectIds = groups.Where(gg => gg.ObjectId.HasValue).Select(gg => gg.ObjectId);

                return GetQueryablePermissions(context).AsNoTracking().Where(p =>
                    p.Groups.Any(g => objectIds.Contains(g.ObjectId))).ToList();

                //return context.Permissions.Include(p => p.Issuer).Include(p => p.Groups)
                //    .Include(p => p.Operations).Include(p => p.Operations.Select(o => o.Hosts)).AsNoTracking()
                //    //.Where(p => p.Groups.Any(g => groups.Any(gg => gg.ObjectId == g.ObjectId))).ToList();
                //    .Where(p => p.Groups.Any(g => groups.Select(gg => gg.ObjectId).Contains(g.ObjectId)));
            }
        }
        public async Task<IEnumerable<Permission>> GetGroupPermissionEntitiesAsync(params Model.RBAC.Contracts.IGroup[] groups)
        {
            using (var context = new IdentityEntities())
            {
                if (groups == null || !groups.Any() || groups.All(g => g == null))
                    return await GetQueryablePermissions(context).AsNoTracking().ToListAsync();

                var objectIds = groups.Where(gg => gg.ObjectId.HasValue).Select(gg => gg.ObjectId);

                return await GetQueryablePermissions(context).AsNoTracking().Where(p =>
                    p.Groups.Any(g => objectIds.Contains(g.ObjectId))).ToListAsync();
            }
        }

        public Model.RBAC.Permission AddPermissionEntity(Model.RBAC.Permission permission)
        {
            permission.DateCreated = permission.DateCreated != DateTime.MinValue ? permission.DateCreated : DateTime.UtcNow;

            using (var context = new IdentityEntities())
            {
                var entity = context.Permissions.Add(permission);

                //Adding GroupPermission
                if (entity != null && (permission.Groups?.Any() ?? false))
                {
                    var groupIds = permission.Groups.Select(g => g.Id);
                    var entityGroups = context.Groups.Where(x => groupIds.Contains(x.Id)).ToList();

                    foreach (var group in permission.Groups)
                    {
                        var entityGroup = entityGroups.FirstOrDefault(x => x.Id == group.Id);
                        entity.Groups.Add(entityGroup);
                    }
                }

                //Adding PermissionOperation
                if (entity != null && (permission.Operations?.Any() ?? false))
                {
                    var operationIds = permission.Operations.Select(g => g.Id);
                    var entityOperations = context.Operations.Where(x => operationIds.Contains(x.Id)).ToList();

                    foreach (var operation in permission.Operations)
                    {
                        var entityOperation = entityOperations.FirstOrDefault(x => x.Id == operation.Id);
                        entity.Operations.Add(entityOperation);
                    }
                }

                int recordsAffected = context.SaveChanges();
                if (recordsAffected <= 0)
                    return null;


                _auditService.TrackActivity(null, permission, ActivityType.Create, EntityType.Permission,
                    entity.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);


                return GetPermissionEntityById(entity.Id);
            }
        }

        public async Task<Model.RBAC.Permission> AddPermissionEntityAsync(Model.RBAC.Permission permission)
        {
            permission.DateCreated = permission.DateCreated != DateTime.MinValue ? permission.DateCreated : DateTime.UtcNow;

            using (var context = new IdentityEntities())
            {
                var entity = context.Permissions.Add(permission);

                //Adding GroupPermission
                if (entity != null && (permission.Groups?.Any() ?? false))
                {
                    var groupIds = permission.Groups.Select(g => g.Id);
                    var entityGroups = await context.Groups.Where(x => groupIds.Contains(x.Id)).ToListAsync();

                    foreach (var group in permission.Groups)
                    {
                        var entityGroup = entityGroups.FirstOrDefault(x => x.Id == group.Id);
                        entity.Groups.Add(entityGroup);
                    }
                }

                //Adding PermissionOperation
                if (entity != null && (permission.Operations?.Any() ?? false))
                {
                    var operationIds = permission.Operations.Select(g => g.Id);
                    var entityOperations = await context.Operations.Where(x => operationIds.Contains(x.Id)).ToListAsync();

                    foreach (var operation in permission.Operations)
                    {
                        var entityOperation = entityOperations.FirstOrDefault(x => x.Id == operation.Id);
                        entity.Operations.Add(entityOperation);
                    }
                }

                int recordsAffected = await context.SaveChangesAsync();
                if (recordsAffected <= 0)
                    return null;

                await _auditService.TrackActivityAsync(null, permission, ActivityType.Create, EntityType.Permission,
                    entity.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);

                return GetPermissionEntityById(entity.Id);
            }
        }

        public int UpdatePermissionEntity(Model.RBAC.Permission permission)
        {
            int detectedChanges = 0;
            try
            {
                using (var context = new IdentityEntities())
                {
                    var permissionEntity = context.Permissions.Find(permission.Id);

                    if (permissionEntity == null)
                        throw new Exception(string.Format(CultureInfo.CurrentCulture, Resources.PermissionNotFoundFor, permission.Id));


                    // convert entity to data object that implements IAuditable so we can automatically track changes to it
                    var unchangedObject = (Model.RBAC.Permission)permissionEntity;

                    // make changes to object being audited
                    detectedChanges = UpdatePermissionEntityChanges(context, permission, ref permissionEntity);

                    // convert entity to new auditable object, thereby copying anything that was changed
                    var modifiedObject = (Model.RBAC.Permission)permissionEntity;

                    // set our unchangedObject property so we can automatically detect changes
                    modifiedObject.AuditableUnchangedObject = unchangedObject;



                    int recordsAffected = 0;
                    if (detectedChanges > 0)
                    {
                        recordsAffected = context.SaveChanges();
                        if (recordsAffected <= 0)
                            throw new Exception($"Found {detectedChanges} differences between submitted Permission and its corresponding record in database, but calling SaveChanges() on the database context resulted in no records affected.");

                        // capture update activity in audit
                        _auditService.TrackActivity(modifiedObject, ActivityType.Update, EntityType.Permission, modifiedObject.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);
                    }

                    return recordsAffected;
                }
            }
            catch (Exception ex)
            {
                _telemetry.TrackException(ex, new Dictionary<string, string>()
                {
                    {"Changes Detected", detectedChanges.ToString()},
                    { "Permission Namespace", permission.Namespace},
                    { "Permission Description", permission.Description},
                    { "Permission IssuerId", permission.IssuerId.ToString()}
                });

                throw;
            }
        }
        public async Task<int> UpdatePermissionEntityAsync(Model.RBAC.Permission permission)
        {
            int detectedChanges = 0;
            try
            {
                using (var context = new IdentityEntities())
                {
                    var permissionEntity = context.Permissions.Find(permission.Id);

                    if (permissionEntity == null)
                        throw new Exception(string.Format(CultureInfo.CurrentCulture, Resources.PermissionNotFoundFor, permission.Id));


                    // convert entity to data object that implements IAuditable so we can automatically track changes to it
                    var unchangedObject = (Model.RBAC.Permission)permissionEntity;

                    // make changes to object being audited
                    detectedChanges = UpdatePermissionEntityChanges(context, permission, ref permissionEntity);

                    // convert entity to new auditable object, thereby copying anything that was changed
                    var modifiedObject = (Model.RBAC.Permission)permissionEntity;

                    // set our unchangedObject property so we can automatically detect changes
                    modifiedObject.AuditableUnchangedObject = unchangedObject;


                    int recordsAffected = 0;
                    if (detectedChanges > 0)
                    {
                        recordsAffected = await context.SaveChangesAsync();
                        if (recordsAffected <= 0)
                            throw new Exception($"Found {detectedChanges} differences between submitted Permission and its corresponding record in database, but calling SaveChanges() on the database context resulted in no records affected.");

                        // capture update activity in audit
                        await _auditService.TrackActivityAsync(modifiedObject, ActivityType.Update, EntityType.Permission, modifiedObject.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);
                    }
                    return recordsAffected;
                }
            }
            catch (Exception ex)
            {
                _telemetry.TrackException(ex, new Dictionary<string, string>()
                {
                    {"Changes Detected", detectedChanges.ToString()},
                    { "Permission Namespace", permission.Namespace},
                    { "Permission Description", permission.Description},
                    { "Permission IssuerId", permission.IssuerId.ToString()}
                });

                throw;
            }

        }

        public int DeletePermissionEntity(int permissionId)
        {
            using (var context = new IdentityEntities())
            {
                var entity = context.Permissions.Find(permissionId);
                if (entity == null)
                    throw new Exception(string.Format(CultureInfo.CurrentCulture, Resources.PermissionNotFoundFor, permissionId));

                if (entity.Groups?.Any() ?? false) entity.Groups.Clear();

                if (entity.Operations?.Any() ?? false) entity.Operations.Clear();

                context.Permissions.Remove(entity);

                int recordsAffected = context.SaveChanges();

                if (recordsAffected > 0)
                    _auditService.TrackActivity((Model.RBAC.Permission)entity, null, ActivityType.Delete, EntityType.Permission, entity.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);
                else
                    _telemetry.TrackTrace($"Permission was not deleted. The database context resulted in no records affected.", SeverityLevel.Warning,
                        new Dictionary<string, string>() { { "PermissionId", permissionId.ToString() } });

                return recordsAffected;
            }
        }
        public async Task<int> DeletePermissionEntityAsync(int permissionId)
        {
            using (var context = new IdentityEntities())
            {
                var entity = context.Permissions.Find(permissionId);
                if (entity == null)
                    throw new Exception(string.Format(CultureInfo.CurrentCulture, Resources.PermissionNotFoundFor, permissionId));

                if (entity.Groups?.Any() ?? false) entity.Groups.Clear();

                if (entity.Operations?.Any() ?? false) entity.Operations.Clear();

                context.Permissions.Remove(entity);

                
                int recordsAffected = await context.SaveChangesAsync();

                if (recordsAffected > 0)
                    await _auditService.TrackActivityAsync((Model.RBAC.Permission)entity, null, ActivityType.Delete, EntityType.Permission, entity.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);
                else
                    _telemetry.TrackTrace($"Permission was not deleted. The database context resulted in no records affected.", SeverityLevel.Warning,
                        new Dictionary<string, string>() { { "PermissionId", permissionId.ToString() } });

                return recordsAffected;
            }
        }

        public Permission FindPermissionEntity(Model.RBAC.Permission permission)
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryablePermissions(context)
                    .AsNoTracking()
                    .FirstOrDefault(p =>
                        p.IssuerId == permission.IssuerId &&
                        (!string.IsNullOrEmpty(permission.Namespace) && p.Namespace.Equals(permission.Namespace,
                             StringComparison.InvariantCultureIgnoreCase)));
            }
        }
        public async Task<Permission> FindPermissionEntityAsync(Model.RBAC.Permission permission)
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryablePermissions(context)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(p =>
                        p.Id == permission.Id ||
                        (p.IssuerId == permission.IssuerId &&
                            (!string.IsNullOrEmpty(permission.Namespace) && p.Namespace.Equals(permission.Namespace, StringComparison.InvariantCultureIgnoreCase))));
            }
        }

        #endregion

        #region Issuer

        public IEnumerable<Issuer> GetAllIssuerEntities()
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryableIssuers(context)
                    .AsNoTracking()
                    .ToList();
            }
        }

        public async Task<IEnumerable<Issuer>> GetAllIssuerEntitiesAsync()
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryableIssuers(context)
                    .AsNoTracking()
                    .ToListAsync();
            }
        }

        public Issuer GetIssuerEntityById(int issuerId)
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryableIssuers(context)
                    .AsNoTracking()
                    .FirstOrDefault(i => i.Id == issuerId);
            }
        }

        public async Task<Issuer> GetIssuerEntityByIdAsync(int issuerId)
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryableIssuers(context)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(i => i.Id == issuerId);
            }
        }

        #endregion

        #region Operations

        public IEnumerable<Operation> GetAllOperationEntities(IEnumerable<Model.RBAC.Operation> operations)
        {
            using (var context = new IdentityEntities())
            {
                var operationIds = operations.Select(o => o.Id);
                return context.Operations
                    .AsNoTracking()
                    .Where(x => operationIds.Contains(x.Id))
                    .ToList();
            }
        }
        public async Task<IEnumerable<Operation>> GetAllOperationEntitiesAsync(IEnumerable<Model.RBAC.Operation> operations)
        {
            using (var context = new IdentityEntities())
            {
                var operationIds = operations.Select(o => o.Id);
                return await GetQueryableOperations(context)
                    .AsNoTracking()
                    .Where(x => operationIds.Contains(x.Id))
                    .ToListAsync();
            }
        }

        public IEnumerable<Operation> GetAllOperationEntities()
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryableOperations(context).AsNoTracking().ToList();
            }
        }
        public async Task<IEnumerable<Operation>> GetAllOperationEntitiesAsync()
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryableOperations(context).AsNoTracking().ToListAsync();
            }
        }

        public Operation GetOperationEntityById(int id)
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryableOperations(context).AsNoTracking().FirstOrDefault(o => o.Id == id);
            }
        }
        public async Task<Operation> GetOperationEntityByIdAsync(int id)
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryableOperations(context).AsNoTracking().FirstOrDefaultAsync(o => o.Id == id);
            }
        }

        public Operation GetOperationEntity(Expression<Func<Operation, bool>> predicate, bool tracking = false)
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryableOperations(context, tracking).FirstOrDefault(predicate);
            }
        }
        public async Task<Operation> GetOperationEntityAsync(Expression<Func<Operation, bool>> predicate, bool tracking = false)
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryableOperations(context, tracking).FirstOrDefaultAsync(predicate);
            }
        }
        public IEnumerable<Operation> GetOperationEntities(Expression<Func<Operation, bool>> predicate, bool tracking = false)
        {
            using (var context = new IdentityEntities())
            {
                return GetQueryableOperations(context, tracking).Where(predicate);
            }
        }
        public async Task<IEnumerable<Operation>> GetOperationEntitiesAsync(Expression<Func<Operation, bool>> predicate, bool tracking = false)
        {
            using (var context = new IdentityEntities())
            {
                return await GetQueryableOperations(context, tracking).Where(predicate).ToListAsync();
            }
        }

        public Operation AddOperationEntity(Model.RBAC.Operation operation)
        {
            operation.DateCreated = DateTime.UtcNow;

            using (var context = new IdentityEntities())
            {
                var entity = context.Operations.Add(operation);

                //Adding OperationHosts
                if (entity != null && (operation.Hosts?.Any() ?? false))
                {
                    var hostIds = operation.Hosts.Select(g => g.Id);
                    var entityHosts = context.Hosts.Where(x => hostIds.Contains(x.Id)).ToList();

                    foreach (var host in operation.Hosts)
                    {
                        var entityHost = entityHosts.FirstOrDefault(x => x.Id == host.Id);
                        entity.Hosts.Add(entityHost);
                    }
                }

                //Adding OperationPermissions
                if (entity != null && (operation.Permissions?.Any() ?? false))
                {
                    var permissionIds = operation.Permissions.Select(g => g.Id);
                    var entityPermissions = context.Permissions.Where(x => permissionIds.Contains(x.Id)).ToList();

                    foreach (var permission in operation.Permissions)
                    {
                        var entityPermission = entityPermissions.FirstOrDefault(x => x.Id == permission.Id);
                        entity.Permissions.Add(entityPermission);
                    }
                }

                int recordsAffected = context.SaveChanges();
                if (recordsAffected <= 0)
                    return null;

                if (entity?.Id > 0)
                    _auditService.TrackActivity(null, operation, ActivityType.Create, EntityType.Operation, entity.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);
                else
                    _telemetry.TrackTrace($"Unable to track Audit activity because an Id was not set for the object.", SeverityLevel.Warning);

                return GetOperationEntityById(entity.Id);
            }
        }
        public async Task<Operation> AddOperationEntityAsync(Model.RBAC.Operation operation)
        {
            operation.DateCreated = DateTime.UtcNow;

            using (var context = new IdentityEntities())
            {
                var entity = context.Operations.Add(operation);

                //Adding OperationHosts
                if (entity != null && (operation.Hosts?.Any() ?? false))
                {
                    var hostIds = operation.Hosts.Select(g => g.Id);
                    var entityHosts = await context.Hosts.Where(x => hostIds.Contains(x.Id)).ToListAsync();

                    foreach (var host in operation.Hosts)
                    {
                        var entityHost = entityHosts.FirstOrDefault(x => x.Id == host.Id);
                        entity.Hosts.Add(entityHost);
                    }
                }

                //Adding OperationPermissions
                if (entity != null && (operation.Permissions?.Any() ?? false))
                {
                    var permissionIds = operation.Permissions.Select(g => g.Id);
                    var entityPermissions = await context.Permissions.Where(x => permissionIds.Contains(x.Id)).ToListAsync();

                    foreach (var permission in operation.Permissions)
                    {
                        var entityPermission = entityPermissions.FirstOrDefault(x => x.Id == permission.Id);
                        entity.Permissions.Add(entityPermission);
                    }
                }

                int recordsAffected = await context.SaveChangesAsync();
                if (recordsAffected <= 0)
                    return null;

                if (entity?.Id > 0)
                    await _auditService.TrackActivityAsync(null, operation, ActivityType.Create, EntityType.Operation, entity.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);
                else
                    _telemetry.TrackTrace($"Unable to track Audit activity because an Id was not set for the object.", SeverityLevel.Warning);

                return GetOperationEntityById(entity.Id);
            }
        }

        public int UpdateOperationEntity(Model.RBAC.Operation operation)
        {
            int detectedChanges = 0;
            try
            {
                using (var context = new IdentityEntities())
                {
                    var operationEntity = context.Operations.Find(operation.Id);
                    if (operationEntity == null)
                        throw new Exception(string.Format(CultureInfo.CurrentCulture, Resources.OperationNotFoundFor, operation.Id));

                    if (operationEntity.IsLocked)
                        throw new Exception(string.Format(CultureInfo.CurrentCulture,
                            Resources.OperationIsLocked, operationEntity.Id));


                    // convert entity to data object that implements IAuditable so we can automatically track changes to it
                    var unchangedObject = (Model.RBAC.Operation)operationEntity;

                    // make changes to object being audited
                    detectedChanges = UpdateOperationEntityChanges(context, operation, ref operationEntity);

                    // convert entity to new auditable object, thereby copying anything that was changed
                    var modifiedObject = (Model.RBAC.Operation)operationEntity;

                    // set our unchangedObject property so we can automatically detect changes
                    modifiedObject.AuditableUnchangedObject = unchangedObject;
                    


                    int recordsAffected = 0;
                    if (detectedChanges > 0)
                    {
                        recordsAffected = context.SaveChanges();
                        if (recordsAffected <= 0)
                            throw new Exception($"Found {detectedChanges} differences between submitted Operation and its corresponding record in database, but calling SaveChanges() on the database context resulted in no records affected.");

                        // capture update activity in audit
                        _auditService.TrackActivity(modifiedObject, ActivityType.Update, EntityType.Operation, modifiedObject.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);
                    }
                    return recordsAffected;
                }
            }
            catch (Exception ex)
            {
                _telemetry.TrackException(ex, new Dictionary<string, string>()
                {
                    {"Changes Detected", detectedChanges.ToString()},
                    { "Operations Uri", operation.Uri},
                    { "Operations Method", operation.Method},
                    { "Operations Resource", operation.Resource}
            });

                throw;
            }
        }
        public async Task<int> UpdateOperationEntityAsync(Model.RBAC.Operation operation)
        {
            int detectedChanges = 0;
            try
            {
                using (var context = new IdentityEntities())
                {
                    var operationEntity = context.Operations.Find(operation.Id);
                    if (operationEntity == null)
                        throw new Exception(string.Format(CultureInfo.CurrentCulture,
                            Resources.OperationNotFoundFor, operation.Id));

                    if (operationEntity.IsLocked)
                        throw new Exception(string.Format(CultureInfo.CurrentCulture,
                            Resources.OperationIsLocked, operationEntity.Id));


                    // convert entity to data object that implements IAuditable so we can automatically track changes to it
                    var unchangedObject = (Model.RBAC.Operation)operationEntity;

                    // make changes to object being audited
                    detectedChanges = UpdateOperationEntityChanges(context, operation, ref operationEntity);

                    // convert entity to new auditable object, thereby copying anything that was changed
                    var modifiedObject = (Model.RBAC.Operation)operationEntity;

                    // set our unchangedObject property so we can automatically detect changes
                    modifiedObject.AuditableUnchangedObject = unchangedObject;


                    int recordsAffected = 0;
                    if (detectedChanges > 0)
                    {
                        recordsAffected = await context.SaveChangesAsync();
                        if (recordsAffected <= 0)
                            throw new Exception($"Found {detectedChanges} differences between submitted Operation and its corresponding record in database, but calling SaveChanges() on the database context resulted in no records affected.");

                        // capture update activity in audit
                        await _auditService.TrackActivityAsync(modifiedObject, ActivityType.Update, EntityType.Operation, modifiedObject.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);
                    }
                    return recordsAffected;
                }
            }
            catch (Exception ex)
            {
                _telemetry.TrackException(ex, new Dictionary<string, string>()
                {
                    {"Changes Detected", detectedChanges.ToString()},
                    { "Operations Uri", operation.Uri},
                    { "Operations Method", operation.Method},
                    { "Operations Resource", operation.Resource}
            });

                throw;
            }
        }

        public int DeleteOperationEntity(int operationId)
        {
            using (var context = new IdentityEntities())
            {
                var entity = context.Operations.Find(operationId);
                if (entity == null)
                    throw new Exception(string.Format(CultureInfo.CurrentCulture, Resources.OperationNotFoundFor, operationId));

                if (entity.IsLocked)
                    throw new Exception(string.Format(CultureInfo.CurrentCulture, Resources.OperationIsLocked, operationId));

                if (entity.Hosts?.Any() ?? false) entity.Hosts.Clear();

                if (entity.Permissions?.Any() ?? false) entity.Permissions.Clear();

                context.Operations.Remove(entity);

                int recordsAffected = context.SaveChanges();

                if (recordsAffected > 0)
                    _auditService.TrackActivity((Model.RBAC.Operation) entity, null, ActivityType.Delete, EntityType.Operation, entity.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);
                else
                    _telemetry.TrackTrace($"Operation was not deleted. The database context resulted in no records affected.", SeverityLevel.Warning,
                        new Dictionary<string, string>() {{"OperationId", operationId.ToString()}});

                return recordsAffected;
            }
        }
        public async Task<int> DeleteOperationEntityAsync(int operationId)
        {
            using (var context = new IdentityEntities())
            {
                var entity = context.Operations.Find(operationId);
                if (entity == null)
                    throw new Exception(string.Format(CultureInfo.CurrentCulture, Resources.OperationNotFoundFor, operationId));

                if (entity.IsLocked)
                    throw new Exception(string.Format(CultureInfo.CurrentCulture, Resources.OperationIsLocked, operationId));

                if (entity.Hosts?.Any() ?? false) entity.Hosts.Clear();

                if (entity.Permissions?.Any() ?? false) entity.Permissions.Clear();

                context.Operations.Remove(entity);

                int recordsAffected = await context.SaveChangesAsync();

                if (recordsAffected > 0)
                    await _auditService.TrackActivityAsync((Model.RBAC.Operation)entity, null, ActivityType.Delete, EntityType.Operation, entity.Id.ToString(), Common.Globals.GetAuthenticateUserGuid(), null);
                else
                    _telemetry.TrackTrace($"Operation was not deleted. The database context resulted in no records affected.", SeverityLevel.Warning,
                        new Dictionary<string, string>() { { "OperationId", operationId.ToString() } });

                return recordsAffected;
            }
        }

        public Model.RBAC.Operation FindOperationEntity(Model.RBAC.Operation operation)
        {
            var compareType = StringComparison.InvariantCultureIgnoreCase;

            using (var context = new IdentityEntities())
            {
                return GetQueryableOperations(context)
                    .AsNoTracking()
                    .FirstOrDefault(p =>
                        (!string.IsNullOrEmpty(operation.Uri) && p.Uri.Equals(operation.Uri, compareType)) &&
                        (!string.IsNullOrEmpty(operation.Method) && p.Method.Equals(operation.Method, compareType)) &&
                        (!string.IsNullOrEmpty(operation.Resource) && p.Resource.Equals(operation.Resource, compareType)) &&
                        (!string.IsNullOrEmpty(operation.Action) && p.Action.Equals(operation.Action, compareType)));
            }
        }
        public async Task<Model.RBAC.Operation> FindOperationEntityAsync(Model.RBAC.Operation operation)
        {
            var compareType = StringComparison.InvariantCultureIgnoreCase;

            using (var context = new IdentityEntities())
            {
                return await GetQueryableOperations(context)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(p =>

                        p.Id == operation.Id ||

                        //((!string.IsNullOrEmpty(operation.Uri) && 
                        //    p.Uri.Equals(operation.Uri, compareType)) &&
                        // (!string.IsNullOrEmpty(operation.Method) && 
                        //    p.Method.Equals(operation.Method, compareType))
                        //) ||

                        //((!string.IsNullOrEmpty(operation.Method) &&
                        //    p.Method.Equals(operation.Method, compareType)) &&
                        // (!string.IsNullOrEmpty(operation.Resource) && p.Resource.Equals(operation.Resource, compareType)) &&
                        // (!string.IsNullOrEmpty(operation.Action) && p.Action.Equals(operation.Action, compareType))
                        //));

                        (!string.IsNullOrEmpty(operation.Method) && p.Method.Equals(operation.Method, compareType)) &&
                        ((!string.IsNullOrEmpty(operation.Uri) && p.Uri.Equals(operation.Uri, compareType)) ||
                         ((!string.IsNullOrEmpty(operation.Resource) && p.Resource.Equals(operation.Resource, compareType)) &&
                          (!string.IsNullOrEmpty(operation.Action) && p.Action.Equals(operation.Action, compareType))
                         ))
                    );
            }
        }

        #endregion



        #region Hosts

        public IEnumerable<Host> GetAllHostEntities()
        {
            using (var context = new IdentityEntities())
            {
                return context.Hosts.AsNoTracking().ToList();
            }
        }
        public async Task<IEnumerable<Host>> GetAllHostEntitiesAsync()
        {
            using (var context = new IdentityEntities())
            {
                return await context.Hosts.AsNoTracking().ToListAsync();
            }
        }

        #endregion

        #region Private methods

        private IQueryable<Group> GetQueryableGroups(IdentityEntities context, bool tracking)
        {
            return tracking ? GetQueryableGroups(context) : GetQueryableGroups(context).AsNoTracking();
        }
        private IQueryable<Group> GetQueryableGroups(IdentityEntities context)
        {
            return context.Groups
                .Include(g => g.Issuer)
                .Include(g => g.Permissions)
                .Include(g => g.Permissions.Select(p => p.Issuer))
                .Include(g => g.Permissions.Select(p => p.Operations))
                .Include(g => g.Permissions.Select(p => p.Operations.Select(o => o.Hosts)));
        }

        private IQueryable<Permission> GetQueryablePermissions(IdentityEntities context, bool tracking)
        {
            return tracking ? GetQueryablePermissions(context) : GetQueryablePermissions(context).AsNoTracking();
        }
        private IQueryable<Permission> GetQueryablePermissions(IdentityEntities context)
        {
            return context.Permissions
                .Include(p => p.Issuer)
                .Include(p => p.Groups)
                .Include(p => p.Groups.Select(g => g.Issuer))
                .Include(p => p.Operations)
                .Include(p => p.Operations.Select(o => o.Hosts));
        }


        private IQueryable<Operation> GetQueryableOperations(IdentityEntities context, bool tracking)
        {
            return tracking ? GetQueryableOperations(context) : GetQueryableOperations(context).AsNoTracking();
        }
        private IQueryable<Operation> GetQueryableOperations(IdentityEntities context)
        {
            return context.Operations
                .Include(o => o.Hosts)
                .Include(o => o.Permissions)
                .Include(o => o.Permissions.Select(p => p.Issuer))
                .Include(o => o.Permissions.Select(p => p.Groups))
                .Include(o => o.Permissions.Select(p => p.Groups.Select(g => g.Issuer)));
        }

        private IQueryable<Issuer> GetQueryableIssuers(IdentityEntities context)
        {
            return context.Issuers
                .Include(i => i.Groups)
                //.Include(i => i.Groups.Select(g => g.Permissions))
                .Include(i => i.Permissions);
            //.Include(i => i.Permissions.Select(p => p.Groups));
        }

        private int UpdateGroupChanges(Model.RBAC.Contracts.IGroup group, ref Model.RBAC.Group groupToUpdate)
        {
            int changes = 0;

            if (!groupToUpdate.Name?.Equals(@group.Name, StringComparison.InvariantCulture) ?? groupToUpdate.Name != @group.Name)
            {
                groupToUpdate.Name = group.Name;
                changes++;
            }

            if (!groupToUpdate.Mail?.Equals(@group.Mail, StringComparison.InvariantCulture) ?? groupToUpdate.Mail != @group.Mail)
            {
                groupToUpdate.Mail = group.Mail;
                changes++;
            }

            if (!groupToUpdate.Description?.Equals(@group.Description, StringComparison.InvariantCulture) ?? groupToUpdate.Description != group.Description)
            {
                groupToUpdate.Description = group.Description;
                changes++;
            }

            // date created is internal and should not be changeable
            //if (groupEntity.CreatedAtUtc != group.DateCreated && group.DateCreated.HasValue)
            //{
            //    groupEntity.CreatedAtUtc = group.DateCreated;
            //    changes++;
            //}

            return changes;
        }

        private int UpdateGroupEntityChanges(Model.RBAC.Contracts.IGroup group, ref Group groupEntity)
        {
            int changes = 0;

            if (!groupEntity.Name?.Equals(@group.Name, StringComparison.InvariantCulture) ?? groupEntity.Name != @group.Name)
            {
                groupEntity.Name = group.Name;
                changes++;
            }

            if (!groupEntity.Mail?.Equals(@group.Mail, StringComparison.InvariantCulture) ?? groupEntity.Mail != @group.Mail)
            {
                groupEntity.Mail = group.Mail;
                changes++;
            }

            if (!groupEntity.Description?.Equals(@group.Description, StringComparison.InvariantCulture) ?? groupEntity.Description != group.Description)
            {
                groupEntity.Description = group.Description;
                changes++;
            }

            // date created is internal and should not be changeable
            //if (groupEntity.CreatedAtUtc != group.DateCreated && group.DateCreated.HasValue)
            //{
            //    groupEntity.CreatedAtUtc = group.DateCreated;
            //    changes++;
            //}

            return changes;
        }

        private int UpdatePermissionChanges(IdentityEntities context, Model.RBAC.Permission permission, ref Model.RBAC.Permission permissionToUpdate)
        {
            int detectedChanges = 0;

            if (permissionToUpdate.IssuerId != permission.IssuerId)
            {
                permissionToUpdate.IssuerId = permission.IssuerId;
                detectedChanges++;
            }

            if (!permissionToUpdate.Name?.Equals(@permission.Name, StringComparison.InvariantCulture) ?? permissionToUpdate.Name != permission.Name)
            {
                permissionToUpdate.Name = permission.Name;
                detectedChanges++;
            }

            if (!permissionToUpdate.Namespace?.Equals(@permission.Namespace, StringComparison.InvariantCulture) ?? permissionToUpdate.Namespace != permission.Namespace)
            {
                permissionToUpdate.Namespace = permission.Namespace;
                detectedChanges++;
            }

            if (!permissionToUpdate.Description?.Equals(@permission.Description, StringComparison.InvariantCulture) ?? permissionToUpdate.Description != permission.Description)
            {
                permissionToUpdate.Description = permission.Description;
                detectedChanges++;
            }

            // date created is internal and should not be changeable
            //if (permissionEntity.CreatedAtUtc != permission.DateCreated && permission.DateCreated != DateTime.MinValue)
            //{
            //    permissionEntity.CreatedAtUtc = permission.DateCreated;
            //    changes++;
            //}

            // Save changes to Permission's groups:

            // ensure child permission collections are not null
            //permissionToUpdate.Groups = permissionToUpdate.Groups ?? new List<Group>();
            permissionToUpdate.Groups = permissionToUpdate.Groups ?? new List<Model.RBAC.Group>();

            // detect changes
            bool groupsChanged = permission.Groups != null &&
                                 (permission.Groups.Count != permissionToUpdate.Groups.Count ||
                                      !permissionToUpdate.Groups.Select(g => g.Id).SequenceEqual(permission.Groups.Select(g => g.Id)));

            if (groupsChanged)
            {
                var removedGroupIds = permissionToUpdate.Groups.Select(g => g.Id).Except(permission.Groups.Select(g => g.Id));
                var groupsToRemove = permissionToUpdate.Groups.Where(g => removedGroupIds.Contains(g.Id)).ToList();

                var addedGroupIds = permission.Groups.Select(g => g.Id).Except(permissionToUpdate.Groups.Select(g => g.Id));
                var groupsToAdd = context.Groups.Where(g => addedGroupIds.Contains(g.Id)).ToList();


                // remove excluded groups
                foreach (var group in groupsToRemove)
                {
                    if (permissionToUpdate.Groups.Remove(group))
                        detectedChanges++;
                    else
                        _telemetry.TrackException(new Exception($"Unable to remove group with Id {group.Id} from Permission {permission.Id} Group collection."));

                }

                // add included groups
                foreach (var group in groupsToAdd)
                {
                    permissionToUpdate.Groups.Add(group);
                    detectedChanges++;
                }
            }

            // Save changes to Permission's operations:

            // ensure child operation collections are not null
            permission.Operations = permission.Operations ?? new List<Model.RBAC.Operation>();
            //permissionToUpdate.Operations = permissionToUpdate.Operations ?? new List<Operation>();
            permissionToUpdate.Operations = permissionToUpdate.Operations ?? new List<Model.RBAC.Operation>();

            // detect changes
            bool operationsChanged = permission.Operations.Count != permissionToUpdate.Operations.Count ||
                                      !permissionToUpdate.Operations.Select(o => o.Id)
                                          .SequenceEqual(permission.Operations.Select(o => o.Id));

            if (operationsChanged)
            {
                var removedOperationIds = permissionToUpdate.Operations.Select(o => o.Id).Except(permission.Operations.Select(o => o.Id));
                var operationsToRemove = permissionToUpdate.Operations.Where(o => removedOperationIds.Contains(o.Id)).ToList();

                var addedOperationIds = permission.Operations.Select(o => o.Id).Except(permissionToUpdate.Operations.Select(o => o.Id));
                var operationsToAdd = context.Operations.Where(o => addedOperationIds.Contains(o.Id)).ToList();


                // remove excluded groups
                foreach (var operation in operationsToRemove)
                {
                    if (permissionToUpdate.Operations.Remove(operation))
                        detectedChanges++;
                    else
                        _telemetry.TrackException(new Exception($"Unable to remove operation with Id {operation.Id} from Permission {permission.Id} Operation collection."));

                }

                // add included groups
                foreach (var operation in operationsToAdd)
                {
                    permissionToUpdate.Operations.Add(operation);
                    detectedChanges++;
                }
            }

            return detectedChanges;
        }

        private int UpdatePermissionEntityChanges(IdentityEntities context, Model.RBAC.Permission permission, ref Permission permissionEntity)
        {
            int detectedChanges = 0;

            if (permissionEntity.IssuerId != permission.IssuerId)
            {
                permissionEntity.IssuerId = permission.IssuerId;
                detectedChanges++;
            }

            if (!permissionEntity.Name?.Equals(@permission.Name, StringComparison.InvariantCulture) ?? permissionEntity.Name != permission.Name)
            {
                permissionEntity.Name = permission.Name;
                detectedChanges++;
            }

            if (!permissionEntity.Namespace?.Equals(@permission.Namespace, StringComparison.InvariantCulture) ?? permissionEntity.Namespace != permission.Namespace)
            {
                permissionEntity.Namespace = permission.Namespace;
                detectedChanges++;
            }

            if (!permissionEntity.Description?.Equals(@permission.Description, StringComparison.InvariantCulture) ?? permissionEntity.Description != permission.Description)
            {
                permissionEntity.Description = permission.Description;
                detectedChanges++;
            }

            // date created is internal and should not be changeable
            //if (permissionEntity.CreatedAtUtc != permission.DateCreated && permission.DateCreated != DateTime.MinValue)
            //{
            //    permissionEntity.CreatedAtUtc = permission.DateCreated;
            //    changes++;
            //}

            // Save changes to Permission's groups:

            // ensure child permission collections are not null
            //permission.Groups = permission.Groups ?? new List<Model.RBAC.Group>();
            permissionEntity.Groups = permissionEntity.Groups ?? new List<Group>();

            // detect changes
            bool groupsChanged = permission.Groups != null &&
                                 (permission.Groups.Count != permissionEntity.Groups.Count ||
                                      !permissionEntity.Groups.Select(g => g.Id).SequenceEqual(permission.Groups.Select(g => g.Id)));

            if (groupsChanged)
            {
                var removedGroupIds = permissionEntity.Groups.Select(g => g.Id).Except(permission.Groups.Select(g => g.Id));
                var groupsToRemove = permissionEntity.Groups.Where(g => removedGroupIds.Contains(g.Id)).ToList();

                var addedGroupIds = permission.Groups.Select(g => g.Id).Except(permissionEntity.Groups.Select(g => g.Id));
                var groupsToAdd = context.Groups.Where(g => addedGroupIds.Contains(g.Id)).ToList();


                // remove excluded groups
                foreach (var group in groupsToRemove)
                {
                    if (permissionEntity.Groups.Remove(group))
                        detectedChanges++;
                    else
                        _telemetry.TrackException(new Exception($"Unable to remove group with Id {group.Id} from Permission {permission.Id} Group collection."));

                }

                // add included groups
                foreach (var group in groupsToAdd)
                {
                    permissionEntity.Groups.Add(group);
                    detectedChanges++;
                }
            }

            // Save changes to Permission's operations:

            // ensure child operation collections are not null
            permission.Operations = permission.Operations ?? new List<Model.RBAC.Operation>();
            permissionEntity.Operations = permissionEntity.Operations ?? new List<Operation>();

            // detect changes
            bool operationsChanged = permission.Operations.Count != permissionEntity.Operations.Count ||
                                      !permissionEntity.Operations.Select(o => o.Id)
                                          .SequenceEqual(permission.Operations.Select(o => o.Id));

            if (operationsChanged)
            {
                var removedOperationIds = permissionEntity.Operations.Select(o => o.Id).Except(permission.Operations.Select(o => o.Id));
                var operationsToRemove = permissionEntity.Operations.Where(o => removedOperationIds.Contains(o.Id)).ToList();

                var addedOperationIds = permission.Operations.Select(o => o.Id).Except(permissionEntity.Operations.Select(o => o.Id));
                var operationsToAdd = context.Operations.Where(o => addedOperationIds.Contains(o.Id)).ToList();


                // remove excluded groups
                foreach (var operation in operationsToRemove)
                {
                    if (permissionEntity.Operations.Remove(operation))
                        detectedChanges++;
                    else
                        _telemetry.TrackException(new Exception($"Unable to remove operation with Id {operation.Id} from Permission {permission.Id} Operation collection."));

                }

                // add included groups
                foreach (var operation in operationsToAdd)
                {
                    permissionEntity.Operations.Add(operation);
                    detectedChanges++;
                }
            }

            return detectedChanges;
        }

        private int UpdateOperationChanges(IdentityEntities context, Model.RBAC.Operation operation, ref Model.RBAC.Operation operationToUpdate)
        {
            int detectedChanges = 0;

            if (!operationToUpdate.Uri?.Equals(operation.Uri, StringComparison.InvariantCulture) ?? operationToUpdate.Uri != operation.Uri)
            {
                operationToUpdate.Uri = operation.Uri;
                detectedChanges++;
            }

            if (!operationToUpdate.Method?.Equals(operation.Method, StringComparison.InvariantCulture) ?? operationToUpdate.Method != operation.Method)
            {
                operationToUpdate.Method = operation.Method;
                detectedChanges++;
            }

            if (!operationToUpdate.Action?.Equals(operation.Action, StringComparison.InvariantCulture) ?? operationToUpdate.Action != operation.Action)
            {
                operationToUpdate.Action = operation.Action;
                detectedChanges++;
            }

            if (!operationToUpdate.Resource?.Equals(operation.Resource, StringComparison.InvariantCulture) ?? operationToUpdate.Resource != operation.Resource)
            {
                operationToUpdate.Resource = operation.Resource;
                detectedChanges++;
            }

            if (!operationToUpdate.Description?.Equals(operation.Description, StringComparison.InvariantCulture) ?? operationToUpdate.Description != operation.Description)
            {
                operationToUpdate.Description = operation.Description;
                detectedChanges++;
            }

            if (operationToUpdate.IsLocked != operation.IsLocked)
            {
                operationToUpdate.IsLocked = operation.IsLocked;
                detectedChanges++;
            }

            // Save changes to Operation's hosts:

            // ensure child hosts collections are not null
            operation.Hosts = operation.Hosts ?? new List<Model.RBAC.Host>();
            operationToUpdate.Hosts = operationToUpdate.Hosts ?? new List<Model.RBAC.Host>();

            // detect changes
            bool hostsChanged = operation.Hosts.Count != operationToUpdate.Hosts.Count ||
                                      !operationToUpdate.Hosts.Select(h => h.Id)
                                          .SequenceEqual(operation.Hosts.Select(h => h.Id));

            if (hostsChanged)
            {
                var removedHostIds = operationToUpdate.Hosts.Select(h => h.Id).Except(operation.Hosts.Select(h => h.Id));
                var hostsToRemove = operationToUpdate.Hosts.Where(h => removedHostIds.Contains(h.Id)).ToList();

                var addedHostIds = operation.Hosts.Select(h => h.Id).Except(operationToUpdate.Hosts.Select(h => h.Id));
                var hostsToAdd = context.Hosts.Where(h => addedHostIds.Contains(h.Id)).ToList();


                // remove excluded hosts
                foreach (var host in hostsToRemove)
                {
                    if (operationToUpdate.Hosts.Remove(host))
                        detectedChanges++;
                    else
                        _telemetry.TrackException(new Exception($"Unable to remove Host with Id {host.Id} from Operation {operation.Id} host collection."));

                }

                // add included hosts
                foreach (var host in hostsToAdd)
                {
                    operationToUpdate.Hosts.Add(host);
                    detectedChanges++;
                }
            }

            // Save changes to Operation's permissions:

            // ensure child Permissions collections are not null
            operation.Permissions = operation.Permissions ?? new List<Model.RBAC.Permission>();
            operationToUpdate.Permissions = operationToUpdate.Permissions ?? new List<Model.RBAC.Permission>();

            // detect changes
            bool permissionsChanged = operation.Permissions.Count != operationToUpdate.Permissions.Count ||
                                      !operationToUpdate.Permissions.Select(p => p.Id)
                                          .SequenceEqual(operation.Permissions.Select(p => p.Id));

            if (permissionsChanged)
            {
                var removedPermissionIds = operationToUpdate.Permissions.Select(p => p.Id).Except(operation.Permissions.Select(p => p.Id));
                var permissionsToRemove = operationToUpdate.Permissions.Where(p => removedPermissionIds.Contains(p.Id)).ToList();

                var addedPermissionIds = operation.Permissions.Select(p => p.Id).Except(operationToUpdate.Permissions.Select(p => p.Id));
                var permissionsToAdd = context.Permissions.Where(p => addedPermissionIds.Contains(p.Id)).ToList();


                // remove excluded Permissions
                foreach (var permission in permissionsToRemove)
                {
                    if (operationToUpdate.Permissions.Remove(permission))
                        detectedChanges++;
                    else
                        _telemetry.TrackException(new Exception($"Unable to remove Permission with Id {permission.Id} from Operation {operation.Id} permission collection."));

                }

                // add included Permissions
                foreach (var permission in permissionsToAdd)
                {
                    operationToUpdate.Permissions.Add(permission);
                    detectedChanges++;
                }
            }

            return detectedChanges;
        }

        private int UpdateOperationEntityChanges(IdentityEntities context, Model.RBAC.Operation operation, ref Operation operationEntity)
        {
            int detectedChanges = 0;

            if (!operationEntity.Uri?.Equals(operation.Uri, StringComparison.InvariantCulture) ?? operationEntity.Uri != operation.Uri)
            {
                operationEntity.Uri = operation.Uri;
                detectedChanges++;
            }

            if (!operationEntity.Method?.Equals(operation.Method, StringComparison.InvariantCulture) ?? operationEntity.Method != operation.Method)
            {
                operationEntity.Method = operation.Method;
                detectedChanges++;
            }

            if (!operationEntity.Action?.Equals(operation.Action, StringComparison.InvariantCulture) ?? operationEntity.Action != operation.Action)
            {
                operationEntity.Action = operation.Action;
                detectedChanges++;
            }

            if (!operationEntity.Resource?.Equals(operation.Resource, StringComparison.InvariantCulture) ?? operationEntity.Resource != operation.Resource)
            {
                operationEntity.Resource = operation.Resource;
                detectedChanges++;
            }

            if (!operationEntity.Description?.Equals(operation.Description, StringComparison.InvariantCulture) ?? operationEntity.Description != operation.Description)
            {
                operationEntity.Description = operation.Description;
                detectedChanges++;
            }

            if (operationEntity.IsLocked != operation.IsLocked)
            {
                operationEntity.IsLocked = operation.IsLocked;
                detectedChanges++;
            }

            // Save changes to Operation's hosts:

            // ensure child hosts collections are not null
            operation.Hosts = operation.Hosts ?? new List<Model.RBAC.Host>();
            operationEntity.Hosts = operationEntity.Hosts ?? new List<Host>();

            // detect changes
            bool hostsChanged = operation.Hosts.Count != operationEntity.Hosts.Count ||
                                      !operationEntity.Hosts.Select(h => h.Id)
                                          .SequenceEqual(operation.Hosts.Select(h => h.Id));

            if (hostsChanged)
            {
                var removedHostIds = operationEntity.Hosts.Select(h => h.Id).Except(operation.Hosts.Select(h => h.Id));
                var hostsToRemove = operationEntity.Hosts.Where(h => removedHostIds.Contains(h.Id)).ToList();

                var addedHostIds = operation.Hosts.Select(h => h.Id).Except(operationEntity.Hosts.Select(h => h.Id));
                var hostsToAdd = context.Hosts.Where(h => addedHostIds.Contains(h.Id)).ToList();


                // remove excluded hosts
                foreach (var host in hostsToRemove)
                {
                    if (operationEntity.Hosts.Remove(host))
                        detectedChanges++;
                    else
                        _telemetry.TrackException(new Exception($"Unable to remove Host with Id {host.Id} from Operation {operation.Id} host collection."));

                }

                // add included hosts
                foreach (var host in hostsToAdd)
                {
                    operationEntity.Hosts.Add(host);
                    detectedChanges++;
                }
            }

            // Save changes to Operation's permissions:

            // ensure child Permissions collections are not null
            operation.Permissions = operation.Permissions ?? new List<Model.RBAC.Permission>();
            operationEntity.Permissions = operationEntity.Permissions ?? new List<Permission>();

            // detect changes
            bool permissionsChanged = operation.Permissions.Count != operationEntity.Permissions.Count ||
                                      !operationEntity.Permissions.Select(p => p.Id)
                                          .SequenceEqual(operation.Permissions.Select(p => p.Id));

            if (permissionsChanged)
            {
                var removedPermissionIds = operationEntity.Permissions.Select(p => p.Id).Except(operation.Permissions.Select(p => p.Id));
                var permissionsToRemove = operationEntity.Permissions.Where(p => removedPermissionIds.Contains(p.Id)).ToList();

                var addedPermissionIds = operation.Permissions.Select(p => p.Id).Except(operationEntity.Permissions.Select(p => p.Id));
                var permissionsToAdd = context.Permissions.Where(p => addedPermissionIds.Contains(p.Id)).ToList();


                // remove excluded Permissions
                foreach (var permission in permissionsToRemove)
                {
                    if (operationEntity.Permissions.Remove(permission))
                        detectedChanges++;
                    else
                        _telemetry.TrackException(new Exception($"Unable to remove Permission with Id {permission.Id} from Operation {operation.Id} permission collection."));

                }

                // add included Permissions
                foreach (var permission in permissionsToAdd)
                {
                    operationEntity.Permissions.Add(permission);
                    detectedChanges++;
                }
            }

            return detectedChanges;
        }

        #endregion
    }

}
