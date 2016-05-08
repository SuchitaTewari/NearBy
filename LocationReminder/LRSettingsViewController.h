//
//  LRSettingsViewController.h
//  LocationReminder
//
//  Created by Suchita. on 19/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRSettingsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
