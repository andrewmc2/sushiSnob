//
//  VenueObject.h
//  SushiSnob
//
//  Created by Craig on 6/7/13.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenueObject : NSObject

@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) NSString  *placeID;
@property (strong, nonatomic) NSString  *subTitle;
@property (strong, nonatomic) NSString  *address;
@property (strong, nonatomic) NSString  *placeLatitude;
@property (strong, nonatomic) NSString  *placeLongitude;
@property (strong, nonatomic) NSString  *distance;
@property (strong, nonatomic) NSString  *imageURL;
@property (strong, nonatomic) NSString  *iconURL;
@property (strong, nonatomic) NSString  *venueURL;
@property (strong, nonatomic) NSString  *venueCategory;
@property (strong, nonatomic) NSString  *rating;
@property (strong, nonatomic) NSString  *hours;
@property (strong, nonatomic) NSString  *additionalInfo;

@property (strong, nonatomic) UIImage   *venueIcon;
@property (strong, nonatomic) UIImage   *venueBigPic;
@property (strong, nonatomic) NSData    *venueTypeIcon;
@property (strong, nonatomic) NSData    *venuePic;

@property (strong, nonatomic) NSMutableDictionary *hugeDictionary;
//@property (nonatomic) CLLocationCoordinate2D coordinate;




@end
