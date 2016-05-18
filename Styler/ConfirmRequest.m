//
//  ConfirmRequest.m
//  Styler
//
//  Created by Apple on 5/3/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ConfirmRequest.h"
#import "StylerFindingVC.h"
#import "ShowAlertView.h"

@interface ConfirmRequest ()

@end

@implementation ConfirmRequest{
    NSArray *servicesPickingArray;
    float keyboardHeight;
    
    PayPalPayment *payment;
    PaymentStatus status;
}
- (void) initPrj{
    _servicesTableView.backgroundColor = [UIColor clearColor];
    servicesPickingArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"servicesPicking"];
    _promotionCodeTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Promotional Code" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _promotionCodeTF.delegate = self;
    _servicesTableView.layer.borderWidth = 1;
    _servicesTableView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardwasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardwasHiden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void) keyBoardwasShown:(NSNotification*)notification{
    CGSize keyboardSize = [[[notification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    keyboardHeight = MIN(keyboardSize.height, keyboardSize.width);
    [self pushView:YES];
}
- (void) keyBoardwasHiden:(NSNotification*)notification{
    [self pushView:NO];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]){
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_promotionCodeTF isFirstResponder]){
        [_promotionCodeTF resignFirstResponder];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPrj];
    [self setTotalPrice];
}
- (void)viewDidAppear:(BOOL)animated{
//    [self createPayPal];
}
//- (void) createPayPal{
//    [PayPal initializeWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX];
//    NSString *totalPrice = _totalPriceLabel.text;
//    totalPrice = [totalPrice stringByReplacingOccurrencesOfString:@" $" withString:@""];
//    payment = [[PayPalPayment alloc]init];
//    payment.subTotal = [NSDecimalNumber decimalNumberWithString:totalPrice];
//    payment.recipient = @"minhnht05.sic-facilitator@gmail.com";
//    payment.paymentCurrency = @"USD";
//    
//    [[PayPal getPayPalInst]checkoutWithPayment:payment];
//    [PayPal getPayPalInst].feePayer = FEEPAYER_SENDER;
//    
//    UIButton *payPalBt = [[PayPal getPayPalInst]getPayButtonWithTarget:self andAction:@selector(onPayPalBt) andButtonType:BUTTON_278x43 andButtonText:BUTTON_TEXT_PAY];
//    payPalBt.frame = CGRectMake(0, 0, _confirmButton.frame.size.width, _confirmButton.frame.size.height);
//    payPalBt.center = _confirmButton.center;

    // temporary remove this code because there is error with Paypal
//    [self.view addSubview:payPalBt];
//    [self.view bringSubviewToFront:payPalBt];
    
//}
- (void) onPayPalBt{
    
    
//    [[PayPal getPayPalInst] preapprovalWithKey:self.preapprovalKey andMerchantName:self.merchantName];
    
}
- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus{
    status = PAYMENT_SUCCESSED;
}
- (void)paymentFailedWithCorrelationID:(NSString *)correlationID{
    status = PAYMENT_FAILED;
}
- (void)paymentCanceled{
    status = PAYMENT_CANCELLED;
}
- (void)paymentLibraryExit{
    switch (status) {
        case PAYMENT_SUCCESSED:{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Payment Success" message:@"Go to find styler" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
                [self gotoStylerFinding];
            }];
            
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:Nil];
            break;
        }
        case PAYMENT_FAILED:
            [ShowAlertView showAlertwithTitle:@"Payment failed" andMessenge:@"please try again" inViewController:self];
            break;
        case PAYMENT_CANCELLED:
            [ShowAlertView showAlertwithTitle:@"Payment cancelled" andMessenge:@"please try again" inViewController:self];
            
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void) setTotalPrice{
    float totalPrice =0;
    NSString *serviceType = [[NSUserDefaults standardUserDefaults]objectForKey:@"serviceType"];
    NSString *priceName = [NSString stringWithFormat:@"price_%@",serviceType];
    
    for (int i=0; i<servicesPickingArray.count;i++){
        totalPrice +=[servicesPickingArray[i][priceName] floatValue];
    }
    _totalPriceLabel.text = [NSString stringWithFormat:@"Total Price: %2.2f $",totalPrice];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return servicesPickingArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell= (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    NSDictionary *service = servicesPickingArray[indexPath.row];
    cell.textLabel.text = service[@"name"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Baskerville" size:17];
    
    NSString *serviceType = [[NSUserDefaults standardUserDefaults]objectForKey:@"serviceType"];
    NSString *priceName = [NSString stringWithFormat:@"price_%@",serviceType];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ $",service[priceName]];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Baskerville" size:17];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void) pushView:(BOOL)moveUp{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect = self.view.frame;
    if (moveUp){
        rect = CGRectMake(0, -keyboardHeight, self.view.frame.size.width, self.view.frame.size.height);
    }else {
        rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (IBAction)onConfirmBt:(id)sender {
    // go to stylerfinding
    [self gotoStylerFinding];
}
- (void) gotoStylerFinding{
    StylerFindingVC *stylerFinding = [self.storyboard instantiateViewControllerWithIdentifier:@"stylerfindingvc"];
    [self.navigationController pushViewController:stylerFinding animated:YES];
}



@end
