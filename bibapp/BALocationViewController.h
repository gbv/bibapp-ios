//
//  BALocationViewControllerPad.h
//  bibapp
//
//  Created by Johannes Schultze on 26.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BAAppDelegate.h"
#import "BALocation.h"

@interface BALocationViewController : UIViewController <MKMapViewDelegate>

@property(strong, nonatomic) BAAppDelegate *appDelegate;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UITextView *textView;
@property(strong, nonatomic) BALocation *currentLocation;
@property float spacing;
@property float spacingSplit;
@property float width;
@property float completeHeight;
@property float splitHeightTop;
@property float splitHeightBottom;

- (void)initSize;

@end
