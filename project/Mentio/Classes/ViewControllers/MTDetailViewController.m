    //
//  MTDetailViewController.m
//  Mentio
//
//  Created by Martin Hartl on 22/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTDetailViewController.h"
#import "MHSegmentedView.h"
#import "MHAlbumView+RoundCorners.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MTImageCacher.h"
#import "App.h"
#import "MTAppDetailViewControllerDelegate.h"
#import "MTDetailViewControllerDelegateFactory.h"
#import <MHCustomTabBarController/MHCustomTabBarController.h>
#import "URBMediaFocusViewController.h"
#import "UIFont+CustomFontsContentSizes.h"
#import "UIImage+ImageEffects.h"
#import "MTStatusBarConstants.h"
#import "Mentio-Swift.h"

@interface MTDetailViewController () <URBMediaFocusViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibAddBarButton;
@property (weak, nonatomic) IBOutlet UIButton *ibItunesButton;
@property (weak, nonatomic) IBOutlet UIButton *ibShareButton;
@property (weak, nonatomic) IBOutlet UILabel *ibCopyrightLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *copyrightLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *ibArtistLabel;
@property (weak, nonatomic) IBOutlet UILabel *ibAlbumTitleLabel;
@property (nonatomic, strong) URBMediaFocusViewController *fullScreenView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation MTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ibCopyrightLabel.text = self.detailModel.protCopyright;
    if (self.detailModel.protCopyright == nil) {
        self.ibCopyrightLabel.text = @"";
    }
    
    [self.ibItunesButton setImage:[[self.ibItunesButton imageForState:UIControlStateNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.ibShareButton setImage:[[self.ibShareButton imageForState:UIControlStateNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    self.navigationItem.title = self.detailModel.protTitle;
    self.ibArtistLabel.text = self.detailModel.protArtistName;
    self.ibAlbumTitleLabel.text = self.detailModel.protTitle;
    
    [self loadIcon];
    
    __weak typeof(self) weakSelf = self;
    
    [self.ibAlbumView setTapInsideActionBlock:^(UIImage *image, UITapGestureRecognizer *tapGestureRecognizer) {
        
        if (weakSelf) {
            if (!weakSelf.fullScreenView) {
                weakSelf.fullScreenView = [[URBMediaFocusViewController alloc] init];
                weakSelf.fullScreenView.shouldDismissOnTap = YES;
                weakSelf.fullScreenView.shouldDismissOnImageTap = YES;
                weakSelf.fullScreenView.delegate = weakSelf;
                weakSelf.fullScreenView.shouldRotateToDeviceOrientation = NO;
            }
            
            if (self.detailViewDelegate) {
                [weakSelf.fullScreenView showImageFromURL:[self.detailViewDelegate largeCoverImageURL] fromView:self.ibAlbumView];
            }
        }
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFonts:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBackgroundImage:) name:MTThemeChangedNotification object:nil];
    
    [self updateFonts:nil];
    
    self.detailViewDelegate = [MTDetailViewControllerDelegateFactory delegateWithModel:self.detailModel];
    self.ibSegmentedView.delegate = self.detailViewDelegate;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)setBackgroundImage {
    UIImage *image;
    
    image = [[MTThemer sharedInstance] bluredImage:self.ibAlbumView.image];
    
    self.backgroundImageView.alpha = 0;
    self.backgroundImageView.image = image;
    
    [UIView animateWithDuration:.25 animations:^{
        self.backgroundImageView.alpha = 1;
    }];
}

- (void)updateBackgroundImage:(NSNotification *)notification {
    [self setBackgroundImage];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.ibCopyrightLabel.hidden = YES;
    
    self.bottomConstraint.constant = kbSize.height - 20;
    [self.ibSegmentedView layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.ibCopyrightLabel.hidden = NO;
    [self configureForDifferentSources];
}

- (void)loadIcon {
    
    __weak typeof(self) welf = self;
    
    MTImageChacheType imageCacheType;
    NSString *fileName;
    
    if (self.fromSearchViewController) {
        imageCacheType = MTImageCacheTypeForTemporarilyUsage;
        fileName = [NSString stringWithFormat:@"%lu",(unsigned long)self.detailModel.protItemId];
    } else {
        imageCacheType = MTImageCacheTypeForPersistentUsage;
        fileName = self.detailModel.protIconFileName;

    }
    
    [[MTImageCacher sharedInstance] loadImageNamed:fileName type:imageCacheType completion:^(UIImage *image) {
        if (image) {
            self.ibAlbumView.image = image;
            [welf setBackgroundImage];
            [self.ibAlbumView applyRoundCorners:[self.detailModel isKindOfClass:[App class]]];
            
        } else {
            [self.ibAlbumView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailModel.protArtworkUrl]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *downloadedImage) {
                //success
                self.ibAlbumView.image = downloadedImage;
                [self.ibAlbumView applyRoundCorners:[self.detailModel isKindOfClass:[App class]]];
                [[MTImageCacher sharedInstance] saveImage:downloadedImage name:fileName type:imageCacheType];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                //failure
            }];
        }
    }];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [self configureForDifferentSources];
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];   //show nav bar
    [self.navigationController.navigationBar setTranslucent:YES];
    
    self.view.backgroundColor = [MHFancyPants colorForKey:MTBackgroundColor];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    self.navigationController.navigationBar.tintColor = [MHFancyPants colorForKey:MTTintColor];
    self.view.tintColor = [MHFancyPants colorForKey:MTTintColor];
    self.ibCopyrightLabel.textColor = [MHFancyPants colorForKey:MTBodyTextColor];
    self.ibSegmentedView.tintColor = [MHFancyPants colorForKey:MTHeadingTextColor];
    
    self.ibArtistLabel.textColor = [MHFancyPants colorForKey:MTBodyTextColor];
    self.ibAlbumTitleLabel.textColor = [MHFancyPants colorForKey:MTHeadingTextColor];
    [self.ibSegmentedView setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MTHideStatusBarView object:nil];
}

- (void)configureForDifferentSources {
    
    if (!self.detailModel.protCopyright) {
        self.copyrightLabelHeightConstraint.constant = 0;
    }
    
    if (self.fromSearchViewController) {
        self.bottomConstraint.constant = 5;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
        self.bottomConstraint.constant = 55;
    }
    
    [self.view layoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popViewController) name:MHCustomTabBarControllerViewControllerAlreadyVisibleNotification object:nil];
    
    if ([self.detailViewDelegate respondsToSelector:@selector(loadScreenshots)]) {
        [self.detailViewDelegate performSelector:@selector(loadScreenshots)];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    
    if (!self.fromArchiveViewController) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];    // hide nav bar
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    if (!(self.fromSearchViewController)) {
        [self.detailModel save];
    }
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.detailViewDelegate = nil;
}

#pragma mark - Setup-Methods

- (void)hideAddButton:(BOOL)boolean {
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - IBAction

- (IBAction)ibaPushedItunesButton:(id)sender {
    NSURL *buyURL = [MTModelActivity createShareUrl:self.detailModel.protCollectionViewUrl];
    [[UIApplication sharedApplication] openURL:buyURL];
}

- (IBAction)pushedShareButton:(id)sender {    
    MTModelActivity *activity = [[MTModelActivity alloc] initWithModel:self.detailModel];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[activity] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

- (IBAction)ibaPushedAddBarButton:(id)sender {
    [self.detailModel save];
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIColor *)osk_color_action {
    return self.view.tintColor;
}

#pragma mark - URBMediaFocusViewController

- (void)mediaFocusViewControllerDidAppear:(URBMediaFocusViewController *)mediaFocusViewController {
    [self.view endEditing:YES];
}


#pragma mark - MHCustomTabBarViewControllerNotification

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Daynamic Type

- (void)updateFonts:(NSNotification *)aNotification {
    self.ibAlbumTitleLabel.font = [UIFont preferredABeeZeeFontForTextStyle:UIFontTextStyleHeadline];
    self.ibArtistLabel.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
}

@end
