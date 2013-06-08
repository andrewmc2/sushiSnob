//
//  AddSushiViewController.h
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSushiDelegate.h"


@interface AddSushiViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *sushiPictureViewHolder;
@property (strong, nonatomic) IBOutlet UIImageView *sushiPic;
@property (strong, nonatomic) IBOutlet UITextField *sushiNameTextField;
@property (strong, nonatomic) IBOutlet UILabel *sushiDate;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sushiGoodOrNot;
@property (strong, nonatomic) IBOutlet UITextField *sushiDescription;
@property (strong, nonatomic) IBOutlet UILabel *sushiCityName;

@property (nonatomic) BOOL sushiIsGood;

@property (strong, nonatomic) id <AddSushiDelegate> addSushiDelegate;

- (IBAction)doneAddingSushi:(id)sender;
- (IBAction)cancelAddingSushi:(id)sender;

//- (IBAction)changeSushiGoodOrNot:(id)sender;


- (IBAction)add4QVenue:(id)sender;
- (IBAction)sushiDescriptionRecordVoice:(id)sender;

@end
