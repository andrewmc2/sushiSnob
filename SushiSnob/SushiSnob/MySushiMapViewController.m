//
//  MySushiMapViewController.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "MySushiMapViewController.h"
#import "SushiDetailMKAnnotation.h"
#import "Sushi.h"
#import "SushiAnnotationView.h"

@interface MySushiMapViewController ()

@end

@implementation MySushiMapViewController

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
    self.fileManager = [NSFileManager defaultManager];
    self.documentsDirectory = [self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    [self displayPhotoPins];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.15, 0.15);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(41.9, -87.65);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    self.mySushiMapView.region = region;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayPhotoPins
{
    for (Sushi *currentSushi in self.fetchedSushiResults) {
        SushiDetailMKAnnotation *sushiDetailMKAnnotation = [[SushiDetailMKAnnotation alloc] init];
        sushiDetailMKAnnotation.title = currentSushi.name;
        sushiDetailMKAnnotation.subtitle = currentSushi.venue;
        sushiDetailMKAnnotation.coordinate = CLLocationCoordinate2DMake([currentSushi.latitude doubleValue], [currentSushi.longitude doubleValue]);
        
        NSString *fileName = currentSushi.sushiImageURL;
        if (fileName != nil) {
            NSURL *localImageURL = [self.documentsDirectory URLByAppendingPathComponent:fileName];
//            sushiDetailMKAnnotation.image = [UIImage imageWithContentsOfFile:localImageURL.path];
            sushiDetailMKAnnotation.image = [UIImage imageNamed:@"sushi.jpg"];
        } else {
            sushiDetailMKAnnotation.image = [UIImage imageNamed:@"sushi.jpeg"];
        }
        
        [self.mySushiMapView addAnnotation:sushiDetailMKAnnotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    NSString *reuseID = @"reuseID";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
    
    if (annotationView == nil) {
        annotationView = [[SushiAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
        annotationView.canShowCallout = YES;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithImage:annotationView.image];
        myImageView.frame = CGRectMake(0, 0, 31, 31);
        annotationView.leftCalloutAccessoryView = myImageView;
        
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    } else {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
}

@end
