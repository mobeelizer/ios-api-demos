#import <Foundation/Foundation.h>

/**
 * Representation of file shared in the cloud.
 */

@interface MobeelizerFile : NSObject

/**
 * The name of the file.
 */
@property (nonatomic, readonly, strong) NSString *name;

/**
 * The guid of the file.
 */
@property (nonatomic, readonly, strong) NSString *guid;

/**
 * The content of the file.
 */
@property (nonatomic, readonly, strong) NSData *data;

@end
