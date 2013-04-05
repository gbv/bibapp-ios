//
//  BALocationViewControllerPad.m
//  bibapp
//
//  Created by Johannes Schultze on 26.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BALocationViewController.h"

#define METERS_PER_MILE 1609.344

@interface BALocationViewController ()

@end

@implementation BALocationViewController

@synthesize spacing;
@synthesize spacingSplit;
@synthesize width;
@synthesize splitHeightTop;
@synthesize splitHeightBottom;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initSize{
    self.spacing = 0;
    self.spacingSplit = 0;
    self.width = 0;
    self.splitHeightTop = 0;
    self.splitHeightBottom = 0;
    self.completeHeight = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSize];
    
	// Do any additional setup after loading the view.
    
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(self.spacing, self.spacing, self.width, self.splitHeightTop)];
    self.mapView.delegate=self;
    
    BOOL hasGeo = NO;
    if (self.currentLocation.geoLong != nil && self.currentLocation.geoLat != nil) {
        if (![self.currentLocation.geoLong isEqualToString:@""] && ![self.currentLocation.geoLat isEqualToString:@""]) {
            hasGeo = YES;
            [self.view addSubview:self.mapView];
            self.textView = [[UITextView alloc] initWithFrame:CGRectMake(self.spacing, self.spacingSplit, self.width, self.splitHeightBottom)];
            [self.view addSubview:self.textView];
        }
    }
    if (!hasGeo) {
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(self.spacing, self.spacing, self.width, self.completeHeight)];
        [self.view addSubview:self.textView];
    }
    
    [self.textView setScrollEnabled:YES];
    [self.textView setEditable:NO];
    [self.textView setDataDetectorTypes:UIDataDetectorTypeAll];
}

- (void)viewWillAppear:(BOOL)animated
{
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Code for dissmissing this viewController by clicking outside it
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizer setNumberOfTapsRequired:1];
    recognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    [self.view.window addGestureRecognizer:recognizer];
    
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
        //Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil]) {
            // Remove the recognizer first so it's view.window is valid.
            [self.view.window removeGestureRecognizer:sender];
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

@end
