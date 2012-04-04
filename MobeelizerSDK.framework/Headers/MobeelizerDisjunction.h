#import <Foundation/Foundation.h>
#import "MobeelizerCriterion.h"

/**
 * The sequence of criterion linked using disjunction - (... OR ... OR ...).
 */
@interface MobeelizerDisjunction : MobeelizerCriterion

/**
 * Add the criterion to this disjunction.
 *
 * @param criterion The criterion.
 * @return The disjunction.
 * @see MobeelizerCriterion
 */
- (MobeelizerDisjunction *)add:(MobeelizerCriterion *)criterion;

@end
