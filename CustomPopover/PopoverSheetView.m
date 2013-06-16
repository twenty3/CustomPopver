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

@interface PopoverSheetView ()

@property (nonatomic, strong) UIButton* button1;
@property (nonatomic, strong) UIButton* button2;

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
    self.layer.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.7].CGColor;
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    self.layer.shadowRadius = 3.0;
    self.layer.shadowOffset = (CGSize){1.0, 1.0};
    self.layer.shadowOpacity = 0.8;
    self.frame = (CGRect){0.0, 0.0, kPopoverSheetWidth, kPopoverSheetHeight};
    
    self.button1 = [self styledSheetButton];
    [self addSubview:self.button1];
    [self.button1 addTarget:self action:@selector(button1Tapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button2 = [self styledSheetButton];
    [self addSubview:self.button2];
    [self.button2 addTarget:self action:@selector(button2Tapped:) forControlEvents:UIControlEventTouchUpInside];
}


- (UIButton*) styledSheetButton
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.backgroundColor = [UIColor grayColor].CGColor;
    button.layer.cornerRadius = 20.0;
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"Button" forState:UIControlStateNormal];
    
    return button;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    
    CGRect buttonRect = (CGRect){0.0, 0.0, 110.0, 60.0};
    CGRect popoverFrame = self.frame;
    
    CGRect button1Frame = buttonRect;
    button1Frame.origin.x = 20.0;
    button1Frame.origin.y = CGRectGetMaxY(popoverFrame) - button1Frame.size.height - 20.0;
    self.button1.frame = button1Frame;
    
    CGRect button2Frame = buttonRect;
    button2Frame.origin.x = CGRectGetMaxX(popoverFrame) - button2Frame.size.width - 20;
    button2Frame.origin.y = CGRectGetMaxY(popoverFrame) - button1Frame.size.height - 20.0;
    self.button2.frame = button2Frame;    
}

#pragma mark - Presentation

- (void) showFromView:(UIView*)view animated:(BOOL)animated
{
    UIWindow* window = [view window];
    [window insertSubview:self atIndex:window.subviews.count];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    [self removeFromSuperview];
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



@end
