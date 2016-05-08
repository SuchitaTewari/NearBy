//
//  LRBaseViewController.m
//  LocationReminder
//
//  Created by Suchita on 19/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import "LRBaseViewController.h"
#import "LRToDoListViewController.h"
#import "LRSettingsViewController.h"

@interface LRBaseViewController ()


@property (strong,nonatomic) LRToDoListViewController *toDoListViewController;
@property (strong,nonatomic) LRSettingsViewController *settingsViewController;


@property (strong,nonatomic) UIBarButtonItem *categoryBarButton;



@end

@implementation LRBaseViewController

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
    
    //TabBar -----------------------------------------
    
    //Set Default selected tab Index
    [self showTabWithSelectedItem:0];
    
    // Highlight the first barButton item in the tabBar.
    [self.mainTabBar setSelectedItem:[self.mainTabBar.items objectAtIndex:0]];
    
    // CustomBackButton --------------------------------
    // Hide the category navigation bar button to other view controller.
    self.categoryBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Category" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem setBackBarButtonItem:self.categoryBarButton];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -----------
#pragma TabBarDelegate 

- (void)tabBar:(UITabBar*)tabBar didSelectItem:(UITabBarItem*)item {
    NSInteger selectedIndex = item.tag;
    
    [self showTabWithSelectedItem:selectedIndex];
    
}


- (void)showTabWithSelectedItem:(NSInteger )index {
    
    if (self.currentViewController) {
        [self.currentViewController removeFromParentViewController];
        [self.currentViewController.view removeFromSuperview];
    }
    
    switch (index) {
        case 0: {
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kLastSelectedCategory];
            if(dict) {
                NSString *titleName = [dict objectForKey:@"LastSelectedCategory"];
                self.title = titleName.capitalizedString;//[[dict objectForKey:@"LastSelectedCategory"] stringValue].capitalizedString;
            }
            else
                self.title = @"Map View";
            [self.navigationItem setHidesBackButton:NO];
            self.currentViewController = self.mapViewController;
            break;
        }
        case 1:
            self.title = @"Reminders";
            [self.navigationItem setHidesBackButton:YES];
            self.currentViewController = self.toDoListViewController;
            break;
        case 2:
            self.title = @"Settings";
            [self.navigationItem setHidesBackButton:YES];
            self.currentViewController = self.settingsViewController;
            break;
            
        default:
            break;
    }
    
    
    self.currentViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.currentViewController.view];
    [self addChildViewController:self.currentViewController];
}

#pragma mark -
#pragma mark UIViewController 

- (LRMapViewController *)mapViewController {
    if (!_mapViewController) {
        _mapViewController = [LRMapViewController new];
    }
    return _mapViewController;
}

- (LRToDoListViewController *)toDoListViewController {
    if (!_toDoListViewController) {
        _toDoListViewController = [LRToDoListViewController new];
    }
    return _toDoListViewController;
}


- (LRSettingsViewController *)settingsViewController {
    if (!_settingsViewController) {
        _settingsViewController = [LRSettingsViewController new];
    }
    return _settingsViewController;
}


@end
