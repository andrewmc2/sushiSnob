//
//  Sushi.h
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-16.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sushi : NSManagedObject

@property (nonatomic, retain) NSData * cannonicalURL;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * isRatedGood;
@property (nonatomic, retain) NSString * japaneseName;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sushiDescription;
@property (nonatomic, retain) NSData * sushiImage;
@property (nonatomic, retain) NSString * sushiImageURL;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSString * city;

@end
