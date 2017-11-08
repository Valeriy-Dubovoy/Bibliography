//
//  MainDataSource.h
//  Archivarius
//
//  Created by Admin on 21.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "UIAlertDialog.h"

typedef void(^CallBackHandler) (void);

@interface MainDataSource : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (MainDataSource *) sharedInstance;
- (void) initWithCompletionBlock:(CallBackHandler)callBackBlock;
- (BOOL) saveChangesWithErrorTitle: (NSString *) errorTitle errorMessage: (NSString *) errorMessage viewController: (UIViewController *) viewController;

- (BOOL) saveChanges: (NSError**) error;

- (void) showAlertWithTitle: (NSString *) title message: (NSString *) message defaultButtonTitle: (NSString *) defaultButtonTitle;

@end
