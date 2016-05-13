//
//  StylerVC.m
//  Styler
//
//  Created by Apple on 5/5/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "StylerVC.h"

@interface StylerVC ()

@end

@implementation StylerVC{
    NSString *stylerPhone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *stylerData = [[NSUserDefaults standardUserDefaults]objectForKey:@"stylerData"];
    NSData *stylerImgData = stylerData[@"imgData"];
    _stylerImg.image = [UIImage imageWithData:stylerImgData];
    
    _stylerName.text = stylerData[@"name"];
    int rateNo = [stylerData[@"rate"] intValue];
    [_stylerRate setStarsView:rateNo];
    
    stylerPhone = stylerData[@"phonenumber"];
    
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)onCallBt:(id)sender {
    NSString *phoneString = [[NSString alloc]initWithFormat:@"tel:%@",stylerPhone];
    NSURL *phoneUrl = [[NSURL alloc] initWithString:phoneString];
    [[UIApplication sharedApplication]openURL:phoneUrl];
}


@end
