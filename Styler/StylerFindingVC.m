//
//  StylerFindingVC.m
//  Styler
//
//  Created by Apple on 5/4/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "StylerFindingVC.h"
#import <Firebase/Firebase.h>
#import "CreateLink.h"
#import "IOSRequest.h"
#import "StylerVC.h"
#import "ImplementationVC.h"
#import "GetIdProduct.h"
#define DISTANCE 5000;

@interface StylerFindingVC ()

@end

@implementation StylerFindingVC{
    Firebase *ref;
    Firebase *roomRef;
    CLLocation *userLocation;
    NSMutableArray *stylers;
    NSString *stylerID;
    NSDictionary *stylerRoom;
    NSMutableDictionary *stylerData;
    UITapGestureRecognizer *tapStyler;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFirstView];
    [self findAvailableStyler];
}
- (void) initFirstView{
    self.navigationController.navigationBarHidden = YES;
    
    _acceptBt.enabled = NO;
    stylers = [[NSMutableArray alloc]init];
    NSDictionary *userCoordinate = [[NSUserDefaults standardUserDefaults]objectForKey:@"userCoordinate"];
    float lat = [userCoordinate[@"lat"] floatValue];
    float log = [userCoordinate[@"long"] floatValue];
    userLocation = [[CLLocation alloc]initWithLatitude:lat longitude:log];
    
    _stylerImg.image = [UIImage animatedImageNamed:@"tmp-" duration:2.0f];
    tapStyler = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
    tapStyler.enabled = YES;
    tapStyler.numberOfTapsRequired = 1;
    stylerData = [[NSMutableDictionary alloc]init];
    
    ref = [[Firebase alloc]initWithUrl:@"https://stylerapplication.firebaseio.com"];
}
- (void) onTap{
    StylerVC *stylerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stylervc"];
    [self.navigationController pushViewController:stylerVC animated:YES];
}
- (CLLocationDistance) withinDistance:(NSDictionary*)room{
    float lat = [room[@"status"][@"gps_lat1"] floatValue];
    float log = [room[@"status"][@"gps_long1"] floatValue];
    CLLocation *stylerLocation = [[CLLocation alloc]initWithLatitude:lat longitude:log];
    CLLocationDistance distance = [userLocation distanceFromLocation:stylerLocation];
    return distance;
}
- (void) findAvailableStyler{
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot){
        NSDictionary *rooms = snapShot.value;
        NSArray *allKeys = rooms.allKeys;
        NSArray *allValues = rooms.allValues;
        for (int i=0; i<allKeys.count; i++){
            NSDictionary *room = allValues[i];
            if ([room[@"status"][@"status1"] isEqualToString:@"open"])
                
                if ([self withinDistance:room]<5000){
                    // we can save more
                    [stylers addObject:allKeys[i]];
                    
                }
        }
        [self methodologyFindStyler];
        [self updateStylerAccept];
        
    }];
}
- (void) methodologyFindStyler{
    if (stylers.count ==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No available Styler" message:@"We can not find available styler" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
                 [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];

        return;
    }
    int index = arc4random()%stylers.count;
    roomRef = [ref childByAppendingPath:stylers[index]];
    [stylerData setObject:stylers[index] forKey:@"stylerRoom"];
    [self addUserServicetoRoom];
    [self addUserInfotoRoom];
}
- (void) addUserServicetoRoom{
    NSArray *userServices = [[NSUserDefaults standardUserDefaults]objectForKey:@"servicesPicking"];
    NSString *selectedService = [NSString new];
    for (int i=0; i<userServices.count; i++){
        NSString *idProduct = userServices[i][@"idproduct"];
        idProduct = [GetIdProduct getIdProductfromId:idProduct];
        idProduct = [idProduct stringByAppendingString:@","];
        selectedService = [selectedService stringByAppendingString:idProduct];
    }
    [[roomRef childByAppendingPath:@"services_customer"]setValue:selectedService];
}

- (void) addUserInfotoRoom{
    NSString *idCustomer = [[NSUserDefaults standardUserDefaults]objectForKey:@"idcustomer"];
    [[roomRef childByAppendingPath:@"idcustomer"]setValue:idCustomer];
    [[[roomRef childByAppendingPath:@"status"]childByAppendingPath:@"gps_lat2"]setValue:@(userLocation.coordinate.latitude)];
    
    [[[roomRef childByAppendingPath:@"status"]childByAppendingPath:@"gps_long2"]setValue:@(userLocation.coordinate.longitude)];
    [[[roomRef childByAppendingPath:@"status"]childByAppendingPath:@"status1"]setValue:@"waiting"];
}

- (void) updateStylerAccept{
    [[[roomRef childByAppendingPath:@"status"]childByAppendingPath:@"status1"] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot){
        NSString *value = snapShot.value;
        if ([value isEqualToString:@"accept"]){
            [self stylerAccept];
        }else if ([value isEqualToString:@"reject"]){
            [self stylerReject];
            [roomRef removeAllObservers];
        }
    }];
}
- (void) stylerReject{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Stylist reject" message:@"Your stylist has rejected the request" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) stylerAccept{
    [roomRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot){
        NSDictionary *room = snapShot.value;
        stylerRoom = room;
        stylerID = [NSString stringWithFormat:@"%@",room[@"idstylist"]];
        [self getStylerInfoBasic];
        [self getStylerInfoServices];
    }];
}
- (void) getStylerInfoBasic{
    NSString *url =@"http://styler.theammobile.com/stylist/GET_STYLIST_INFORMATION_BASIC.php?";
    NSDictionary *paras = @{@"idstylist":stylerID};
    NSString *urlString = [CreateLink linkwithUrl:url andparas:paras];
    [IOSRequest requestPath:urlString onCompletion:^(NSError*error, NSDictionary*json){
        if (!error){
          [self updateStylerBasic:json];  
        }
        
    }];
    
}
- (void) updateStylerBasic:(NSDictionary*)json{
    [stylerData setObject:json[@"phonenumber"] forKey:@"phonenumber"];
    
    NSString *stylerName = [NSString stringWithFormat:@"%@ %@\n",json[@"firstname"],json[@"lastname"]];
    NSString *distance = [NSString stringWithFormat:@"%2.0fm",[self withinDistance:stylerRoom]];
    [stylerData setObject:stylerName forKey:@"name"];
    
    
    NSString *imgLink = json[@"img"];
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgLink]];
    [stylerData setObject:imgData forKey:@"imgData"];
    if (stylerData[@"rate"]) [self enableTap];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _stylerInfo.text = [stylerName stringByAppendingString:distance];
        _stylerImg.image = [UIImage imageWithData:imgData];
    });
    
    
}
- (void) getStylerInfoServices{
    NSString *url= @"http://styler.theammobile.com/stylist/GET_STYLIST_INFORMATION_SERVICES.php?";
    NSDictionary *paras = @{@"idstylist":stylerID};
    NSString*urlString = [CreateLink linkwithUrl:url andparas:paras];
    [IOSRequest requestPath:urlString onCompletion:^(NSError*error, NSDictionary*json){
        if (!error){
            [self updateStylerService:[json[@"rate"] intValue]];
        }
        
    }];
}
- (void) updateStylerService:(int) rateNo{
    [stylerData setObject:@(rateNo) forKey:@"rate"];
    if (stylerData[@"name"]) [self enableTap];
    dispatch_async(dispatch_get_main_queue(), ^{
            [_rateView setStarsView:rateNo];
    });
}
- (void) enableTap{
    [[NSUserDefaults standardUserDefaults]setObject:stylerData forKey:@"stylerData"];
    [_stylerImg addGestureRecognizer:tapStyler];
    dispatch_async(dispatch_get_main_queue(), ^{
            _acceptBt.enabled = YES;
            _stylerFinding.text = @"Styler available to help you";
    });
    
    
}
- (IBAction)onAcceptBt:(id)sender {
    [[[roomRef childByAppendingPath:@"status"]childByAppendingPath:@"status1"]setValue:@"doing"];
    ImplementationVC *implementationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"implementationvc"];
    [self.navigationController pushViewController:implementationVC animated:YES];
}
- (IBAction)onDeclineBt:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[[roomRef childByAppendingPath:@"status"]childByAppendingPath:@"status1"]setValue:@"open"];
}


@end
