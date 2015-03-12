//
//  MTSelectCountryViewController.m
//  Mentio
//
//  Created by Martin Hartl on 12/01/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MTSelectCountryViewController.h"
#import "CountryPicker.h"
#import "MTCountryPicker.h"
#import "MTITunesClient.h"
#import "UIFont+CustomFontsContentSizes.h"

@interface MTSelectCountryViewController ()

@property NSArray *countryNames;
@property NSArray *countryCodes;
@property NSString *selectedCountryCode;

@end

@implementation MTSelectCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countryNames = [MTCountryPicker countryNames];
    self.countryCodes = [MTCountryPicker countryCodes];
    self.selectedCountryCode = [[MTItunesClient sharedClient] selectedCountryCode];
    self.title = NSLocalizedString(@"Country Settings", @"Country Settings");
    
    NSInteger selectedRow = [self.countryCodes indexOfObjectIdenticalTo:self.selectedCountryCode];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    self.view.backgroundColor = [MHFancyPants colorForKey:MTBackgroundColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCountryCode = self.countryCodes[indexPath.row];
    [[MTItunesClient sharedClient] setSelectedCountryCode:self.selectedCountryCode];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.countryCodes.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"Please select your country", @"Please select your country");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.countryCodes[indexPath.row] isEqualToString:self.selectedCountryCode]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", self.countryCodes[indexPath.row], self.countryNames[indexPath.row] ];
}

@end
