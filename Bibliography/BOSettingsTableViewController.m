//
//  BOSettingsTableViewController.m
//  Bibliography
//
//  Created by Admin on 14.08.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import "BOSettingsTableViewController.h"
#import "BOStylesViewController.h"
#import "BORemarksListViewController.h"
#import "MainDataSource.h"

@interface BOSettingsTableViewController ()

@end


@implementation BOSettingsTableViewController
{
    NSManagedObjectContext *_managedObjectContext;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    };
    
    _managedObjectContext = [[MainDataSource sharedInstance] managedObjectContext];
    return _managedObjectContext;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRemarks"]){
        BORemarksListViewController *destinationController = [segue destinationViewController];
        
        [destinationController initializeWithManagedObjectContext:[self managedObjectContext] PickerMode:NO currentRemark:nil];
        //destinationController.delegete = self;
    } else if ([segue.identifier isEqualToString:@"showStyles"]){
        BOStylesViewController *destinationController = [segue destinationViewController];
        
        [destinationController initializeWithManagedObjectContext:[self managedObjectContext] PickerMode:NO currentStyles:nil];
        //destinationController.delegete = self;
    }}

@end
