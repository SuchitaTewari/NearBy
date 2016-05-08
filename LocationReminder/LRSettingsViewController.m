//
//  LRSettingsViewController.m
//  LocationReminder
//
//  Created by Suchita. on 19/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import "LRSettingsViewController.h"
#import "LRSettingsSliderCell.h"

enum {
    LRSliderCell = 0,
    LRNotificationToggle
}LRSettingsCell;

#define kNoOfRow 2

static NSString *sliderCellIdentifier = @"sliderCell";


@interface LRSettingsViewController ()

@end

@implementation LRSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"LRSettingsSliderCell" bundle:nil] forCellReuseIdentifier:sliderCellIdentifier];
}
-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ------------------------
#pragma mark Tableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return kNoOfRow;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == LRSliderCell) {
// ravi ravi ravi ravi ravii raviii rafvi ravi jungli jungli jungliii jungliii jungliii 
        return 71.0f;
    } else if (indexPath.row == LRNotificationToggle) {
        return 44.0f;
    }
    return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier  = @"Cell";
    
    
    UITableViewCell *cell = nil;
    LRSettingsSliderCell *sliderCell = nil;

    
    if (indexPath.row == LRSliderCell) {
        
        sliderCell = [tableView dequeueReusableCellWithIdentifier:sliderCellIdentifier];
        
        if (!sliderCell) {
            sliderCell = [[LRSettingsSliderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sliderCellIdentifier];
           
            
        }
        
        return sliderCell;
    } else if (indexPath.row == LRNotificationToggle) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        UISwitch *notificationSwitch;
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            notificationSwitch = [[UISwitch alloc] init];
            [notificationSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            [cell setAccessoryView:notificationSwitch];
        }
        BOOL isNotificationOn = [[NSUserDefaults standardUserDefaults]boolForKey:kNotificationAllowKey];
        [notificationSwitch setOn:isNotificationOn animated:NO];
        cell.textLabel.text = @"Notification";
        cell.detailTextLabel.text = @"Turn ON or OFF your notification";
        return cell;

    }
    
    
    
    
    return cell;
    
}


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



#pragma mark ------------
#pragma Button Actions

- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kNotificationAllowKey];
    } else{
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kNotificationAllowKey];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
