//
//  AddSushiViewController.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "AddSushiViewController.h"

@interface AddSushiViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneAddingSushi:(id)sender {
    //do this later after all inputs are setup
    
//    [self.addSushiDelegate addSushiName:self.sushiNameTextField.text addSushiPicture:nil addSushiDate:[NSDate date] addSushiGoodOrNot:YES addSushiDescription:self.sushiDescription.text addSushiCityName:self.sushiCityName.text];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAddingSushi:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)add4QVenue:(id)sender {
}

- (IBAction)sushiDescriptionRecordVoice:(id)sender {
}
@end
