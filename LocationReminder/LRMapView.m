//
//  LRMapView.m
//  LocationReminder
//
//  Created by suchita on 3/24/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import "LRMapView.h"


@implementation LRMapView

- (id)initWithName:(NSString*)name address:(NSString*)address andIcon:(NSString*)iconUrl coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        _iconUrl = [iconUrl copy];
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    
    CGFloat disTanceMeters = [self getDistance];
    NSString* subTitle;
    if(disTanceMeters > 1000)
        subTitle  = [NSString stringWithFormat:@"%0.1f KM from %@",disTanceMeters/1000,[LRAppDelegate sharedInstance].currentAddress];
    else
        subTitle  = [NSString stringWithFormat:@"%0.0f Meters from %@",disTanceMeters,[LRAppDelegate sharedInstance].currentAddress];

    return subTitle;
}
- (NSString *)iconUrl {
    return _iconUrl;
}
- (CLLocationDistance)getDistance {
    CLLocation *currentLocation = [LRAppDelegate sharedInstance].locationManager.location;
    CLLocation* location = [[CLLocation alloc]initWithLatitude:_coordinate.latitude longitude:_coordinate.longitude];
    CLLocationDistance distance = [currentLocation distanceFromLocation:location];

    return distance;
}



- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}
@end
