//
//  ServiceRequest.h
//  Styler
//
//  Created by Apple on 4/26/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SWRevealViewController.h"

@interface ServiceRequest : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate,UISearchControllerDelegate, UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBt;

@property (strong, nonatomic) UISegmentedControl *serviceTypeSegment;
@property (strong, nonatomic) UILabel *explainTF;
@property (strong, nonatomic) UIButton *chooseService;
@property (nonatomic, strong) UIButton *nextButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
