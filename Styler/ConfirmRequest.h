//
//  ConfirmRequest.h
//  Styler
//
//  Created by Apple on 5/3/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPal.h"
#import "PayPalPayment.h"

typedef enum PaymentStatuses{
    PAYMENT_SUCCESSED,
    PAYMENT_FAILED,
    PAYMENT_CANCELLED
}PaymentStatus;

@interface ConfirmRequest : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,PayPalPaymentDelegate>
@property (weak, nonatomic) IBOutlet UITableView *servicesTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *promotionCodeTF;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@end
