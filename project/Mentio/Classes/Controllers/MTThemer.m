//
//  MTThemer.m
//  Mentio
//
//  Created by Martin Hartl on 11/11/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTThemer.h"
#import "MTListSectionHeader.h"
#import "MTDetailViewController.h"
#import "MTMusicDetailSongCell.h"
#import "MHSimpleTableList.h"
#import "MHSimpleTableListCell.h"
#import "MHAlbumView.h"
#import "MTStatusBarView.h"
#import "MTListViewController.h"
#import "MTStatusCell.h"
#import "MHScreenshotsScrollView.h"
#import "MTCustomTabBarController.h"
#import "MTSettingsViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "MTNavigationViewController.h"
#import <SZTextView/SZTextView.h>
#import "UIImage+ImageEffects.h"
#import "MTSettingsTableViewCell.h"
#import "MHSegmentedView.h"

NSString *const MTThemeChangedNotification = @"MTThemeChangedNotification";

static NSString *const kDefaultThemeDark = @"Theme";
static NSString *const kDefaultThemeLight = @"ThemeLight";
static NSString *const kDefaultTheme = @"kDefaultTheme";

@implementation MTThemer


+ (instancetype)sharedInstance {
    static MTThemer *_sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstace = [[self alloc] init];
    });
    
    return _sharedInstace;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTheme]) {
            [[NSUserDefaults standardUserDefaults] setObject:kDefaultThemeDark forKey:kDefaultTheme];
        }
        
    }
    return self;
}

- (void)applyTheme {
    NSString *defaultTheme = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTheme];
    [MHFancyPants configWithPlistName:defaultTheme];
    
    UIColor *backgroundColor = [MHFancyPants colorForKey:MTBackgroundColor];
    UIColor *barBackgroundColor = [MHFancyPants colorForKey:MTBarBackgroundColor];
    UIColor *tintColor = [MHFancyPants colorForKey:MTTintColor];
    UIColor *headingTextColor = [MHFancyPants colorForKey:MTHeadingTextColor];
    UIColor *bodyTextColor = [MHFancyPants colorForKey:MTBodyTextColor];
    
    [[UITextField appearance] setKeyboardAppearance:[MHFancyPants integerForKey:@"keyboardAppearance"]];
//    [[UINavigationBar appearanceWhenContainedIn:[MTNavigationViewController class], nil] setBarTintColor:barBackgroundColor];
    
    [[UISearchBar appearance] setTintColor:tintColor];
    [[UISearchBar appearance] setBarTintColor:barBackgroundColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName:tintColor,NSFontAttributeName: [UIFont avenirFontWithSize:17]} forState:UIControlStateNormal];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont avenirFontWithSize:15]];
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:bodyTextColor];
    
    [[UITableViewCell appearanceWhenContainedIn:[MTNavigationViewController class], nil] setBackgroundColor:[MHFancyPants colorForKey:MTAlternateBackgroundColor]];
    [[UILabel appearanceWhenContainedIn:[MTSettingsTableViewCell class], nil] setTextColor:headingTextColor];
    [[UISwitch appearance] setOnTintColor:tintColor];
    [[UISwitch appearance] setTintColor:tintColor];
    
    [[UITableView appearance] setBackgroundColor:backgroundColor];
    [[UITableView appearance] setSeparatorColor:[UIColor darkGrayColor]];
    
    [[MTListSectionHeader appearance] setBackgroundColor:[MHFancyPants colorForKey:@"sectionHeaderBackgroundColor"]];
    [[MTListSectionHeader appearance] setTintColor:[MHFancyPants colorForKey:@"sectionHeaderTintColor"]];
    
    [[MTStatusBarView appearance] setAlpha:[MHFancyPants floatForKey:@"statusBarViewAlpha"]];
    [[MTStatusBarView appearance] setBackgroundColor:[MHFancyPants colorForKey:@"statusBarViewColor"]];
    
    [[UIToolbar appearanceWhenContainedIn:[MTCustomTabBarController class], nil] setBarStyle:[MHFancyPants integerForKey:@"tabBarStyle"]];
    
    [[UINavigationBar appearance] setBarStyle:[MHFancyPants integerForKey:@"tabBarStyle"]];
    
    [[MTMusicDetailSongCell appearance] setTextLabelTextColor:headingTextColor];
    
    [UIApplication sharedApplication].statusBarStyle = [MHFancyPants integerForKey:@"defaultStatusBarStyle"];
    
    [[UINavigationBar appearanceWhenContainedIn:[MTNavigationViewController class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName: [MHFancyPants colorForKey:@"navigationBarTitleTextColor"], NSFontAttributeName: [UIFont avenirFontWithSize:17] }];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont avenirFontWithSize:17]} forState:UIControlStateNormal];
    
    [[UITableView appearanceWhenContainedIn:[MTDetailViewController class], nil] setBackgroundColor:[UIColor clearColor]];
    
    [[MHSimpleTableList appearance] setCellBackgroundColor:[UIColor clearColor]];
    [[MHSimpleTableListCell appearance] setDescriptorLabelTextColor:bodyTextColor];
    [[MHSimpleTableListCell appearance] setValueLabelTextColor:headingTextColor];
    
    [[MHAlbumView appearance] setBackgroundColor:[UIColor clearColor]];
    [[MHAlbumView appearance] setIndicatorColor:tintColor];
    
    [[UITextView appearance] setBackgroundColor:[UIColor clearColor]];
    
    [[SZTextView appearance] setTextColor:headingTextColor];
    [[SZTextView appearance] setPlaceholderTextColor:bodyTextColor];
    
    
    [[MHSegmentedView appearance] setControlHeight:28.0];
}

- (void)setDarkThemeToDefault {
    [[NSUserDefaults standardUserDefaults] setObject:kDefaultThemeDark forKey:kDefaultTheme];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self applyTheme];
    [[NSNotificationCenter defaultCenter] postNotificationName:MTThemeChangedNotification object:nil];
}

- (void)setLightThemeToDefault {
    
    [[NSUserDefaults standardUserDefaults] setObject:kDefaultThemeLight forKey:kDefaultTheme];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self applyTheme];
    [[NSNotificationCenter defaultCenter] postNotificationName:MTThemeChangedNotification object:nil];
}

- (void)applyDefaultTheme {
    [self applyTheme];
}

- (BOOL)usesLightTheme {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTheme] isEqualToString:kDefaultThemeLight];
}


#pragma mark - Theme-Methods

- (void)themeMTCustomTabBarController:(MTCustomTabBarController *)customTabBarController {
    [customTabBarController setFakeBlurToolbarStyle:[MHFancyPants integerForKey:@"tabBarStyle"]];
}

- (void)themeDefaultUITableView:(UITableView *)tableView {
    [tableView setBackgroundColor:[MHFancyPants colorForKey:@"backgroundColor"]];
    [tableView setSeparatorColor:[UIColor darkGrayColor]];
}

- (void)themeMTListViewController:(MTListViewController *)listViewController {
    [listViewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [MHFancyPants colorForKey:@"navigationBarTitleTextColor"]}];
    listViewController.view.backgroundColor = [MHFancyPants colorForKey:MTBackgroundColor];
}

- (void)themeMTStatusBarView:(MTStatusBarView *)statusBarView {
    [statusBarView setAlpha:[MHFancyPants floatForKey:@"statusBarViewAlpha"]];
    [statusBarView setBackgroundColor:[MHFancyPants colorForKey:@"statusBarViewColor"]];
}

- (void)themeMTSettingsViewController:(MTSettingsViewController *)settingsViewController {
    
    [settingsViewController.navigationController.navigationBar setBarStyle:[MHFancyPants integerForKey:@"tabBarStyle"]];
    settingsViewController.navigationController.navigationBar.translucent = YES;
    [settingsViewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [MHFancyPants colorForKey:@"navigationBarTitleTextColor"]}];
    settingsViewController.view.backgroundColor = [MHFancyPants colorForKey:MTBackgroundColor];
}

- (void)themeMTScrollCell:(MTScrollCell *)cell {
    UIColor *backgroundColor = [MHFancyPants colorForKey:MTBackgroundColor];
    UIColor *headingTextColor = [MHFancyPants colorForKey:MTHeadingTextColor];
    UIColor *bodyTextColor = [MHFancyPants colorForKey:MTBodyTextColor];
    
    [cell setCollectionNameLabelTextColor:headingTextColor];
    [cell setArtistNameLabelTextColor:bodyTextColor];
    [cell setScrollContentViewBackgroundColor:backgroundColor];
    [cell setContentViewBackGround:backgroundColor];
    [cell setBackgroundColor:backgroundColor];
    cell.disclousureIndicatorImageView.tintColor = bodyTextColor;
    
    UIView *selectedbg = [[UIView alloc] init];
    selectedbg.backgroundColor = [MHFancyPants colorForKey:@"selectedBackgroundColor"];
    cell.selectedBackgroundView = selectedbg;
}

- (void)themeMTStatusCell:(MTStatusCell *)cell {
    UIColor *backgroundColor = [MHFancyPants colorForKey:MTBackgroundColor];
    UIColor *headingTextColor = [MHFancyPants colorForKey:MTHeadingTextColor];
    UIColor *tintColor = [MHFancyPants colorForKey:MTTintColor];
    
    [cell setContentViewBackgroundColor:backgroundColor];
    [cell setTextLabeltextColor:headingTextColor];
    [cell setIndicatorColor:tintColor];
    [cell setBackgroundColor:backgroundColor];
}

- (void)themeMHScreenshotsScrollView:(MHScreenshotsScrollView *)screenshotsScrollView {
    UIColor *bodyTextColor = [MHFancyPants colorForKey:MTBodyTextColor];
    UIColor *tintColor = [MHFancyPants colorForKey:MTTintColor];
    [screenshotsScrollView setCurrentPageIndicatorTintColor:tintColor];
    [screenshotsScrollView setPageIndicatorTintColor:bodyTextColor];
}

- (void)themeMTSearchViewController:(MTSearchViewController *)searchViewController {
}

#pragma mark - Blur Image for Style

- (UIImage *)bluredImage:(UIImage *)image {
    if (self.usesLightTheme) {
        return [image applyExtraLightEffect];
    }
    
    return [image applyExtraDarkEffect];
}

@end
