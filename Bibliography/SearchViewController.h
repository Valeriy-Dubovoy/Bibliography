//
//  SearchViewController.h
//  Bibliography
//
//  Created by Admin on 04.01.17.
//  Copyright © 2017 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
- (IBAction)namePrimaryAction:(id)sender;

@end
