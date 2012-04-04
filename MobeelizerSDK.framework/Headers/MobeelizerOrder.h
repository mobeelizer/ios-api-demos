#import <Foundation/Foundation.h>

/**
 * Utility with factory methods for query order.
 */
@interface MobeelizerOrder : NSObject

/**
 * Create ascending order for the given field.
 *
 * @param field The field name.
 * @return The order.
 */
+ (MobeelizerOrder *)asc:(NSString *)field;

/**
 * Create descending order for the given field.
 *
 * @param field The field name.
 * @return The order.
 */
+ (MobeelizerOrder *)desc:(NSString *)field;

@end
