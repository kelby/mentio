//
//  MTThemer.h
//  Mentio
//
//  Created by Martin Hartl on 11/11/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTCustomTabBarController.h"
#import "MTListViewController.h"
#import "MTStatusBarView.h"
#import "MTSettingsViewController.h"
#import "MTScrollCell.h"
#import "MTStatusCell.h"
#import "MHScreenshotsScrollView.h"
#import "MTSearchViewController.h"

extern NSString * const MTThemeChangedNotification;

@protocol MTThemeProtocol <NSObject>

- (void)applyTheme:(NSNotification *)notification;

@end


@interface MTThemer : NSObject

+ (instancetype)sharedInstance;

- (BOOL)usesLightTheme;

- (void)setDarkThemeToDefault;
- (void)setLightThemeToDefault;
- (void)applyDefaultTheme;

- (void)themeMTCustomTabBarController:(MTCustomTabBarController *)customTabBarController;
- (void)themeDefaultUITableView:(UITableView *)tableView;
- (void)themeMTListViewController:(MTListViewController *)listViewController;
- (void)themeMTStatusBarView:(MTStatusBarView *)statusBarView;
- (void)themeMTSettingsViewController:(MTSettingsViewController *)settingsViewController;
- (void)themeMTScrollCell:(MTScrollCell *)cell;
- (void)themeMTStatusCell:(MTStatusCell *)cell;
- (void)themeMHScreenshotsScrollView:(MHScreenshotsScrollView *)screenshotsScrollView;
- (void)themeMTSearchViewController:(MTSearchViewController *)searchViewController;

- (UIImage *)bluredImage:(UIImage *)image;

@end
