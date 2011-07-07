//
//  PMSTableViewController.h
//  PMSTable
//
//  Created by Christopher Miller on 6/30/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PMSTableView.h"
#import "PMSTableViewDelegate.h"

@interface PMSTableViewController : UIViewController <PMSTableViewDelegate> {
    PMSTableView *tableView;
    NSArray * data;
}

@property (nonatomic, retain) IBOutlet PMSTableView *tableView;
@property (nonatomic, retain) NSArray * data;

@end
