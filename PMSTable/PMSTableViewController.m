//
//  PMSTableViewController.m
//  PMSTable
//
//  Created by Christopher Miller on 6/30/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "PMSTableViewController.h"

#define kNumberOfSections 5
#define kObjectsPerSection 40
#define kItemsPerPage 8

@implementation PMSTableViewController

@synthesize tableView;
@synthesize data;

#pragma mark PMSTableViewDelegate

- (void)tableView:(PMSTableView *)t
        fetchPage:(NSUInteger)page
        forSource:(NSUInteger)sourceId
{
    assert(t==tableView);
    assert(page<kObjectsPerSection/kItemsPerPage+2); // ensure that we never ask for two pages beyond
    assert(sourceId<kNumberOfSections);
    
}

- (UITableViewCell *)tableView:(PMSTableView *)t
                   cellForData:(id)data
                    fromSource:(NSUInteger)sourceId
{
    assert(t==tableView);
    assert(sourceId<kNumberOfSections);
    
    return nil;
}

- (bool)tableViewUsesTitleCells:(PMSTableView *)t
{
    assert(t==tableView);
    
    return YES;
}

- (bool)tableViewUsesLoadingCells:(PMSTableView *)t
{
    assert(t==tableView);
    
    return YES;
}

- (UITableViewCell *)tableView:(PMSTableView *)t
          cellAsTitleForSource:(NSUInteger)sourceId
{
    assert(t==tableView);
    
    return nil;
}

- (NSString *)tableView:(PMSTableView *)t
    headerTextForSource:(NSUInteger)sourceId
{
    assert(t==tableView);
    
    return @"";
}

- (NSString *)tableView:(PMSTableView *)t
    footerTextForSource:(NSUInteger)sourceId
{
    assert(t==tableView);
    
    return @"";
}

 - (UITableViewCell *)tableView:(PMSTableView *)t
cellAsLoadingIndicatorForSource:(NSUInteger)sourceId
{
    assert(t==tableView);
    
    return nil;
}

#pragma mark NSObject

- (void)dealloc
{
    [tableView release];
    [data release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    // set up with some example data
    NSMutableArray * arr = [[NSMutableArray alloc] initWithCapacity:kNumberOfSections];
    NSMutableArray * brr;
    for (size_t i=0; i < kNumberOfSections; ++i) {
        brr = [[NSMutableArray alloc] initWithCapacity:kObjectsPerSection];
        for (size_t j=0; j < kObjectsPerSection; ++j)
            [brr addObject:[NSString stringWithFormat:@"Section %ld Row %ld", i+1, j+1]];
        [arr addObject:[NSArray arrayWithArray:brr]];
        [brr release];
        [tableView addDataSourceAtIndex:i];
    }
    self.data = [NSArray arrayWithArray:arr];
    [arr release];
    
    [pool release];
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
