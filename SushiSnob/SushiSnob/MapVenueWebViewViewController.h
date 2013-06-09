//
//  MapVenueWebViewViewController.h
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapVenueWebViewViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIWebView *venueFSWebView;
@property (strong, nonatomic) NSString *fourSquareVenueWebPage;
@property (strong, nonatomic) id mkAnnotation;



@end
