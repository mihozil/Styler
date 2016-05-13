//
//  ShareServiceVC.m
//  Styler
//
//  Created by Apple on 5/7/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ShareServiceVC.h"
#import <Social/Social.h>
#import "SWRevealViewController.h"


@interface ShareServiceVC ()

@end

@implementation ShareServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onShareFacebook:(id)sender {
    FBSDKShareLinkContent *shareLink = [[FBSDKShareLinkContent alloc]init];
    shareLink.contentURL = [NSURL URLWithString:@"https://www.facebook.com/people/Nguyễn-Trần-Huyền-My/100001193631520"];
    [FBSDKShareDialog showFromViewController:self withContent:shareLink delegate:nil];
    
}

- (IBAction)onShareGoogle:(id)sender {
    NSURL *shareUrl = [NSURL URLWithString:@"https://www.facebook.com/people/Nguyễn-Trần-Huyền-My/100001193631520"];
    NSURLComponents *urlComponents = [[NSURLComponents alloc]initWithString:@"https://plus.google.com/share"];

    urlComponents.queryItems = @[[[NSURLQueryItem alloc]
                                  initWithName:@"url"
                                  value:[shareUrl absoluteString]]];
    NSURL *url = [urlComponents URL];
    
    if ([SFSafariViewController class]){
        SFSafariViewController *controller = [[SFSafariViewController alloc]initWithURL:url];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }else {
        [[UIApplication sharedApplication]openURL:url];
        
    }
    
    
    
}
- (IBAction)onHomeBt:(id)sender {
    SWRevealViewController *swRevealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
    [self.navigationController pushViewController:swRevealVC animated:YES];
}

- (IBAction)onShareTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet addURL:[NSURL URLWithString:@"http://blogtintuconline.net/hinh-anh-a-hau-huyen-my-8844.html"]];
        [self presentViewController: tweetSheet animated:YES completion:nil];
    }
}

@end
