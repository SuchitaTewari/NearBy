//
//  LRInputViewController.h
//  LocationReminder
//
//  Created by Suchita. on 28/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRInputViewController : UIViewController

@property (nonatomic) BOOL isInputTitle;
@property (strong,nonatomic) NSString *reminderTitle;
@property (strong,nonatomic) NSString *reminderNote;

@end
