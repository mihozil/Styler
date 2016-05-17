//
//  ImplementationVC.m
//  Styler
//
//  Created by Apple on 5/5/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ImplementationVC.h"
#import <Firebase/Firebase.h>
#import "ConfirmRequest.h"
#import "ShowAlertView.h"
#import "SWRevealViewController.h"
#import "StylerVC.h"
#import "ReceiptVC.h"
#import "ShowAlertView.h"
#import "ConfirmRequest.h"

@interface ImplementationVC ()

@end

@implementation ImplementationVC{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D userCoordinate;
    NSDictionary *stylerData;
    Firebase *ref, *roomRef;
    MKPointAnnotation *stylerAnnotation;
    NSTimer*timer;
    int timeCount;
    NSString*stylerStatus;
    UIView*tapView;
}
- (void) initPrj{
    self.navigationController.navigationBarHidden = NO;
    
    stylerData = [[NSUserDefaults standardUserDefaults]objectForKey:@"stylerData"];
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=8){
        [locationManager requestWhenInUseAuthorization];
    }
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    userCoordinate = CLLocationCoordinate2DMake(0, 0);
    ref = [[Firebase alloc]initWithUrl:@"https://stylerapplication.firebaseio.com/rooms"];
    
    SWRevealViewController *swReveal = self.revealViewController;
    tapView = [[UIView alloc]initWithFrame:self.view.frame];
    tapView.backgroundColor = [UIColor clearColor];
    self.revealViewController.delegate = self;
    if (swReveal){
        [_menuBarBt setTarget:self.revealViewController];
        [_menuBarBt setAction:@selector(revealToggle:)];
        [tapView addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position{
    if (position==FrontViewPositionRight){
        [self.view addSubview:tapView];
    } else if (position == FrontViewPositionLeft){
        [tapView removeFromSuperview];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [locationManager startUpdatingLocation];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [locationManager stopUpdatingLocation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self notifyRequestSuccessful];
    [self initPrj];
    [self addStyler];
    [self updateCancel];

}
- (void) notifyRequestSuccessful{
    [ShowAlertView showAlertwithTitle:@"Request successfully" andMessenge:@"Your request has been successfully created" inViewController:self];
}
- (void) updateLabel{
    _freeCancelLabel.text = [NSString stringWithFormat:@"Free Cancel:\n%dmin %ds",timeCount/60,timeCount%60];
}
- (void) updateCancel{
    timeCount= 20;
    [self updateLabel];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
}
- (void) onTimer{
    timeCount-=1;
    [self updateLabel];
    if (timeCount==0){
        [timer invalidate];
        _freeCancelLabel.text = nil;
        _cancelImg.image = nil;
    }
    
}
- (void) addStyler{
    NSString *stylerRoom = [stylerData objectForKey:@"stylerRoom"];
    stylerStatus = [NSString stringWithFormat:@"doing"];
    roomRef = [ref childByAppendingPath:stylerRoom];
    [roomRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapShot){
        NSDictionary *room = snapShot.value;
        stylerStatus = room[@"status"][@"status1"];
        if ([stylerStatus isEqualToString:@"begin"]){
            [self notifyBegin];
        }
        if ([stylerStatus isEqualToString:@"complete"]){
            [self gotoReceipt];
        }
        if ([stylerStatus isEqualToString:@"cancel"]){
            [self serviceCanceled];
        }
        [self updateStylerPosition:room];
    }];
}
- (void) serviceCanceled{
    [ShowAlertView showAlertwithTitle:@"Service Cancelled" andMessenge:@"You styler has cancelled the service" inViewController:self];
    for (UIViewController *viewController in self.navigationController.viewControllers ){
        if ([viewController isKindOfClass:[ConfirmRequest class]]){
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }
    }
    // this may be deleted
    [roomRef removeAllObservers];
}

- (void) notifyBegin{
    [ShowAlertView showAlertwithTitle:@"Begin Service" andMessenge:@"The service has been began" inViewController:self];
}
- (void) gotoReceipt{
    ReceiptVC *receiptVC = [self.storyboard instantiateViewControllerWithIdentifier:@"receiptvc"];
    [self.navigationController pushViewController:receiptVC animated:YES];
    
    
}
- (void) updateStylerPosition:(NSDictionary*) room{
    float lat = [room[@"status"][@"gps_lat1"] floatValue];
    float log = [room[@"status"][@"gps_long1"] floatValue];
    
    if (!stylerAnnotation) {
        stylerAnnotation = [[MKPointAnnotation alloc] init];
        stylerAnnotation.title = @"Styler Moving";
        [_mapView addAnnotation:stylerAnnotation];
    }
    stylerAnnotation.coordinate = CLLocationCoordinate2DMake(lat, log);
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *ann= nil;
    if (annotation!=_mapView.userLocation){
        ann = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationViewCell"];
        ann.canShowCallout = YES;
        if (!ann)
            ann = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationViewCell"];
        ann.image = [self imageWithImage:[UIImage imageNamed:@"car.png"] convertToSize:CGSizeMake(46, 46)];
        
    }
    return ann;
}
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

-(void) recenterMap{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance((userCoordinate), 2000, 2000);
    [_mapView setRegion:region];
    [_mapView setMapType:MKMapTypeStandard];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if ((userCoordinate.latitude!=0) || (userCoordinate.longitude!=0))return;
    userCoordinate = [locations lastObject].coordinate;
    [self recenterMap];
}

- (IBAction)cancelBt:(id)sender {
    if ([stylerStatus isEqualToString:@"doing"]){
        if (timeCount>0) [self freeCancel];
        if (timeCount==0) [self chargedCancel];
    }else [self cancelInvalid];
    
   
    
}
- (void) freeCancel{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Do you want to cancel" message:@"You can have a free cancel now" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        if (timeCount>0) {
         [self gotoRequestVC];
         [self updateRoomRefCancel];
            [roomRef removeAllObservers];
        }
        else [self chargedCancel];
        // add later
        
    }];
    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:actionYES];
    [alertController addAction:actionNO];
    [self presentViewController: alertController animated:YES completion:nil];
}

- (void) chargedCancel{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Do you want to cancel" message:@"Time out - You will be charged 10$" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        if ([stylerStatus isEqualToString:@"begin"]) [self cancelInvalid];
        else {
            [self gotoRequestVC];
            [self updateRoomRefCancel];
            [roomRef removeAllObservers];
        }
    }];
    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:actionYES];
    [alertController addAction:actionNO];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void) updateRoomRefCancel{
    [[[roomRef childByAppendingPath:@"status"]childByAppendingPath:@"status1"]setValue:@"cancel"];
}
- (void) cancelInvalid{
    [ShowAlertView showAlertwithTitle:@"CancelInvalid" andMessenge:@"The service has been begun" inViewController:self];
}
- (void) gotoRequestVC{
    for (UIViewController*viewController in [self.navigationController viewControllers]) {
        if ([viewController isKindOfClass:[ConfirmRequest class]]){
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
}
                                          
- (IBAction)contactStylerBt:(id)sender {
    StylerVC *stylerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stylervc"];
    [self.navigationController pushViewController:stylerVC animated:YES];
}


@end
