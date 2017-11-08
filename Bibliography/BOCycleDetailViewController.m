//
//  BOCycleDetailViewController.m
//  Bibliography
//
//  Created by Admin on 15.07.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import "BOCycleDetailViewController.h"

@interface BOCycleDetailViewController ()

@end


@implementation BOCycleDetailViewController
{
    Cycles *_cycle;
    Authors *_author;
    NSManagedObjectContext *_managedObjectContext;
    NSArray *_styles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _styles = [[NSMutableArray alloc] init];
    if (_author != nil) {
        self.authorNameCell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", _author.secondName, _author.name, _author.middleName];
    }
    if (_cycle != nil) {
        self.nameTextField.text = _cycle.name;
        _styles = [(NSSet *) _cycle.styles allObjects];
    }
    [self.nameTextField becomeFirstResponder];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self showStyles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initialaizeWithAuthor:(Authors *)author cycle:(Cycles *)cycle managamentObjectContext:(NSManagedObjectContext *)managamentObjectContext
{
    _author = author;
    _cycle = cycle;
    _managedObjectContext = managamentObjectContext;
    
    //NSLog(@"init cycle editor for %@ cycle %@", [_author valueForKey:@"secondName"], cycle.name);
}

- (IBAction)cancel:(id)sender
{
    [self.delegate cycleDetailViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    // validate datas
    if ([self.nameTextField.text isEqualToString:@""]) {
        // show message
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message: NSLocalizedString(@"The name shouldn't be empty", nil) delegate:nil cancelButtonTitle:NSLocalizedString( @"OK", nil ) otherButtonTitles: nil];
        [alertView show];
    } else if (_cycle == nil) {
        // send message to delegate
        [self.delegate cycleDetailViewController:self insertNewObjectWithName:self.nameTextField.text author:_author styles:[NSSet setWithArray:_styles]];
    } else {
        // send message to delegate
        [self.delegate cycleDetailViewController:self updateObject:_cycle withName:self.nameTextField.text styles:[NSSet setWithArray:_styles]];
    }
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.nameTextField becomeFirstResponder];
    
//    if (indexPath.section == 0) {
//        [self.nameTextField becomeFirstResponder];
//    } else if (indexPath.section == 1) {
//        [self.nameTextField becomeFirstResponder];
//    }
}

- (IBAction)namePrimaryAction:(id)sender
{
    // put focus to first name
    [self.nameTextField resignFirstResponder];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pickStyles"]){
        BOStylesViewController *destinationController = [segue destinationViewController];
        
        [destinationController initializeWithManagedObjectContext:_managedObjectContext PickerMode:YES currentStyles:_styles];
        destinationController.delegete = self;
    }
}

#pragma mark - delegates

- (void) BOStylesViewController: (BOStylesViewController *)controller didSelectStyles: (NSArray *) styles
{
    _styles = styles;
    
    [self showStyles];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) BOStylesViewControllerDidCancel: (BOStylesViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) showStyles
{
    NSString *stylesListString = @"";
    for (Styles *style in _styles) {
        NSString *delimiter = [stylesListString isEqualToString:@""] ? @"" : @", ";
        stylesListString = [NSString stringWithFormat:@"%@%@%@", stylesListString, delimiter, style.name];
    }
    
    self.stylesViewCell.textLabel.text = stylesListString;
}


@end
