//
//  PopoverSheetView.m
//  CustomPopover
//
//  Created by 23 on 6/15/13.
//  Copyright (c) 2013 Aged and Distilled. All rights reserved.
//

#import "PopoverSheetView.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat kPopoverSheetHeight = 400.0;
const CGFloat kPopoverSheetWidth = 280.0;
const CGFloat kPopoverSheetBottomMargin = 60.0;

const CGFloat kPresentPopoverSheetDuration = .35;

@interface PopoverSheetView ()

@property (nonatomic, strong) UIButton* button1;
@property (nonatomic, strong) UIButton* button2;

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* messageLabel;

@property (nonatomic, strong) UIView* shieldingView;
@property (nonatomic, strong) UITapGestureRecognizer* shieldTapRecognizer;

@property (nonatomic, assign) BOOL initialized;

@end


@implementation PopoverSheetView

- (id)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
    
}

- (void) commonInit
{
    if (self.initialized) return;
    
    //self.layer.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:.95].CGColor;
    self.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOffset = (CGSize){0.0, 4.0};
    self.layer.shadowOpacity = 0.5;
    self.frame = (CGRect){0.0, 0.0, kPopoverSheetWidth, kPopoverSheetHeight};
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = @"Placeholder Title";
    [self addSubview:self.titleLabel];
    
    self.messageLabel = [UILabel new];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = [UIFont systemFontOfSize:15.0];
    self.messageLabel.textColor = [UIColor darkGrayColor];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.text = @"I must not fear. Fear is the mind-killer. Fear is the little-death that brings total obliteration. I will face my fear. I will permit to pass over and through me.";
    [self addSubview:self.messageLabel];
    
    self.button1 = [self styledSheetButton];
    [self addSubview:self.button1];
    [self.button1 addTarget:self action:@selector(button1Tapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button2 = [self styledSheetButton];
    [self addSubview:self.button2];
    [self.button2 addTarget:self action:@selector(button2Tapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.shieldingView = [UIView new];
    self.shieldingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.shieldTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shieldViewTapped)];
    self.shieldTapRecognizer.numberOfTapsRequired = 1;
    self.shieldTapRecognizer.numberOfTouchesRequired = 1;
    [self.shieldingView addGestureRecognizer:self.shieldTapRecognizer];
    
    self.initialized = YES;
}


- (UIButton*) styledSheetButton
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
    button.layer.cornerRadius = 20.0;
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"Button" forState:UIControlStateNormal];
    
    return button;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect popoverBounds = self.bounds;

    // Buttons
    
    CGRect buttonRect = (CGRect){0.0, 0.0, 110.0, 60.0};

    CGRect button1Frame = buttonRect;
    button1Frame.origin.x = 20.0;
    button1Frame.origin.y = CGRectGetMaxY(popoverBounds) - button1Frame.size.height - 20.0;
    self.button1.frame = button1Frame;
    
    CGRect button2Frame = buttonRect;
    button2Frame.origin.x = CGRectGetMaxX(popoverBounds) - button2Frame.size.width - 20;
    button2Frame.origin.y = CGRectGetMaxY(popoverBounds) - button1Frame.size.height - 20.0;
    self.button2.frame = button2Frame;
    
    // Text
    
    [self.titleLabel sizeToFit];
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size.width = MIN(titleFrame.size.width, popoverBounds.size.width - 40.0);
    titleFrame.origin.x = floor((popoverBounds.size.width - titleFrame.size.width) / 2.0);
    titleFrame.origin.y = 40.0;
    self.titleLabel.frame = titleFrame;
    
    CGRect messageFrame = CGRectZero;
    messageFrame.size.width = popoverBounds.size.width - (2 * 20.0);
    self.messageLabel.frame = messageFrame;
    [self.messageLabel sizeToFit];
    messageFrame = self.messageLabel.frame;
    
    messageFrame.origin.x = floor((popoverBounds.size.width - messageFrame.size.width) / 2.0);
    messageFrame.origin.y = CGRectGetMaxY(titleFrame) + 20.0;
    self.messageLabel.frame = messageFrame;
}

- (void)sizeShieldToWindow:(UIWindow*)window
{
    self.shieldingView.frame = window.bounds;
}

- (void)layoutForWindow:(UIWindow*)window
{
    CGRect windowBounds = window.bounds;
    CGSize popoverSize = (CGSize){.width = kPopoverSheetWidth, .height = kPopoverSheetHeight};
    
    CGFloat x = floor(windowBounds.size.width - popoverSize.width) / 2.0;
    CGFloat y = CGRectGetMaxY(windowBounds) - popoverSize.height - kPopoverSheetBottomMargin;
    CGRect popoverFrame = (CGRect){ .origin = {x, y}, .size = popoverSize };
    
    self.frame = popoverFrame;
}

#pragma mark - Presentation

- (void) showFromView:(UIView*)view animated:(BOOL)animated
{
    UIWindow* window = [view window];
    
    [self presentShieldOnWindow:window animated:animated];
    
    [self layoutForWindow:window];
    [window insertSubview:self atIndex:window.subviews.count];
    
    CGRect startFrame = self.frame;
    startFrame.origin.y = CGRectGetMaxY(window.frame);
    CGRect endFrame = self.frame;
    
    CGFloat startOpacity = self.layer.opacity * 0.8;
    CGFloat endOpacity = self.layer.opacity;
    
    self.frame = startFrame;
    self.layer.opacity = startOpacity;
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = endFrame;
        self.layer.opacity = endOpacity;
    } completion:^(BOOL finished) {
        // Do something
    }];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    [self dismissShieldAnimated:animated];

    CGRect startFrame = self.frame;
    CGRect endFrame = self.frame;
    endFrame.origin.y = CGRectGetMaxY(self.window.frame);
    
    CGFloat startOpacity = self.layer.opacity;
    CGFloat endOpacity = self.layer.opacity * 0.8;
    
    self.frame = startFrame;
    self.layer.opacity = startOpacity;
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = endFrame;
        self.layer.opacity = endOpacity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) presentShieldOnWindow:(UIWindow*)window animated:(BOOL)animated
{
    const CGFloat startOpacity = 0.0;
    const CGFloat endOpacity = 1.0;
    
    [self sizeShieldToWindow:window];
    self.shieldingView.layer.opacity = startOpacity;
    
    [window insertSubview:self.shieldingView atIndex:window.subviews.count];
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.shieldingView.layer.opacity = endOpacity;
    } completion:^(BOOL finished) {
        // do something
    }];
}

- (void) dismissShieldAnimated:(BOOL)animated
{
    const CGFloat startOpacity = 1.0;
    const CGFloat endOpacity = 0.0;
    
    self.shieldingView.layer.opacity = startOpacity;
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.shieldingView.layer.opacity = endOpacity;
    } completion:^(BOOL finished) {
        [self.shieldingView removeFromSuperview];
    }];
}


#pragma mark - Actions

- (void) button1Tapped:(id)sender
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) button2Tapped:(id)sender
{
    [self dismissWithClickedButtonIndex:1 animated:YES];
}

- (void) shieldViewTapped
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

@end
