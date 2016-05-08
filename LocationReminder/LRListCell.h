//
//  LRListCell.h
//  LocationReminder
//
//  Created by suchita on 4/16/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *placeName;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *distance;
-(void)setImageWithUrl:(NSString*)imageurl;
@end
