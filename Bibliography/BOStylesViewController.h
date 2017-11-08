//
//  BOStylesViewController.h
//  Bibliography
//
//  Created by Admin on 12.07.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Styles+CoreDataProperties.h"
#import "BOStyleDetailViewController.h"

@class BOStylesViewController;

@protocol BOStylesViewControllerDelegate <NSObject>
- (void) BOStylesViewController: (BOStylesViewController *)controller didSelectStyles: (NSArray *) styles;
- (void) BOStylesViewControllerDidCancel: (BOStylesViewController *)controller;
@end

@interface BOStylesViewController : UITableViewController <NSFetchedResultsControllerDelegate, BOStyleDetailViewControllerDelegate>

@property (nonatomic, weak) id <BOStylesViewControllerDelegate> delegete;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void) initializeWithManagedObjectContext: (NSManagedObjectContext *)managedObjectContext PickerMode: (BOOL) pickerMode currentStyles: (NSArray *)styles;


@end
