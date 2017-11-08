//
//  BOStylesViewController.m
//  Bibliography
//
//  Created by Admin on 12.07.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import "BOStylesViewController.h"

@interface BOStylesViewController ()

@end


@implementation BOStylesViewController
{
    BOOL _pickerMode;
    NSMutableArray *_checkedstyles;
    NSManagedObjectContext *_managedObjectContext;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (_pickerMode) {
        self.navigationItem.title = NSLocalizedString(@"Check up styles", nil);
        
        UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Check", nil) style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
        self.navigationItem.leftBarButtonItem = backButton;
    } else {
        self.navigationItem.title = NSLocalizedString(@"Styles list", nil);
        
        // remove Done Button
        //[self.saveButton setEnabled:NO];
        //[self.saveButton setTintColor:[UIColor clearColor]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initializeWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext PickerMode:(BOOL)pickerMode currentStyles:(NSArray *)styles
{
    _managedObjectContext = managedObjectContext;
    _pickerMode = pickerMode;
    _checkedstyles = [NSMutableArray arrayWithArray:styles];
}

- (IBAction)cancel:(id)sender {
    [self.delegete BOStylesViewControllerDidCancel:self];
}


- (IBAction)done:(id)sender {
    [self.delegete BOStylesViewController:self didSelectStyles:_checkedstyles];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        NSUInteger rows = [sectionInfo numberOfObjects];
        return rows;
    } else
        return 0;
    
}

- (void)configureCell:(UITableViewCell *)cell withObject:(Styles *)object
{
    if (object == nil) {
        cell.textLabel.text = NSLocalizedString(@"<No styles", nil);
    } else
        cell.textLabel.text = [object valueForKey:@"name"];
    
    if (_pickerMode) {
        if ([_checkedstyles indexOfObject: object] == NSNotFound) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"styleCell" forIndexPath:indexPath];
    
    id anObject = nil;
    
    if (indexPath.row == [[self.fetchedResultsController fetchedObjects] count]) {
        anObject = nil;
    } else {
        anObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    [self configureCell:cell withObject:anObject];
    
   
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (indexPath.row < [[self.fetchedResultsController fetchedObjects] count]) {
            [_managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
            [self saveChangesWithErrorTitle:@"Error" errorMessage:@"Can't delete record"];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //NSLog(@"Insert new cycle");
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_pickerMode) {
        Styles *currentObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if ([_checkedstyles indexOfObject:currentObject] == NSNotFound) {
            [_checkedstyles addObject:currentObject];
        } else {
            [_checkedstyles removeObject:currentObject];
        }
        [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:currentObject];
        
    } else {
        [self performSegueWithIdentifier:@"editStyle" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
    
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //self._editableAuthor = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //[self performSegueWithIdentifier:@"showBooks" sender:self];
    //NSLog(@"Show books");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addStyle"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        BOStyleDetailViewController *destinationView  = [navigationController viewControllers][0];
        destinationView.delegate = self;
        
        [destinationView initialaizeWithStyle:nil managamentObjectContext: _managedObjectContext];
    } else if ([segue.identifier isEqualToString:@"editStyle"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        BOStyleDetailViewController *destinationView  = [navigationController viewControllers][0];
        destinationView.delegate = self;
        
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Styles *style = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [destinationView initialaizeWithStyle:style managamentObjectContext: _managedObjectContext];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Styles" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:2];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptorName]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:_managedObjectContext
                                                             sectionNameKeyPath:nil
                                                             cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Error reading styles %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            // change cell before moving
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - delegate for detail controller
- (void) styleDetailViewControllerDidCancel: (BOStyleDetailViewController *)controller{
    // rollback changes.
    if ([_managedObjectContext hasChanges])
    {
        [_managedObjectContext rollback];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) styleDetailViewController: (BOStyleDetailViewController *)controller insertNewObjectWithName: (NSString *) name{
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    Styles *newObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:_managedObjectContext];
    
    newObject.name = name;
    
    if (![self saveChangesWithErrorTitle:@"Error" errorMessage:@"Can't insert style"]) {
        [self.tableView reloadData];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void) styleDetailViewController: (BOStyleDetailViewController *)controller updateObject: (Styles *) object withName: (NSString *) name{
    object.name = name;
    if (![self saveChangesWithErrorTitle:@"Error" errorMessage:@"Can't save style"]) {
        [self.tableView reloadData];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


#pragma mark - common methods

- (BOOL) saveChangesWithErrorTitle: (NSString *) errorTitle errorMessage: (NSString *) errorMessage
{
    
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        
        [self showErrorMessageWithTitle:errorTitle errorMessage:errorMessage error:error];
        
        return NO;
        
    }
    return YES;
}

- (void) showErrorMessageWithTitle: (NSString *) errorTitle errorMessage: (NSString *) errorMessage error: (NSError *) error
{
    NSLog(@"%@ \n%@", error, [error userInfo]);
    
    NSString *localizedTitle = NSLocalizedString(errorTitle, nil);
    NSString *fullErrorMessage = [NSString stringWithFormat:@"%@:\n%@\n%@\n%@", NSLocalizedString(errorMessage, nil), error, [error localizedDescription], [error userInfo]];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:localizedTitle message:fullErrorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    
}

@end
