//
//  SearchViewController.m
//  Bibliography
//
//  Created by Admin on 04.01.17.
//  Copyright © 2017 dvsoft. All rights reserved.
//

#import "SearchViewController.h"
#import "BooksListViewController.h"
#import "MainDataSource.h"

@interface SearchViewController ()

@end


@implementation SearchViewController
{
    //NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_managedObjectContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _managedObjectContext = [[MainDataSource sharedInstance] managedObjectContext];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showBooks"]) {
        // hide keyboard
        [self.nameTextField resignFirstResponder];
        
        BooksListViewController *viewController = [segue destinationViewController];
        
        // get fetchResultController
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Books" inManagedObjectContext:_managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:0];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptorSection = [[NSSortDescriptor alloc] initWithKey:@"author.secondName" ascending:YES];
        NSSortDescriptor *sortDescriptorCycle = [[NSSortDescriptor alloc] initWithKey:@"cycle.name" ascending:YES];
        NSSortDescriptor *sortDescriptorOrder = [[NSSortDescriptor alloc] initWithKey:@"cycleOrder" ascending:YES];
        NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        
        [fetchRequest setSortDescriptors:@[sortDescriptorSection, sortDescriptorCycle, sortDescriptorOrder, sortDescriptorName]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", self.nameTextField.text];
        [fetchRequest setPredicate:predicate];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                                 initWithFetchRequest:fetchRequest
                                                                 managedObjectContext:_managedObjectContext
                                                                 sectionNameKeyPath:@"author.fullName"
                                                                 cacheName:nil];
        
        [viewController initWithFetchedResultsController:aFetchedResultsController];
        
    }
}



- (IBAction)namePrimaryAction:(id)sender
{
    [self performSegueWithIdentifier:@"showBooks" sender:self];
}

@end
