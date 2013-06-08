//
//  AddSushiViewController.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "AddSushiViewController.h"
#import "LocationManagerSingleton.h"

@interface AddSushiViewController ()
{
    float latitude;
    float longitude;
}
@end

@implementation AddSushiViewController

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
    [self.sushiGoodOrNot setTitle:@"Good!" forSegmentAtIndex:0];
    [self.sushiGoodOrNot setTitle:@"Bad!" forSegmentAtIndex:1];
    latitude = [LocationManagerSingleton sharedSingleton].userLocation.coordinate.latitude;
    longitude = [LocationManagerSingleton sharedSingleton].userLocation.coordinate.longitude;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneAddingSushi:(id)sender {
    //do this later after all inputs are setup
    [self.addSushiDelegate addSushiName:self.sushiNameTextField.text addSushiPicture:self.sushiPic.image addSushiDate:[NSDate date] addSushiGoodOrNot:[self sushiIsGoodOrNot] addSushiDescription:self.sushiDescription.text addSushiCityName:self.sushiCityName.text addLatitude:latitude addLongitude:longitude];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAddingSushi:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (IBAction)changeSushiGoodOrNot:(id)sender {
//    if (self.sushiGoodOrNot.selectedSegmentIndex == 0) {
//        self.sushiIsGood = YES;
//    } else {
//        self.sushiIsGood = NO;
//    }
//}

-(BOOL)sushiIsGoodOrNot
{
    if (self.sushiGoodOrNot.selectedSegmentIndex == 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}


- (IBAction)add4QVenue:(id)sender {
}

- (IBAction)sushiDescriptionRecordVoice:(id)sender {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
