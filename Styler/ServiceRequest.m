//
//  ServiceRequest.m
//  Styler
//
//  Created by Apple on 4/26/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ServiceRequest.h"
#import "SWRevealViewController.h"
#import <Firebase/Firebase.h>
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "SPGooglePlacesPlaceDetailQuery.h"
#import "SPGooglePlacesAutocompleteUtilities.h"
#import "ShowAlertView.h"
#import "ServicesVC.h"
#import "UpdateNotification.h"



@interface ServiceRequest ()
@property (strong, nonatomic) UIView *nextView;
@end

@implementation ServiceRequest{
    int numberOfTap;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D userCoordinate;
    Firebase *ref;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    NSArray *searchResultPlaces;
    MKPointAnnotation *userAnnotation;
    UIView *tapView;
    NSTimer *timer;
    BOOL viewWillAppear;
}
    NSString *const juniorExplain= @"You should choose Junior Service because it is cheap";
    NSString *const seniorExplain= @"Senior is quite more expensive. But it is OK";
    NSString *const superStarExplain = @"This is the very luxury services, but it worths";

- (void) initProject{
//    NSDictionary *userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"userData"];
//    NSLog(@"userDat: %@",userData);
//    
//    NSString *email = [[NSUserDefaults standardUserDefaults]objectForKey:@"email"];
//    NSLog(@"email: %@",email);
//    
//    NSString *idCustomer = [[NSUserDefaults standardUserDefaults]objectForKey:@"idcustomer"];
//    NSLog(@"idCustomer: %@",idCustomer);
    viewWillAppear = NO;
    numberOfTap = 0;
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    ref = [[Firebase alloc]initWithUrl:@"https://stylerapplication.firebaseio.com/rooms"];
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc]init];
    searchQuery.radius = 100;
    userCoordinate = CLLocationCoordinate2DMake(0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initProject];
    [self addNextView];
    [self initMenuBt];
    [self initMapView];
    [self updateNotification];
}
- (void) updateNotification{
    UpdateNotification *updateNoti = [[UpdateNotification alloc]init];
    [updateNoti updateNoti];

}
- (void) addNextView{
    _nextView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 200)];
    _nextView.backgroundColor = [UIColor blackColor];
    
    _chooseService = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _nextView.frame.size.width, 50)];
    [_chooseService setTitle:@"Choose Service Type" forState:UIControlStateNormal];
    _chooseService.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:20];
    [_chooseService addTarget:self action:@selector(onChooseServiceBt:) forControlEvents:UIControlEventTouchUpInside];
    [_nextView addSubview:_chooseService];
    
    _serviceTypeSegment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Junior",@"Senior",@"Super Star", nil]];
    _serviceTypeSegment.frame = CGRectMake(5, 50, _nextView.frame.size.width-10, 40);
    [_serviceTypeSegment addTarget:self action:@selector(onSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    _serviceTypeSegment.selectedSegmentIndex = 0;
    _serviceTypeSegment.tintColor = [UIColor whiteColor];
    _serviceTypeSegment.layer.borderColor = [UIColor whiteColor].CGColor;
    [_nextView addSubview:_serviceTypeSegment];
    
    _explainTF = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, _nextView.frame.size.width,50)];
    _explainTF.textAlignment = NSTextAlignmentCenter;
    _explainTF.font = [UIFont fontWithName:@"Baskerville" size:16];
    _explainTF.textColor = [UIColor whiteColor];
    _explainTF.text = juniorExplain;
    _explainTF.numberOfLines = 0;
    [_nextView addSubview:_explainTF];
    
    _nextButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 140, _nextView.frame.size.width, 60)];
    [_nextButton addTarget:self action:@selector(onNextButton:) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setTitle:@"Next" forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:25];
    [_nextView addSubview:_nextButton];
    
    [self.view addSubview:_nextView];
    
}

- (void)onChooseServiceBt:(id)sender {
    if (_nextView.frame.origin.y>self.view.frame.size.height-60){
        [self pushView:YES];
    }
}

- (void) explainServiceType{
    switch (_serviceTypeSegment.selectedSegmentIndex) {
        case 0:{
            _explainTF.text = juniorExplain;
            break;
        }
        case 1:{
            _explainTF.text = seniorExplain;
            break;
        }
        case 2:{
            _explainTF.text = superStarExplain;
            break;
        }
        default:
            break;
    }
}

- (void) pushView:(BOOL)moveUp{
    float moveDistance;
    if (moveUp) moveDistance =-150;
    else moveDistance = 150;
    [UIView animateWithDuration:0.3 animations:^{
    
        _nextView.frame = CGRectOffset(_nextView.frame, 0, moveDistance);
    }];
}

- (void) initMapView{
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8){
        [locationManager requestWhenInUseAuthorization];
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [locationManager startUpdatingLocation];
    viewWillAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidAppear:YES];
    [ref removeAllObservers];
    [locationManager stopUpdatingLocation];
}

- (void) initMenuBt{
    self.revealViewController.delegate = self;
    tapView = [[UIView alloc]initWithFrame:self.view.frame];
    tapView.backgroundColor = [UIColor clearColor];
    
    SWRevealViewController *revealVC = self.revealViewController;
    if (revealVC){
        [_menuBt setTarget:self.revealViewController];
        [_menuBt setAction:@selector(revealToggle:)];
        [tapView addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position{
    if (position == FrontViewPositionRight){
        [self.view addSubview:tapView];
        [self.view bringSubviewToFront:tapView];
        
    }else if (position == FrontViewPositionLeft){
        
        [tapView removeFromSuperview];
        
    }
}

- (void)onSegmentChanged:(id)sender {
    [self explainServiceType];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (viewWillAppear ==YES){
        viewWillAppear =NO;
        userCoordinate = userLocation.coordinate;
        [self recenterMap];
    }
}


- (void) recenterMap{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userCoordinate, 2000, 2000);
    [_mapView setRegion:region];
    [_mapView setMapType:MKMapTypeStandard];
    [self drawStylers];
}

- (void) drawStylers{
    [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot*snapShot){
        
        NSDictionary *room = snapShot.value;
        if ([room[@"status"][@"status1"] isEqualToString:@"open"]){
            float lat = [room[@"status"][@"gps_lat1"] floatValue];
            float log = [room[@"status"][@"gps_long1"] floatValue];
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
            annotation.coordinate = CLLocationCoordinate2DMake(lat, log);
            [self.mapView addAnnotation:annotation];
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *annView = nil;
    if (annotation!=_mapView.userLocation){
        annView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationViewCell"];
        annView.canShowCallout = YES;
        if (!annView){
            annView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationViewCell"];
        }
        if (annotation!=userAnnotation){
            annView.image = [self imageWithImage:[UIImage imageNamed:@"styler_waiting.png"] convertToSize:CGSizeMake(46, 46)];
        }else annView.image = [self imageWithImage:[UIImage imageNamed:@"userwaiting.png"] convertToSize:CGSizeMake(46, 46)];
        
    }
    return annView;
}
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    searchQuery.input = searchText;
    searchQuery.location = userCoordinate;
    [searchQuery fetchPlaces:^(NSArray*places, NSError*error){
        if (error){
            [ShowAlertView showAlertwithTitle:@"Error fetching places" andMessenge:nil inViewController:self];
        }else {
            if (!searchResultPlaces) searchResultPlaces = [NSArray arrayWithArray:places];
            else searchResultPlaces = places;
            // need to reload tableView
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}
- (void) dismissViewControllerWhileStayingActive{
    [self.searchDisplayController setActive:NO animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *searchPath = [self placeAtIndexPath:indexPath].name;
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder geocodeAddressString:searchPath completionHandler:^(NSArray*placeMarks, NSError*error){
        CLPlacemark *placeMark = [placeMarks lastObject];
        userCoordinate = placeMark.location.coordinate;
        [self addServicePositionAnnotation];
        [self recenterMap];
        [self dismissViewControllerWhileStayingActive];
        [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
}
- (void) addServicePositionAnnotation{
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc]init];
    pointAnnotation.coordinate = userCoordinate;
    pointAnnotation.title = @"Service Location";
    [_mapView removeAnnotation:userAnnotation];
    [_mapView addAnnotation:pointAnnotation];
    userAnnotation = pointAnnotation;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchResultPlaces.count;
}

- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return [searchResultPlaces objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    
    return cell;
}
- (void) onNextButton:(id)sender {
    if ((userCoordinate.latitude==0) && (userCoordinate.longitude ==0)) {
        [ShowAlertView showAlertwithTitle:@"Data Loading" andMessenge:@"Please wait" inViewController:self];
        return;
    }
    
    [self updateServiceType];
    [self updateUserCoordinate];
    
    ServicesVC *servicesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"servicesvc"];
    [self.navigationController pushViewController:servicesVC animated:YES];
    
}
- (void) updateUserCoordinate{
    NSDictionary *userLocation = @{@"lat":@(userCoordinate.latitude),@"long":@(userCoordinate.longitude)};
    [[NSUserDefaults standardUserDefaults]setObject:userLocation forKey:@"userCoordinate"];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSArray *allTouch = [touches allObjects];
    CGPoint touchPoint = [[allTouch firstObject] locationInView:self.view];
    if (touchPoint.y< _nextView.frame.origin.y)
    if (_nextView.frame.origin.y<self.view.frame.size.height-60){
        [self pushView:NO];
    }
}

- (void) updateServiceType{
    NSString *serviceType = [_serviceTypeSegment titleForSegmentAtIndex:[_serviceTypeSegment selectedSegmentIndex]];
    serviceType = [serviceType lowercaseString];
    serviceType = [serviceType stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults]setObject:serviceType forKey:@"serviceType"];
}


@end
