//
//  UIFont+ABeeZeeContentSize.h
//  Noteness
//
//  Created by Martin Hartl on 10/01/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (CustomFontsContentSizes)

+ (UIFont *)preferredABeeZeeFontForTextStyle:(NSString *)textStyle;
+ (UIFont *)preferredAvenirFontForTextStyle:(NSString *)textStyle;

+ (UIFont *)avenirFontWithSize:(NSInteger)fontSize;

@end
