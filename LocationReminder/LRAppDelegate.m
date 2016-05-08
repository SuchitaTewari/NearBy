//
//  LRAppDelegate.m
//  LocationReminder
//
//  Created by Suchita on 19/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import "LRAppDelegate.h"
#import "LRCategoryViewController.h"
#import "LRBaseViewController.h"




@implementation LRAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    //Instantiate a location object.
    [self initLocationManger];

    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls) {
        UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (notification) {
            // show the alert view;
            [self showLocationNotification:notification.userInfo];
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber == 0 ? 0 : application.applicationIconBadgeNumber - 1;
        }
    }
    
    // Create a categoryListViewController and add it as rootViewController for NavigationController.
    self.categoryViewController = [LRCategoryViewController new];
    // BaseViewController
    self.baseViewController = [LRBaseViewController new];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.categoryViewController];
    // Set title to the categoryViewController so It will display the back button name as a category.
    self.categoryViewController.title = @"Category";
    
    // Push the baseViewController
    [self.navigationController pushViewController:self.baseViewController animated:NO];
    

    [self.window setRootViewController:self.navigationController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    // Use startMonitoringSignificantLocationChanges to save baterry power
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop normal location updates and start significant location change updates for battery efficiency.
		[self.locationManager stopUpdatingLocation];
		[self.locationManager startMonitoringSignificantLocationChanges];
	}
	else {
		NSLog(@"Significant location change monitoring is not available.");
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
	if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop significant location updates and start normal location updates again since the app is in the forefront.
		[self.locationManager stopMonitoringSignificantLocationChanges];
		[self.locationManager startUpdatingLocation];
	}
	else {
		NSLog(@"Significant location change monitoring is not available.");
	}

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if(notification) {
        // show the alert view;
        application.applicationIconBadgeNumber = application.applicationIconBadgeNumber == 0 ? 0 : application.applicationIconBadgeNumber - 1;
        [self showLocationNotification:notification.userInfo];
    }
}

-(void)showLocationNotification:(NSDictionary*)userInfos
{
   NSString* title = @"";
    NSString* message = @"";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LocationReminder" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LocationReminder.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

-(void) initLocationManger {
    
    if(self.locationManager == nil)
        self.locationManager = [[CLLocationManager alloc] init];
    self.geoCoder = [[CLGeocoder alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - CLLocationManager Delegate Method

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* loc = [locations lastObject]; // locations is guaranteed to have at least one object
    [self startReverseGeocodingWithCurrentLocation:loc];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSString *event = [NSString stringWithFormat:@"You are here %@", region.identifier];
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = [NSDate date];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = event;
    localNotif.alertAction = @"OK";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber += 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString* title = @"Sorry!";
    NSString* message = nil;
	if ([error domain]==kCLErrorDomain) {
		switch ([error code]) {
			case kCLErrorDenied:
				// This error code is usually returned whenever user taps "Don't Allow" in response to
				// being told your app wants to access the current location. Once this happens, you cannot
				// attempt to get the location again until the app has quit and relaunched.
				// "Don't Allow" on two successive app launches is the same as saying "never allow". The user
				// can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
                message = @"Permission not granted.";
				break;
			case kCLErrorLocationUnknown:
				// This error code is usually returned whenever the device has no data or WiFi connectivity,
				// or when the location cannot be determined for some other reason.
				// CoreLocation will keep trying, so you can keep waiting, or prompt the user.
				message = @"Your location could not be determined";
				break;
			default:
				// We shouldn't ever get an unknown error code, but just in case...
				message = @"There was a problem finding your location.";
				break;
		}
	} else {
		// We handle all non-CoreLocation errors here (we depend on localizedDescription for localization)
		message = @"There was a problem finding your location";
	}
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}
+ (LRAppDelegate *)sharedInstance {
    
    return (LRAppDelegate *)[UIApplication sharedApplication].delegate;
}

// Get users current address
-(NSDictionary*)getCategoriesFromPlist {
    // Access the plist and fill category list
    // plist will return dictionary
    // Set category list useing fiuction dictionary.allkeys
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Categories" ofType:@"plist"]];
}

-(void)startReverseGeocodingWithCurrentLocation:(CLLocation*)currentLocation {
    
    [self.geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
          MKPlacemark*  placemark = [placemarks lastObject];
            self.currentAddress = placemark.thoroughfare;
            LRMapViewController *mapViewController;
            if([self.baseViewController.currentViewController isKindOfClass:[LRMapViewController class]]) {
                mapViewController = (LRMapViewController*)self.baseViewController.currentViewController;
                [mapViewController setMapCurrentLocationAddress:placemark.thoroughfare];
                if (![[NSUserDefaults standardUserDefaults] objectForKey:kLastSelectedCategory]) {
                    [mapViewController getPlaceDataFromGoogleAPI];
                }
            }
        } else {
            self.currentAddress = @"Current Location";
        }
    }];
}

@end
