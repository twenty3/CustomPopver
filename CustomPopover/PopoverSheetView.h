//
//  PopoverSheetView.h
//  CustomPopover
//
//  Created by 23 on 6/15/13.
//  Copyright (c) 2013 Aged and Distilled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverSheetView : UIView

- (void) showFromView:(UIView*)view animated:(BOOL)animated;
    // presents the Popover in an animated manner

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;


@end
