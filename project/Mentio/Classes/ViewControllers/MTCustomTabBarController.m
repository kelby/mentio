//
//  MTCustomTabBarController.m
//  Mentio
//
//  Created by Martin Hartl on 11/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTCustomTabBarController.h"
#import "MTTButtonView.h"
#import "MTThemer.h"
#import <QuartzCore/QuartzCore.h>
#import "MTSearchViewController.h"
#import "MTSearchMusicViewControllerDelegate.h"
#import "MTSearchMovieViewControllerDelegate.h"
#import "MTSearchBookViewControllerDelegate.h"
#import "MTSearchTVShowViewControllerDelegate.h"
#import "MTSearchAppViewControllerDelegate.h"
#import "MTContainerViewController.h"
#import "MTStatusBarConstants.h"
#import "Mentio-Swift.h"


@interface MTCustomTabBarController () <MTThemeProtocol, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIView *ibButtonView;
@property (weak, nonatomic) IBOutlet UIButton *ibAddButton;
@property (weak, nonatomic) IBOutlet MTTButtonView *addButtonView;
@property (weak, nonatomic) IBOutlet UIToolbar *fakeBlurView;

@property (weak, nonatomic) IBOutlet UIButton *ibEntriesTabBarButton;

@property (strong, nonatomic) UIVisualEffectView *dimmedView;
@property (strong, nonatomic) UIVisualEffectView *dimmedTapBarView;
@property (strong, nonatomic) UIBlurEffect *blurEffect;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer *screenPanGestureRecognizer;

@property (strong, nonatomic) id<MTSearchViewControllerDelegate> searchViewControllerDelegate;

@end

@implementation MTCustomTabBarController

- (UIButton *)createAddButtonWithImage:(UIImage *)image selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.layer.cornerRadius = 25;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [MHFancyPants colorForKey:@"tintColor"].CGColor;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)setupButtonView {
    
    [self.addButtonView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    [self.addButtonView addFirstButton:[self createAddButtonWithImage:[UIImage imageNamed:@"music"] selector:@selector(musicButtonAction:)]];
    
    [self.addButtonView addSecondButton:[self createAddButtonWithImage:[UIImage imageNamed:@"movie"] selector:@selector(movieButtonAction:)]];
    
    [self.addButtonView addThirdButton:[self createAddButtonWithImage:[UIImage imageNamed:@"app"] selector:@selector(appButtonAction:)]];
    
    [self.addButtonView addFourthButton:[self createAddButtonWithImage:[UIImage imageNamed:@"book"] selector:@selector(bookButtonAction:)]];
    
    [self.addButtonView addFifthButton:[self createAddButtonWithImage:[UIImage imageNamed:@"tv"] selector:@selector(tvShowButtonAction:)]];

    
}

- (void)setupDismissGestureRecognizers {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleButtonViewHiding)];
    self.screenPanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleButtonViewHiding)];
    self.screenPanGestureRecognizer.edges = UIRectEdgeLeft;
}

- (void)applyTheme:(NSNotification *)notification {
    
    [[MTThemer sharedInstance] themeMTCustomTabBarController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    self.dimmedView = [[UIVisualEffectView alloc] initWithEffect:self.blurEffect];
    self.dimmedTapBarView = [[UIVisualEffectView alloc] initWithEffect:self.blurEffect];
    
    [self setupButtonView];
    [self setupDismissGestureRecognizers];
    
    self.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.ibButtonView.backgroundColor = [UIColor clearColor];
    
    for (UIButton *button in self.buttons) {
        [button setImage:[[button imageForState:UIControlStateSelected] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
        [button setImage:[[button imageForState:UIControlStateHighlighted] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
    }
    
    
    self.container.backgroundColor = [MHFancyPants colorForKey:@"backgroundColor"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme:) name:MTThemeChangedNotification object:nil];
    
    [self.addButtonView hideButtons:^{
        self.addButtonView.hidden = YES;
    }];
}

- (void)addFullViewConstrainsForView:(UIView *)view toView:(UIView *)parent {
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *const1 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    
    NSLayoutConstraint *const2 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    
    NSLayoutConstraint *const3 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *const4 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [parent addConstraints:@[const1, const2, const3, const4]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.tintColor = [MHFancyPants colorForKey:@"tintColor"];
    self.ibAddButton.backgroundColor = self.view.tintColor;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"1"]) {
        
        UINavigationController *nc = segue.destinationViewController;
        MTContainerViewController *vc = (MTContainerViewController *)nc.topViewController;
        
        vc.searchViewControllerDelegate = self.searchViewControllerDelegate;
        
        return;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Manual TabBarButtonAction + Button

- (IBAction)addButtonAction:(id)sender {
    if (self.addButtonView.isShowing) {
        [self handleButtonViewHiding];
    } else {
        [self handleButtonViewShowing];
    }
}

- (void)showDimmedView {
    [[NSNotificationCenter defaultCenter] postNotificationName:[MTAddViewConstants didShow] object:nil];
    
    [UIView animateWithDuration:.2 animations:^{
        [self.view insertSubview:self.dimmedView belowSubview:self.addButtonView];
        [self addFullViewConstrainsForView:self.dimmedView toView:self.view];
        
        [self.ibButtonView addSubview:self.dimmedTapBarView];
        [self addFullViewConstrainsForView:self.dimmedTapBarView toView:self.ibButtonView];
        self.dimmedTapBarView.alpha = 1;
    }];
}

- (void)hideDimmedView {
    [[NSNotificationCenter defaultCenter] postNotificationName:[MTAddViewConstants didHide] object:nil];
    
    [UIView animateWithDuration:.2 animations:^{
    } completion:^(BOOL finished) {
        [self.dimmedView removeFromSuperview];
        [self.dimmedTapBarView removeFromSuperview];
    }];
}

- (void)handleButtonViewShowing {
    
    
    self.addButtonView.hidden = NO;
    [self.addButtonView showButtons];
    self.addButtonView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    
    self.ibButtonView.userInteractionEnabled = NO;
    self.destinationViewController.view.userInteractionEnabled = NO;
    
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    [self.view addGestureRecognizer:self.screenPanGestureRecognizer];
    
    [self showDimmedView];
    
    self.ibAddButton.backgroundColor = self.view.tintColor;
}

- (void)handleButtonViewHiding {
    
    [self.addButtonView hideButtons:^{
        self.addButtonView.hidden = YES;
    }];
    self.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.addButtonView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    
    self.ibButtonView.userInteractionEnabled = YES;
    self.destinationViewController.view.userInteractionEnabled = YES;
    
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    [self.view removeGestureRecognizer:self.screenPanGestureRecognizer];
    
    [self hideDimmedView];
    
    self.ibAddButton.backgroundColor = self.view.tintColor;
}


#pragma mark - ButtonView Buttons

- (void)musicButtonAction:(UIButton *)button {
    self.searchViewControllerDelegate = [[MTSearchMusicViewControllerDelegate alloc] init];
    [self performSegueWithIdentifier:@"1" sender:self];
    [self handleButtonViewHiding];
}

- (void)movieButtonAction:(UIButton *)button {
    self.searchViewControllerDelegate = [[MTSearchMovieViewControllerDelegate alloc] init];
    [self performSegueWithIdentifier:@"1" sender:self];
    [self handleButtonViewHiding];
}

- (void)appButtonAction:(UIButton *)button {
    self.searchViewControllerDelegate = [[MTSearchAppViewControllerDelegate alloc] init];
    [self performSegueWithIdentifier:@"1" sender:self];
    [self handleButtonViewHiding];
}

- (void)bookButtonAction:(UIButton *)button {
    self.searchViewControllerDelegate = [[MTSearchBookViewControllerDelegate alloc] init];
    [self performSegueWithIdentifier:@"1" sender:self];
    [self handleButtonViewHiding];
}

- (void)tvShowButtonAction:(UIButton *)button {
    self.searchViewControllerDelegate = [[MTSearchTVShowViewControllerDelegate alloc] init];
    [self performSegueWithIdentifier:@"1" sender:self];
    [self handleButtonViewHiding];
}

#pragma mark - MHAppearance

- (void)setFakeBlurToolbarStyle:(UIBarStyle)barstyle {
    self.fakeBlurView.barStyle = barstyle;
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
