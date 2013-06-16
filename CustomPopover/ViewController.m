//
//  ViewController.m
//  CustomPopover
//
//  Created by 23 on 6/15/13.
//  Copyright (c) 2013 Aged and Distilled. All rights reserved.
//

#import "ViewController.h"

#import "PopoverSheetView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *showItButton;

- (IBAction)customShowItTapped:(id)sender;
- (IBAction)showItTapped:(id)sender;

@end

@implementation ViewController


- (IBAction)customShowItTapped:(id)sender
{
    PopoverSheetView* popover = [PopoverSheetView new];
    
    [popover showFromView:self.view animated:YES];
}

- (IBAction)showItTapped:(id)sender
{
    UIActionSheet* actionSheet = [UIActionSheet new];
    actionSheet.title = @"This is the title";
    [actionSheet addButtonWithTitle:@"Button 1"];
    [actionSheet addButtonWithTitle:@"Button 2"];

    if ( [sender isKindOfClass:[UIBarButtonItem class]])
    {
        [actionSheet showFromBarButtonItem:sender animated:YES];
    }
    else
    {
        [actionSheet showFromRect:(CGRect){10,10, 100, 100} inView:sender animated:YES];
    }
}

@end
