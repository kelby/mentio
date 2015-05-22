//
//  MTSearchResultCell.m
//  Mentio
//
//  Created by Martin Hartl on 05/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTScrollCell.h"
#import "UIFont+CustomFontsContentSizes.h"


@interface MTScrollCell () <UIScrollViewDelegate>

@end

@implementation MTScrollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFonts:) name:@"UIContentSizeCategoryDidChangeNotification" object:nil];
    
    [self updateFonts:nil];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fireDetailDisclosure)];
    [self.disclousureIndicatorImageView addGestureRecognizer:tapGest];
    self.disclouseIndicatorTappable = NO;
}


- (void)hideAllElements:(BOOL)hide {
    self.albumView.hidden = hide;
    self.collectionNameLabel.hidden = hide;
    self.artistNameLabel.hidden = hide;
    self.disclousureIndicatorImageView.hidden = hide;
    self.priceLabel.hidden = hide;
    self.userInteractionEnabled = !hide;
}

#pragma mark - Custom Setter

- (void)setDisclouseIndicatorTappable:(BOOL)disclouseIndicatorTappable {
    _disclouseIndicatorTappable = disclouseIndicatorTappable;
    self.disclousureIndicatorImageView.userInteractionEnabled = disclouseIndicatorTappable;
}

- (void)setScrollCellAccessoryType:(MTScrollCellAccessoryType)scrollCellAccessoryType {
    
    if (_scrollCellAccessoryType == scrollCellAccessoryType) {
        return;
    }
    
    _scrollCellAccessoryType = scrollCellAccessoryType;
    
    switch (scrollCellAccessoryType) {
        case MTScrollCellAccessoryNone: {
            self.disclousureIndicatorImageView.image = nil;
            self.disclouseIndicatorTappable = NO;
            break;
        } case MTScrollCellAccessoryDisclosureIndicator: {
            self.disclouseIndicatorTappable = YES;
            self.disclousureIndicatorImageView.tintColor = [UIColor redColor];
            self.disclousureIndicatorImageView.image = [[UIImage imageNamed:@"detailDisclousure"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            self.disclouseIndicatorTappable = NO;
            self.disclousureIndicatorImageView.contentMode = UIViewContentModeCenter;
            break;
        } case MTScrollCellAccessoryDetailDisclosureButton: {
            self.disclouseIndicatorTappable = YES;
            self.disclousureIndicatorImageView.tintColor = [UIColor redColor];
            self.disclousureIndicatorImageView.image = [[UIImage imageNamed:@"moreInfoDetailDisclousure"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            self.disclousureIndicatorImageView.contentMode = UIViewContentModeLeft;
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Custom Disclouse Detail Action

- (void)fireDetailDisclosure {
    if ([self.scrollDelegate respondsToSelector:@selector(accessoryButtonTappedForScrollCell:)])  {
        [self.scrollDelegate accessoryButtonTappedForScrollCell:self];
    }
}

#pragma mark - UIApperance

- (void)setArtistNameLabelTextColor:(UIColor *)artistNameLabelTextColor {
    self.artistNameLabel.textColor = artistNameLabelTextColor;
    self.artistNameLabel.highlightedTextColor = artistNameLabelTextColor;
    self.priceLabel.textColor = artistNameLabelTextColor;
}

- (void)setCollectionNameLabelTextColor:(UIColor *)collectionNameLabelTextColor {
    self.collectionNameLabel.textColor = collectionNameLabelTextColor;
    self.collectionNameLabel.highlightedTextColor = collectionNameLabelTextColor;
}


- (void)setContentViewBackGround:(UIColor *)contentViewBackGround {
    self.contentView.backgroundColor = contentViewBackGround;
}

#pragma mark - Dynamic Type

- (void)updateFonts:(NSNotification *)aNotification {
    
    self.collectionNameLabel.font = [UIFont preferredABeeZeeFontForTextStyle:UIFontTextStyleHeadline];
    self.artistNameLabel.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
