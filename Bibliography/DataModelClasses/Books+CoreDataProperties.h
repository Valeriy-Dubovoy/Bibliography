//
//  Books+CoreDataProperties.h
//  Bibliography
//
//  Created by Admin on 27.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Books.h"

NS_ASSUME_NONNULL_BEGIN

@interface Books (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *rating;
@property (nullable, nonatomic, retain) NSNumber *cycleOrder;
@property (nullable, nonatomic, retain) Cycles *cycle;
@property (nullable, nonatomic, retain) Authors *author;
@property (nullable, nonatomic, retain) NSSet<Styles *> *styles;
@property (nullable, nonatomic, retain) Remarks *remark;
@property (nullable, nonatomic, retain) NSString *cycleName;
@property (nullable, nonatomic, retain) NSString *stylesAsString;

@end

@interface Books (CoreDataGeneratedAccessors)

- (void)addStylesObject:(Styles *)value;
- (void)removeStylesObject:(Styles *)value;
- (void)addStyles:(NSSet<Styles *> *)values;
- (void)removeStyles:(NSSet<Styles *> *)values;

@end

NS_ASSUME_NONNULL_END
