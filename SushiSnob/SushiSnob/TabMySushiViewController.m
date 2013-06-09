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

@interface TabMySushiViewController ()

@end

@implementation TabMySushiViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addSushi"]) {
        
        ((AddSushiViewController*)segue.destinationViewController).addSushiDelegate = self;
        
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
	// Do any additional setup after loading the view.
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
        
        cell.textLabel.text = @"Sushi";
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    } else {
        return 1;
    }
}

-(void)addSushiName:(NSString *)sushiName addSushiPicture:(UIImage *)sushiPicutre addSushiDate:(NSDate *)sushiDate addSushiGoodOrNot:(BOOL)sushiGoodOrNot addSushiDescription:(NSString *)sushiDescription addSushiCityName:(NSString *)sushiCityName addLatitude:(float)latitude addLongitude:(float)longitude
{
    //do this later
    NSLog(@"sushiName: %@, picture: %@, date: %@, good or not: %c, description: %@, city name: %@", sushiName, sushiPicutre, sushiDate, sushiGoodOrNot, sushiDescription, sushiCityName);
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Sushi" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *newSushi = [[NSManagedObject alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    [newSushi setValue:sushiName forKey:@"name"];
    [newSushi setValue:sushiPicutre forKey:@"sushiImage"];
    [newSushi setValue:sushiDate forKey:@"date"];
    [newSushi setValue:[NSNumber numberWithBool:sushiGoodOrNot] forKey:@"isRatedGood"];
    [newSushi setValue:sushiDescription forKey:@"sushiDescription"];
    [newSushi setValue:[NSNumber numberWithFloat:latitude] forKey:@"latitude"];
    [newSushi setValue:[NSNumber numberWithFloat:longitude] forKey:@"longitude"];
    
//    add later
//    [newSushi setValue:<#(id)#> forKey:@"cannonicalURL"];
//    [newSushi setValue:<#(id)#> forKey:@"venue"];
    
    NSError *error;
    
    [self.managedObjectContext save:&error];

}

@end