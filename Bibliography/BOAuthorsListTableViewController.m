//
//  BOAuthorsListTableViewController.m
//  Bibliography
//
//  Created by Admin on 27.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import "BOAuthorsListTableViewController.h"
#import "BOAuthorsListCell.h"

#import "Authors+CoreDataProperties.h"
#import "BOBooksOfAuthorViewController.h"


@interface BOAuthorsListTableViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) Authors *_editableAuthor;

@end


@implementation BOAuthorsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainDataSource = [MainDataSource sharedInstance];
    self.managedObjectContext = [self.mainDataSource managedObjectContext];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
    
}

- (void)configureCell:(BOAuthorsListCell *)cell withObject:(Authors *)object
{

    cell.secondNameLabel.text = [object valueForKey:@"secondName"];
    
    NSString *name = [object valueForKey:@"name"];
    NSString *middleName = [object valueForKey:@"middleName"];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", name, middleName];

    NSNumber *ratingByBooks = object.rating;
    
    NSString *countStars;
    
    if ([ratingByBooks floatValue] == 0.0){
        countStars = @"";
    } else if ([ratingByBooks floatValue] <= 1.5){
        countStars = @"1";
    } else if ([ratingByBooks floatValue] <= 2.5){
        countStars = @"2";
    } else if ([ratingByBooks floatValue] <= 3.5){
        countStars = @"3";
    } else if ([ratingByBooks floatValue] <= 4.5){
        countStars = @"4";
       } else {
        countStars = @"5";
    }
    
    if ([countStars isEqualToString:@""]) {
        // no stars to show
    } else {
        NSString *imageName = [NSString stringWithFormat:@"%@StarsSmall", countStars];
        cell.ratingImage.image = [UIImage imageNamed: imageName];
    }
     
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOAuthorsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"authorCell" forIndexPath:indexPath];
    
    id anObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withObject:anObject];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else
        return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
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
        [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        [self saveChangesWithErrorTitle:@"Error" errorMessage:@"Can't delete record"];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
    //self._editableAuthor = [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    //self._editableAuthor = [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"addAuthor"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        BOAuthorDetailViewController *authorDetailViewController = [navigationController viewControllers][0];
        //BOAuthorDetailViewController *authorDetailViewController = [segue destinationViewController];
        authorDetailViewController.delegate = self;
        
        authorDetailViewController.managedObjectContext = self.managedObjectContext;
        authorDetailViewController.author = nil;
    } else if ([[segue identifier] isEqualToString:@"editAuthor"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        BOAuthorDetailViewController *authorDetailViewController = [navigationController viewControllers][0];
        //BOAuthorDetailViewController *authorDetailViewController = [segue destinationViewController];
        authorDetailViewController.delegate = self;
        
        authorDetailViewController.managedObjectContext = self.managedObjectContext;

        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        self._editableAuthor = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        authorDetailViewController.author = self._editableAuthor;
    } else if ([[segue identifier] isEqualToString:@"showBooks"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self._editableAuthor = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        BOBooksOfAuthorViewController *viewController = [segue destinationViewController];
        [viewController initWithDataSource:self.mainDataSource Author:self._editableAuthor];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Authors" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:0];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptorSection = [[NSSortDescriptor alloc] initWithKey:@"sortLetter" ascending:YES];
    NSSortDescriptor *sortDescriptorAuthor = [[NSSortDescriptor alloc] initWithKey:@"secondName" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptorSection, sortDescriptorAuthor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.managedObjectContext
                                                             sectionNameKeyPath:@"sortLetter"
                                                             cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
//    NSError *error = nil;
//    if (![self.fetchedResultsController performFetch:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Error reading authors %@, %@", error, [error userInfo]);
//        abort();
//    }
    [self readData];
    
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

#pragma mark - authorDetail controller delegate
- (void) authorDetailViewControllerDidCancel: (BOAuthorDetailViewController *)controller
{
    // rollback changes.
    if ([self.managedObjectContext hasChanges])
    {
        [self.managedObjectContext rollback];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) authorDetailViewControllerDidSave: (BOAuthorDetailViewController *)controller
{

    // Save the context.
    if (![self saveChangesWithErrorTitle:@"Error" errorMessage:@"Can't save the author"]) {
        
        [self.tableView reloadData];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void) authorDetailViewControllerInsertNewObject:(BOAuthorDetailViewController *)controller withFirstName:(NSString *)firstName secondName:(NSString *)secondName middleName:(NSString *)middleName withSaving: (BOOL) withSaving
{
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    Authors *newAuthor = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedObjectContext];
    
    newAuthor.name = firstName;
    newAuthor.secondName = secondName;
    newAuthor.middleName = middleName;
    [newAuthor updateSortLetter];
    
    controller.author = newAuthor;
    
    // Save the context.
    if (withSaving) {
        if (![self saveChangesWithErrorTitle:@"Error" errorMessage:@"Can't insert author"]) {
            
            [self.tableView reloadData];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void) authorDetailViewControllerUpdateCurrentObject:(BOAuthorDetailViewController *)controller withFirstName:(NSString *)firstName secondName:(NSString *)secondName middleName:(NSString *)middleName withSaving:(BOOL)withSaving
{
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //self._editableAuthor = [self.fetchedResultsController objectAtIndexPath:indexPath];

    self._editableAuthor.name = firstName;
    self._editableAuthor.secondName = secondName;
    self._editableAuthor.middleName = middleName;
    [self._editableAuthor updateSortLetter];
    
    
    // Save the context.
    if (withSaving) {
        if (![self saveChangesWithErrorTitle:@"Error" errorMessage:@"Can't save the author"]) {
            
            [self.tableView reloadData];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - search bar
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //NSLog(@"search text did changed");
    [self setFilterWithString: self.searchBar.text];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //NSLog(@"search button clicked");
    [self setFilterWithString: self.searchBar.text];

    [self.searchBar endEditing:YES];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    //NSLog(@"hide keyboard");
    [self.searchBar endEditing:YES];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self setFilterWithString: self.searchBar.text];

    [self.searchBar endEditing:YES];
}

- (void) setFilterWithString: (NSString *) filterString
{
    NSFetchedResultsController *ftc = self.fetchedResultsController;
    if ([filterString isEqualToString:@""]) {
        [ftc.fetchRequest setPredicate:nil];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS [cd] %@) OR (secondName CONTAINS [cd] %@) OR (middleName CONTAINS [cd] %@)", filterString, filterString, filterString];
        [ftc.fetchRequest setPredicate:predicate];
    }
    
    [self readData];
    [self.tableView reloadData];
}

#pragma mark - common methods

- (BOOL) saveChangesWithErrorTitle: (NSString *) errorTitle errorMessage: (NSString *) errorMessage
{
    
    return [self.mainDataSource saveChangesWithErrorTitle:NSLocalizedString(errorTitle, nil) errorMessage:NSLocalizedString(errorMessage, nil) viewController:self];
    
}

- (void) showErrorMessageWithTitle: (NSString *) errorTitle errorMessage: (NSString *) errorMessage error: (NSError *) error
{
    NSLog(@"%@ \n%@", error, [error userInfo]);
    
    NSString *localizedTitle = NSLocalizedString(errorTitle, nil);
    NSString *fullErrorMessage = [NSString stringWithFormat:@"%@:\n%@\n%@\n%@", NSLocalizedString(errorMessage, nil), error, [error localizedDescription], [error userInfo]];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:localizedTitle message:fullErrorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    
}

- (void) readData
{
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Error reading authors %@, %@", error, [error userInfo]);
        //abort();
        [self showErrorMessageWithTitle:@"Error reading authors" errorMessage:@"" error:error];
    }
}

- (IBAction)refreshTableAction:(id)sender
{
    [self.tableView reloadData];
}


@end
