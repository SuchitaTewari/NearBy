//
//  LRDataHandler.h
//  LocationReminder
//
//  Created by Suchita. on 26/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRReminders.h"

@interface LRDataHandler : NSObject

+(LRReminders*)createEntity;
+(NSArray*) getReminders;
+(void) deleteObjectFromReminder:(LRReminders*)object;
@end
