//
//  BOStyleDetailViewController.m
//  Bibliography
//
//  Created by Admin on 07.08.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import "BOStyleDetailViewController.h"
#import "BooksListViewController.h"

@interface BOStyleDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end


@implementation BOStyleDetailViewController
{
    Styles *_style;
    NSManagedObjectContext *_managedObjectContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    if (_style != nil) {
        self.nameTextField.text = _style.name;
        self.navigationItem.title = NSLocalizedString( @"Edit style", nil );
    } else {
        self.navigationItem.title = @"Add style";
    }
    [self.nameTextField becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initialaizeWithStyle:(Styles *)style managamentObjectContext:(NSManagedObjectContext *)managamentObjectContext
{
    _style = style;
    _managedObjectContext = managamentObjectContext;
}

- (IBAction)cancel:(id)sender
{
    [self.delegate styleDetailViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    // validate datas
    if ([self.nameTextField.text isEqualToString:@""]) {
        // show message
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message: NSLocalizedString(@"The name shouldn't be empty", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alertView show];
    } else if (_style == nil) {
        // send message to delegate
        [self.delegate styleDetailViewController:self insertNewObjectWithName:self.nameTextField.text];
    } else {
        // send message to delegate
        [self.delegate styleDetailViewController:self updateObject:_style withName:self.nameTextField.text];
    }
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.nameTextField becomeFirstResponder];
}

- (IBAction)namePrimaryAction:(id)sender
{
    // put focus to first name
    [self.nameTextField resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showBooks"]) {
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY styles == %@", _style];
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


@end
