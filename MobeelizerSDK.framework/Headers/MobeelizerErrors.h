#import <Foundation/Foundation.h>

/**
 * Holder for validation errors.
 */

@interface MobeelizerErrors : NSObject

/**
 * Check if entity is valid - doesn't contain any global or field's errors.
 *
 * @return TRUE if valid.
 */
- (BOOL)isValid;

/**
 * Check if field is valid.
 *
 * @param field Field's name.
 * @return TRUE if valid.
 */
- (BOOL)isFieldValid:(NSString *)field;

/**
 * The list of global errors.
 *
 * @return The list of errors.
 */
- (NSArray *)errors;

/**
 * The list of field's errors.
 *
 * @param field Field's name.
 * @return The list of errors.
 */
- (NSArray *)fieldErrors:(NSString *)field;

@end
