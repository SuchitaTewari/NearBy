//
//  LRDataHandler.m
//  LocationReminder
//
//  Created by Suchita. on 26/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import "LRDataHandler.h"

@implementation LRDataHandler

+(LRReminders*)createEntity {
    LRReminders *reminder = [NSEntityDescription insertNewObjectForEntityForName:@"LRReminders" inManagedObjectContext:[[LRAppDelegate sharedInstance] managedObjectContext]];
    return reminder;
}

+(NSArray*) getReminders {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LRReminders" inManagedObjectContext:[LRAppDelegate sharedInstance].managedObjectContext];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setReturnsObjectsAsFaults:NO];
    request.returnsDistinctResults = YES;
    NSError *error;
    NSArray *results = [[LRAppDelegate sharedInstance].managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

+(void) deleteObjectFromReminder:(LRReminders*)object
{
    [[LRAppDelegate sharedInstance].managedObjectContext deleteObject:object];
    [[LRAppDelegate sharedInstance].managedObjectContext save:NULL];
    
 
}
@end
