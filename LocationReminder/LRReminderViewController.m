//
//  LRReminderViewController.m
//  LocationReminder
//
//  Created by Suchita. on 26/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import "LRReminderViewController.h"
#import "LRDataHandler.h"
#import <QuartzCore/QuartzCore.h>
#import "LRInputViewController.h"

@interface LRReminderViewController ()

@end

@implementation LRReminderViewController

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
    self.title = @"Add Reminder";
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.tableView reloadData];
}

#pragma tableView delegate method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {
        return self.reminderNote.length ? [self heightForReminderNote] : 50.0f;
    } else if(indexPath.section == 3)
        return 55.0f;
    else
        return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *identifier = @"cellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if(indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"Add Tittle";
        cell.detailTextLabel.text = self.reminderTitle.length ? self.reminderTitle : @"Add title";
        
    } else if(indexPath.section == 1) {

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"Reminder Note";
        cell.detailTextLabel.text = self.reminderNote.length ? self.reminderNote : @"Add reminder note";
        
        cell.detailTextLabel.numberOfLines = 2;
    }else if(indexPath.section == 2) {
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.textLabel.text = @"Place Name";
        cell.detailTextLabel.text = self.mapItem.placemark.name;

    } else if (indexPath.section == 3) {

        cell.textLabel.text = @"Place Address";
        cell.detailTextLabel.text = self.mapItem.placemark.thoroughfare;
        cell.detailTextLabel.numberOfLines = 2;
    } else if(indexPath.section == 4) {

        // TODO need to see we need this toggle or not
        cell.textLabel.text = @"Distance";
        CLLocation *currentLocation = [LRAppDelegate sharedInstance].locationManager.location;
        CLLocationDistance distance = [currentLocation distanceFromLocation:self.mapItem.placemark.location];
        cell.detailTextLabel.text = distance > 0.0 ? [NSString stringWithFormat:@"%0.3f KM",distance/1000] : @"Not available.";
//        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.556863f green:0.556863 blue:0.576471 alpha:1.0f];
//        UISwitch *notificationSwitch = [[UISwitch alloc] init];
//        [notificationSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
//        [cell setAccessoryView:notificationSwitch];

    } else if(indexPath.section == 5) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 320.0f, 50.0f);
        [button setTitle:@"Add Reminders" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addReminderTapped:)
         forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:button];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.556863f green:0.556863 blue:0.576471 alpha:1.0f];

    return cell;
}

-(CGFloat)getDistanceBetWeenCurrentLocationAndLocation:(CLLocation*)location {
    CLLocation *currentLocation = [LRAppDelegate sharedInstance].locationManager.location;
    CLLocationDistance distance = [currentLocation distanceFromLocation:self.mapItem.placemark.location];
    return distance;
  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LRInputViewController *inputView = [LRInputViewController new];
    if(indexPath.section == 0) {
        inputView.isInputTitle = YES;
        inputView.title = @"Reminder Title";
        inputView.reminderTitle = self.reminderTitle;
        [self.navigationController pushViewController:inputView animated:YES];
    }
    else if(indexPath.section == 1) {
        inputView.isInputTitle = NO;
        inputView.title = @"Reminder Note";
        inputView.reminderNote = self.reminderNote;
        [self.navigationController pushViewController:inputView animated:YES];
    }
}


#pragma mark ------------
#pragma Button Actions

- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        
    } else{
        
    }
}


- (IBAction)addReminderTapped:(UIButton*)sender {
    if([self validReminder] ) {
        LRReminders *reminder;
        if(!self.isEditReminder)
            reminder = [LRDataHandler createEntity];
        else
            reminder = self.currentReminder;
 
        reminder.placeName = self.mapItem.placemark.name;
        reminder.placeAddress  = self.mapItem.placemark.thoroughfare;
        reminder.reminderName = self.reminderTitle;
        reminder.reminderNote = self.reminderNote;
        reminder.latitude = [NSNumber numberWithDouble:self.mapItem.placemark.location.coordinate.latitude];
        reminder.longitude = [NSNumber numberWithDouble:self.mapItem.placemark.location.coordinate.longitude];
        NSError* error = nil;
        [[LRAppDelegate sharedInstance].managedObjectContext save:&error];
        if(!error)
            NSLog(@"Reminder Saved: \n%@",reminder);
        // TODO Set location based local notification if notify toggle is on
        BOOL isNotificationAllowed = [[NSUserDefaults standardUserDefaults]boolForKey:kNotificationAllowKey];
        if(isNotificationAllowed) {
            // set up the location magaer monitor this resion
            [self addRegionToMonotor:self.mapItem.placemark.location.coordinate.latitude andLongitude:self.mapItem.placemark.location.coordinate.longitude];
            [self.navigationController popViewControllerAnimated:YES];

        } else {
            // show alert showing that you have disabled the notification permission
            // and you will not notified ,do you want to allow or cancel
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"You have choose not to notified in app settings" message:@"You will not get notified when you reach here.\nDo you want to allow.?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Get Notified", nil];
            [alertView show];
        }
    }
}

/*
 This method creates a new region based on the center coordinate of the map view.
 A new annotation is created to represent the region and then the application starts monitoring the new region.
 */
- (void)addRegionToMonotor:(CGFloat)latitude andLongitude:(CGFloat)longitude {
	if ([CLLocationManager isMonitoringAvailableForClass:[CLRegion class]]) {
		// Create a new region based on the center of the map view.
		CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude,longitude);
		CLCircularRegion *newRegion = [[CLCircularRegion alloc] initWithCenter:coord radius:100.0 identifier:[NSString stringWithFormat:@"%f, %f", latitude,longitude]];
		// Start monitoring the newly created region.
		[[LRAppDelegate sharedInstance].locationManager startMonitoringForRegion:newRegion];
	}
	else {
		NSLog(@"Region monitoring is not available.");
	}
}


#pragma UIAlertView Delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        // Just dissmiss
    } else if (buttonIndex == 1) {
        // change the notification allow value to yes
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNotificationAllowKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        if([[NSUserDefaults standardUserDefaults]boolForKey:kNotificationAllowKey])
        {
            [self addRegionToMonotor:self.mapItem.placemark.location.coordinate.latitude andLongitude:self.mapItem.placemark.location.coordinate.longitude];
            [self.navigationController popViewControllerAnimated:YES];

        }

    }
}


-(BOOL)validReminder {
    
    BOOL isValid = NO;
    NSString *reminderTitle = [self.reminderTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(self.mapItem && (reminderTitle.length > 0))
        isValid = YES;
    else
        isValid = NO;
    
    return isValid;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)heightForReminderNote {
    CGRect rect = [self.reminderNote boundingRectWithSize:CGSizeMake(320, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:14.0f]} context:NULL];
    CGFloat height = rect.size.height + 30.0f;
    height = height < 50.0f ? 50.0f : height;
    NSLog(@"%f",height);
    return height;;
}

@end
