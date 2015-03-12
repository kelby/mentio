//
//  MTTInfoTableViewCell.m
//  Test2
//
//  Created by Martin Hartl on 26/11/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MHSimpleTableListCell.h"

@interface MHSimpleTableListCell ()

@end

@implementation MHSimpleTableListCell

- (void)setDescriptorLabelTextColor:(UIColor *)descriptorLabelTextColor {
    self.descriptorLabel.textColor = descriptorLabelTextColor;
}

- (void)setValueLabelTextColor:(UIColor *)valueLabelTextColor {
    self.valueLabel.textColor = valueLabelTextColor;
}

@end
