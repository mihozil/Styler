//
//  SetViewMoveUp.m
//  Styler
//
//  Created by Apple on 4/27/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "SetViewMoveUp.h"
#define kOFFSET_FOR_KEYBOARD 100

@implementation SetViewMoveUp
+(void) setViewMoveUp:(BOOL)movedUp inView:(UIView*)view{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    view.frame = rect;
    
    [UIView commitAnimations];
}


@end
