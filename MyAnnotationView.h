//
//  MyAnnotationView.h
//  Map
//
//  Created by Admin on 12/15/16.
//  Copyright © 2016 Admin. All rights reserved.
//




#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotationView : NSObject <MKAnnotation>{
    
    NSString *title;
    NSString *subtitle;
    NSString *note;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;

@end
