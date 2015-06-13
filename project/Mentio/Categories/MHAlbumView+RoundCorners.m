//
//  MHAlbumView+RoundCorners.m
//  Mentio
//
//  Created by Martin Hartl on 14/02/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MHAlbumView+RoundCorners.h"

@implementation MHAlbumView (RoundCorners)

// 对图片进行圆角矩形的处理 - 本项目中，仅针对 app
- (void)applyRoundCorners:(BOOL)value {
    if (value) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
        CGFloat cornerRadius = ((self.frame.size.height / 100) * 22.5f);
        [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius] addClip];
        [self.image drawInRect:self.bounds];
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

@end
