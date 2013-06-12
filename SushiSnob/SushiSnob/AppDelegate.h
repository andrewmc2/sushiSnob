//
//  AppDelegate.h
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import "TabMapViewController.h"
#import "TabCompassViewController.h"
#import "TabMySushiViewController.h"
#import "VenueObject.h"


@class TabMySushiViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate,MKMapViewDelegate>

@property (strong, nonatomic) UIWindow *window;

//core data stuff
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//location stuff
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic)CLLocationManager*locationManager;
@property (strong, nonatomic) NSMutableArray * fourSquareVenueObjectsArray;
@property (strong, nonatomic) VenueObject * closestVenue;

- (void) startStandardLocationServices;
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

@end