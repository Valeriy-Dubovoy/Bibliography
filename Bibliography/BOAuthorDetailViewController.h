//
//  BOAuthorDetailViewController.h
//  Bibliography
//
//  Created by Admin on 28.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Authors+CoreDataProperties.h"
#import "MainDataSource.h"

// delegate
@class BOAuthorDetailViewController;

@protocol BOAuthorDetailViewControllerDelegate <NSObject>

- (void) authorDetailViewControllerDidCancel: (BOAuthorDetailViewController *)controller;
- (void) authorDetailViewControllerDidSave: (BOAuthorDetailViewController *)controller;
- (void) authorDetailViewControllerInsertNewObject: (BOAuthorDetailViewController *)controller withFirstName: (NSString *) firstName secondName: (NSString *) secondName middleName: (NSString *) middleName withSaving: (BOOL) withSaving;
- (void) authorDetailViewControllerUpdateCurrentObject: (BOAuthorDetailViewController *)controller withFirstName: (NSString *) firstName secondName: (NSString *) secondName middleName: (NSString *) middleName withSaving: (BOOL) withSaving;

@end


@interface BOAuthorDetailViewController : UITableViewController

// delegate
@property (nonatomic, weak) id <BOAuthorDetailViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *middleNameTextField;
//@property (strong, nonatomic) IBOutlet UITableView *doneButton;

@property (weak, nonatomic) Authors *author;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableViewCell *cyclesViewCell;

@end
