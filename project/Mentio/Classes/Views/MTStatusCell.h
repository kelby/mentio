//
//  MTStatusCell.h
//  Mentio
//
//  Created by Martin Hartl on 16/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTStatusCell : UITableViewCell

@property BOOL *foundData;

@property (nonatomic, strong) UIColor *textLabeltextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *indicatorColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *contentViewBackgroundColor UI_APPEARANCE_SELECTOR;

- (void)showSearchPromt;
- (void)showNoDataFound;
- (void)showLoading;

- (void)showSearchPromtWithText:(NSString *)text;
- (void)showNoDataFoundWithText:(NSString *)text;

- (void)showIcon:(UIImage *)icon;

@end
