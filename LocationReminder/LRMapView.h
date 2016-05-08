//
//  LRMapView.h
//  LocationReminder
//
//  Created by suchita on 3/24/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface LRMapView : NSObject <MKAnnotation>


@property (copy,nonatomic) NSString *name;
@property (copy,nonatomic) NSString *address;
@property (copy,nonatomic) NSString *iconUrl;
@property (strong,nonatomic) MKMapItem *mapItem;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


- (id)initWithName:(NSString*)name address:(NSString*)address andIcon:(NSString*)iconUrl coordinate:(CLLocationCoordinate2D)coordinate;

@end
