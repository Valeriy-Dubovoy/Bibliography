//
//  BOBookDetailViewController.h
//  Bibliography
//
//  Created by Admin on 08.07.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Authors+CoreDataProperties.h"
#import "Books+CoreDataProperties.h"
#import "Cycles+CoreDataProperties.h"
#import "BOCyclesViewController.h"
#import "BORemarksListViewController.h"
#import "BOStylesViewController.h"

#import "RateView.h"


@class BOBookDetailViewController;

@protocol BOBookDetailViewControllerDelegate <NSObject>

- (void) bookDetailViewController: (BOBookDetailViewController *) controller
          insertNewObjectWithName: (NSString *) name
                           rating: (NSNumber *) rating
                            cycle: (Cycles *) cycle
                       cycleOrder: (NSNumber *) cycleOrder
                           author: (Authors *) author
                           styles: (NSSet<Styles *> *) styles
                           remark: (Remarks *)remark;

- (void) bookDetailViewController: (BOBookDetailViewController *) controller
                     updateObject: (Books *) book
                         withName: (NSString *) name
                           rating: (NSNumber *) rating
                            cycle: (Cycles *) cycle
                       cycleOrder: (NSNumber *) cycleOrder
                           author: (Authors *) author
                           styles: (NSSet<Styles *> *) styles
                           remark: (Remarks *)remark;
- (void) bookDetailViewControllerDidCancel: (BOBookDetailViewController *)controller;
@end



@interface BOBookDetailViewController : UITableViewController <RateViewDelegate, BOCyclesViewControllerDelegate, BORemarksListViewControllerDelegate, BOStylesViewControllerDelegate>

// delegate
@property (nonatomic, weak) id <BOBookDetailViewControllerDelegate> delegate;

//@property (nonatomic, weak) Authors *author;
//@property (nonatomic, weak) Books *book;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

- (void) initWithDataSource: (MainDataSource *)mainDataSource Author: (Authors *) author Book: (Books *) book;

@end
