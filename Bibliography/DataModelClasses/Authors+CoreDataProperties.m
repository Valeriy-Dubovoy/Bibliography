//
//  Authors+CoreDataProperties.m
//  Bibliography
//
//  Created by Admin on 27.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Authors+CoreDataProperties.h"
#import "MainDataSource.h"
#import "Books+CoreDataProperties.h"

@implementation Authors (CoreDataProperties)

@dynamic name;
@dynamic secondName;
@dynamic middleName;
@dynamic sortLetter;
@dynamic books;
@dynamic cycles;

@dynamic rating;
@dynamic fullName;


- (NSNumber *) rating
{
    // cast NSSet of objects to NSArray of objectd
    NSArray *booksArray = [self.books allObjects];
    
    if ([booksArray count] == 0) {
        return [NSNumber numberWithInt:0];
    }
    
    int summRating = 0;
    for (Books * book in booksArray) {
        summRating += [book.rating integerValue];
    }
 
    NSNumber *result = [NSNumber numberWithFloat:(float)summRating / [booksArray count]];
    return result;
}


- (void) setSecondName:(NSString *)secondName
{
    [self willChangeValueForKey:@"secondName"];
    [self setPrimitiveValue:secondName forKey:@"secondName"];
    
    [self updateSortLetter];
    [self didChangeValueForKey:@"secondName"];
}

- (void) updateSortLetter
{
    self.sortLetter = [[self.secondName substringWithRange:NSMakeRange(0, 1)] uppercaseString];
}

- (NSString *) fullName
{
    return [NSString stringWithFormat:@"%@ %@ %@", self.secondName, self.name, self.middleName];
}

@end
