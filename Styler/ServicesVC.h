//
//  ServicesVC.h
//  Styler
//
//  Created by Apple on 4/29/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServicesVC : UIViewController<UIScrollViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *totalPriceLabel;
@property (strong, nonatomic)  UITextField *descriptionTF;
@property (strong, nonatomic)  UIButton *nextBt;
@property (strong, nonatomic)  UIView *nextView;
@property (strong, nonatomic)  UIButton *moveUpBt;

@end
