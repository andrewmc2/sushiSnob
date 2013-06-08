//
//  VenueObject.h
//  SushiSnob
//
//  Created by Craig on 6/7/13.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VenueObject : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString  *venueName;
@property (strong, nonatomic) NSString  *address;
@property (strong, nonatomic) NSString  *venueLatitude;
@property (strong, nonatomic) NSString  *venueLongitude;
@property (strong, nonatomic) NSString  *distance;
@property (strong, nonatomic) NSString  *checkinsCount;
@property (strong, nonatomic) NSString  *rating;
@property (strong, nonatomic) NSString  *hours;
@property (strong, nonatomic) NSString  *fourSquareVenuePage;
@property (strong, nonatomic) NSString  *subtitle;
@property (strong, nonatomic) NSString  *title;

@property (nonatomic) CLLocationCoordinate2D coordinate;




@end
