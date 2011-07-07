//
//  PMSTableAppDelegate.h
//  PMSTable
//
//  Created by Christopher Miller on 6/30/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMSTableViewController;

@interface PMSTableAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet PMSTableViewController *viewController;

@end
