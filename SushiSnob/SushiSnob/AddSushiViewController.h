//
//  AddSushiViewController.h
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSushiDelegate.h"
//for picture taking
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import <CoreLocation/CoreLocation.h>
#import "AddVenueVC.h"
#import "VenueDelegate.h"



@interface AddSushiViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, VenueDelegate>

@property (strong, nonatomic) IBOutlet UIView *sushiPictureViewHolder;
@property (strong, nonatomic) IBOutlet UIImageView *sushiPic;

@property (strong, nonatomic) IBOutlet UITextField *sushiDescription;
@property (strong, nonatomic) IBOutlet UILabel *sushiCityName;
@property (nonatomic) BOOL sushiIsBad;

//for pic taking
@property (strong, nonatomic) UIImage *selectedImage;
@property (weak, nonatomic) IBOutlet UILabel *addSushiPictureLabel;
@property (weak, nonatomic) IBOutlet UIView *takePictureView;
@property (weak, nonatomic) IBOutlet UIImageView *takePictureViewImageView;

//for sushi name
@property (strong, nonatomic) IBOutlet UITextField *sushiNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *sushiNameLabel;
@property (weak, nonatomic) IBOutlet UIView *addSushiNameView;
@property (weak, nonatomic) IBOutlet UIImageView *addSushiNameImageView;

//for venue
@property (strong, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UIView *addVenueView;
@property (weak, nonatomic) IBOutlet UIImageView *addVenueViewImageView;

//good or bad


//type



@property (strong, nonatomic) id <AddSushiDelegate> addSushiDelegate;

//nav bar
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;




- (IBAction)doneAddingSushi:(id)sender;
- (IBAction)cancelAddingSushi:(id)sender;

//- (IBAction)changeSushiGoodOrNot:(id)sender;

- (IBAction)add4QVenue:(id)sender;

@end

//NSArray *distanceSortedArray;
