//
//  ServicesVC.m
//  Styler
//
//  Created by Apple on 4/29/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ServicesVC.h"
#import "ConfirmRequest.h"
#import "ShowAlertView.h"
#import "PushView.h"

@interface ServicesVC ()

@end

@implementation ServicesVC{
    NSArray *services;
    NSMutableArray *buttonServices;
    NSMutableArray *labelServices;
    float height, margin, distance,labelWidth,frameWidth, keyboardHeight;
    NSDictionary *currentService;
    NSMutableArray *servicePickingArray;
    
    float totalPrice;
}
- (void) initProject{
    [self addNextView];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    totalPrice =0;
    servicePickingArray = [[NSMutableArray alloc]init];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [self.view bringSubviewToFront:_nextView];
    
    height =50;margin=10;distance=50;frameWidth=self.view.frame.size.width;
    labelWidth = frameWidth/2 - margin-height-margin/2;
    
    buttonServices = [[NSMutableArray alloc]init];
    labelServices = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasHiden) name:UIKeyboardDidHideNotification object:nil];
    
    _descriptionTF.delegate = self;
  
}
- (void) keyboardWasShown:(NSNotification*)notification{
    CGSize keyboardSize = [[[notification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    keyboardHeight = MIN(keyboardSize.width, keyboardSize.height);
    [PushView pushView:self.view distance:-keyboardHeight];
    
}
- (void) keyboardWasHiden{
    [PushView pushView:self.view distance:keyboardHeight];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    services = [[NSUserDefaults standardUserDefaults]objectForKey:@"services"];
    [self initProject];
    [self drawServices];
}

- (void) addNextView{
    _nextView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 140)];
    _nextView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_nextView];
    
    _moveUpBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _moveUpBt.titleLabel.font = [UIFont fontWithName:@"Avenir Medium" size:20];
    [_moveUpBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_moveUpBt setTitle:@"....." forState:UIControlStateNormal];
    [_moveUpBt addTarget:self action:@selector(onMoveupBt:) forControlEvents:UIControlEventTouchDown];
    [_nextView addSubview:_moveUpBt];
    
    _totalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, self.view.frame.size.width-50, 50)];
    _totalPriceLabel.text = @"Total Price";
    _totalPriceLabel.textAlignment = NSTextAlignmentCenter;
    _totalPriceLabel.textColor = [UIColor whiteColor];
    _totalPriceLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:20];
    [_nextView addSubview:_totalPriceLabel];
    
    _descriptionTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 50, self.view.frame.size.width-40, 40)];
    _descriptionTF.backgroundColor = [UIColor whiteColor];
    _descriptionTF.font = [UIFont fontWithName:@"Baskerville" size:20];
    _descriptionTF.placeholder = @"Description - optional";
    _descriptionTF.borderStyle = UITextBorderStyleRoundedRect;
    [_nextView addSubview:_descriptionTF];
    
    _nextBt = [[UIButton alloc]initWithFrame:CGRectMake(20, 90, self.view.frame.size.width-40, 50)];
    [_nextBt setTitle:@"Next" forState:UIControlStateNormal];
    _nextBt.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:25];
    [_nextBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBt addTarget:self action:@selector(onNextBt:) forControlEvents:UIControlEventTouchDown];
    [_nextView addSubview:_nextBt];
    
}

- (void) drawServices{
    NSString *lastCatgr = @"";
    float x=margin;float y=self.navigationController.navigationBar.frame.size.height+height/2;
    
    for (int i=0; i<services.count; i++){
        currentService = services[i];
        // from the above's bottom to this
        if (![lastCatgr isEqualToString:currentService[@"category"]]){
            
            lastCatgr = currentService[@"category"];
            if (x==margin){
                [self addCategorywithX:x andY:y andName:lastCatgr];
                y=y+height*1.5;
            }else {
                x=margin;y=y+height*2;
                [self addCategorywithX:x andY:y andName:lastCatgr];
                y=y+height*1.5;
            }
        }
        
        [self addServicewithX:x andY:y andi:i];
        
        if (x==margin){
            x=frameWidth/2+margin;
        }else {
            x=margin;y=y+height*2;
        }
    }
    
    _scrollView.contentSize = CGSizeMake(frameWidth,y+height*2);
    
}
- (void) addCategorywithX:(float)x andY:(float)y andName:(NSString*)name{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, height-10, height-10)];
    NSString *ImgName = [NSString stringWithFormat:@"%@.png",[name lowercaseString]];
    imgView.image = [UIImage imageNamed:ImgName];
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(x+height, y, labelWidth*2, height)];
    newLabel.text = currentService[@"category"];
    newLabel.font = [UIFont fontWithName:@"Baskerville-Bold" size:25];
    [_scrollView addSubview:imgView];
    [_scrollView addSubview:newLabel];
    
}
- (void) addServicewithX:(float)x andY:(float)y andi:(int)i{
    UIButton *newButton = [[UIButton alloc]initWithFrame:CGRectMake(x, y, height, height)];
    newButton.tag = i;
    [[newButton layer]setBorderWidth:2.0f];
    [[newButton layer]setBorderColor:[UIColor purpleColor].CGColor];
    [newButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    [buttonServices addObject:newButton];
    [_scrollView addSubview:newButton];
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(x+height+margin/2, y-10, labelWidth, height+20)];
    newLabel.text = currentService[@"name"];
    newLabel.font = [UIFont fontWithName:@"Baskerville" size:17];
    newLabel.numberOfLines=0;
    [labelServices addObject:newLabel];
    [_scrollView addSubview:newLabel];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_nextView.frame.origin.y<self.view.frame.size.height-60){
        [PushView pushView:_nextView distance:90];
    }
    if ([_descriptionTF isFirstResponder]){
        [_descriptionTF resignFirstResponder];
    }
}
- (IBAction)onMoveupBt:(id)sender {
    if (_nextView.frame.origin.y>self.view.frame.size.height-60){
        [PushView pushView:_nextView distance:-90];
    }
}

- (void) onButton:(id)sender{
    NSInteger index = [sender tag];
    if (![sender imageForState:UIControlStateNormal]){
        [sender setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
        [servicePickingArray addObject:services[index]];
        [self updatePrice:index moveUp:YES];
    }else {
        [sender setImage:nil forState:UIControlStateNormal];
        [servicePickingArray removeObject:services[index]];
        [self updatePrice:index moveUp:NO];
    }
}
- (void) updatePrice:(NSInteger)index moveUp:(BOOL)moveUp{
    NSDictionary *service = services[index];
    NSString *serviceType = [[NSUserDefaults standardUserDefaults]objectForKey:@"serviceType"];
    NSString *priceName = [NSString stringWithFormat:@"price_%@",serviceType];
    if (moveUp) totalPrice +=[service[priceName] floatValue];
    else totalPrice -= [service[priceName] floatValue];
    _totalPriceLabel.text = [NSString stringWithFormat:@"Total price: %2.2fUSD",totalPrice];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]){
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)onNextBt:(id)sender {
    if (servicePickingArray.count==0){
        [ShowAlertView showAlertwithTitle:@"Error" andMessenge:@"You must pick at least 1 service" inViewController:self];
        return;
    }
    [[NSUserDefaults standardUserDefaults]setObject:servicePickingArray forKey:@"servicesPicking"];
    ConfirmRequest *confirmRequest = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmrequest"];
    [self.navigationController pushViewController:confirmRequest animated:YES];
    
}


@end
