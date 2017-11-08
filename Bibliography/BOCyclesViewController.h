//
//  BOCyclesViewController.h
//  Bibliography
//
//  Created by Admin on 12.07.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainDataSource.h"
#import "Cycles+CoreDataProperties.h"
#import "Authors+CoreDataProperties.h"
#import "BOCycleDetailViewController.h"

@class BOCyclesViewController;

@protocol BOCyclesViewControllerDelegate <NSObject>
- (void) BOCyclesViewController: (BOCyclesViewController *)controller didSelectCycle: (Cycles *) cycle;
@end


@interface BOCyclesViewController : UITableViewController <NSFetchedResultsControllerDelegate, BOCycleDetailViewControllerDelegate>

@property (nonatomic, weak) id <BOCyclesViewControllerDelegate> delegete;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (strong, nonatomic) Authors *author;

- (IBAction)refreshTableAction:(id)sender;
- (void) initializeWithManagedObjectContext: (NSManagedObjectContext *)managedObjectContext Author: (Authors *) author PickerMode: (BOOL) pickerMode currentCycle: (Cycles *) cycle;

@end
