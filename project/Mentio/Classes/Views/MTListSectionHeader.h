//
//  MTListSectionHeader.h
//  Mentio
//
//  Created by Martin Hartl on 28/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTListSectionHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (id)initWithTitle:(NSString *)title;



@end
