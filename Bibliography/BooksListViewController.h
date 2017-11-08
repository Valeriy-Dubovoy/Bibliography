//
//  BooksListViewController.h
//  Bibliography
//
//  Created by Admin on 21.08.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Authors+CoreDataProperties.h"
#import "BOBookDetailViewController.h"
#import "AppDelegate.h"

@interface BooksListViewController : UITableViewController <NSFetchedResultsControllerDelegate, BOBookDetailViewControllerDelegate>

- (void) initWithFetchedResultsController: (NSFetchedResultsController *) fetchedResultsController;
@end
