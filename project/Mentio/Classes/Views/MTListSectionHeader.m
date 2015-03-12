//
//  MTListSectionHeader.m
//  Mentio
//
//  Created by Martin Hartl on 28/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTListSectionHeader.h"

@implementation MTListSectionHeader

- (id)initWithTitle:(NSString *)title {
    self = [super initWithFrame:CGRectMake(0,0, 320, 22)];
    if (self) {
        [self setup];
        self.textLabel.text = title;
        self.textLabel.textColor = self.tintColor;
    }
    
    return self;
}

- (void)setup {
    [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"MTListSectionHeader" owner:self options:nil] objectAtIndex:0]];
    self.textLabel.opaque = YES;
    self.textLabel.font = [UIFont avenirFontWithSize:14];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.textLabel.textColor = self.tintColor;
}

#pragma mark - UIAppearance

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
    self.textLabel.backgroundColor = backgroundColor;
}

@end
