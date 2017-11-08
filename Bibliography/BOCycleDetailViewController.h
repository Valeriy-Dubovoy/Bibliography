//
//  BOCycleDetailViewController.h
//  Bibliography
//
//  Created by Admin on 15.07.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "Authors+CoreDataProperties.h"
#import "Cycles+CoreDataProperties.h"
#import "BOStylesViewController.h"


// delegate
@class BOCycleDetailViewController;

@protocol BOCycleDetailViewControllerDelegate <NSObject>

- (void) cycleDetailViewControllerDidCancel: (BOCycleDetailViewController *)controller;
- (void) cycleDetailViewController: (BOCycleDetailViewController *)controller insertNewObjectWithName: (NSString *) name author: (Authors *) author styles: (NSSet<Styles *> *) styles;
- (void) cycleDetailViewController: (BOCycleDetailViewController *)controller updateObject: (Cycles *) object withName: (NSString *) name styles: (NSSet<Styles *> *) styles;

@end


@interface BOCycleDetailViewController : UITableViewController <BOStylesViewControllerDelegate>

// delegate
@property (nonatomic, weak) id <BOCycleDetailViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

- (void) initialaizeWithAuthor: (Authors *) author cycle: (Cycles *) cycle managamentObjectContext: (NSManagedObjectContext *) managamentObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *authorNameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *stylesViewCell;

@end
