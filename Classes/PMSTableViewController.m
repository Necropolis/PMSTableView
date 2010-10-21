//
//  PaginatedMultisourceTableViewController.m
//  PaginatedMultisourceTableViewController
//
//  Created by Chris Miller on 10/19/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import "PMSTableViewController.h"

#define WRONG_TABLE_VIEW_EXCEPTION @"PMSTableViewController wrong table view"
#define INVALID_TABLE_VIEW_SECTION_EXCEPTION @"PMSTableViewController invalid section"
#define INVALID_SOURCE_EXCEPTION @"PMSTableViewController invalid data source supplied"

@interface PMSTableViewSource : NSObject {
    NSArray * objects;
    size_t currentPage;
    BOOL hasMorePages;
}

@property (readwrite, retain) NSArray * objects;
@property (readwrite, assign) size_t currentPage;
@property (readwrite, assign) BOOL hasMorePages;

@end

@implementation PMSTableViewController

@synthesize tableView;
@synthesize dg;
@synthesize dataSources;
@synthesize useTitleCells;

- (void)addDataSourceAtIndex:(size_t)idx {
    NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
    NSMutableArray * mutableSources = [[NSMutableArray alloc] initWithArray:self.dataSources];
    
    [mutableSources insertObject:[[[PMSTableViewSource alloc] init] autorelease]
                         atIndex:idx];
    
    self.dataSources = [NSArray arrayWithArray:mutableSources];
    
    [mutableSources release];
    [pool0 release];
}

- (void)removeDataSourceAtIndex:(size_t)idx {
    NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
    NSMutableArray * mutableSources = [[NSMutableArray alloc] initWithArray:self.dataSources];
    
    [mutableSources removeObjectAtIndex:idx];
    
    self.dataSources = [NSArray arrayWithArray:mutableSources];
    
    [mutableSources release];
    [pool0 release];
}

- (void)setData:(NSArray *)objects
      forSource:(size_t)sourceId
         onPage:(size_t)currentPage
   hasMorePages:(BOOL)morePages {
    if(sourceId>=[self.dataSources count]) {
        @throw [NSException exceptionWithName:INVALID_SOURCE_EXCEPTION
                                       reason:@"Your code has given an invalid data source."
                                     userInfo:nil];
        return;
    }

    PMSTableViewSource * tvs = [self.dataSources objectAtIndex:sourceId];

    tvs.objects = objects;
    tvs.currentPage = currentPage;
    tvs.hasMorePages = morePages;
    
    [self.tableView reloadData];
}

- (void)addData:(NSArray *)objects
      forSource:(size_t)sourceId
         onPage:(size_t)currentPage
   hasMorePages:(BOOL)morePages {
    if(sourceId>=[self.dataSources count]) {
        @throw [NSException exceptionWithName:INVALID_SOURCE_EXCEPTION
                                       reason:@"Your code has given an invalid data source."
                                     userInfo:nil];
        return;
    }
    
    PMSTableViewSource * tvs = [self.dataSources objectAtIndex:sourceId];
    
    tvs.objects = [tvs.objects arrayByAddingObjectsFromArray:objects];
    tvs.currentPage = currentPage;
    tvs.hasMorePages = morePages;
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(t != self.tableView) {
        @throw [NSException exceptionWithName:WRONG_TABLE_VIEW_EXCEPTION
                                       reason:@"tableView supplied is inconsistent with the table view this controller controls"
                                     userInfo:nil];
        return 0.0f;
    } else if (!self.dataSources||[self.dataSources count]<indexPath.section) {
        @throw [NSException exceptionWithName:INVALID_TABLE_VIEW_SECTION_EXCEPTION
                                       reason:@"section supplied is inconsistent with the number of data sources"
                                     userInfo:nil];
        return 0.0f;
    }
    

    if(self.useTitleCells&&indexPath.row==0)
        return [self.dg heightForTitleCellFromSource:indexPath.section];
    else
        return [self.dg heightForCellAtRow:indexPath.row fromSource:indexPath.section];
    
}

- (void)tableView:(UITableView *)t willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // determine if we need to load more informations!
    if(t != self.tableView) {
        @throw [NSException exceptionWithName:WRONG_TABLE_VIEW_EXCEPTION
                                       reason:@"tableView supplied is inconsistent with the table view this controller controls"
                                     userInfo:nil];
        return;
    } else if (!self.dataSources||[self.dataSources count]<indexPath.section) {
        @throw [NSException exceptionWithName:INVALID_TABLE_VIEW_SECTION_EXCEPTION
                                       reason:@"section supplied is inconsistent with the number of data sources."
                                     userInfo:nil];
        return;
    }
    
    PMSTableViewSource * tvs = [self.dataSources objectAtIndex:indexPath.section];
    
    if([tvs.objects count] - indexPath.row < 3)
        [self.dg fetchPage:tvs.currentPage+1 forSource:indexPath.section];
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(t != self.tableView) {
        @throw [NSException exceptionWithName:WRONG_TABLE_VIEW_EXCEPTION
                                       reason:@"tableView supplied is inconsistent with the table view this controller controls"
                                     userInfo:nil];
        return nil;
    } else if (!self.dataSources||[self.dataSources count]<indexPath.section) {
        @throw [NSException exceptionWithName:INVALID_TABLE_VIEW_SECTION_EXCEPTION
                                       reason:@"section supplied is inconsistent with the number of data sources."
                                     userInfo:nil];
        return nil;
    }
    
    UITableViewCell * cell = (UITableViewCell *)[t dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(self.useTitleCells)
        if(indexPath.row==0)
            return [self.dg configureCell:cell
                         asTitleForSource:indexPath.section];
        else
            return [self.dg configureCell:cell
                                  forData:[[[self.dataSources objectAtIndex:indexPath.section] objects] objectAtIndex:indexPath.row-1]
                               fromSource:indexPath.section];
    else
        return [self.dg configureCell:cell
                              forData:[[[self.dataSources objectAtIndex:indexPath.section] objects] objectAtIndex:indexPath.row]
                           fromSource:indexPath.section];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)section {
    if(t != self.tableView) {
        @throw [NSException exceptionWithName:WRONG_TABLE_VIEW_EXCEPTION
                                       reason:@"tableView supplied is inconsistent with the table view this controller controls"
                                     userInfo:nil];
        return nil;
    } else if (!self.dataSources||[self.dataSources count]<section) {
        @throw [NSException exceptionWithName:INVALID_TABLE_VIEW_SECTION_EXCEPTION
                                       reason:@"section supplied is inconsistent with the number of data sources."
                                     userInfo:nil];
        return nil;
    }
    
    return [[[self.dataSources objectAtIndex:section] objects] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)t {
    if(t != self.tableView) {
        @throw [NSException exceptionWithName:WRONG_TABLE_VIEW_EXCEPTION
                                       reason:@"tableView supplied is inconsistent with the table view this controller controls"
                                     userInfo:nil];
        return nil;
    }
    
    return [self.dataSources count];
}

- (NSString *)tableView:(UITableView *)t titleForHeaderInSection:(NSInteger)section {
    if(![self.dg respondsToSelector:@selector(headerTextForSource:)])
        return nil;
    else
        return [self.dg headerTextForSource:section];
}

- (NSString *)tableView:(UITableView *)t titleForFooterInSection:(NSInteger)section {
    if(![self.dg respondsToSelector:@selector(footerTextForSource:)])
        return nil;
    else
        return [self.dg footerTextForSource:section];
}

#pragma mark NSObject

- (id)init {
    self = [super init];
    if(!self) return nil;
    self.tableView = nil;
    dg = nil;
    self.dataSources = nil;
    return self;
}

- (void)dealloc {
    self.tableView = nil;
    self.dataSources = nil;
    [super dealloc];
}

@end

@implementation PMSTableViewSource

@synthesize objects;
@synthesize currentPage;
@synthesize hasMorePages;

#pragma mark NSObject

- (id)init {
    self = [super init];
    if(!self) return nil;
    self.objects = [NSArray array];
    self.currentPage = 0;
    self.hasMorePages = YES;
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\"PMSTableViewSource\" : {\n\t\"objects\" : %@,\n\t\"currentPage\" : \"%ld\",\n\t\"hasMorePages\" : \"%@\"\n}",
            [self.objects description],
            self.currentPage,
            (self.hasMorePages)?@"YES":@"NO"];
}

- (void)dealloc {
    self.objects = nil;
    [super dealloc];
}

@end

