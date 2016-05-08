//
//  LRToDoCellTableViewCell.h
//  LocationReminder
//
//  Created by Nanda Ballabh on 12/04/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRToDoCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rNoteLabel;
@property (weak, nonatomic) IBOutlet UIButton *getDirectionBtn;
@end
