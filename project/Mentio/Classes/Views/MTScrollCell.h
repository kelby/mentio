//
//  MTSearchResultCell.h
//  Mentio
//
//  Created by Martin Hartl on 05/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHAlbumView.h"

@class MTScrollCell;

@protocol MTScrollCellDelegate <NSObject>


@optional
- (void)accessoryButtonTappedForScrollCell:(MTScrollCell *)cell;

@end

typedef NS_ENUM(NSInteger, MTScrollCellAccessoryType) {
    MTScrollCellAccessoryNone,
    MTScrollCellAccessoryDisclosureIndicator,
    MTScrollCellAccessoryDetailDisclosureButton
};

@interface MTScrollCell : UITableViewCell

#pragma mark - UIAppearance

@property (nonatomic, strong) UIColor *artistNameLabelTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *collectionNameLabelTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *scrollContentViewBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *contentViewBackGround UI_APPEARANCE_SELECTOR;


///------------------
/// @name Properties
///------------------

/**
 The object that acts as the delegate of the receiving cell.
 
 @discussion The delegate must adopt the `TLSwipeForOptionsCellDelegate` protocol.
 */

@property (nonatomic, weak) id<MTScrollCellDelegate>scrollDelegate;

@property (weak, nonatomic) IBOutlet MHAlbumView *albumView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *disclousureIndicatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (nonatomic, assign) BOOL disclouseIndicatorTappable; //Default to no

@property (nonatomic) MTScrollCellAccessoryType scrollCellAccessoryType;

- (void)hideAllElements:(BOOL)hide;

@end
