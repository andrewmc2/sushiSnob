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
	locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter =  kCLDistanceFilterNone;
	locationManager.headingFilter = kCLHeadingFilterNone;
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
    
    
    thisDistVenueLat = [appDelegate.closestVenue.venueLatitude floatValue];
    thisDistVenueLong = [appDelegate.closestVenue.venueLongitude floatValue];
  //  give latitude2,lang of destination   and latitude,longitude of first place.
    
    //this function return distance in kilometer.
    
    float DistRadCurrentLat = degreesToRadians(startLocation.coordinate.latitude);
    float DistRadCurrentLong = degreesToRadians(startLocation.coordinate.longitude);
    float DistRadthisVenueLat = degreesToRadians(thisDistVenueLat);
    float DistRadthisVenueLong = degreesToRadians(thisDistVenueLong);
    //float deltLat = (radthisVenueLat - radcurrentLat);
    float deltDistLat = (DistRadthisVenueLat - DistRadCurrentLat);
    float deltDistLong = (DistRadthisVenueLong - DistRadCurrentLong);
    
    float a = (sinf(deltDistLat/2) * sinf(deltDistLat/2)) + ((sinf(deltDistLong/2) * sinf(deltDistLong/2)) * cosf(DistRadCurrentLat) * cosf(DistRadthisVenueLat));
    NSLog(@"%f", a);
    
    float srootA = sqrtf(a);
    float srootoneMinusA = sqrtf((1-a));
    
    float c = (2 * atan2f(srootA, srootoneMinusA));
    
    float distBetweenStartandVenueKilometers = (c * 6371); //radius of earth
    NSLog (@"%f", distBetweenStartandVenueKilometers);
    
    float distBetweenStartandVenueFeet = (distBetweenStartandVenueKilometers/3281);
    
    NSLog (@"%f", distBetweenStartandVenueFeet);
    self.theDistance = [[NSString alloc] init];
    self.theDistance = [NSString stringWithFormat:@"%f", distBetweenStartandVenueKilometers];
    
    self.theDistanceLabel.text = self.theDistance;
    
    //    var R = 6371; // km
//    var dLat = (lat2-lat1).toRad();
//    var dLon = (lon2-lon1).toRad();
//    var lat1 = lat1.toRad();
//    var lat2 = lat2.toRad();
//    
//    var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
//    Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2);
//    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
//    var d = R * c;
//    
//    //(acos(sin()));
//    
    
//    -(double)distanceFilter:(double) latitude2 :(double)lang{
//        double distance=(((acos(sin((latitude*M_PI/180)) * sin((latitude2*M_PI/180))+cos((latitude*M_PI/180)) * cos((latitude2*M_PI/180)) * cos(((longitude- lang)*M_PI/180))))*180/M_PI)*60*1.1515*1.609344);
//        
//        return distance;
//    }
//    
//    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    if (!self.headingDidStartUpdating) {
        [self setupCompassObjectsAndLabels];
        self.headingDidStartUpdating = YES;
    }
    
    thisVenueLat = [appDelegate.closestVenue.venueLatitude floatValue];
    thisVenueLong = [appDelegate.closestVenue.venueLongitude floatValue];
    
    float radcurrentLat = degreesToRadians(ourPhoneFloatLat);
    float radcurrentLong = degreesToRadians(ourPhoneFloatLong);
    float radthisVenueLat = degreesToRadians(thisVenueLat);
    float radthisVenueLong = degreesToRadians(thisVenueLong);
    //float deltLat = (radthisVenueLat - radcurrentLat);
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
    

   // NSLog(@"Initial bearing/initial angle rotation from north in degrees is = %f", VenueBearDeg);
    VenueObject * thisNearPlace = [[VenueObject alloc] init];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    thisNearPlace = appDelegate.closestVenue;

    
    NSString *nearPlaceName = thisNearPlace.title;
    NSLog(@"%@", nearPlaceName);
    self.closeSushiLabel.text = nearPlaceName;

    //trig calculations necessary to display additional navigation information (distance, etc, spherical of cosines).
   // float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
    //
    //float newRad =  newHeading.trueHeading * M_PI / 180.0f;
    //float managerheadRad = manager.heading.trueHeading * M_PI/180.0f;
    //float newHeadingRad = newHeading.trueHeading * M_PI /180.0f;
    float angleCalc;
    if (newHeading.trueHeading > VenueBearDeg)
    {angleCalc = -(newHeading.trueHeading - VenueBearDeg);
    }
    else
    {angleCalc = VenueBearDeg - newHeading.trueHeading;
    }
    //float angleCalc = (VenueBearDeg - newHeading.magneticHeading);
    
   // NSLog(@"%@", self.nearestPlaceLabel.text);
    float radAngleCalc = angleCalc * M_PI / 180.0f;
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    //theAnimation.fromValue = [NSNumber numberWithFloat:0];
    //theAnimation.toValue=[NSNumber numberWithFloat:radAngleCalc];
    theAnimation.duration = 1.2f;
    self.closeSushiLabel.text = nearPlaceName;
    [self.saiImage.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
    self.saiImage.transform = CGAffineTransformMakeRotation(radAngleCalc);
    //NSLog(@"true heading is %f", newHeading.trueHeading);

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[locationManager stopUpdatingHeading];
    [locationManager pausesLocationUpdatesAutomatically];// Or pause
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end