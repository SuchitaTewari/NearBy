//
//  LRListCell.m
//  LocationReminder
//
//  Created by suchita on 4/16/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import "LRlistCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation LRListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib {
    
    UIView* view = [self viewWithTag:1991];
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.cornerRadius = 7.0;
}
-(void)setImageWithUrl:(NSString*)imageurl {

}
@end
