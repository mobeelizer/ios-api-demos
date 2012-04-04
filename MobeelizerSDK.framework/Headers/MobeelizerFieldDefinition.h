#import <Foundation/Foundation.h>

/**
 * Definition of the database model's field.
 */

@class MobeelizerFieldCredentials;

@interface MobeelizerFieldDefinition : NSObject

/**
 * The name of the field.
 */
@property (nonatomic, readonly, strong) NSString *name;

/**
 * The flag if the field is required.
 */
@property (nonatomic, readonly) BOOL required;

/**
 * The default value of the field.
 */
@property (nonatomic, readonly, strong) id defaultValue;

/**
 * The credentials for current user.
 *
 * @see MobeelizerFieldCredentials
 */
@property (nonatomic, readonly, strong) MobeelizerFieldCredentials *credential;

@end
