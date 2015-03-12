//
//  MTTButtonView.m
//  CoreAnimationTutorial
//
//  Created by Martin Hartl on 08/11/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTTButtonView.h"

static NSInteger kBottomConstant = 0;

@interface MTTButtonView ()

@property (strong, nonatomic) NSMutableArray *buttons;

@property (strong, nonatomic) NSLayoutConstraint *button1Bottom;
@property (strong, nonatomic) NSLayoutConstraint *button1Leading;
@property (strong, nonatomic) NSLayoutConstraint *button1Horizontal;

@property (strong, nonatomic) NSLayoutConstraint *button2Bottom;
@property (strong, nonatomic) NSLayoutConstraint *button2VertCenter;
@property (strong, nonatomic) NSLayoutConstraint *button2Horizontal;

@property (strong, nonatomic) NSLayoutConstraint *button3Bottom;
@property (strong, nonatomic) NSLayoutConstraint *button3Trailing;
@property (strong, nonatomic) NSLayoutConstraint *button3Horizontal;

@property (strong, nonatomic) NSLayoutConstraint *button4Bottom;
@property (strong, nonatomic) NSLayoutConstraint *button4Leading;
@property (strong, nonatomic) NSLayoutConstraint *button4Horizontal;

@property (strong, nonatomic) NSLayoutConstraint *button5Bottom;
@property (strong, nonatomic) NSLayoutConstraint *button5Trailing;
@property (strong, nonatomic) NSLayoutConstraint *button5Horizontal;


@end

@implementation MTTButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (void)initSetup {
    _buttons = [NSMutableArray array];
    self.backgroundColor = [UIColor clearColor];
    self.isShowing = NO;
    self.userInteractionEnabled = NO;
    
    self.floatingHeight = 70;
    self.viewHeight = 50;
    self.floatingWidth = 20;
    self.parallaxMovement = 15;
}

- (void)addFirstButton:(UIView *)view {
    
    [self.buttons addObject:view];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    
    self.button1Leading = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:self.floatingWidth];
    
    self.button1Bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:kBottomConstant];
    
    self.button1Horizontal = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *const3 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.viewHeight];
    
    NSLayoutConstraint *const4 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.viewHeight];
    
    [self addConstraint:self.button1Horizontal];
    [self addConstraint:self.button1Bottom];
    
    [view addConstraint:const3];
    [view addConstraint:const4];
    
    [self addMotionEffectToView:view];
    
    [self layoutSubviews];
    [view layoutIfNeeded];
    
}

- (void)addSecondButton:(UIView *)view {
    
    [self.buttons addObject:view];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    
    self.button2Bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:kBottomConstant];
    
    self.button2Horizontal = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *const3 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.viewHeight];
    
    NSLayoutConstraint *const4 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.viewHeight];
    
    [self addConstraint:self.button2Horizontal];
    [self addConstraint:self.button2Bottom];
    
    [view addConstraint:const3];
    [view addConstraint:const4];
    
    [self addMotionEffectToView:view];
    
    [self layoutSubviews];
    [view layoutIfNeeded];
    
}

- (void)addThirdButton:(UIView *)view {
    
    [self.buttons addObject:view];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    
    self.button3Trailing = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:- self.floatingWidth];
    
    self.button3Bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:kBottomConstant];
    
    self.button3Horizontal = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *const3 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.viewHeight];
    
    NSLayoutConstraint *const4 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.viewHeight];
    
    [self addConstraint:self.button3Horizontal];
    [self addConstraint:self.button3Bottom];
    
    [view addConstraint:const3];
    [view addConstraint:const4];
    
    [self addMotionEffectToView:view];
    
    [self layoutSubviews];
    [view layoutIfNeeded];
    
}

- (void)addFourthButton:(UIView *)view {
    
    [self.buttons addObject:view];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    
    self.button4Leading = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:self.floatingWidth + self.viewHeight + 8];
    
    self.button4Bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:kBottomConstant];
    
    self.button4Horizontal = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *const3 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.viewHeight];
    
    NSLayoutConstraint *const4 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.viewHeight];
    
    [self addConstraint:self.button4Horizontal];
    [self addConstraint:self.button4Bottom];
    
    [view addConstraint:const3];
    [view addConstraint:const4];
    
    [self addMotionEffectToView:view];
    
    [self layoutSubviews];
    [view layoutIfNeeded];
    
}

- (void)addFifthButton:(UIView *)view {
    
    [self.buttons addObject:view];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    
    self.button5Trailing = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:- self.floatingWidth - self.viewHeight - 8];
    
    self.button5Bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:kBottomConstant];
    
    self.button5Horizontal = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *const3 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.viewHeight];
    
    NSLayoutConstraint *const4 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.viewHeight];
    
    [self addConstraint:self.button5Horizontal];
    [self addConstraint:self.button5Bottom];
    
    [view addConstraint:const3];
    [view addConstraint:const4];
    
    [self addMotionEffectToView:view];
    
    [self layoutSubviews];
    [view layoutIfNeeded];
    
}

- (void)addMotionEffectToView:(UIView *)view {
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    verticalMotionEffect.minimumRelativeValue = @(-self.parallaxMovement);
    
    verticalMotionEffect.maximumRelativeValue = @(self.parallaxMovement);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    horizontalMotionEffect.minimumRelativeValue = @(-self.parallaxMovement);
    
    horizontalMotionEffect.maximumRelativeValue = @(self.parallaxMovement);
    
    
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [view addMotionEffect:group];
}

- (void)showButtons {
    
    self.isShowing = YES;
    self.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:.5
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:0
                     animations:^{
                         //nil
                         [self removeConstraint:self.button1Horizontal];
                         [self addConstraint:self.button1Leading];
                         self.button1Bottom.constant = - self.floatingHeight;
                         
                         self.button2Bottom.constant = - self.floatingHeight;
                         
                         [self removeConstraint:self.button3Horizontal];
                         [self addConstraint:self.button3Trailing];
                         self.button3Bottom.constant = -self.floatingHeight;
                         
                         [self removeConstraint:self.button4Horizontal];
                         [self addConstraint:self.button4Leading];
                         self.button4Bottom.constant = - self.floatingHeight * 2;
#
                         [self removeConstraint:self.button5Horizontal];
                         [self addConstraint:self.button5Trailing];
                         self.button5Bottom.constant = -self.floatingHeight * 2;
                         
                         [self layoutButtonsIfNeeded];
                     } completion:^(BOOL finished) {
                         //nil
                     }];
}


- (void)hideButtons:(void(^)(void))finishedBlock {
    
    self.isShowing = NO;
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:2
                        options:0
                     animations:^{
                         //nil
                         
                         [self removeConstraint:self.button1Leading];
                         [self addConstraint:self.button1Horizontal];
                         
                         self.button1Bottom.constant = kBottomConstant;
                         
                         self.button2Bottom.constant = kBottomConstant;
                         
                         [self removeConstraint:self.button3Trailing];
                         [self addConstraint:self.button3Horizontal];
                         
                         self.button3Bottom.constant = kBottomConstant;
                         
                         [self removeConstraint:self.button4Leading];
                         [self addConstraint:self.button4Horizontal];
                         
                         self.button4Bottom.constant = kBottomConstant;
                         
                         [self removeConstraint:self.button5Trailing];
                         [self addConstraint:self.button5Horizontal];
                         
                         self.button5Bottom.constant = kBottomConstant;
                         
                         [self layoutButtonsIfNeeded];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             finishedBlock();
                         }
                     }];
}

- (void)layoutButtonsIfNeeded {
    [self.buttons enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view layoutIfNeeded];
    }];
}

@end
