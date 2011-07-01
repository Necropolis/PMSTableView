//
//  PMSTableView.m
//  PMSTable
//
//  Created by Christopher Miller on 6/30/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "PMSTableView.h"
#import <objc/runtime.h> // dude that was the most fun code I've written all month

#define kSerialVersionId 0
#define kSerialVersionKey @"SVID"

@interface PMSTableViewSource : NSObject<NSCoding> {
@private
    NSArray * objects;
    NSUInteger currentPage;
    bool hasMorePages;
}

@property (readwrite, retain) NSArray * objects;
@property (readwrite, assign) NSUInteger currentPage;
@property (readwrite, assign) bool hasMorePages;

@end

@implementation PMSTableView

@synthesize dg;
@synthesize dataSources;
@synthesize loadThreshold;

- (void)addDataSourceAtIndex:(NSUInteger)idx
{
    NSLog(@"TODO: Add a data source!");
}

- (void)removeDataSourceAtIndex:(NSUInteger)idx
{
    NSLog(@"TODO: Remove a data soruce!");
}

- (void)setData:(NSArray *)objects
      forSource:(NSUInteger)sourceId
         onPage:(NSUInteger)currentPage
   hasMorePages:(bool)morePages
{
    
}

- (void)addData:(NSArray *)objects
      forSource:(NSUInteger)sourceId
         onPage:(NSUInteger)currentPage
   hasMorePages:(bool)morePages
{
    
}

- (void)setHasMorePages:(bool)morePages
              forSource:(NSUInteger)sourceId
{
    
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if ([aDecoder allowsKeyedCoding]) {
            NSInteger serialVersionId = NSIntegerMax;
            serialVersionId = [aDecoder decodeIntegerForKey:kSerialVersionKey];
            switch (serialVersionId) {
                case kSerialVersionId:
                    self.dg = [aDecoder decodeObjectForKey:@"dg"]; // should just decode a pointer from the rest of the object graph
                    self.dataSources = [aDecoder decodeObjectForKey:@"dataSources"];
                    useTitleCells = [aDecoder decodeBoolForKey:@"useTitleCells"];
                    useLoadingCells = [aDecoder decodeBoolForKey:@"useLoadingCells"];
                    break;
                    
                default:
                    @throw [NSException exceptionWithName:@"Unknown Archive Version!"
                                                   reason:@"My serial version ID doesn't match something I know how to decode!"
                                                 userInfo:nil];
                    break;
            }
            super.delegate = self;
        } else {
            @throw [NSException exceptionWithName:@"I don't know how to use unkeyed coding!"
                                           reason:@"Apple is about to deprecate it!"
                                         userInfo:nil];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:kSerialVersionId forKey:kSerialVersionKey];
    [aCoder encodeObject:dg forKey:@"dg"];
    [aCoder encodeObject:dataSources forKey:@"dataSources"];
    [aCoder encodeBool:useTitleCells forKey:@"useTitleCells"];
    [aCoder encodeBool:useLoadingCells forKey:@"useLoadingCells"];
    // and that's all she wrote!
}

#pragma mark UITableView

- (id)init
{
    self = [super init];
    if (self) {
        super.delegate = self;
        super.dataSource = nil;
        self.dataSources = [NSArray array];
    }
    return self;
}

- (void)dealloc
{
    self.dataSources = nil;
    [super dealloc];
}

#pragma mark UITableViewDelegate

// this here is the bad-mutha method which decides whether or not to go grab more data
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef PMSDEBUG
    NSLog(@"__PMSTableViewDelegate(internal stuffs) tableView:willDisplayCell:forRowAtIndexPath: called with tableView %@ cell %@ and indexPath %@", tableView, cell, indexPath);
#endif
    NSInteger row=indexPath.row, section=indexPath.section;
    assert(tableView == self); // if not, well, we got some big problems
    assert([self.dataSources count]>section);
    // perform the logic of whether to load more data
    PMSTableViewSource * src = [dataSources objectAtIndex:section];
    if ([src.objects count] - row < loadThreshold && src.hasMorePages)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           [dg tableView:self
                               fetchPage:src.currentPage+1
                               forSource:section];
                       });
    // forward this message off to the delegate so that it can configure the cell if it needs to.
    if ([dg respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
        [dg tableView:tableView
            willDisplayCell:cell
          forRowAtIndexPath:indexPath];
}

#pragma mark NSObject

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    // evil evil selector forwarding on ONLY the methods from UITableViewDelegate
    // see http://mikeash.com/pyblog//friday-qa-2009-03-27-objective-c-message-forwarding.html
    // for why this even works
    struct objc_method_description m = 
    protocol_getMethodDescription(@protocol(UITableViewDelegate), aSelector, NO, YES);
    if (m.name!=NULL)
        return dg;
    return nil;
}

@end

@implementation PMSTableViewSource

@synthesize objects;
@synthesize currentPage;
@synthesize hasMorePages;

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        if ([aDecoder allowsKeyedCoding]) {
            NSInteger svid = NSIntegerMax;
            svid = [aDecoder decodeIntegerForKey:kSerialVersionKey];
            switch (svid) {
                case kSerialVersionId:
                    self.objects = [aDecoder decodeObjectForKey:@"objects"];
                    self.currentPage = [aDecoder decodeIntegerForKey:@"currentPage"];
                    self.hasMorePages = [aDecoder decodeBoolForKey:@"hasMorePages"];
                    break;
                    
                default:
                    @throw [NSException exceptionWithName:@"Unknown Archive Version!"
                                                   reason:@"My serial version ID doesn't match something I know how to decode!"
                                                 userInfo:nil];
                    break;
            }
        } else
            @throw [NSException exceptionWithName:@"I don't know how to use unkeyed coding!"
                                           reason:@"Apple is about to deprecate it!"
                                         userInfo:nil];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:kSerialVersionId forKey:kSerialVersionKey];
    [aCoder encodeObject:objects forKey:@"objects"];
    [aCoder encodeInteger:currentPage forKey:@"curentPage"];
    [aCoder encodeBool:hasMorePages forKey:@"hasMorePages"];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    if (self) {
        self.objects = [NSArray array];
        self.currentPage = -1;
        self.hasMorePages = YES;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\"PMSTableViewSource\" : {\n\t\"objects\" : %@,\n\t\"currentPage\" : \"%ld\",\n\t\"hasMorePages\" : \"%@\"\n}",
            [self.objects description],
            self.currentPage,
            (self.hasMorePages)?@"YES":@"NO"];
}

- (void)dealloc
{
    self.objects = nil;
    [super dealloc];
}

@end

#undef kSerialVersionId
#undef kSerialVersionKey
