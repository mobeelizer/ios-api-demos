#import <Foundation/Foundation.h>
#import <MobeelizerSDK/Mobeelizer.h>

/**
 * Credentials for the database model and the user role.
 */

@interface MobeelizerModelCredentials : NSObject

/**
 * Credential for read operation.
 *
 * The possible values:
 *
 * - MobeelizerCredentialNone - No permission.
 * - MobeelizerCredentialOwn - Permission only for own entities.
 * - MobeelizerCredentialGroup - Permission only for group entities.
 * - MobeelizerCredentialAll - All permission.
 */
@property (nonatomic, readonly) MobeelizerCredential readAllowed;

/**
 * Credential for update operation.
 *
 * The possible values:
 *
 * - MobeelizerCredentialNone - No permission.
 * - MobeelizerCredentialOwn - Permission only for own entities.
 * - MobeelizerCredentialGroup - Permission only for group entities.
 * - MobeelizerCredentialAll - All permission.
 */
@property (nonatomic, readonly) MobeelizerCredential updateAllowed;

/**
 * Credential for create operation.
 *
 * The possible values:
 *
 * - MobeelizerCredentialNone - No permission.
 * - MobeelizerCredentialOwn - Permission only for own entities.
 * - MobeelizerCredentialGroup - Permission only for group entities.
 * - MobeelizerCredentialAll - All permission.
 */
@property (nonatomic, readonly) MobeelizerCredential createAllowed;

/**
 * Credential for delete operation.
 *
 * The possible values:
 *
 * - MobeelizerCredentialNone - No permission.
 * - MobeelizerCredentialOwn - Permission only for own entities.
 * - MobeelizerCredentialGroup - Permission only for group entities.
 * - MobeelizerCredentialAll - All permission.
 */
@property (nonatomic, readonly) MobeelizerCredential deleteAllowed;

/**
 * The flag if role has permission to the resolve conflicts.
 */
@property (nonatomic, readonly) BOOL resolveConflictAllowed;

@end
