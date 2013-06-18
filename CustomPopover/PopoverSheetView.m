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

const CGFloat kShieldOpactiy = 0.5;
const CGFloat kShieldIntensity = 0.0;

const CGFloat kPresentPopoverSheetDuration = .25;


@interface PopoverSheetView ()

@property (nonatomic, strong) UIButton* button1;
@property (nonatomic, strong) UIButton* button2;

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* messageLabel;

@property (nonatomic, strong) UIView* shieldingView;
@property (nonatomic, strong) UITapGestureRecognizer* shieldTapRecognizer;
@property (nonatomic, strong) UIWindow* shieldWindow;

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
    self.layer.shadowRadius = 1.0;
    self.layer.shadowOffset = (CGSize){0.0, 1.0};
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
    self.shieldingView.backgroundColor = [UIColor colorWithWhite:kShieldIntensity alpha:kShieldOpactiy];
    
    self.shieldTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shieldViewTapped)];
    self.shieldTapRecognizer.numberOfTapsRequired = 1;
    self.shieldTapRecognizer.numberOfTouchesRequired = 1;
    [self.shieldingView addGestureRecognizer:self.shieldTapRecognizer];
    
    self.shieldWindow = [[UIWindow alloc] initWithFrame:CGRectZero];
    self.shieldWindow.windowLevel = UIWindowLevelStatusBar + 1.0f;
    self.shieldWindow.clipsToBounds = YES;
    self.shieldWindow.backgroundColor = [UIColor colorWithWhite:kShieldIntensity alpha:kShieldOpactiy];
    self.shieldWindow.hidden = YES;
    
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

- (void) layoutCenteredInRect:(CGRect)rect;
{
    CGSize popoverSize = (CGSize){.width = kPopoverSheetWidth, .height = kPopoverSheetHeight};
    
    CGFloat x = floor( (rect.size.width - popoverSize.width) / 2.0);
    CGFloat y = floor( (CGRectGetMaxY(rect) - popoverSize.height) / 2.0);
    CGRect popoverFrame = (CGRect){ .origin = {x, y}, .size = popoverSize };
    
    self.frame = popoverFrame;
}

#pragma mark - Presentation

 - (void) showFromView:(UIView*)view animated:(BOOL)animated
 {
     UIWindow* window = [view window];
     
     [self presentStatusBarSheildForWindow:window animated:YES];
     [self presentShieldOnWindow:window animated:animated];
     
     CGRect presentationRect = [window convertRect:view.frame fromView:view];
     [self layoutCenteredInRect:presentationRect];
     [window insertSubview:self atIndex:window.subviews.count];
     
     if (animated)
     {
         //[self presentWithAnimatedFadeIn];
         //[self presentWithAnimatedSlideIn];
         //[self presentWithGrowForWindow:window];
         [self presentWithShrink];
     }
 }
 

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    [self dismissStatusBarShieldAnimated:animated];
    [self dismissShieldAnimated:animated];

    if ( animated )
    {
        //[self dismissWithAnimatedFadeOut];
        //[self dismissWithAnimatedSlideOut];
        [self dismissWithShink];
    }
    else
    {
        [self removeFromSuperview];
    }
}

#pragma mark - Scale

- (void) presentWithGrow
{
    CGFloat startScale = 0.1;
    CATransform3D startTransform = CATransform3DMakeScale(startScale, startScale, 1.0);
    CATransform3D endTransform = CATransform3DIdentity;
    
    CGFloat startOpacity = 0.0;
    CGFloat endOpacity = 1.0;
    
    self.layer.transform = startTransform;
    self.layer.opacity = startOpacity;
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.layer.transform = endTransform;
                         self.layer.opacity = endOpacity;
                     } completion:nil];
}

- (void) presentWithShrink
{
    CGFloat startScale = 1.25;
    CATransform3D startTransform = CATransform3DMakeScale(startScale, startScale, 1.0);
    CATransform3D endTransform = CATransform3DIdentity;
    
    CGFloat startOpacity = 0.0;
    CGFloat endOpacity = 1.0;
    
    self.layer.transform = startTransform;
    self.layer.opacity = startOpacity;
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.layer.transform = endTransform;
                         self.layer.opacity = endOpacity;
                     } completion:nil];
}

- (void) dismissWithShink
{
    CGFloat endScale = 0.75;
    CATransform3D startTransform = CATransform3DIdentity;
    CATransform3D endTransform = CATransform3DMakeScale(endScale, endScale, 1.0);;
    
    CGFloat startOpacity = 1.0;
    CGFloat endOpacity = 0.0;
    
    self.layer.transform = startTransform;
    self.layer.opacity = startOpacity;
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.layer.transform = endTransform;
                         self.layer.opacity = endOpacity;
                     } completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}

#pragma mark - Fade

- (void) presentWithAnimatedFadeIn
{
    CGFloat startOpacity = 0.0;
    CGFloat endOpacity = self.layer.opacity;
    
    self.layer.opacity = startOpacity;
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.layer.opacity = endOpacity;
                     }
                     completion:nil];
}

- (void) dismissWithAnimatedFadeOut
{
    CGFloat startOpacity = self.layer.opacity;
    CGFloat endOpacity = 0.0;
    
    self.layer.opacity = startOpacity;
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.layer.opacity = endOpacity;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}

#pragma mark - Slide

- (void) dismissWithAnimatedSlideOut
{
    CGRect startFrame = self.frame;
    CGRect endFrame = self.frame;
    endFrame.origin.y = CGRectGetMaxY(self.window.frame);
    
    CGFloat startOpacity = self.layer.opacity;
    CGFloat endOpacity = self.layer.opacity * 0.8;
    
    self.frame = startFrame;
    self.layer.opacity = startOpacity;
    
    void (^animations)(void) = ^{
        self.frame = endFrame;
        self.layer.opacity = endOpacity;
    };
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:animations
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}

- (void) presentWithAnimatedSlideIn
{
    CGRect startFrame = self.frame;
    startFrame.origin.y = CGRectGetMaxY(self.superview.frame);
    CGRect endFrame = self.frame;
    
    CGFloat startOpacity = self.layer.opacity * 0.8;
    CGFloat endOpacity = self.layer.opacity;
    
    self.frame = startFrame;
    self.layer.opacity = startOpacity;
    
    void (^animations)(void) = ^{
        self.frame = endFrame;
        self.layer.opacity = endOpacity;
    };
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:animations
                     completion:nil];
}

#pragma mark - Shield

- (void) presentStatusBarSheildForWindow:(UIWindow*)window animated:(BOOL)animated
{
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if ( CGRectEqualToRect(statusBarFrame, CGRectZero) ) return;
    
    const CGFloat startOpacity = 0.0;
    const CGFloat endOpacity = 1.0;

    self.shieldWindow.frame = statusBarFrame;
    self.shieldWindow.hidden = NO;

    if ( !animated ) return;
    
    self.shieldWindow.layer.opacity = startOpacity;
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.shieldWindow.layer.opacity = endOpacity;
                     }
                     completion:nil];
}

- (void) dismissStatusBarShieldAnimated:(BOOL)animated
{
    if ( !animated )
    {
        self.shieldWindow.hidden = YES;
        return;
    }
    
    const CGFloat startOpacity = 1.0;
    const CGFloat endOpacity = 0.0;
    
    self.shieldWindow.layer.opacity = startOpacity;
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.shieldWindow.layer.opacity = endOpacity;
                     }
                     completion:^(BOOL finished){
                         self.shieldWindow.hidden = YES;
                     }];
}

- (void) presentShieldOnWindow:(UIWindow*)window animated:(BOOL)animated
{
    const CGFloat startOpacity = 0.0;
    const CGFloat endOpacity = 1.0;
    
    [self sizeShieldToWindow:window];
    self.shieldingView.layer.opacity = startOpacity;
    
    [window insertSubview:self.shieldingView atIndex:window.subviews.count];
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.shieldingView.layer.opacity = endOpacity;
                     }
                     completion:nil];
}

- (void) dismissShieldAnimated:(BOOL)animated
{
    const CGFloat startOpacity = 1.0;
    const CGFloat endOpacity = 0.0;
    
    self.shieldingView.layer.opacity = startOpacity;
    
    [UIView animateWithDuration:kPresentPopoverSheetDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.shieldingView.layer.opacity = endOpacity;
                     }
                     completion:^(BOOL finished) {
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
