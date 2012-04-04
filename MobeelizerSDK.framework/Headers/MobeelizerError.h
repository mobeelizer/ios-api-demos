#import <Foundation/Foundation.h>

typedef enum {
    
    MobeelizerErrorCodeEmpty,
    MobeelizerErrorCodeTooLong,
    MobeelizerErrorCodeGreaterThan,
    MobeelizerErrorCodeGreaterThanOrEqualsTo,
    MobeelizerErrorCodeLessThan,
    MobeelizerErrorCodeLessThanOrEqualsTo,
    MobeelizerErrorCodeNotFound
    
} MobeelizerErrorCode;

/**
 * Representation of the validation error.
 */

@interface MobeelizerError : NSObject

/**
 * The code of the error.
 *
 * The possible values:
 *
 * - MobeelizerErrorCodeEmpty - Value of the field can't be empty.
 * - MobeelizerErrorCodeTooLong - Value of the field is too long.
 * - MobeelizerErrorCodeGreaterThan - Value of the field is too low.
 * - MobeelizerErrorCodeGreaterThanOrEqualsTo - Value of the field is too low.
 * - MobeelizerErrorCodeLessThan - Value of the field is too high.
 * - MobeelizerErrorCodeLessThanOrEqualsTo - Value of the field is too high.
 * - MobeelizerErrorCodeNotFound - Value of the field points to not existing entity.
 */
@property(nonatomic, readonly) MobeelizerErrorCode code;

/**
 * The arguments for the message.
 */
@property(nonatomic, readonly, strong) NSArray *arguments;

/**
 * The readable message for the error.
 * 
 * @return The message for the errors.
 */
- (NSString *)message;

@end
