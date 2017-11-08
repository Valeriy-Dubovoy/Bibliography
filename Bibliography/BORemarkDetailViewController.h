//
//  BORemarkDetailViewController.h
//  Bibliography
//
//  Created by Admin on 19.07.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Remarks+CoreDataProperties.h"

// delegate
@class BORemarkDetailViewController;

@protocol BORemarkDetailViewControllerDelegate <NSObject>

- (void) remarkDetailViewControllerDidCancel: (BORemarkDetailViewController *)controller;
- (void) remarkDetailViewController: (BORemarkDetailViewController *)controller insertNewObjectWithName: (NSString *) name ;
- (void) remarkDetailViewController: (BORemarkDetailViewController *)controller updateObject: (Remarks *) object withName: (NSString *) name;

@end


@interface BORemarkDetailViewController : UITableViewController

// delegate
@property (nonatomic, weak) id <BORemarkDetailViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

- (void) initialaizeWithRemark: (Remarks *) remark managamentObjectContext: (NSManagedObjectContext *) managamentObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end
