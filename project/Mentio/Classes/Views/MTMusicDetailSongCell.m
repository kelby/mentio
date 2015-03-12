//
//  MTMusicDetailSongCell.m
//  Mentio
//
//  Created by Martin Hartl on 17/11/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTMusicDetailSongCell.h"

@implementation MTMusicDetailSongCell


#pragma mark - UIAppearance

- (void)setTextLabelTextColor:(UIColor *)textLabelTextColor {
    self.textLabel.textColor = textLabelTextColor;
}

- (void)setContentViewBackGround:(UIColor *)contentViewBackGround {
    self.contentView.backgroundColor = contentViewBackGround;
}

@end
