//
//  BookViewCell.h
//  Bibliography
//
//  Created by Admin on 03.01.17.
//  Copyright © 2017 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *stylesLabel;
@property (weak, nonatomic) IBOutlet UILabel *cycleLabel;


@end
