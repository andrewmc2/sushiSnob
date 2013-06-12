//
//  AppDelegate.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "AppDelegate.h"
#import "VenueObject.h"
#import "TabCompassViewController.h"
#import "TabCompassViewController.h"
#import "TabMapViewController.h"

@interface AppDelegate ()
{

NSDictionary* firstDictionary;
//NSArray* itemArray;
NSDictionary *itemDictionary;
NSMutableDictionary*
listVenue;
VenueObject* oneVenue;
NSDictionary *categoryDictionary;
NSMutableArray *categoryArray;
NSMutableDictionary *categoryInfo;
NSMutableDictionary * checkinStats;
NSString *latitudeWithCurrentCoordinates;
NSString *longitudeWithCurrentCoordinates;
float ourFloatLat;
float ourFloatLong;
VenueObject *selectedVenue;
}

-(void)setupManagerContextModel;

@property (nonatomic, strong) NSString * strLatitude;
@property (nonatomic, strong) NSString * strLongitude;

@end


@implementation AppDelegate



NSMutableArray *arrayWithDistance;
TabMapViewController *TBTel;//NSArray *distanceSortedArray;
//NSArray *distanceSortedArray;

-(void)setupManagerContextModel
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectoryURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    NSURL *modelUrl = [[NSBundle mainBundle]URLForResource:@"SushiSnob" withExtension:@"momd"];
    NSURL *persistentStoreDestinationUrl = [documentsDirectoryURL URLByAppendingPathComponent:@"SushiSnob.sqlite"];
    
    //pointing to the model -- what the data looks like -- not the actual data -- sort of like setting up the properties -- model holds data
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    //doesn't create the data -- it simply giving the persistanceStoreCoordinator access to the model
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError *error = nil;
    //so this is where the actual lies
    NSPersistentStore *persistenceStore = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistentStoreDestinationUrl options:nil error:&error];
    
    if (persistenceStore != nil) {
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self setupManagerContextModel];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    UINavigationController *navigationController0 = [[tabBarController viewControllers] objectAtIndex:0];
    TabMapViewController *tabMapViewController = [[navigationController0 viewControllers] objectAtIndex:0];
    tabMapViewController.managedObjectContext = self.managedObjectContext;

    TabCompassViewController *tabCompassViewController = [[tabBarController viewControllers] objectAtIndex:1];
    tabCompassViewController.managedObjectContext = self.managedObjectContext;

    UINavigationController *navigationController2 = [[tabBarController viewControllers] objectAtIndex:2];
    TabMySushiViewController *tabSushiViewController = [[navigationController2 viewControllers] objectAtIndex:0];
    tabSushiViewController.managedObjectContext = self.managedObjectContext;
    [self startStandardLocationServices];
    
    return YES;
}


-(void) startStandardLocationServices
{
    if (nil == self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        // Set a movement threshold for new events.
        self.locationManager.distanceFilter = 500;
        
        [self.locationManager startUpdatingLocation];
        
        if([CLLocationManager headingAvailable]) {
            [self.locationManager startUpdatingHeading];
        } else {
            NSLog(@"No Compass -- You're lost");
        }
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
   self.location = [locations objectAtIndex:0];
    
    CLLocation * ourlocation = [locations lastObject];
//    TabMapViewController * TMAPTest;
//    TMAPTest = [[TabMapViewController alloc] init];
//    [TMAPTest fourSquareParsing];
    
    NSDate* eventDate = ourlocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    NSLog(@"this is from location manager: %f", ourlocation.coordinate.latitude);
    ourFloatLat = ourlocation.coordinate.latitude;
    ourFloatLong = ourlocation.coordinate.longitude;
    self.strLatitude = [NSString stringWithFormat: @"%f", ourlocation.coordinate.latitude];
    self.strLongitude = [NSString stringWithFormat: @"%f", ourlocation.coordinate.longitude];
    
    NSLog(@"this is from viewDidLoad");
    
    NSString *CurrentCoord = [NSString stringWithFormat:@"%@,%@", self.strLatitude, self.strLongitude];
    
    allItems1 = [[NSMutableArray alloc] init];
    self.theItems = [[NSMutableArray alloc] init];
    //TBTel.teleportationArray = [[NSMutableArray alloc] init];

    //self.venueMapView = [[MKMapView alloc]init];
    TabCompassViewController * VCData = [[TabCompassViewController alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%@&query=sushi&oauth_token=R0LICVP1OPDRVUGDTBAY4YQDCCRZKQ20BLR4SNG5XVKZ5T5M", CurrentCoord];
    NSLog(@"The search URL is%@", urlString);
    
    NSURL *url = [NSURL URLWithString: urlString];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue: [NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
     
     {
         
         
         NSDictionary *bigDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSDictionary * venueDictionary = [bigDictionary objectForKey:@"response"];
         NSArray *groupsArray = [venueDictionary objectForKey:@"groups"];
         NSDictionary* subgroupDictionary = [groupsArray objectAtIndex:0];
         itemArray = [subgroupDictionary objectForKey:@"items"];
         
         
         
         for (listVenue in itemArray)
             
         {
             oneVenue = [[VenueObject alloc]init] ;
             
             
             oneVenue.title = [listVenue objectForKey:@"name"];
             oneVenue.fourSquareVenuePage = listVenue [@"canonicalUrl"];
             oneVenue.venueLatitude = listVenue [@"location"][@"lat"];
             oneVenue.venueLongitude = listVenue [@"location"][@"lng"];
             oneVenue.coordinate = CLLocationCoordinate2DMake([oneVenue.venueLatitude floatValue], [oneVenue.venueLongitude floatValue]);
             if (listVenue [@"stats"][@"checkinsCount"] == nil || listVenue [@"stats"][@"checkinsCount"] == NULL)
             {
                 oneVenue.subtitle = @"0";
             } else {
                 NSString * subtitlecheckinPart = [listVenue[@"stats"][@"checkinsCount"] stringValue];
                 oneVenue.subtitle = [NSString stringWithFormat:@"%@ checkins", subtitlecheckinPart];
             }
             categoryArray = [listVenue objectForKey: @"categories"];
             if (categoryArray == nil || categoryArray == NULL || [categoryArray count] == 0)
             {
                 oneVenue.venueCategory = @"Public Space";
             } else {
                 
                 categoryInfo = [categoryArray objectAtIndex:0];
                 oneVenue.venueCategory = [categoryInfo objectForKey:@"name"];
             }
             oneVenue.iconURL = [categoryInfo objectForKey: @"icon"];
             NSURL *NSiconURL = [NSURL URLWithString:oneVenue.iconURL];
             oneVenue.venueTypeIcon = [NSData dataWithContentsOfURL:NSiconURL];
             oneVenue.venueIcon = [[UIImage alloc] initWithData:oneVenue.venueTypeIcon];
             oneVenue.distance = listVenue[@"location"][@"distance"];
             [allItems1 addObject:oneVenue];
             [self.theItems addObject:oneVenue];
             //TBTel.teleportationArray = self.theItems;
    
             
          //   [VCData.FUCKYOU addObject:oneVenue];
         }
         [self sortArray];
     }];
    
    
  //  NSLog(@"tel array %@", TBTel.teleportationArray);

//             [self.venueMapView addAnnotation:oneVenue];
             
}

-(void) sortArray {
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *distanceSortedArray = [[NSArray alloc] init];
    distanceSortedArray = [self.theItems sortedArrayUsingDescriptors:sortDescriptors];
    //self.closestVenue =
    self.closestVenue = [distanceSortedArray objectAtIndex:0];
    //NSLog(@"%@", distanceSortedArray);
    //NSLog(@"%@", self.closestVenue);
    NSLog(@"%@", distanceSortedArray);
    NSLog(@"%@", self.closestVenue);
    
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
