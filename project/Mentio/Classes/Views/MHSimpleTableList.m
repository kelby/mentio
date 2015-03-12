//
//  MTTInfoTableView.m
//  Test2
//
//  Created by Martin Hartl on 26/11/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MHSimpleTableList.h"
#import "MHSimpleTableListCell.h"


static NSString *const cellIdentifier = @"cell";

@interface MHSimpleTableList ()

@property (nonatomic, strong) NSMutableArray *descriptorArray;
@property (nonatomic, strong) NSMutableArray *valueArray;

@end

@implementation MHSimpleTableList


- (instancetype)init {
    self = [super init];
    if (self) {
        _descriptorArray = [NSMutableArray array];
        _valueArray = [NSMutableArray array];
        [self setup];
    }
    return self;
}

- (void)setup {
    self.delegate = self;
    self.dataSource = self;
    
    [self registerNib:[UINib nibWithNibName:@"MHSimpleTableListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.rowHeight = UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)addRowWithDescriptor:(NSString *)descriptor value:(NSString *)value {
    if (!descriptor || !value) {
        return;
    }
    
    [self.descriptorArray addObject:descriptor];
    [self.valueArray addObject:value];
    
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.descriptorArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self configureCell:(MHSimpleTableListCell *)cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(MHSimpleTableListCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.descriptorLabel.font = self.labelFont;
    cell.valueLabel.font = self.labelFont;
    cell.descriptorLabel.text = self.descriptorArray[indexPath.row];
    cell.valueLabel.text = self.valueArray[indexPath.row];
    cell.backgroundColor = self.cellBackgroundColor;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 20.0f;
}

 #pragma mark - UIAppearance

- (void)setLabelFont:(UIFont *)labelFont {
    _labelFont = labelFont;
    [self reloadData];
}

@end
