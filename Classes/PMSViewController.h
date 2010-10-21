//
//  PaginatedMultisourceTableViewControllerViewController.h
//  PaginatedMultisourceTableViewController
//
//  Created by Chris Miller on 10/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMSTableViewController.h"

#define PAGE_LENGTH 10

@interface PMSViewController : UIViewController <PMSTableViewControllerDelegate> {
    IBOutlet UITableView * tableView;
    IBOutlet PMSTableViewController * tableViewController;
    NSArray * data;
}

@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) IBOutlet PMSTableViewController * tableViewController;
@property (nonatomic, retain)          NSArray * data;


@end

