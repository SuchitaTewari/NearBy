//
//  LRToDoListViewController.m
//  LocationReminder
//
//  Created by Suchita. on 19/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import "LRToDoListViewController.h"
#import "LRReminderViewController.h"
#import "LRToDoCellTableViewCell.h"

@interface LRToDoListViewController ()
@property (strong,nonatomic) IBOutlet UITableView* tableView;
@property (strong,nonatomic) NSMutableArray *remindersList;

@end

@implementation LRToDoListViewController
static NSString *cellIdentifier  = @"TodoCellIdentifier";

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
    [self.tableView registerNib:[UINib nibWithNibName:@"LRToDoCellTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.remindersList = [[NSMutableArray alloc]initWithArray:[LRDataHandler getReminders]];
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
    
    return self.remindersList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LRToDoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(self.remindersList.count) {
        LRReminders *reminder = (LRReminders*)[self.remindersList objectAtIndex:indexPath.row];
        cell.rTitleLabel.text = reminder.reminderName.capitalizedString;
        cell.rNoteLabel.text = reminder.reminderNote.capitalizedString;
        cell.placeLabel.text = reminder.placeName.capitalizedString;
        [cell.getDirectionBtn addTarget:self action:@selector(getDirections:) forControlEvents:UIControlEventTouchUpInside];
    }
    // TODO need to decide the cell structure
    return cell;
    
}
-(IBAction)getDirections:(id)sender {
    UIButton *button = (UIButton *)sender;
    CGRect buttonFrame = [button convertRect:button.bounds toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrame.origin];
    NSLog(@"selected row %ld",(long)indexPath.row);
    LRReminders *reminder = (LRReminders*)[self.remindersList objectAtIndex:indexPath.row];
    CLLocation* location = [LRAppDelegate sharedInstance].locationManager.location;

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        
        NSString* url = [NSString stringWithFormat: @"comgooglemaps://?saddr=%f,%f&daddr=%f,%f",location.coordinate.latitude,location.coordinate.longitude,reminder.latitude.floatValue, reminder.longitude.floatValue];

        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:url]];
    } else {
        NSLog(@"Can't use comgooglemaps://");
        NSString* url = [NSString stringWithFormat: @"https://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",location.coordinate.latitude,location.coordinate.longitude,reminder.latitude.floatValue, reminder.longitude.floatValue];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];

    }
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LRReminderViewController *reminderView = [LRReminderViewController new];
    LRReminders *reminder = (LRReminders*)[self.remindersList objectAtIndex:indexPath.row];
    reminderView.currentReminder = reminder;
    reminderView.reminderNote = reminder.reminderNote;
    reminderView.reminderTitle = reminder.reminderName;
    reminderView.mapItem = [self mapItem:reminder.placeAddress andLatitude:reminder.latitude.floatValue andLogitude:reminder.longitude.floatValue andName:reminder.placeName];
    reminderView.isEditReminder = YES;
    [self.navigationController pushViewController:reminderView animated:YES];

}
- (MKMapItem*)mapItem :(NSString*)address andLatitude:(CGFloat)latitude andLogitude:(CGFloat)logitude andName:(NSString*)name {
    
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : address};
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(latitude, logitude);
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:coordinates
                              addressDictionary:addressDict];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = name;
    return mapItem;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        LRReminders *reminder = (LRReminders*)[self.remindersList objectAtIndex:indexPath.row];
        [self.remindersList removeObject:reminder];
        // remove  core data
        [LRDataHandler deleteObjectFromReminder:reminder];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end
