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
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController addDataSourceAtIndex:%ld", idx);
#endif
    NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
    NSMutableArray * mutableSources = [[NSMutableArray alloc] initWithArray:self.dataSources];
    
    [mutableSources insertObject:[[[PMSTableViewSource alloc] init] autorelease]
                         atIndex:idx];
    
    self.dataSources = [NSArray arrayWithArray:mutableSources];
    
    [self.dg fetchPage:0 forSource:idx];
    
    [mutableSources release];
    [pool0 release];
}

- (void)removeDataSourceAtIndex:(size_t)idx {
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController removeDataSourceAtIndex:%ld", idx);
#endif
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
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController setData:%@ forSource:%ld onPage:%ld hasMorePages:%@",
          objects,
          sourceId,
          currentPage,
          (morePages)?@"YES":@"NO");
#endif
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
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController addData:%@ forSource:%ld onPage:%ld hasMorePages:%@",
          objects,
          sourceId,
          currentPage,
          (morePages)?@"YES":@"NO");
#endif
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
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController tableView:%@ heightForRowAtIndexPath:%@", t, indexPath);
#endif
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
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController tableView:%@ willDisplayCell:%@ forRowAtIndexPath:%@", t, cell, indexPath);
#endif
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
    
    if([tvs.objects count] - indexPath.row < 3 && tvs.hasMorePages)
        [self.dg fetchPage:tvs.currentPage+1 forSource:indexPath.section];
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController tableView:%@ cellForRowAtIndexPath:%@", t, indexPath);
#endif
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
    
    UITableViewCell * cell;
    
    if(self.useTitleCells)
        if(indexPath.row==0) 
            cell = [self.dg configureCellAsTitleForSource:indexPath.section];
        else
            cell = [self.dg configureCellForData:[[[self.dataSources objectAtIndex:indexPath.section] objects] objectAtIndex:indexPath.row-1]
                                      fromSource:indexPath.section];
    else
        cell = [self.dg configureCellForData:[[[self.dataSources objectAtIndex:indexPath.section] objects] objectAtIndex:indexPath.row]
                                  fromSource:indexPath.section];
    
    if(!cell) {
        @throw [NSException exceptionWithName:@"Nil Cell Exception"
                                       reason:@"You failed to return a valid UITableViewCell"
                                     userInfo:nil];
        cell = (UITableViewCell *)[t dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)section {
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController tableView:%@ numberOfRowsInSection:%ld", t, section);
#endif
    if(t != self.tableView) {
        @throw [NSException exceptionWithName:WRONG_TABLE_VIEW_EXCEPTION
                                       reason:@"tableView supplied is inconsistent with the table view this controller controls"
                                     userInfo:nil];
        return 0;
    } else if (!self.dataSources||[self.dataSources count]<section) {
        @throw [NSException exceptionWithName:INVALID_TABLE_VIEW_SECTION_EXCEPTION
                                       reason:@"section supplied is inconsistent with the number of data sources."
                                     userInfo:nil];
        return 0;
    }
    
    if(self.useTitleCells)
        return [[[self.dataSources objectAtIndex:section] objects] count]+1;
    else
        return [[[self.dataSources objectAtIndex:section] objects] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)t {
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController numberOfSectionsInTableView:%@", t);
#endif
    if(t != self.tableView) {
        @throw [NSException exceptionWithName:WRONG_TABLE_VIEW_EXCEPTION
                                       reason:@"tableView supplied is inconsistent with the table view this controller controls"
                                     userInfo:nil];
        return 0;
    }
    
    return [self.dataSources count];
}

- (NSString *)tableView:(UITableView *)t titleForHeaderInSection:(NSInteger)section {
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController tableView:%@ titleForHeaderInSection:%ld", t, section);
#endif
    if(![self.dg respondsToSelector:@selector(headerTextForSource:)])
        return nil;
    else
        return [self.dg headerTextForSource:section];
}

- (NSString *)tableView:(UITableView *)t titleForFooterInSection:(NSInteger)section {
#ifdef PMSDEBUG
    NSLog(@"PMSTableViewController tableView:%@ titleForFooterInSection:%ld", t, section);
#endif
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
    self.currentPage = -1;
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

