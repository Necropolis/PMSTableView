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

#define kDataCellReuseId @"Data Cell"
#define kTitleCellReuseId @"Title Cell"
#define kLoadingCellReuseId @"Loading Cell"

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
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController tableView:%@\n\tfetchPage:%u\n\tforSource:%u", t, page, sourceId);
#endif
    
    [NSThread sleepForTimeInterval:5.0f];
    
    NSArray * d = [data objectAtIndex:sourceId];
    NSArray * dsub = [d subarrayWithRange:NSMakeRange(page * kItemsPerPage, kItemsPerPage)];
    
    [t addData:dsub
     forSource:sourceId
        onPage:page
  hasMorePages:(page * kItemsPerPage + kItemsPerPage >= kObjectsPerSection)];
}

- (UITableViewCell *)tableView:(PMSTableView *)t
                   cellForData:(id)d
                    fromSource:(NSUInteger)sourceId
{
    assert(t==tableView);
    assert(sourceId<kNumberOfSections);
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController tableView:%@\n\tcellForData:%@\n\tfromSource:%u", t, d, sourceId);
#endif
    
    UITableViewCell * c = [t dequeueReusableCellWithIdentifier:kDataCellReuseId];
    
    if (!c)
        c = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:kDataCellReuseId] autorelease];
    
    [[c textLabel] setText:d];
    
    return c;
}

- (bool)tableViewUsesTitleCells:(PMSTableView *)t
{
    assert(t==tableView);
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController tableViewUsesTitleCells:%@", t);
#endif
    
    return YES;
}

- (bool)tableViewUsesLoadingCells:(PMSTableView *)t
{
    assert(t==tableView);
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController tableViewUsesLoadingCells:%@", t);
#endif
    
    return YES;
}

- (UITableViewCell *)tableView:(PMSTableView *)t
          cellAsTitleForSource:(NSUInteger)sourceId
{
    assert(t==tableView);
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController tableView:%@\n\tcellAsTitleForSource:%u", t, sourceId);
#endif
    
    UITableViewCell * c = [t dequeueReusableCellWithIdentifier:kTitleCellReuseId];
    
    if (!c)
        c = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:kTitleCellReuseId] autorelease];
    
    [[c textLabel] setText:[NSString stringWithFormat:@"Section %u", sourceId]];
    
    return c;
}

- (NSString *)tableView:(PMSTableView *)t
    headerTextForSource:(NSUInteger)sourceId
{
    assert(t==tableView);
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController tableView:%@\n\theaderTextForSource:%u", t, sourceId);
#endif
    
    return [NSString stringWithFormat:@"Section Header %lu", sourceId+1];
}

- (NSString *)tableView:(PMSTableView *)t
    footerTextForSource:(NSUInteger)sourceId
{
    assert(t==tableView);
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController tableView:%@\n\tfooterTextForSource:%u", t, sourceId);
#endif
    
    return [NSString stringWithFormat:@"Section Footer %lu", sourceId+1];
}

 - (UITableViewCell *)tableView:(PMSTableView *)t
cellAsLoadingIndicatorForSource:(NSUInteger)sourceId
{
    assert(t==tableView);
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController tableView:%@\n\tcellAsLoadingIndicatorForSource:%u", t, sourceId);
#endif
    
    UITableViewCell * c = [t dequeueReusableCellWithIdentifier:kLoadingCellReuseId];
    
    if (!c)
        c = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:kLoadingCellReuseId] autorelease];
             
    [[c contentView] addSubview:[[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease]];
    
    return c;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil; // never called
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0; // never called
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
    [super viewDidLoad];
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    // set up with some example data
    NSMutableArray * arr = [[NSMutableArray alloc] initWithCapacity:kNumberOfSections];
    NSMutableArray * brr;
    for (NSUInteger i=0; i < kNumberOfSections; ++i) {
        brr = [[NSMutableArray alloc] initWithCapacity:kObjectsPerSection];
        for (NSUInteger j=0; j < kObjectsPerSection; ++j)
            [brr addObject:[NSString stringWithFormat:@"Section %ld Row %ld", i+1, j+1]];
        [arr addObject:[NSArray arrayWithArray:brr]];
        [brr release];
        NSLog(@"Iterating?");
        [tableView addDataSourceAtIndex:i];
    }
    self.data = [NSArray arrayWithArray:arr];
    [arr release];
    
    [self.tableView reloadData];
    
    [pool release];
    
#ifdef PMSDEBUG
    NSLog(@"Is this working?");
#endif
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
