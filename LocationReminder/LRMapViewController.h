//
//  LRMapViewController.h
//  LocationReminder
//
//  Created by Suchita. on 19/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LRBaseViewController.h"
#import "LRMapView.h"



@interface LRMapViewController : UIViewController <MKMapViewDelegate>
{
    
    CLLocationCoordinate2D currentCentre;
    int currenDist;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKMapItem *destination;
@property (nonatomic) BOOL firstLaunch;
@property (strong, nonatomic) NSArray *mapData;

- (void)setMapCurrentLocationAddress:(NSString*)address;
- (void)getPlaceDataFromGoogleAPI;

@end
