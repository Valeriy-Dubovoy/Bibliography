//
//  BOBooksOfAuthorViewController.m
//  Bibliography
//
//  Created by Admin on 01.07.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import "BOBooksOfAuthorViewController.h"

#import "Cycles+CoreDataProperties.h"
#import "Books+CoreDataProperties.h"
#import "Styles+CoreDataProperties.h"
#import "Remarks+CoreDataProperties.h"
#import "BookOfAuthorViewCell.h"


@interface BOBooksOfAuthorViewController ()

@end


@implementation BOBooksOfAuthorViewController
{
    Books * _editingBook;
    Authors *_author;
    NSManagedObjectContext *_managedObjectContext;
    MainDataSource *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;*/

    if (_author) {
        NSString *fullName = [NSString stringWithFormat:@"%@ %@ %@", _author.secondName, _author.name, _author.middleName];
        self.navigationItem.title = fullName;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initWithDataSource: (MainDataSource *)mainDataSource Author: (Authors *) author;
{
    _author = author;
    _dataSource = mainDataSource;
    _managedObjectContext = mainDataSource.managedObjectContext;
    
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

- (void)configureCell:(BookOfAuthorViewCell *)cell withObject:(Books *)object
{
    cell.nameLabel.text = object.name;
    cell.remarkLabel.text = object.remark.name;
    cell.stylesLabel.text = [object stylesAsString];
    
    NSString *countStars;
    int rating = (int)[object.rating integerValue];
    switch (rating) {
        case 1:
            countStars = @"1";
            break;
            
        case 2:
            countStars = @"2";
            break;
            
        case 3:
            countStars = @"3";
            break;
            
        case 4:
            countStars = @"4";
            break;
            
        case 5:
            countStars = @"5";
            break;
            
        default:
            countStars = @"";
            break;
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
    
    BookOfAuthorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCell" forIndexPath:indexPath];
    
    id anObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withObject:anObject];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        NSString *sectionName = @"<Out of a cycle>";
        if (sectionInfo) {
            sectionName = [sectionInfo name];
        }
        return sectionName;
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
        [_managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
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
    //[self performSegueWithIdentifier:@"editBook" sender:self];
    //NSLog(@"Edit book");
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addBook"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        BOBookDetailViewController *detailViewController = [navigationController viewControllers][0];
        detailViewController.delegate = self;
        
        [detailViewController initWithDataSource:_dataSource Author:_author Book:nil];
    } else if ([segue.identifier isEqualToString:@"editBook"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        BOBookDetailViewController *detailViewController = [navigationController viewControllers][0];
        detailViewController.delegate = self;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Books *book = [self.fetchedResultsController objectAtIndexPath:indexPath];
        //NSLog(@"edit book %@", book.name);
        [detailViewController initWithDataSource:_dataSource Author:_author Book:book];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Books" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:0];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptorSection = [[NSSortDescriptor alloc] initWithKey:@"cycle.name" ascending:YES];
    NSSortDescriptor *sortDescriptorOrder = [[NSSortDescriptor alloc] initWithKey:@"cycleOrder" ascending:YES];
    NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptorSection, sortDescriptorOrder, sortDescriptorName]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author == %@", _author];
    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:_managedObjectContext
                                                             sectionNameKeyPath:@"cycleName"
                                                             cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Error reading authors %@, %@", error, [error userInfo]);
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

#pragma mark - detail delegate
- (void) bookDetailViewControllerDidCancel:(BOBookDetailViewController *)controller
{
    // rollback changes.
    if ([_managedObjectContext hasChanges])
    {
        [_managedObjectContext rollback];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) bookDetailViewController:(BOBookDetailViewController *)controller insertNewObjectWithName:(NSString *)name rating:(NSNumber *)rating cycle:(Cycles *)cycle cycleOrder:(NSNumber *)cycleOrder author:(Authors *)author styles:(NSSet<Styles *> *)styles remark:(Remarks *)remark
{
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    Books *newObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:_managedObjectContext];
    
    newObject.author = author;
    newObject.name = name;
    newObject.rating = rating;
    newObject.cycle = cycle;
    newObject.cycleOrder = cycleOrder;
    newObject.styles = styles;
    newObject.remark = remark;
    
    // Save the context.
    if (![self saveChangesWithErrorTitle:@"Error" errorMessage:@"Can't insert book"]) {
            
        [self.tableView reloadData];
    } else {
        _editingBook = newObject;
        //controller.book = _editingBook;
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) bookDetailViewController:(BOBookDetailViewController *)controller updateObject:(Books *)book withName:(NSString *)name rating:(NSNumber *)rating cycle:(Cycles *)cycle cycleOrder:(NSNumber *)cycleOrder author:(Authors *)author styles:(NSSet<Styles *> *)styles remark:(Remarks *)remark
{
    if (book != nil) {
        book.name = name;
        book.rating = rating;
        book.cycle = cycle;
        book.cycleOrder = cycleOrder;
        book.author = author;
        book.styles = styles;
        book.remark = remark;
        
        // Save the context.
        if (![self saveChangesWithErrorTitle:@"Error" errorMessage:@"Can't save the book"]) {
            
            [self.tableView reloadData];
        } else {
            //controller.book = _editingBook;
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - common methods

- (BOOL) saveChangesWithErrorTitle: (NSString *) errorTitle errorMessage: (NSString *) errorMessage
{
    NSError *error = nil;
    
    if (! [_dataSource saveChanges:&error]) {
        
        [self showErrorMessageWithTitle:errorTitle errorMessage:errorMessage error:error];
        
        return NO;
        
    }
    return YES;
}

- (void) showErrorMessageWithTitle: (NSString *) errorTitle errorMessage: (NSString *) errorMessage error: (NSError *) error
{
    NSLog(@"%@ \n%@", error, [error localizedDescription]);
    
    NSString *localizedTitle = NSLocalizedString(errorTitle, nil);
    NSString *fullErrorMessage = [NSString stringWithFormat:@"%@:\n%@\n%@\n%@", NSLocalizedString(errorMessage, nil), [error localizedDescription], error, [error userInfo]];
    
    [_dataSource showAlertWithTitle:localizedTitle message:fullErrorMessage defaultButtonTitle:@"OK"];
}

@end
