//
//  LRSettingsSliderCell.m
//  LocationReminder
//
//  Created by Suchita. on 23/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import "LRSettingsSliderCell.h"

@implementation LRSettingsSliderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat selectedRadius = [[defaults objectForKey:@"Radius"] floatValue];
    if(selectedRadius == 0.0)
        selectedRadius = 1.0;
    self.radiusMeasureLabel.text = [NSString stringWithFormat:@"%2.0f KM",selectedRadius];
    [self.slider setMinimumValue:1.0f];
    [self.slider setMaximumValue:50.0f];
    [self.slider setValue:selectedRadius];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (IBAction)sliderValueChanged:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    NSInteger val = lround(slider.value);
    NSString*selectedVale = [NSString stringWithFormat:@"%.2f",roundf(val * 2.0) * 0.5];
    self.radiusMeasureLabel.text = [NSString stringWithFormat:@"%@ KM",selectedVale];
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedVale forKey:@"Radius"];
    [defaults synchronize];
    [LRAppDelegate sharedInstance].googleAPINeedToRefresh = YES;

}

@end
