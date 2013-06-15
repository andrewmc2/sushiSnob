//
//  SushiDetailViewController.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "SushiDetailViewController.h"
#import "SushiDetailMKAnnotation.h"

@interface SushiDetailViewController ()

@end

@implementation SushiDetailViewController

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
    
    NSString *fileName = self.selectedSushi.sushiImageURL;
    if (fileName != nil) {
        NSURL *localImageURL = [self.documentsDirectory URLByAppendingPathComponent:fileName];
        self.sushiDetailImage.image = [UIImage imageWithContentsOfFile:localImageURL.path];
    } else {
        self.sushiDetailImage.image = [UIImage imageNamed:@"sushi.jpeg"];
    }
    
    self.sushiDetailName.text = self.selectedSushi.name;
    self.sushiDetailVenue.text = self.selectedSushi.venue;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.sushiDetailDate.text = [dateFormatter stringFromDate:self.selectedSushi.date];
    self.sushiDetailNotes.text = self.selectedSushi.sushiDescription;
    
    //do city later after updating core data file
    NSString *boolString = [NSString stringWithFormat:@"%@", self.selectedSushi.isRatedGood];
    
    if ([boolString isEqualToString:@"1"]) {
        self.xImage.hidden = YES;
    } else {
        self.xImage.hidden = NO;
    }
    
    [self setMapZoom];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setMapZoom
{
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake([self.selectedSushi.latitude doubleValue], [self.selectedSushi.longitude doubleValue]);
    MKCoordinateSpan span = MKCoordinateSpanMake(.05, .05);
    MKCoordinateRegion region = MKCoordinateRegionMake(mapCenter, span);
    self.sushiDetailMapView.region = region;
    
    SushiDetailMKAnnotation *sushiDetailMKAnnotation = [[SushiDetailMKAnnotation alloc] init];
    sushiDetailMKAnnotation.coordinate = CLLocationCoordinate2DMake([self.selectedSushi.latitude doubleValue], [self.selectedSushi.longitude doubleValue]);
    [self.sushiDetailMapView addAnnotation:sushiDetailMKAnnotation];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *reuseIdentifier = @"myIdentifier";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        ((MKPinAnnotationView *)(annotationView)).animatesDrop = YES;
    } else {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}


@end
