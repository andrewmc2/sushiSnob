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

@interface TabMapViewController ()

@end

float userLatitude;
float userLongitude;
NSString *userLatitudeString;
NSString *userLongitudeString;
NSArray *itemArray;
NSMutableDictionary *listVenue;


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
	// Do any additional setup after loading the view.
    [[LocationManagerSingleton sharedSingleton] describe];
    
       

}

-(void) viewDidAppear:(BOOL)animated
{
    [self setMapZoom];
    
}

-(void) setMapZoom
{
    
    userLatitude = [LocationManagerSingleton sharedSingleton].userLocation.coordinate.latitude;
    userLongitude = [LocationManagerSingleton sharedSingleton].userLocation.coordinate.longitude;
    
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake (userLatitude, userLongitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(.05, .05);
    MKCoordinateRegion region = MKCoordinateRegionMake(mapCenter, span);
    self.venueMapView.region = region;
    self.venueMapView.showsUserLocation = YES;
    
    NSLog(@"%f", userLatitude);
    
}



-(void) fourSquareParsing
{
    
    
   userLongitudeString = [NSString stringWithFormat:@"%f",userLongitude];
    userLatitudeString = [NSString stringWithFormat:@"%f", userLatitude];
    NSString *currentCoordinate = [NSString stringWithFormat:@"%@%@", userLatitudeString, userLongitudeString];
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%@&query=sushi&oauth_token=R0LICVP1OPDRVUGDTBAY4YQDCCRZKQ20BLR4SNG5XVKZ5T5M", currentCoordinate];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
                               NSDictionary *mainDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               NSDictionary *venueDictionary = [mainDictionary objectForKey:@"response"];
                               NSArray *groupsArray = [venueDictionary objectForKey:@"groups"];
                               NSDictionary *subGroupDictionary = [groupsArray objectAtIndex:0];
                               itemArray = [subGroupDictionary objectForKey:@"items"];
                               
                               for (listVenue in itemArray) {
                                   VenueObject *venueObject = [[VenueObject alloc]init];
                               }
                               
                               
                           }];//end of Block

    
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showLocation:(id)sender {
 NSLog(@"%f lat",[LocationManagerSingleton sharedSingleton].userLocation.coordinate.latitude);
    
}
@end
