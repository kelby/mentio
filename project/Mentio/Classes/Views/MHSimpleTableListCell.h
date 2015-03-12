//
//  MTTInfoTableViewCell.h
//  Test2
//
//  Created by Martin Hartl on 26/11/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHSimpleTableListCell : UITableViewCell

@property (nonatomic, strong) UIColor *descriptorLabelTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *valueLabelTextColor UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) CGFloat descriptorLabelFontSize;
@property (assign, nonatomic) CGFloat valueLabelFontSize;

@property (weak, nonatomic) IBOutlet UILabel *descriptorLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
