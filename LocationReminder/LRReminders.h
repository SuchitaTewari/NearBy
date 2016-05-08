//
//  LRReminders.h
//  LocationReminder
//
//  Created by Suchita. on 26/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LRReminders : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * reminderName;
@property (nonatomic, retain) NSString * reminderNote;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSString * placeAddress;

@end
