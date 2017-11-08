//
//  BoookOfAuthorViewCell.h
//  Bibliography
//
//  Created by Admin on 07.08.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookOfAuthorViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *stylesLabel;

@end
