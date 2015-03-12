//
//  UIFont+ABeeZeeContentSize.m
//  Noteness
//
//  Created by Martin Hartl on 10/01/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "UIFont+CustomFontsContentSizes.h"

@implementation UIFont (CustomFontsContentSizes)

+ (UIFont *)preferredABeeZeeFontForTextStyle:(NSString *)textStyle {
	// choose the font size
	CGFloat fontSize = 16.0;
	NSString *contentSize = [UIApplication sharedApplication].preferredContentSizeCategory;
    
	if ([contentSize isEqualToString:UIContentSizeCategoryExtraSmall]) {
		fontSize = 12.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategorySmall]) {
		fontSize = 13.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryMedium]) {
		fontSize = 14.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryLarge]) {
		fontSize = 15.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraLarge]) {
		fontSize = 20.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
		fontSize = 22.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
		fontSize = 24.0;
	}
    
    return [UIFont fontWithName:@"ABeeZee-Regular" size:fontSize];
}


+ (UIFont *)preferredAvenirFontForTextStyle:(NSString *)textStyle {
	// choose the font size
	CGFloat fontSize = 16.0;
	NSString *contentSize = [UIApplication sharedApplication].preferredContentSizeCategory;
    
	if ([contentSize isEqualToString:UIContentSizeCategoryExtraSmall]) {
		fontSize = 10.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategorySmall]) {
		fontSize = 14.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryMedium]) {
		fontSize = 15.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryLarge]) {
		fontSize = 16.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraLarge]) {
		fontSize = 17.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
		fontSize = 19.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
		fontSize = 21.0;
	}
    
    
    return [UIFont fontWithName:@"Avenir Next" size:fontSize];

}

+ (UIFont *)avenirFontWithSize:(NSInteger)fontSize {
    return [UIFont fontWithName:@"Avenir Next" size:fontSize];
}

@end
