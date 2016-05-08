//
//  LRBaseViewController.h
//  LocationReminder
//
//  Created by Suchita on 19/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRConstant.h"
#import "LRMapViewController.h"

@interface LRBaseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITabBar *mainTabBar;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong,nonatomic) LRMapViewController *mapViewController;
@property (strong,nonatomic) UIViewController *currentViewController;

@end
