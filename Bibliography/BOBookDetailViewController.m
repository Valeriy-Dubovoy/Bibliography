//
//  BOBookDetailViewController.m
//  Bibliography
//
//  Created by Admin on 08.07.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import "BOBookDetailViewController.h"
#import "BOCyclesViewController.h"

@interface BOBookDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *bookNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *cycleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stylesListLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet RateView *ratingVew;
@property (weak, nonatomic) IBOutlet UITextField *cycleOrder;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
- (IBAction)orderStepperAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIStepper *orderStepper;
@property (weak, nonatomic) IBOutlet UITableViewCell *stylesViewCell;

@end


@implementation BOBookDetailViewController
{
    Authors *_author;
    Books *_book;
    NSManagedObjectContext *_managedObjecContext;
    MainDataSource *_dataSource;
    
    Cycles *_cycle;
    NSArray *_styles;
    Remarks *_remark;
    NSNumber *_rating;
    NSNumber *_orderInCycle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.ratingVew.notSelectedImage = [UIImage imageNamed:@"EmptyStar"];
    self.ratingVew.halfSelectedImage = [UIImage imageNamed:@"HalfStar"];
    self.ratingVew.fullSelectedImage = [UIImage imageNamed:@"1Star"];
    self.ratingVew.editable = YES;
    self.ratingVew.maxRating = 5;
    self.ratingVew.delegate = (id) self;
    self.ratingVew.rating = 0;
    
    _orderInCycle = [NSNumber numberWithInteger:0];
    _rating = [NSNumber numberWithInteger:0];
    _styles = [[NSMutableArray alloc] init];
    
    if (_author != nil) {
        self.authorNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@", _author.secondName, _author.name, _author.middleName];
    }
    if (_book != nil) {
        _cycle = _book.cycle;
        _styles = [(NSSet *) _book.styles allObjects];
        _remark = _book.remark;
        _rating = _book.rating;
        _orderInCycle = _book.cycleOrder;
        
        self.ratingVew.rating = [_rating floatValue];
        
        self.bookNameTextField.text = _book.name;
    }
    [self showCycleName];
    [self showOrderInCycle];
    [self showRemarkName];
    [self showStyles];
    
    self.orderStepper.value = [_orderInCycle doubleValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initWithDataSource: (MainDataSource *)mainDataSource Author: (Authors *) author Book: (Books *) book;
{
    _author = author;
    _dataSource = mainDataSource;
    _managedObjecContext = _dataSource.managedObjectContext;
    _book = book;
}

- (IBAction) done:(id)sender
{
    if (_book == nil) {
        [self.delegate bookDetailViewController:self insertNewObjectWithName:self.bookNameTextField.text rating:_rating cycle:_cycle cycleOrder:_orderInCycle author:_author styles:[NSSet setWithArray:_styles] remark:_remark];
    } else {
        [self.delegate bookDetailViewController:self updateObject:_book withName:self.bookNameTextField.text rating:_rating cycle:_cycle cycleOrder:_orderInCycle author:_author styles:[NSSet setWithArray:_styles] remark:_remark];
    }
    //[self.delegate bookDetailViewControllerDidCancel:self];
}

- (IBAction) cancel:(id)sender
{
    [self.delegate bookDetailViewControllerDidCancel:self];
}

- (void) showCycleName
{
    if (_cycle == nil) {
        self.cycleNameLabel.text = NSLocalizedString( @"<Out of a cycle>", nil );
    } else {
        self.cycleNameLabel.text = _cycle.name;
    }
}

- (void) showRemarkName
{
    if (_remark == nil) {
        self.remarkLabel.text = @"-";
    } else {
        self.remarkLabel.text = _remark.name;
    }
}

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating;
{
    _rating = [NSNumber numberWithFloat:rating];
}

- (void) showOrderInCycle
{
    self.orderLabel.text = [NSString stringWithFormat:@"%@", _orderInCycle];
}

- (IBAction)orderStepperAction:(id)sender;
{
    _orderInCycle = [NSNumber numberWithDouble:self.orderStepper.value];
    [self showOrderInCycle];
}
- (IBAction)orderStepperValueChanged:(id)sender {
    _orderInCycle = [NSNumber numberWithDouble:self.orderStepper.value];
    [self showOrderInCycle];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)namePrimeryActionTriggered:(id)sender {
    // hide keyboard
    [self.bookNameTextField resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pickCycle"]){
        BOCyclesViewController *destinationController = [segue destinationViewController];
        
        [destinationController initializeWithManagedObjectContext:_managedObjecContext Author:_author PickerMode:YES currentCycle:_cycle];
        destinationController.delegete = self;
    } else if ([segue.identifier isEqualToString:@"pickRemark"]){
        BORemarksListViewController *destinationController = [segue destinationViewController];
        
        [destinationController initializeWithManagedObjectContext:_managedObjecContext PickerMode:YES currentRemark:_remark];
        destinationController.delegete = self;
    } else if ([segue.identifier isEqualToString:@"pickStyles"]){
        BOStylesViewController *destinationController = [segue destinationViewController];
        
        [destinationController initializeWithManagedObjectContext:_managedObjecContext PickerMode:YES currentStyles:_styles];
         //initializeWithManagedObjectContext:_managedObjecContext PickerMode:YES currentRemark:_remark];
        destinationController.delegete = self;
    }
}

#pragma mark - delegate events

- (void) BOCyclesViewController: (BOCyclesViewController *)controller didSelectCycle: (Cycles *) cycle
{
    _cycle = cycle;
    if (_cycle != nil){
        _styles = [(NSSet *) _cycle.styles allObjects];
    };
    [self showStyles];
    [self showCycleName];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) BORemarksListViewController:(BORemarksListViewController *)controller didSelectRemark:(Remarks *)remark
{
    _remark = remark;
    [self showRemarkName];
    
    [self.navigationController popViewControllerAnimated:YES];
}

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

@end
