//
//  ViewController.m
//  Map
//
//  Created by Admin on 12/12/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CLLocation *location;
    NSString *temp;
    NSString *place;
}

@end

@implementation ViewController
@synthesize coordinate= _coordinate;
@synthesize mapView=_mapView;

-(BOOL)FindTemperature:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"reome boundar");
   // NSString *temp;
    NSLog(@"GESTUR");
    CGPoint touchlocation = [gestureRecognizer locationInView:self.mapView];
    NSLog(@"gesture");
    CLLocationCoordinate2D pressedloc = [self.mapView convertPoint:touchlocation toCoordinateFromView:self.mapView];
    NSLog(@"GESTUR %f %f %f",touchlocation.x,pressedloc.latitude,pressedloc.longitude );
    NSString *strng = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=f9675edab0ac78f3ba98c6d57c63dfb1",pressedloc.latitude,pressedloc.longitude];
    // NSString *strng = @"http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&APPID=f9675edab0ac78f3ba98c6d57c63dfb1";
    NSURL *url = [NSURL URLWithString:strng];
    NSURLSessionDataTask *dataTask = [[ NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"completion handler");
        //self.imgView.image = [ UIImage imageWithData:data];
        if(error ==nil)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"json %@",json);
            NSLog(@"%@", [[json objectForKey:@"main"] objectForKey:@"temp"]);
            temp = [NSString stringWithFormat:@"%@",[[json objectForKey:@"main"] objectForKey:@"temp"]];
            place = [json objectForKey:@"place"];
            [dataTask resume];
            MyAnnotationView *annot = [[MyAnnotationView alloc]init];
            annot.coordinate = CLLocationCoordinate2DMake(pressedloc.latitude,pressedloc.longitude );
            NSLog(@"Coordinate %f %f", pressedloc.latitude,pressedloc.longitude);
            annot.title = [json objectForKey:@"name"];
            annot.subtitle =temp;
            //Need main thread to update on UI.
            //Without main thread it will not update UI on the View
            dispatch_async(dispatch_get_main_queue(), ^ {
                
                [self.mapView addAnnotation:annot];
                
           });
            

                    }
        else
        {
            NSLog(@"ERRor %@", error);
        }
    }];[dataTask resume];
    


    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[CLLocationManager alloc]init];
    self.manager.delegate = self;
    [self.manager requestAlwaysAuthorization];
    [self.manager requestWhenInUseAuthorization];
    [self.manager startUpdatingLocation];
    NSString *address = @"CURRENT ADDRESS";
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placemark = placemarks[0];
        location = placemark.location;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 800, 800);
        [self.mapView setRegion:region animated:NO];
        MyAnnotationView *annot = [[MyAnnotationView alloc]init];
        annot.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        annot.title = @"My Home";
        annot.subtitle = @"My Place";
        [self.mapView addAnnotation:annot];
             
   
    
  //  api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&APPID={APIKEY}
    NSLog(@"Coordinate %f %f", location.coordinate.latitude,location.coordinate.longitude);
    
    NSString *strng = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=f9675edab0ac78f3ba98c6d57c63dfb1",location.coordinate.latitude,location.coordinate.longitude];
   // NSString *strng = @"http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&APPID=f9675edab0ac78f3ba98c6d57c63dfb1";
                       NSURL *url = [NSURL URLWithString:strng];
    NSURLSessionDataTask *dataTask = [[ NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"completion handler");
        //self.imgView.image = [ UIImage imageWithData:data];
        if(error ==nil)
        {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"json %@",json);
       NSLog(@"%@", [[json objectForKey:@"main"] objectForKey:@"temp"]);
        }
        else
        {
            NSLog(@"ERRor %@", error);
        }
    }];
    [dataTask resume];

 }];

    UILongPressGestureRecognizer *doubleLongPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(FindTemperature:)];
    
    //[doubleLongPressGesture setNumberOfTouchesRequired:2];
    doubleLongPressGesture.delegate = self;
    
    [self.mapView addGestureRecognizer:doubleLongPressGesture];

}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(locations[0].coordinate, 800, 800);
    [self.mapView setRegion:region animated:NO];
    
}

-(void)getMapCoordinateFromTouch:(UILongPressGestureRecognizer *) gesture{
    if(gesture.state == UIGestureRecognizerStateBegan){
        CGPoint touchlocation = [gesture locationInView:self.mapView];
        NSLog(@"gesture");
       // pressedloc = [self.mapView convertPoint:touchlocation toCoordinateFromView:self.mapView];
       // [self createBundarywithRadius:.1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
