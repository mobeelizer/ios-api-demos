#import <Foundation/Foundation.h>
#import "MobeelizerCriterion.h"

/**
 * The sequence of criterion linked using disjunction - (... AND ... AND ...).
 */
@interface MobeelizerConjunction : MobeelizerCriterion

/**
 * Add the criterion to this conjunction.
 *
 * @param criterion The criterion.
 * @return The conjunction.
 * @see MobeelizerCriterion
 */
- (MobeelizerConjunction *)add:(MobeelizerCriterion *)criterion;

@end
