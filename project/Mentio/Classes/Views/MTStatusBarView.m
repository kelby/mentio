//
//  MTStatusBarView.m
//  Mentio
//
//  Created by Martin Hartl on 14/11/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTStatusBarView.h"
#import "MTStatusBarConstants.h"

@interface MTStatusBarView () <MTThemeProtocol>

@end

@implementation MTStatusBarView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme:) name:MTThemeChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show) name:MTShowStatusBarView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:MTHideStatusBarView object:nil];
}

- (void)show {
    self.hidden = NO;
}

- (void)hide {
    self.hidden = YES;
}

- (void)applyTheme:(NSNotification *)notification {
    [[MTThemer sharedInstance] themeMTStatusBarView:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
