//
//  Books+CoreDataProperties.m
//  Bibliography
//
//  Created by Admin on 27.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Books+CoreDataProperties.h"
#import "Cycles+CoreDataProperties.h"
#import "Styles+CoreDataProperties.h"

@implementation Books (CoreDataProperties)

@dynamic name;
@dynamic rating;
@dynamic cycleOrder;
@dynamic cycle;
@dynamic author;
@dynamic styles;
@dynamic remark;
@dynamic cycleName;
@dynamic stylesAsString;

- (NSString *) cycleName
{
    return self.cycle ? self.cycle.name : NSLocalizedString(@"<Out of a cycle>", nil);
}

- (NSString *) stylesAsString
{
    NSString *stylesListString = @"";
    for (Styles *style in [self.styles allObjects]) {
        NSString *delimiter = [stylesListString isEqualToString:@""] ? @"" : @", ";
        stylesListString = [NSString stringWithFormat:@"%@%@%@", stylesListString, delimiter, style.name];
    }
    return  stylesListString;
}

@end
