//
//  LRCategoryCell.m
//  LocationReminder
//
//  Created by suchita on 3/27/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import "LRCategoryCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation LRCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
