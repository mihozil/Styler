//
//  RateView.m
//  Styler
//
//  Created by Apple on 5/4/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "RateView.h"

@implementation RateView
- (void) setStarsView:(int)index{
    float starSize = MIN(self.frame.size.height, self.frame.size.width/5);
    for (UIImageView*imgView in self.subviews){
        [imgView removeFromSuperview];
    }
    for (int i=0; i<5; i++){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*starSize, 0, starSize, starSize)];
        if (i<index){
            imgView.image = [UIImage imageNamed:@"star.png"];
        }else {
            imgView.image = [UIImage imageNamed:@"starno.png"];
        }
    
        [self addSubview:imgView];
    }
}



@end
