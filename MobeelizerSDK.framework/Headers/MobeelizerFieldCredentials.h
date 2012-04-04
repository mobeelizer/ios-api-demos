#import <Foundation/Foundation.h>
#import <MobeelizerSDK/Mobeelizer.h>

/**
 * Credentials for the database model's field and the user role.
 */

@interface MobeelizerFieldCredentials : NSObject

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

@end
