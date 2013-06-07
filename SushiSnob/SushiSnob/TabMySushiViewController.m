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


@end
