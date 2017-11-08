//
//  BOAuthorDetailViewController.m
//  Bibliography
//
//  Created by Admin on 28.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import "BOAuthorDetailViewController.h"
#import "BOCyclesViewController.h"


@interface BOAuthorDetailViewController ()

@end


@implementation BOAuthorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    if (self.author != nil) {
        self.firstNameTextField.text = [self.author valueForKey:@"name"];
        self.secondNameTextField.text = [self.author valueForKey:@"secondName"];
        self.middleNameTextField.text = [self.author valueForKey:@"middleName"];
        
        //NSLog(@"init author detal with %@", [self.author valueForKey:@"secondName"]);
    } else {
        self.cyclesViewCell.userInteractionEnabled = NO;
        self.cyclesViewCell.textLabel.alpha = 0.3;
        self.navigationItem.title = NSLocalizedString( @"Add an author", nil);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    [self.delegate authorDetailViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
    // validate datas
    if ([self.secondNameTextField.text isEqualToString:@""]) {
        // show message
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Error", nil ) message: NSLocalizedString( @"You should input at least Second name", nil ) delegate:nil cancelButtonTitle: NSLocalizedString( @"OK", nil ) otherButtonTitles: nil];
        [alertView show];
    } else if (self.author == nil) {
        // send message to delegate
        [self.delegate authorDetailViewControllerInsertNewObject:self withFirstName:self.firstNameTextField.text secondName:self.secondNameTextField.text middleName:self.middleNameTextField.text withSaving:YES];
    } else {
        // send message to delegate
        [self.delegate authorDetailViewControllerUpdateCurrentObject:self withFirstName:self.firstNameTextField.text secondName:self.secondNameTextField.text middleName:self.middleNameTextField.text withSaving:YES];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self.secondNameTextField becomeFirstResponder];
    } else if (indexPath.section == 1) {
        [self.firstNameTextField becomeFirstResponder];
    } else if (indexPath.section == 2) {
        [self.middleNameTextField becomeFirstResponder];
    }
}

- (IBAction)secondNamePrimaryAction:(id)sender
{
    // put focus to first name
    [self.firstNameTextField becomeFirstResponder];
}

- (IBAction)firstNamePrimaryAction:(id)sender
{
    // put focus to middle name
    [self.middleNameTextField becomeFirstResponder];
}

- (IBAction)middleNamePrimaryAction:(id)sender
{
    // hide keyboard
    [self.middleNameTextField resignFirstResponder];
    //[self.doneButton becomeFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCycles"]) {
        if (self.author == nil) {
        }
        BOCyclesViewController *cyclesVewController = [segue destinationViewController];
        [cyclesVewController initializeWithManagedObjectContext:self.managedObjectContext Author:self.author PickerMode:NO currentCycle:nil];
        
        //NSLog(@"Show cycles for %@", [self.author valueForKey:@"secondName"]);
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
