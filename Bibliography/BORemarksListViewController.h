//
//  BORemarksListViewController.h
//  Bibliography
//
//  Created by Admin on 19.07.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Remarks+CoreDataProperties.h"
#import "BORemarkDetailViewController.h"

@class BORemarksListViewController;

@protocol BORemarksListViewControllerDelegate <NSObject>
- (void) BORemarksListViewController: (BORemarksListViewController *)controller didSelectRemark: (Remarks *) remark;
@end


@interface BORemarksListViewController : UITableViewController <NSFetchedResultsControllerDelegate, BORemarkDetailViewControllerDelegate>

@property (nonatomic, weak) id <BORemarksListViewControllerDelegate> delegete;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (IBAction)refreshTableAction:(id)sender;
- (void) initializeWithManagedObjectContext: (NSManagedObjectContext *)managedObjectContext PickerMode: (BOOL) pickerMode currentRemark: (Remarks *) remark;

@end
