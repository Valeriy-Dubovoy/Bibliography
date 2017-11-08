//
//  BOStyleDetailViewController.h
//  Bibliography
//
//  Created by Admin on 07.08.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Styles+CoreDataProperties.h"

// delegate
@class BOStyleDetailViewController;

@protocol BOStyleDetailViewControllerDelegate <NSObject>

- (void) styleDetailViewControllerDidCancel: (BOStyleDetailViewController *)controller;
- (void) styleDetailViewController: (BOStyleDetailViewController *)controller insertNewObjectWithName: (NSString *) name;
- (void) styleDetailViewController: (BOStyleDetailViewController *)controller updateObject: (Styles *) object withName: (NSString *) name;

@end


@interface BOStyleDetailViewController : UITableViewController

// delegate
@property (nonatomic, weak) id <BOStyleDetailViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

- (void) initialaizeWithStyle: (Styles *) style managamentObjectContext: (NSManagedObjectContext *) managamentObjectContext;

@end
