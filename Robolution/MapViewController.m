//
//  MapViewController.m
//  Robolution
//
//  Created by Praktikant on 27.05.13.
//  Copyright (c) 2013 baniaf. All rights reserved.
//

#import "MapViewController.h"
@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
 
  /*
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
    
    
    CLLocationCoordinate2D annotationCoord;
    
     
    annotationCoord.latitude = 51.051937;
    annotationCoord.longitude = 13.806534;
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = @"Tyclipso";
    annotationPoint.subtitle = @"www.tyclipso.net, Hüblerstraße 1";
    [mapView addAnnotation:annotationPoint];
    [mapView setRegion:region animated:NO];
    [super viewDidLoad];

*/	
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
