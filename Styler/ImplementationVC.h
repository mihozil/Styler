//
//  ImplementationVC.h
//  Styler
//
//  Created by Apple on 5/5/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ImplementationVC : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *freeCancelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cancelImg;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarBt;

@end
