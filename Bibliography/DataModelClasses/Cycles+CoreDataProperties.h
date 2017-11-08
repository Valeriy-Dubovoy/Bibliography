//
//  Cycles+CoreDataProperties.h
//  Bibliography
//
//  Created by Admin on 27.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Cycles.h"

NS_ASSUME_NONNULL_BEGIN

@interface Cycles (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Authors *author;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *books;
@property (nullable, nonatomic, retain) NSString *stylesAsString;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *styles;

- (NSString *) description;

@end

@interface Cycles (CoreDataGeneratedAccessors)

- (void)addBooksObject:(NSManagedObject *)value;
- (void)removeBooksObject:(NSManagedObject *)value;
- (void)addBooks:(NSSet<NSManagedObject *> *)values;
- (void)removeBooks:(NSSet<NSManagedObject *> *)values;

- (void)addStylesObject:(Styles *)value;
- (void)removeStylesObject:(Styles *)value;
- (void)addStyles:(NSSet<Styles *> *)values;
- (void)removeStyles:(NSSet<Styles *> *)values;

@end

NS_ASSUME_NONNULL_END
