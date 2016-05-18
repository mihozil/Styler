//
//  LoadView.m
//  Styler
//
//  Created by Apple on 4/25/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "LoadView.h"
#import "SignInVC.h"
#import "SWRevealViewController.h"
#import "CreateLink.h"
#import "IOSRequest.h"
#import "ShowActivityIndicatorView.h"

@interface LoadView ()

@end

@implementation LoadView{
    NSDictionary *idCustomer;
    UIActivityIndicatorView *activityIndicatorView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"idcustomer"];
    idCustomer = [[NSUserDefaults standardUserDefaults]objectForKey:@"idcustomer"];
    NSLog(@"idcustomer: %@",idCustomer);
    self.navigationController.navigationBarHidden = YES;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    [ShowActivityIndicatorView startActivityIndicatorView:activityIndicatorView inView:self.view];
    
    [self updateService];
}

- (void) updateService{
    NSString *urlString = @"http://styler.theammobile.com/GET_PRODUCT.php";
    [IOSRequest requestPath:urlString onCompletion:^(NSError*error, NSDictionary*json){
        if (!error){
            NSArray *services = json[@"product"];
            [[NSUserDefaults standardUserDefaults]setObject:services forKey:@"services"];
            if (idCustomer) [self updateData];
            else [self gotoSignIn];
        }else {
            [ShowActivityIndicatorView stopActivityIndicatorView:activityIndicatorView];
        }
    }];
    
}
- (void) updateData{
    //update userData
//    [selgotoHome];
    NSString *url = @"http://styler.theammobile.com/GET_CUSTOMER_INFORMATION_BASIC.php?";
    NSDictionary *paras = @{@"idcustomer":idCustomer};
    NSString *urlString = [CreateLink linkwithUrl:url andparas:paras];
    
    [IOSRequest requestPath:urlString onCompletion:^(NSError*error, NSDictionary*json){
        if (!error){
            [[NSUserDefaults standardUserDefaults]setObject:json forKey:@"userData"];
            [self gotoHome];
        } else {
            [ShowActivityIndicatorView stopActivityIndicatorView:activityIndicatorView];
        }
    }];
}

- (void) gotoSignIn{
    dispatch_async(dispatch_get_main_queue(), ^{
        SignInVC *signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"signinvc"];
        [self.navigationController pushViewController:signIn animated:YES];
        [ShowActivityIndicatorView stopActivityIndicatorView:activityIndicatorView];
    });
    
}

- (void) gotoHome{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SWRevealViewController *swRevealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
        [self.navigationController pushViewController:swRevealVC animated:YES];
        [ShowActivityIndicatorView stopActivityIndicatorView:activityIndicatorView];
    });
}

@end
