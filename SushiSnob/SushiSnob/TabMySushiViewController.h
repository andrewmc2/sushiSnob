//
//  TabMySushiViewController.h
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "AddSushiDelegate.h"
#import "AddSushiViewController.h"

@interface TabMySushiViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AddSushiDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *fetchedSushiResults;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end