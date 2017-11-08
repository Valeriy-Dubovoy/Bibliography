//
//  AVMainDataSource.m
//  Archivarius
//
//  Created by Admin on 21.06.16.
//  Copyright © 2016 dvsoft. All rights reserved.
//

#import "MainDataSource.h"


@interface MainDataSource ()

// блок определения внутренних приватных свойств
//@property (nonatomic, strong) NSPersistentStoreCoordinator * persistentStoreCoordinator;

@end


@implementation MainDataSource

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Initalization

+ (MainDataSource *)sharedInstance;
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t onceToken = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only ones for lifetime of an application
    dispatch_once( &onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // retuns the same object each time
    return _sharedObject;
}

#pragma mark - Methods

-(void)initWithCompletionBlock:(CallBackHandler)callBackBlock
{
   
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
        
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"bibliography.sqlite"];

        
        NSError *error = nil;
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        if (!store) {
            NSString *fullMessage = [NSString stringWithFormat:@"%@:\n%@", NSLocalizedString(@"ERR_INIT_STORAGE", nil),  [error localizedDescription]];
            [self showAlertWithTitle:NSLocalizedString(@"ERR_DBOPEN", nil) message:fullMessage defaultButtonTitle:NSLocalizedString(@"OK", nil)];
            
            NSLog(@"Failed to initalize persistent store: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
            //A more user facing error message may be appropriate here rather than just a console log and an abort
        }
        if (!callBackBlock) {
            //If there is no callback block we can safely return
            return;
        }
        //The callback block is expected to complete the User Interface and therefore should be presented back on the main queue so that the user interface does not need to be concerned with which queue this call is coming from.
        dispatch_sync(dispatch_get_main_queue(), ^{
            callBackBlock();
        });
    });
    return;
}

- (BOOL) saveChanges: (NSError**) error
{
    if (![self.managedObjectContext hasChanges]) {
        return YES;
    };
    
    BOOL returnValue = [self.managedObjectContext save:error];
    
    return returnValue;
}

- (BOOL) saveChangesWithErrorTitle: (NSString *) errorTitle errorMessage: (NSString *) errorMessage viewController: (UIViewController *) viewController
{
    NSError *error = nil;
    BOOL returnValue = [self saveChanges:&error];
    returnValue = NO;
    
    if (!returnValue) {
        
        //dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *fullErrorMessage = [NSString stringWithFormat:@"%@:\n%@", errorMessage, [error localizedDescription]];

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:errorTitle message:fullErrorMessage preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            }];
            
            [alert addAction:defaultAction];
            
            [viewController presentViewController:alert animated:YES completion:nil];
            
        //});
        
    }
    return returnValue;
}

- (void) showAlertWithTitle: (NSString *) title message: (NSString *) message defaultButtonTitle: (NSString *) defaultButtonTitle
{
    //dispatch_sync(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle: defaultButtonTitle otherButtonTitles: nil];
        
        [alertView show];
    //});
}



#pragma mark - Properties

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    [self initWithCompletionBlock:^{
        return;
    }];
    
    return _managedObjectContext;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "ru.iSoftDV.Bibliography" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MainDataModel" withExtension:@"momd"];
    NSAssert(modelURL, NSLocalizedString(@"ERR_MODEL_DESCRIPTION_NOT_FOUND", nil));
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSString *errorMessage = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"ERR_MODEL_INIT", nil), modelURL];
    NSAssert(_managedObjectModel, errorMessage );

    return _managedObjectModel;
}

@end

