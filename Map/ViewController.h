//
//  ViewController.h
//  Map
//
//  Created by Admin on 12/12/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyAnnotationView.h"

@interface ViewController : UIViewController   <MKMapViewDelegate ,CLLocationManagerDelegate ,MKAnnotation , UIGestureRecognizerDelegate>
@property (nonatomic,strong) CLLocationManager *manager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

