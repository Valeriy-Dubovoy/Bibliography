//
//  BOBooksOfAuthorViewController.h
//  Bibliography
//
//  Created by Admin on 01.07.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Authors+CoreDataProperties.h"
#import "BOBookDetailViewController.h"
#import "MainDataSource.h"


@interface BOBooksOfAuthorViewController : UITableViewController <NSFetchedResultsControllerDelegate, BOBookDetailViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void) initWithDataSource: (MainDataSource *)mainDataSource Author: (Authors *) author;

@end
