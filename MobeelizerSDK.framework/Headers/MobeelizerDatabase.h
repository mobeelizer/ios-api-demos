#import <Foundation/Foundation.h>

@class Mobeelizer;
@class MobeelizerErrors;
@class MobeelizerModelDefinition;
@class MobeelizerCriteriaBuilder;

/**
 * Representation of the database.
 */
@interface MobeelizerDatabase : NSObject

/**
 * Get the definition of model for the given class.
 *
 * @param name The model name.
 * @return The definition of model.
 * @see MobeelizerModelDefinition
 */
- (MobeelizerModelDefinition *)model:(NSString *)name;

/**
 * Get all entities for the given class from the database.
 *
 * @param clazz The model class.
 * @return The list of entities.
 */
- (NSArray *)list:(Class)clazz;

/**
 * Prepare the query builder for the given class.
 *
 * @param clazz The model class.
 * @return The criteria builder.
 * @see MobeelizerCriteriaBuilder
 */
- (MobeelizerCriteriaBuilder *)find:(Class)clazz;

/**
 * Delete all entities for the given class from the database.
 *
 * @param clazz The model class.
 */
- (void)removeAll:(Class)clazz;

/**
 * Delete the entity for the given class and guid from the database.
 *
 * @param clazz The model class.
 * @param guid The guid of entity.
 */
- (void)remove:(Class)clazz withGuid:(NSString *)guid;

/**
 * Delete the given entity from the database.
 *
 * @param object The entity to remove.
 */
- (void)remove:(id)object;

/**
 * Check whether the entity for the given class and guid exist.
 *
 * @param clazz The model class.
 * @param guid The guid of entity.
 * @return TRUE if exists.
 */
- (BOOL)exists:(Class)clazz withGuid:(NSString *)guid;

/**
 * Get an entity for the given class and guid. If not found return null.
 *
 * @param clazz The model class.
 * @param guid The guid of entity.
 * @return The entity or NIL if not found.
 */
- (id)get:(Class)clazz withGuid:(NSString *)guid;

/**
 * Return the count of the entities of the given class.
 *
 * @param clazz The model class.
 * @return The number of entities.
 */
- (NSUInteger)count:(Class)clazz;

/**
 * Save the given entity in the database and return validation errors.
 *
 * Check the result of [MobeelizerErrors isValid] to confirm that save has finished with success.
 *
 * @param object The entity to save.
 * @return The validation errors.
 * @see MobeelizerErrors
 */
- (MobeelizerErrors *)save:(id)object;

@end
