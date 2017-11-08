//
//  Remarks+CoreDataProperties.h
//  Bibliography
//
//  Created by Admin on 27.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Remarks.h"

NS_ASSUME_NONNULL_BEGIN

@interface Remarks (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *books;

@end

@interface Remarks (CoreDataGeneratedAccessors)

- (void)addBooksObject:(NSManagedObject *)value;
- (void)removeBooksObject:(NSManagedObject *)value;
- (void)addBooks:(NSSet<NSManagedObject *> *)values;
- (void)removeBooks:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
