//
//  TabMapViewController.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

//
//  TabMapViewController.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "TabMapViewController.h"
#import "LocationManagerSingleton.h"
#import "Sushi.h"
#import "VenueObject.h"
#import "MapVenueWebViewViewController.h"
#import "VenueTableViewController.h"
#import "AppDelegate.h"

@interface TabMapViewController ()
@property (strong, nonatomic) CLLocationManager *mapLocationManager;
@end

//float userLatitude;
//float userLongitude;
VenueObject *selectedVenue;

//NSMutableDictionary *listVenue;
//NSMutableArray * parsedAnnotations;
//float startingUserLocationFloatLat;
//float startingUserLocationFloatLong;



@implementation TabMapViewController

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
    [super viewDidLoad];

    
   
}


-(void) viewDidAppear:(BOOL)animated
{

    [self setMapZoom];

    
}

-(void) setMapZoom
{
    
    //[appDelegate1 did

    
   // userLatitude = [LocationManagerSingleton sharedSingleton].userLocation.coordinate.latitude;
   // userLongitude = [LocationManagerSingleton sharedSingleton].userLocation.coordinate.longitude;
    
    //CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake (userLatitude, userLongitude);
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake (startingUserLocationFloatLat, startingUserLocationFloatLong);
    MKCoordinateSpan span = MKCoordinateSpanMake(.05, .05);
    MKCoordinateRegion region = MKCoordinateRegionMake(mapCenter, span);
    self.venueMapView.region = region;
    
    AppDelegate *appDelegate1 = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    [self.venueMapView addAnnotations:appDelegate1.fourSquareVenueObjectsArray];
  }
   
     


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Map Annotation

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    mapView.showsUserLocation = YES;

    NSString *reuseIdentifier = @"myIdentifier";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        ((MKPinAnnotationView *)(annotationView)).animatesDrop = YES;
    } else {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    selectedVenue = ((VenueObject *)(view.annotation));
    [self performSegueWithIdentifier:@"pushWebView" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushWebView"]) {
        MapVenueWebViewViewController *mapVenueWebViewController = segue.destinationViewController;
        mapVenueWebViewController.mkAnnotation = [self.venueMapView selectedAnnotations][0];
        mapVenueWebViewController.fourSquareVenueWebPage = selectedVenue.fourSquareVenuePage;
    }
    
}




//- (IBAction)showLocation:(id)sender {
//    NSLog(@"%f lat",[LocationManagerSingleton sharedSingleton].userLocation.coordinate.latitude);
//    NSLog(@"number of venue: %i", venueArray.count);
//}


@end

