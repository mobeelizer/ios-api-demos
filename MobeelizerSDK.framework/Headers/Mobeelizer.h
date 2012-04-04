#import <Foundation/Foundation.h>

@class MobeelizerDatabase;
@class MobeelizerFile;

typedef enum {
    MobeelizerLoginStatusOk = 1,
    MobeelizerLoginStatusAuthenticationFailure = -1,
    MobeelizerLoginStatusConnectionFailure = -2,
    MobeelizerLoginStatusMissingConnectionFailure = -3,
    MobeelizerLoginStatusOtherFailure = -4
} MobeelizerLoginStatus;    

typedef enum {
    MobeelizerSyncStatusNone = -1,
    MobeelizerSyncStatusStarted = 1,
    MobeelizerSyncStatusFileCreated = 2,
    MobeelizerSyncStatusTaskCreated = 3,
    MobeelizerSyncStatusTaskPerformed = 4,
    MobeelizerSyncStatusFileReceived = 5,
    MobeelizerSyncStatusFinishedWithSuccess = -6,
    MobeelizerSyncStatusFinishedWithFailure = -7
} MobeelizerSyncStatus;

typedef enum {
    MobeelizerCredentialNone = 0,
    MobeelizerCredentialOwn,
    MobeelizerCredentialGroup,
    MobeelizerCredentialAll
} MobeelizerCredential;

/**
 * Protocol for sync status change listeners.
 */

@protocol MobeelizerSyncListener <NSObject>

/**
 * Hook invoked when sync status has changed.
 * 
 * The possible values of sync status:
 *
 * - MobeelizerSyncStatusNone - Sync has not been executed in the existing user session.
 * - MobeelizerSyncStatusStarted - Sync is in progress.  The file with local changes is being prepared.
 * - MobeelizerSyncStatusFileCreated - Sync is in progress. The file with local changes has been prepared and now is being transmitted to the cloud.
 * - MobeelizerSyncStatusTaskCreated - Sync is in progress. The file with local changes has been transmitted to the cloud. Waiting for the cloud to finish processing sync.
 * - MobeelizerSyncStatusTaskPerformed - Sync is in progress. The file with cloud changes has been prepared and now is being transmitted to the device.
 * - MobeelizerSyncStatusFileReceived - Sync is in progress. The file with cloud changes has been transmitted to the device cloud and now is being inserted into local database.
 * - MobeelizerSyncStatusFinishedWithSuccess - Sync has been finished successfully.
 * - MobeelizerSyncStatusFinishedWithFailure - Sync has not been finished successfully. Look for the explanation in the application logs.
 *
 * @param newStatus The new sync status.
 * @see [Mobeelizer registerSyncStatusListener:]
 */
- (void)syncStatusHasBeenChangedTo:(MobeelizerSyncStatus)newStatus;

@end

/**
 * Entry point to the Mobeelizer application that holds references to the user sessions and the database.
 */

@interface Mobeelizer : NSObject

///---------------------------------------------------------------------------------------
/// @name Lifecycle
///---------------------------------------------------------------------------------------

/**
 * Initializer Mobeelizer. Invoke it immediately after launching the application (didFinishLaunchingWithOptions).
 */
+ (void)create;

/**
 * Destroy Mobeelizer. Invoke it just before terminating the application (applicationWillTerminate).
 */
+ (void)destroy;

///---------------------------------------------------------------------------------------
/// @name User Session
///---------------------------------------------------------------------------------------

/**
 * Create a user session for the given login, password and instance.
 *
 * The possible values:
 *
 * - MobeelizerLoginStatusOk - The user session has been successfully created.
 * - MobeelizerLoginStatusAuthenticationFailure - Login, password and instance do not match to any existing users.
 * - MobeelizerLoginStatusConnectionFailure - Connection error. Look for the explanation in the application logs.
 * - MobeelizerLoginStatusMissingConnectionFailure - Missing connection. First login requires active Internet connection.
 * - MobeelizerLoginStatusOtherFailure - Unknown error. Look for the explanation in the instance logs and the application logs.
 *
 * @param instance Instance's name.
 * @param user User.
 * @param password Password.
 * @return Login status.
 */
+ (MobeelizerLoginStatus)loginToInstance:(NSString *)instance withUser:(NSString *)user andPassword:(NSString *)password;

/**
 * Create a user session for the given login, password and instance equal to the mode ("test" or "production").
 *
 * The possible values:
 *
 * - MobeelizerLoginStatusOk - The user session has been successfully created.
 * - MobeelizerLoginStatusAuthenticationFailure - Login, password and instance do not match to any existing users.
 * - MobeelizerLoginStatusConnectionFailure - Connection error. Look for the explanation in the application logs.
 * - MobeelizerLoginStatusMissingConnectionFailure - Missing connection. First login requires active Internet connection.
 * - MobeelizerLoginStatusOtherFailure - Unknown error. Look for the explanation in the instance logs and the application logs.
 *
 * @param user User.
 * @param password Password.
 * @return Login status.
 * @see loginToInstance:withUser:andPassword:
 */
+ (MobeelizerLoginStatus)loginUser:(NSString *)user andPassword:(NSString *)password;

/**
 *  Check if the user session is active.
 *
 * @return TRUE if user session is active.
 */
+ (BOOL)isLoggedIn;

/**
 * Close the user session.
 */
+ (void)logout;

///---------------------------------------------------------------------------------------
/// @name Database
///---------------------------------------------------------------------------------------

/**
 *  Database for the active user session.
 *
 * @see MobeelizerDatabase
 */
+ (MobeelizerDatabase *)database;


///---------------------------------------------------------------------------------------
/// @name Synchronization
///---------------------------------------------------------------------------------------

/**
 * Start a differential sync.
 */
+ (void)sync;

/**
 * Start a differential sync and wait until it finishes.
 *
 * @see sync
 */
+ (void)syncAndWait;

/**
 * Start a full sync.
 */
+ (void)syncAll;

/**
 * Start a full sync and wait until it finishes.
 *
 * @see syncAll
 */
+ (void)syncAllAndWait;

/**
 * Check and return the status of current sync.
 *
 * The possible values:
 *
 * - MobeelizerSyncStatusNone - Sync has not been executed in the existing user session.
 * - MobeelizerSyncStatusStarted - Sync is in progress.  The file with local changes is being prepared.
 * - MobeelizerSyncStatusFileCreated - Sync is in progress. The file with local changes has been prepared and now is being transmitted to the cloud.
 * - MobeelizerSyncStatusTaskCreated - Sync is in progress. The file with local changes has been transmitted to the cloud. Waiting for the cloud to finish processing sync.
 * - MobeelizerSyncStatusTaskPerformed - Sync is in progress. The file with cloud changes has been prepared and now is being transmitted to the device.
 * - MobeelizerSyncStatusFileReceived - Sync is in progress. The file with cloud changes has been transmitted to the device cloud and now is being inserted into local database.
 * - MobeelizerSyncStatusFinishedWithSuccess - Sync has been finished successfully.
 * - MobeelizerSyncStatusFinishedWithFailure - Sync has not been finished successfully. Look for the explanation in the application logs.
 *
 * @return Sync status.
 */
+ (MobeelizerSyncStatus)checkSyncStatus;

/**
 * Register listener that will be notified if sync status is changed.
 *
 * @param listener listener.
 * @see MobeelizerSyncListener
 */
+ (void)registerSyncStatusListener:(id<MobeelizerSyncListener>)listener;

///---------------------------------------------------------------------------------------
/// @name Files
///---------------------------------------------------------------------------------------

/**
 * Create a new file with a given name and content.
 *
 * @param name Name.
 * @param data Content.
 * @return File.
 * @see MobeelizerFile
 */
+ (MobeelizerFile *)createFile:(NSString *)name withData:(NSData *)data;

/**
 * Create a file with a given name that points to a file with a given guid.
 *
 * @param name Name.
 * @param guid Existing file's guid.
 * @return File.
 * @see MobeelizerFile
 */
+ (MobeelizerFile *)createFile:(NSString *)name withGuid:(NSString *)guid;

@end
