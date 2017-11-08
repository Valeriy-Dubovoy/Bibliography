//
//  BOAuthorsListTableViewController.h
//  Bibliography
//
//  Created by Admin on 27.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "AppDelegate.h"
#import "BOAuthorDetailViewController.h"


@interface BOAuthorsListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, BOAuthorDetailViewControllerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) MainDataSource *mainDataSource;

- (IBAction)refreshTableAction:(id)sender;
- (void) setFilterWithString: (NSString *) filterString;

@end
