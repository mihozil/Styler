//
//  ReceiptVC.m
//  Styler
//
//  Created by Apple on 5/7/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ReceiptVC.h"
#import "ShareServiceVC.h"

@interface ReceiptVC ()

@end

@implementation ReceiptVC{
    NSArray*services;
    UITapGestureRecognizer *tap;
    int rateNo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self setDate];
    [self setServices];
    [self setStyler];
    [self setTap];
    
}
- (void) setTap{
    [_rateView setStarsView:0];
    rateNo=0;
    tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
    tap.numberOfTapsRequired= 1;
    tap.enabled = YES;
    [_rateView addGestureRecognizer:tap];
}
- (void) onTap{
    float starSize = MIN(_rateView.frame.size.height, _rateView.frame.size.width/5);
    CGPoint tapLocation = [tap locationInView:_rateView];
    rateNo = tapLocation.x/starSize+1;
    [_rateView setStarsView:rateNo];
    
}
- (void) setDate{
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString*dateString = [[NSDate date]descriptionWithLocale:currentLocale];
    _dateLabel.text = [dateString componentsSeparatedByString:@" at"][0];
}
-  (void) setServices{
    services = [[NSUserDefaults standardUserDefaults]objectForKey:@"servicesPicking"];
//    NSLog(@"services: %@",services);
    float totalPrice=0;
    NSString *servicesString = [NSString new];
    for (int i=0; i<services.count; i++){
        NSDictionary*service = services[i];
        
        NSString *priceType = [[NSUserDefaults standardUserDefaults]objectForKey:@"serviceType"];
        NSString *priceName = [NSString stringWithFormat:@"price_%@",priceType];
        totalPrice+=[service[priceName] floatValue];
        
        servicesString = [servicesString stringByAppendingString:service[@"name"]];
        servicesString = [servicesString stringByAppendingString:@"\n"];
        
    }
    
    _servicesTextView.text = servicesString;
    _priceLabel.text = [NSString stringWithFormat:@"Price: %2.2f",totalPrice];
}

- (void) setStyler{
    NSDictionary *stylerData = [[NSUserDefaults standardUserDefaults]objectForKey:@"stylerData"];
    NSData *stylerImgData = stylerData[@"imgData"];
    _userImg.image = [UIImage imageWithData:stylerImgData];
    
    _stylerNameLabel.text = stylerData[@"name"];

}

- (IBAction)onSubmit:(id)sender {
//    [[NSUserDefaults standardUserDefaults]setObject:@(rateNo) forKey:@"rateNo"];
    ShareServiceVC *shareService = [self.storyboard instantiateViewControllerWithIdentifier:@"shareservicevc"];
    [self.navigationController pushViewController:shareService animated:YES];
}



@end
