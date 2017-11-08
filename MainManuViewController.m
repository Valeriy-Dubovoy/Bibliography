//
//  MainManuViewController.m
//  Bibliography
//
//  Created by Valery Dubovoy on 06.11.17.
//  Copyright © 2017 dvsoft. All rights reserved.
//

#import "MainManuViewController.h"

@interface MainManuViewController ()

@end

@implementation MainManuViewController
{
    MainDataSource* _mainDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _mainDataSource = app.mainDataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)showAuthors:(id)sender
{
    //[_mainDataSource saveChangesWithErrorTitle:@"Saving error" errorMessage:@"Message of error" viewController:self];
    
    //NSLog(@"Alert was shown;");
    
    [self testUsingAlertDialog];
}

- (void) testUsingAlertDialog
{
    UIAlertDialog *alert =[[UIAlertDialog alloc] initWithStyle:UIAlertDialogStyleAlert title:@"Error alert" andMessage:@"Alert message" andCancelButtonTitle:@"Close"];
    
    [alert addButtonWithTitle:@"OK" andHandler:^(NSInteger buttonIndex) {
        [self myReactionOnButtonPressed:@"First button pressed"];
    }];
    [alert addButtonWithTitle: NSLocalizedString(@"Cancel", nil)  andHandler:^(NSInteger buttonIndex) {
        [self myReactionOnButtonPressed:@"Second button pressed"];
    }];
    
    [alert showInViewController:self];
    NSLog(@"Test passed");
    
}

- (void) myReactionOnButtonPressed: (NSString*) buttonMessage
{
    NSLog(@"Event: %@", buttonMessage);
}
@end
