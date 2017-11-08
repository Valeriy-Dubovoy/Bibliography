//
//  AppDelegate.h
//  Bibliography
//
//  Created by Admin on 27.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainDataSource.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainDataSource * mainDataSource;

- (void)saveContext;

@end

