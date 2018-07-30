//
//  BALocationViewControllerPad.m
//  bibapp
//
//  Created by Johannes Schultze on 26.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BALocationViewController.h"
#import "BALocalizeHelper.h"

#define METERS_PER_MILE 1609.344

@interface BALocationViewController ()

@end

@implementation BALocationViewController

@synthesize width;
@synthesize mapViewHeight;
@synthesize textViewHeight;
@synthesize top;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initSize{
    self.width = 0;
    self.mapViewHeight = 0;
    self.textViewHeight = 0;
    self.top = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSize];
    
	// Do any additional setup after loading the view.
    
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //[self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.navigationItem setTitle:BALocalizedString(@"Standort")];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.mapViewHeight)];
    self.mapView.delegate=self;
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    MKMapView *tempMapView = self.mapView;
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.textViewHeight)];
    [self.textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.textView setScrollEnabled:YES];
    [self.textView setEditable:NO];
    [self.textView setDataDetectorTypes:UIDataDetectorTypeAll];
    UITextView *tempTextView = self.textView;
    [self.view addSubview:tempTextView];
    
    BOOL hasGeo = NO;
    if (self.currentLocation.geoLong != nil && self.currentLocation.geoLat != nil) {
        if (![self.currentLocation.geoLong isEqualToString:@""] && ![self.currentLocation.geoLat isEqualToString:@""]) {
            hasGeo = YES;
            [self.view addSubview:tempMapView];
            NSArray *constraintsVerticalMapView = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[tempMapView(%f)]", self.top, self.mapViewHeight]
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:NSDictionaryOfVariableBindings(tempMapView)];
            
            [self.view addConstraints:constraintsVerticalMapView];
            NSArray *constraintsHorizontalMapView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tempMapView]|"
                                                                                            options:0
                                                                                            metrics:nil
                                                                                              views:NSDictionaryOfVariableBindings(tempMapView)];
            
            [self.view addConstraints:constraintsHorizontalMapView];
            
            
            NSArray *constraintsVerticalMapAndTextView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[tempMapView]-[tempTextView]"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:NSDictionaryOfVariableBindings(tempMapView, tempTextView)];
            
            [self.view addConstraints:constraintsVerticalMapAndTextView];
            
            NSArray *constraintsVerticalTextView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[tempTextView]|"
                                                                                                 options:0
                                                                                                 metrics:nil
                                                                                                   views:NSDictionaryOfVariableBindings(tempTextView)];
            
            [self.view addConstraints:constraintsVerticalTextView];
            
            NSArray *constraintsHorizontalTextView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tempTextView]|"
                                                                                            options:0
                                                                                            metrics:nil
                                                                                              views:NSDictionaryOfVariableBindings(tempTextView)];
            
            [self.view addConstraints:constraintsHorizontalTextView];
        }
    }
    if (!hasGeo) {
        NSArray *constraintsVerticalTextView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tempTextView]|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:NSDictionaryOfVariableBindings(tempTextView)];
        
        [self.view addConstraints:constraintsVerticalTextView];
        
        NSArray *constraintsHorizontalTextView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tempTextView]|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(tempTextView)];
        
        [self.view addConstraints:constraintsHorizontalTextView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [self.currentLocation.geoLat floatValue];
    zoomLocation.longitude = [self.currentLocation.geoLong floatValue];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    CLLocationCoordinate2D annotationCoord;
    annotationCoord.latitude = [self.currentLocation.geoLat floatValue];
    annotationCoord.longitude = [self.currentLocation.geoLong floatValue];
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = self.currentLocation.name;
    [self.mapView addAnnotation:annotationPoint];
    
    NSMutableString *addressString = [[NSMutableString alloc] init];
    
    if (self.currentLocation.name != nil) {
        if (![self.currentLocation.name isEqualToString:@""]) {
            [addressString appendFormat:@"%@", self.currentLocation.name];
        }
    }
    
    if (self.currentLocation.address != nil) {
        if (![self.currentLocation.address isEqualToString:@""]) {
            [addressString appendFormat:@"\n%@", self.currentLocation.address];
        }
    }
    
    if (self.currentLocation.phone != nil) {
        if (![self.currentLocation.phone isEqualToString:@""]) {
            [addressString appendFormat:@"\n\n%@", self.currentLocation.phone];
        }
    }
    
    if (self.currentLocation.email != nil) {
        if (![self.currentLocation.email isEqualToString:@""]) {
            [addressString appendFormat:@"\n\n%@", self.currentLocation.email];
        }
    }
    
    if (self.currentLocation.url != nil) {
        if (![self.currentLocation.url isEqualToString:@""]) {
            [addressString appendFormat:@"\n\n%@", self.currentLocation.url];
        }
    }
    
    if (self.currentLocation.openinghours != nil) {
        if (![self.currentLocation.openinghours isEqualToString:@""]) {
            [addressString appendFormat:@"\n\n%@", self.currentLocation.openinghours];
        }
    }
    
    if (self.currentLocation.desc != nil) {
        if (![self.currentLocation.desc isEqualToString:@""]) {
            [addressString appendFormat:@"\n\n%@", self.currentLocation.desc];
        }
    }
    
    [self.textView setText:addressString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
