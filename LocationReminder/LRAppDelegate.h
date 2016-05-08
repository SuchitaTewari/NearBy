//
//  LRAppDelegate.h
//  LocationReminder
//
//  Created by Suchita on 19/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRCategoryViewController.h"
#import "LRBaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LRAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (strong,nonatomic) UINavigationController *navigationController;
@property (strong,nonatomic) LRCategoryViewController *categoryViewController;
@property (strong,nonatomic) LRBaseViewController *baseViewController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geoCoder;
@property (strong, nonatomic) NSString *currentAddress;
@property (nonatomic) BOOL isGeoCoderStart;
@property (nonatomic) BOOL googleAPINeedToRefresh;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(NSDictionary*)getCategoriesFromPlist ;


+ (LRAppDelegate *)sharedInstance;




@end
