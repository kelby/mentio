//
//  MTTButtonView.h
//  CoreAnimationTutorial
//
//  Created by Martin Hartl on 08/11/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTTButtonView : UIView

@property (nonatomic, assign) BOOL isShowing;

- (void)addFirstButton:(UIView *)view;
- (void)addSecondButton:(UIView *)view;
- (void)addThirdButton:(UIView *)view;
- (void)addFourthButton:(UIView *)view;
- (void)addFifthButton:(UIView *)view;

- (void)showButtons;
- (void)hideButtons:(void(^)(void))finishedBlock;

@property (assign) NSInteger floatingHeight;
@property (assign) NSInteger floatingWidth;
@property (assign) NSInteger viewHeight;
@property (assign) NSInteger parallaxMovement;

@end
