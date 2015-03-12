//
//  MTTInfoTableView.h
//  Test2
//
//  Created by Martin Hartl on 26/11/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHSimpleTableList : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIColor *cellBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *labelFont UI_APPEARANCE_SELECTOR;

- (void)addRowWithDescriptor:(NSString *)descriptor value:(NSString *)value;

@end
