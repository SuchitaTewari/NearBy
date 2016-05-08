//
//  LRReminderViewController.h
//  LocationReminder
//
//  Created by Suchita. on 26/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LRReminders.h"

@interface LRReminderViewController : UIViewController

@property (strong,nonatomic) MKMapItem *mapItem;
@property (strong,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSString *reminderTitle;
@property (strong,nonatomic) NSString *reminderNote;
@property (strong,nonatomic) LRReminders *currentReminder;
@property (nonatomic) BOOL isEditReminder;

@end
