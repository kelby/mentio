//
//  UISearchBar+AlwaysEnableCancelButton.m
//  Mentio
//
//  Created by Martin Hartl on 22/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "UISearchBar+AlwaysEnableCancelButton.h"

@implementation UISearchBar (AlwaysEnableCancelButton)

- (void)enableCancelButton {
    for (UIView *view in self.subviews) {
        for (id subview in view.subviews) {
            if ( [subview isKindOfClass:[UIButton class]] ) {
                [subview setEnabled:YES];
                return;
            }
        }
    }
}

@end
