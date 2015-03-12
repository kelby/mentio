//
//  MTStatusCell.m
//  Mentio
//
//  Created by Martin Hartl on 16/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTStatusCell.h"

@interface MTStatusCell ()

@property (weak, nonatomic) IBOutlet UILabel *ibStatusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ibActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;


@end

@implementation MTStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFonts:) name:@"UIContentSizeCategoryDidChangeNotification" object:nil];
    [self updateFonts:nil];
}

- (void)showSearchPromt {
    [self showSearchPromtWithText:NSLocalizedString(@"MTStatusCellSearchSomeThing", @"searchSOmething")];
}

- (void)showNoDataFound {
    [self showNoDataFoundWithText:NSLocalizedString(@"MTStatusCellNoDataFound", @"loading")];
}

- (void)showSearchPromtWithText:(NSString *)text {
    self.ibStatusLabel.text = text;
    self.ibActivityIndicator.hidden = YES;
}

- (void)showNoDataFoundWithText:(NSString *)text {
    self.ibStatusLabel.text = text;
    self.ibActivityIndicator.hidden = YES;
    [self.ibActivityIndicator stopAnimating];
}

- (void)showLoading {
    self.ibStatusLabel.text = NSLocalizedString(@"MTStatusCellLoading", @"loading");
    self.ibActivityIndicator.hidden = NO;
    [self.ibActivityIndicator startAnimating];
}


- (void)showIcon:(UIImage *)icon {
    self.ibStatusLabel.text = @"";
    self.ibActivityIndicator.hidden = YES;
    self.ibImageView.tintColor = [MHFancyPants colorForKey:@"tableViewSeparetorColor"];
    self.ibImageView.image = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark - UIAppearance

- (void)setTextLabeltextColor:(UIColor *)textLabeltextColor {
    self.ibStatusLabel.textColor = textLabeltextColor;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    self.ibActivityIndicator.color = indicatorColor;
}

- (void)setContentViewBackgroundColor:(UIColor *)contentViewBackgroundColor {
    self.contentView.backgroundColor = contentViewBackgroundColor;
}

#pragma mark - Dynamic Type

- (void)updateFonts:(NSNotification *)aNotification {
    
    self.ibStatusLabel.font = [UIFont preferredABeeZeeFontForTextStyle:UIFontTextStyleHeadline];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
