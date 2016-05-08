//
//  LRListViewController.m
//  LocationReminder
//
//  Created by suchita on 4/16/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import "LRListViewController.h"

@interface LRListViewController ()
@property (strong,nonatomic) IBOutlet UITableView *listTable;

@end

@implementation LRListViewController
static NSString* cellIdentifier = @"ListCellIdentifier";
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
    [self.listTable registerNib:[UINib nibWithNibName:NSStringFromClass([LRListCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma mark datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mapResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LRListCell *cell = (LRListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary* placeData = [self.mapResults objectAtIndex:indexPath.row];
    NSString *name =[placeData objectForKey:@"name"];
    NSString *vicinity = [placeData objectForKey:@"vicinity"];
    cell.placeName.text = name;
    cell.address.text = vicinity;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [LRAppDelegate sharedInstance].googleAPINeedToRefresh = YES;
    [LRAppDelegate sharedInstance].baseViewController.mapViewController.mapData = self.mapResults;
    [LRAppDelegate sharedInstance].baseViewController.title = self.title;
    NSString * categoryType = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastSelectedCategory] objectForKey:@"LastSelectedCategory"];
    [LRAppDelegate sharedInstance].baseViewController.mapViewController.title = categoryType;
    [self.navigationController pushViewController:[LRAppDelegate sharedInstance].baseViewController animated:YES];
   
    

}



@end
