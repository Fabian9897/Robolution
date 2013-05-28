//
//  MapViewController.h
//  Robolution
//
//  Created by Praktikant on 27.05.13.
//  Copyright (c) 2013 baniaf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController
{
    MKMapView *mapView;

}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
