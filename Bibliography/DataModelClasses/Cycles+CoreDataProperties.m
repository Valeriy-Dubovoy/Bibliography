//
//  Cycles+CoreDataProperties.m
//  Bibliography
//
//  Created by Admin on 27.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Cycles+CoreDataProperties.h"
#import "Styles+CoreDataProperties.h"

@implementation Cycles (CoreDataProperties)

@dynamic name;
@dynamic author;
@dynamic books;
@dynamic styles;
@dynamic stylesAsString;

- (NSString *) description
{
    return self.name;
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

