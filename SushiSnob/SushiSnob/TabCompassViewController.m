//
//  TabCompassViewController.m
//  SushiSnob
//
//  Created by MasterRyuX on 6/8/13.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import "TabCompassViewController.h"
#import "VenueObject.h"
#import "AppDelegate.h"

@interface TabCompassViewController ()

{
    VenueObject* oneVenue;
    NSMutableArray *arrayWithDistance;
    NSArray *distanceSortedArray;
    NSString *latitudeWithCurrentCoordinates;
    NSString *longitudeWithCurrentCoordinates;
    float ourPhoneFloatLat;
    float ourPhoneFloatLong;
    VenueObject *selectedVenue;
    NSMutableArray * allItems1;
    AppDelegate *appDelegate ;
}

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiandsToDegrees(x) (x * 180.0 / M_PI)

@property (nonatomic, strong) NSString * strLatitude;
@property (nonatomic, strong) NSString * strLongitude;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL headingDidStartUpdating;

@end

@implementation TabCompassViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self startStandardLocationServices];
    


    
}

-(void)setupCompassObjectsAndLabels

{
    VenueObject * thisNearPlace = [[VenueObject alloc] init];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    thisNearPlace = appDelegate.closestVenue;
    
    NSString *nearPlaceName = thisNearPlace.title;
    NSLog(@"%@", nearPlaceName);
    self.closeSushiLabel.text = nearPlaceName;


}

-(void) startStandardLocationServices
{
    locationManager=[[CLLocationManager alloc] init];
	locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
	locationManager.headingFilter = 1;
	locationManager.delegate=self;
    
    [locationManager startUpdatingLocation];
    
    if([CLLocationManager headingAvailable]) {
        
        [locationManager startUpdatingHeading];
    } else {
        NSLog(@"Location Heading/Compass FAIL");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power
    CLLocation* startLocation = [locations lastObject];
//    NSDate* eventDate = startLocation.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    if (abs(howRecent) < 15.0) {
        ourPhoneFloatLat = startLocation.coordinate.latitude;
        ourPhoneFloatLong = startLocation.coordinate.longitude;
        self.strLatitude = [NSString stringWithFormat: @"%f", startLocation.coordinate.latitude];
        self.strLongitude = [NSString stringWithFormat: @"%f", startLocation.coordinate.longitude];
//    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
//    if (!self.headingDidStartUpdating) {
//        [self setupCompassObjectsAndLabels];
//        self.headingDidStartUpdating = YES;
//    }
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    VenueObject * thisNearPlace = [[VenueObject alloc] init];
    
    
    thisNearPlace = appDelegate.closestVenue;
    
    NSString *nearPlaceName = thisNearPlace.title;
    NSLog(@"%@", nearPlaceName);
    self.closeSushiLabel.text = nearPlaceName;
    
    thisVenueLat = [appDelegate.closestVenue.venueLatitude floatValue];
    thisVenueLong = [appDelegate.closestVenue.venueLongitude floatValue];
    
    float radcurrentLat = degreesToRadians(ourPhoneFloatLat);
    float radcurrentLong = degreesToRadians(ourPhoneFloatLong);
    float radthisVenueLat = degreesToRadians(thisVenueLat);
    float radthisVenueLong = degreesToRadians(thisVenueLong);
    float deltLat = (radthisVenueLat - radcurrentLat);
    float deltLong = (radthisVenueLong - radcurrentLong);
    
    float y = sinf(deltLong) * cosf(radthisVenueLat);
    float x = (cosf(radcurrentLat) * sinf(radthisVenueLat)) - ((sinf(radcurrentLat) *cosf(radthisVenueLat)) * cosf(deltLong));
    float radRotateAngle = atan2f(y, x);
    float initialVenueBearing = radRotateAngle;
    float VenueBearDeg;
    
    float initialVenueBearingDegrees = initialVenueBearing * 180/M_PI;
    
    if (initialVenueBearingDegrees < 0) {
        VenueBearDeg = initialVenueBearingDegrees + 360;
    }
    else{
        VenueBearDeg = initialVenueBearingDegrees;
    };
    
    NSLog(@"Initial bearing/initial angle rotation in degrees is = %f", VenueBearDeg);
    float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
    //
    float newRad =  newHeading.trueHeading * M_PI / 180.0f;
    float managerheadRad = manager.heading.trueHeading * M_PI/180.0f;
    float newHeadingRad = newHeading.trueHeading * M_PI /180.0f;
    float angleCalc;
    if (newHeading.magneticHeading > VenueBearDeg)
    {angleCalc = -(newHeading.magneticHeading - VenueBearDeg);
    }
    else
    { angleCalc = VenueBearDeg - newHeading.magneticHeading;
        
    }
    //float angleCalc = (VenueBearDeg - newHeading.magneticHeading);
    
   // NSLog(@"%@", self.nearestPlaceLabel.text);
    float radAngleCalc = angleCalc * M_PI / 180.0f;
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    theAnimation.duration = .8f;
    [self.saiImage.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
    
    //float currentPointerDeg =
    
    self.saiImage.transform = CGAffineTransformMakeRotation(radAngleCalc);
    
    
    
    NSLog(@"magnetic heading now is %f", newHeading.magneticHeading);
}



- (void)viewDidAppear:(BOOL)animated {
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationUpdated)
                                                 name:@"locationUpdated"
                                               object:nil];
    NSLog(@"We're subscribed.");
    // NSLog(@"%@", appDelegate.theItems);
    
    
    if (appDelegate.location) {
        [self locationUpdated];
        NSLog(@"Already had the location.");
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"locationUpdated" object:nil];
}

- (void)locationUpdated {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self locationManager:nil didUpdateLocations:[NSArray arrayWithObject:appDelegate.location]];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end