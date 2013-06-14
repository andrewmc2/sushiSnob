//
//  TabMySushiViewController.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "TabMySushiViewController.h"
#import "LocationManagerSingleton.h"
#import "AddSushiCell.h"
#import "SushiCell.h"
#import "Sushi.h"
//translate tools
#import "MSTranslateAccessTokenRequester.h"
#import "MSTranslateVendor.h"
//to detail
#import "SushiDetailViewController.h"

@interface TabMySushiViewController ()
{
    //make global in order to toss over to SushiDetailViewController
    UIImage *sushiCellImage;
    SushiCell *sushiCellClass;
    dispatch_queue_t queue;
}

@property (strong, nonatomic) NSOperationQueue *backgroundOperationQueue;

@end

@implementation TabMySushiViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addSushi"]) {
        
        ((AddSushiViewController*)segue.destinationViewController).addSushiDelegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"viewSushi"]) {

        SushiDetailViewController *sushiDetailViewController = [segue destinationViewController];
        Sushi *selectedSushiCell = [self.fetchedSushiResults objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        [sushiDetailViewController setSelectedSushi:selectedSushiCell];
    }
    
    if ([segue.identifier isEqualToString:@"sushiMap"]) {
        MySushiMapViewController *mySushiMapViewController = [segue destinationViewController];
        mySushiMapViewController.managedObjectContext = self.managedObjectContext;
        mySushiMapViewController.fetchedSushiResults = self.fetchedSushiResults;
    }
}

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
    self.backgroundOperationQueue = [[NSOperationQueue alloc] init];
    [self.backgroundOperationQueue setMaxConcurrentOperationCount:4];
    
    self.fileManager = [NSFileManager defaultManager];
    self.documentsDirectory = [self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    
    self.imageArray = [[NSMutableArray alloc]init];
    [self setupFetchedResults];
    
    sushiCellClass = [[SushiCell alloc] init];
}

-(void)setupFetchedResults
{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Sushi" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    NSError *error;
    self.fetchedSushiResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (int i = 0; i < self.fetchedSushiResults.count; i++) {
        Sushi *sushiInfo = [self.fetchedSushiResults objectAtIndex:i];
        NSString *fileName = sushiInfo.sushiImageURL;
        NSURL *localImageURL = [self.documentsDirectory URLByAppendingPathComponent:fileName];
        UIImage *image = [UIImage imageWithContentsOfFile:[localImageURL path]];
        [self.imageArray addObject:image];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSourceMethods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sushiCell = @"sushiCell";
    NSString *addSushiCellIdentifier = @"addSushiCell";
    
    if (indexPath.section == 0){
        
        SushiCell *cell = [tableView dequeueReusableCellWithIdentifier:sushiCell];
        
        if (cell == nil) {
            cell = [[SushiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sushiCell];
        }
        
        if (self.fetchedSushiResults != 0) {
            Sushi *sushiInfo = [self.fetchedSushiResults objectAtIndex:indexPath.row];
            cell.sushiName.text  = sushiInfo.name;
            cell.sushiRestauraunt.text = sushiInfo.venue;
            
            NSTimeInterval timeSinceSushiEntry = -[sushiInfo.date timeIntervalSinceNow];
            NSLog(@"%f",timeSinceSushiEntry);
            if (timeSinceSushiEntry < 86400 && timeSinceSushiEntry > 3600) {
                int hours = timeSinceSushiEntry/60/60;
                cell.sushiDate.text = [NSString stringWithFormat:@"%i hours ago", hours];
            }
            else if (timeSinceSushiEntry > 86400) {
                int days = timeSinceSushiEntry/60/60/24;
                cell.sushiDate.text = [NSString stringWithFormat:@"%i days ago ",days];
            }
            else if (timeSinceSushiEntry < 3600) {
                cell.sushiDate.text = @"added recently";
            }
            
            cell.sushiNameJapanese.text = sushiInfo.japaneseName;
            
            cell.sushiImageView.image = [self.imageArray objectAtIndex:indexPath.row];
//            [self addPictureToCell:cell atIndexPath:indexPath];
            //[sushiCellClass addPicture:sushiInfo atIndexPath:indexPath];
        }
        
        return cell;
    }
    
    if (indexPath.section == 1){
        
        AddSushiCell *cell = [tableView dequeueReusableCellWithIdentifier:addSushiCellIdentifier];
        if (cell == nil) {
            cell = [[AddSushiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addSushiCellIdentifier];
        }

        cell.textLabel.text = @"Add Sushi";
        
        return cell;
    }
    return nil;
}

-(void)addPictureToCell: (SushiCell*)sushiCell
            atIndexPath:(NSIndexPath*)indexpath
{
    sushiCell.imageView.image = [self.imageArray objectAtIndex:indexpath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        NSLog(@"sections");
        return self.fetchedSushiResults.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)addSushiName:(NSString *)sushiName addSushiPicture:(UIImage *)sushiPicutre addSushiDate:(NSDate *)sushiDate addSushiGoodOrNot:(BOOL)sushiGoodOrNot addSushiDescription:(NSString *)sushiDescription addSushiCityName:(NSString *)sushiCityName addLatitude:(float)latitude addLongitude:(float)longitude
{
    //save coreData
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Sushi" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *newSushi = [[NSManagedObject alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    [newSushi setValue:sushiName forKey:@"name"];
    //[newSushi setValue:sushiPicutre forKey:@"sushiImage"];
    [newSushi setValue:sushiDate forKey:@"date"];
    [newSushi setValue:[NSNumber numberWithBool:sushiGoodOrNot] forKey:@"isRatedGood"];
    [newSushi setValue:sushiDescription forKey:@"sushiDescription"];
    [newSushi setValue:[NSNumber numberWithFloat:latitude] forKey:@"latitude"];
    [newSushi setValue:[NSNumber numberWithFloat:longitude] forKey:@"longitude"];
    
    //save image
    NSString *sushiImageURLString = [sushiName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSURL *sushiImageURL = [NSURL URLWithString:sushiImageURLString];
    NSString *fileName = [sushiImageURL lastPathComponent];
    [newSushi setValue:fileName forKey:@"sushiImageURL"];
    NSURL *localImageURL = [self.documentsDirectory URLByAppendingPathComponent:fileName];
    NSData *imageData = UIImageJPEGRepresentation(sushiPicutre, 0.005);
    [imageData writeToURL:localImageURL atomically:YES];
    
    //make japanese name
    [[MSTranslateAccessTokenRequester sharedRequester] requestSynchronousAccessToken:CLIENT_ID clientSecret:CLIENT_SECRET];
    MSTranslateVendor *vendor = [[MSTranslateVendor alloc] init];
    [vendor requestTranslate:sushiName from:@"en" to:@"ja" blockWithSuccess:^(NSString *translatedText) {
        [newSushi setValue:translatedText forKey:@"japaneseName"];
        NSLog(@"%@", translatedText);
        NSLog(@"%@", sushiName);
    } failure:^(NSError *error) {
        //error
    }];
    
    NSError *error;
    [self.managedObjectContext save:&error];
    
    [self setupFetchedResults];
   
}

@end