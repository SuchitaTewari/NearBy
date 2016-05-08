//
//  LRSettingsSliderCell.h
//  LocationReminder
//
//  Created by Suchita. on 23/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRSettingsSliderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *radiusMeasureLabel;

@end
