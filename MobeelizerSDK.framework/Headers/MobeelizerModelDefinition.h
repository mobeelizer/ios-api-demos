#import <Foundation/Foundation.h>

/**
 * Definition of the database model.
 */

@class MobeelizerModelCredentials;

@interface MobeelizerModelDefinition : NSObject

/**
 * The name of the model.
 */
@property (nonatomic, readonly, strong) NSString *name;

/**
 * The class of the model.
 */
@property (nonatomic, readonly, strong) Class clazz;

/**
 * The list of fields.
 *
 * @see MobeelizerFieldDefinition
 */
@property (nonatomic, strong) NSArray *fields;

/**
 * The credentials for current user.
 *
 * @see MobeelizerModelCredentials
 */
@property (nonatomic, strong) MobeelizerModelCredentials *credential;

@end