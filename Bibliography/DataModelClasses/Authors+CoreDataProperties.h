//
//  Authors+CoreDataProperties.h
//  Bibliography
//
//  Created by Admin on 27.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Authors.h"

NS_ASSUME_NONNULL_BEGIN

@interface Authors (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *secondName;
@property (nullable, nonatomic, retain) NSString *middleName;
@property (nullable, nonatomic, retain) NSString *sortLetter;
@property (nullable, nonatomic, retain) NSSet<Books *> *books;
@property (nullable, nonatomic, retain) NSSet<Cycles *> *cycles;

@property (nullable, nonatomic, retain) NSNumber *rating;
@property (nullable, nonatomic, retain) NSString *fullName;


@end

@interface Authors (CoreDataGeneratedAccessors)

- (void)addBooksObject:(NSManagedObject *)value;
- (void)removeBooksObject:(NSManagedObject *)value;
- (void)addBooks:(NSSet<NSManagedObject *> *)values;
- (void)removeBooks:(NSSet<NSManagedObject *> *)values;

- (void)addCyclesObject:(NSManagedObject *)value;
- (void)removeCyclesObject:(NSManagedObject *)value;
- (void)addCycles:(NSSet<NSManagedObject *> *)values;
- (void)removeCycles:(NSSet<NSManagedObject *> *)values;


- (NSNumber *) ratingByBooks;
- (void) updateSortLetter;

@end

NS_ASSUME_NONNULL_END
