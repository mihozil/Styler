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
    shareLink.contentURL = [NSURL URLWithString:@"https://www.facebook.com/theAMmobile/"];
    [FBSDKShareDialog showFromViewController:self withContent:shareLink delegate:nil];
    
}

- (IBAction)onShareGoogle:(id)sender {
    NSURL *shareUrl = [NSURL URLWithString:@"https://www.facebook.com/theAMmobile/"];
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
        [tweetSheet addURL:[NSURL URLWithString:@"https://www.facebook.com/theAMmobile/"]];
        [self presentViewController: tweetSheet animated:YES completion:nil];
    }
}

@end
