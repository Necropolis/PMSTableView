//
//  PaginatedMultisourceTableViewControllerAppDelegate.h
//  PaginatedMultisourceTableViewController
//
//  Created by Chris Miller on 10/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMSViewController;

@interface PMSAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PMSViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PMSViewController *viewController;

@end

