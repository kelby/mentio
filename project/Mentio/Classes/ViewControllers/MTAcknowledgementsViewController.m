//
//  MTAcknowledgementsViewController.m
//  Mentio
//
//  Created by Martin Hartl on 02/03/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MTAcknowledgementsViewController.h"
#import "MTAcknowledgmentCell.h"
#import "UIFont+CustomFontsContentSizes.h"

@interface MTAcknowledgementsViewController ()

@property (nonatomic, strong) NSArray *acks;

@end

@implementation MTAcknowledgementsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pods-acknowledgements" ofType:@"plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSMutableArray *array = [dict objectForKey:@"PreferenceSpecifiers"];
    [array removeObjectAtIndex:0];
    [array insertObject:@{@"Title" : NSLocalizedString(@"acknowledgment.introduction", @"Mentio makes use of the following...")} atIndex:0];
    self.acks = [NSArray arrayWithArray:array];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    
    self.title = NSLocalizedString(@"acknowledgment.title", @"Attribution");
    self.view.backgroundColor = [MHFancyPants colorForKey:MTBackgroundColor];
    self.tableView.estimatedRowHeight = 500;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.acks.count;
}

- (void)configureCell:(MTAcknowledgmentCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleHeadline];
    cell.descriptionLabel.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
    cell.descriptionLabel.font = [cell.descriptionLabel.font fontWithSize:13];
    
    cell.titleLabel.textColor = [MHFancyPants colorForKey:@"headingTextColor"];
    cell.descriptionLabel.textColor = [MHFancyPants colorForKey:@"bodyTextColor"];
    
    cell.titleLabel.text = [self.acks[indexPath.row] objectForKey:@"Title"];
    cell.descriptionLabel.text = [self.acks[indexPath.row] objectForKey:@"FooterText"];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    MTAcknowledgmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Dynamic Type

- (void)updateFonts:(NSNotification *)notification {
    [self.tableView reloadData];
}

@end
