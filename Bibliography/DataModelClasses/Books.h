//
//  Books.h
//  Bibliography
//
//  Created by Admin on 27.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Authors, Cycles, Remarks, Styles;

NS_ASSUME_NONNULL_BEGIN

@interface Books : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Books+CoreDataProperties.h"
