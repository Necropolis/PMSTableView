//
//  PaginatedMultisourceTableViewControllerViewController.m
//  PaginatedMultisourceTableViewController
//
//  Created by Chris Miller on 10/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PMSViewController.h"

@implementation PMSViewController

@synthesize tableView;
@synthesize tableViewController;
@synthesize data;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    NSLog(@"PMSViewController viewDidLoad");
    
    self.data = [[NSArray alloc] initWithObjects:
                 [NSArray arrayWithObjects:@"Object  1",
                  @"Object  2", @"Object  3", @"Object  4",
                  @"Object  5", @"Object  6", @"Object  7",
                  @"Object  8", @"Object  9", @"Object 10",
                  @"Object 11", @"Object 12", @"Object 13",
                  @"Object 14", @"Object 15", @"Object 16",
                  @"Object 17", @"Object 18", @"Object 19",
                  @"Object 20", @"Object 21", @"Object 22", nil],
                 [NSArray arrayWithObjects:@"Object  1",
                  @"Object  2", @"Object  3", @"Object  4",
                  @"Object  5", @"Object  6", @"Object  7",
                  @"Object  8", @"Object  9", @"Object 10",
                  @"Object 11", @"Object 12", @"Object 13",
                  @"Object 14", @"Object 15", @"Object 16",
                  @"Object 17", @"Object 18", @"Object 19",
                  @"Object 20", @"Object 21", @"Object 22", nil],
                 nil];
    
    self.tableViewController.useTitleCells = YES;
    
    [self.tableViewController addDataSourceAtIndex:0];
    [self.tableViewController addDataSourceAtIndex:1]; // create two data sources
    
    [self.tableView reloadData];
    
    [super viewDidLoad];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

/*
 @protocol PMSTableViewControllerDelegate
 @required
 - (void)fetchPage:(NSUInteger)page
 forSource:(size_t)sourceId;
 - (CGFloat)heightForCellAtRow:(NSUInteger)row
 fromSource:(size_t)sourceId;
 - (void)configureCell:(UITableViewCell *)cell
 forData:(NSObject *)data
 fromSource:(size_t)sourceId;
 @optional
 - (CGFloat)heightForTitleCellFromSource:(size_t)sourceId; // required if useTitleCells is YES
 - (void)configureCell:(UITableViewCell *)cell             // required if useTitleCells is YES
 asTitleForSource:(size_t)sourceId;
 - (NSString *)headerTextForSource:(size_t)sourceId;
 - (NSString *)footerTextForSource:(size_t)sourceId;
 @end
 */

#pragma mark PMSTableViewControllerDelegate

- (void)fetchPage:(NSUInteger)page
        forSource:(size_t)sourceId {
    NSLog(@"PMSViewController fetchPage:%ld forSource:%ld", page, sourceId);
    NSMutableArray * objects = [[NSMutableArray alloc] init];
    NSArray * source = [self.data objectAtIndex:sourceId];
    
    for(size_t i = page * PAGE_LENGTH;
        i < (page * PAGE_LENGTH) + PAGE_LENGTH && i < [source count];
        ++i)
        [objects addObject:[source objectAtIndex:i]];
    
    [self.tableViewController addData:[NSArray arrayWithArray:objects]
                            forSource:sourceId
                               onPage:page
                         hasMorePages:(((page * PAGE_LENGTH) + PAGE_LENGTH) <= [source count])];
}

- (CGFloat)heightForCellAtRow:(NSUInteger)row
                   fromSource:(size_t)sourceId {
    return 40.0f;
}

- (void)configureCell:(UITableViewCell *)cell
              forData:(NSObject *)d              
           fromSource:(size_t)sourceId {
    [[cell textLabel] setText:((NSString *)d)];
}

- (CGFloat)heightForTitleCellFromSource:(size_t)sourceId {
    return 40.0f;
}
- (void)configureCell:(UITableViewCell *)cell
     asTitleForSource:(size_t)sourceId {
    switch (sourceId) {
        case 0:
            [[cell textLabel] setText:@"Source 0 Header Cell"];
            break;
        default:
            [[cell textLabel] setText:@"Source 1 Header Cell"];
            break;
    }
}
- (NSString *)headerTextForSource:(size_t)sourceId {
    return [NSString stringWithFormat:@"Source %ld Header Text", sourceId];
}
- (NSString *)footerTextForSource:(size_t)sourceId {
    return [NSString stringWithFormat:@"Source %ld Footer Text", sourceId];
}

#pragma mark NSObject

- (void)dealloc {
    [super dealloc];
}

@end
