//
//  PMSTableView.h
//  PMSTable
//
//  Created by Christopher Miller on 6/30/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMSTableViewDelegate.h"

/**
 * Automates the logic of when to fetch and show new content from one or more sources of paginated data.
 *
 * This is a light wrapper on top of `UITableView` that controls the logic of obtaining data from sources. It is built to prevent the programmer from having to write custom logic each and every time he or she desires to populate the contents of a `UITableView` with such data. This data is usually loaded from network data, which incurs a degree of latency. The nature of PMSTableView's callbacks enable the interface to not block while retrieving more data.
 *
 * To use this class, add a new `UITableView` to your XIB, and then set the subclass to PMSTableView. Do not alter the delegate or data source, or you will be bypassing the functionality of PMSTableView.
 *
 * *Note:* I am planning on using some method swizzling in the future to make it so that this is no longer a requirement, since it rather prevents you from listening for selection events.
 *
 * You need to implement the protocol PMSTableViewDelegate. PMSTableView will call dg to request more data and to get cells to add to the table.
 * 
 * To some it might seem strange to have an infinite scrolling device with more than one section. If the first section is especially long, it could take a while for the customer to scroll down to the second section in low-latency situations. I am fully aware of this potential problem, and it is a thing for the programmer to  think about. There are situations in which there are smaller sections which you want to be put first, with the longer section infinitely-scrolling at the bottom.
 *
 * Finally, although this tool supports multiple data sources, you do not have to use more than one if you don't want to.
 *
 * PMSTableView should be thread-safe. It supports keyed archiving, so you can load it from NIBs without loosing your IB customizations.
 *
 * If you are reading this, you have found some (very) beta, untested software. This is a complete rewrite of the old PMSTableViewController project. This rewrite uses a lot more Cocoa design patterns and will be much easier to use.
 */
@interface PMSTableView : UITableView <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet id<PMSTableViewDelegate> dg;
    NSArray * dataSources;
    NSInteger loadThreshold;
    bool useTitleCells;
    bool useLoadingCells;
}

/**
 * The delegate to which requests for more data or content cells is sent.
 */
@property (readwrite, assign) IBOutlet id<PMSTableViewDelegate> dg;
@property (readwrite, retain) NSArray * dataSources;
/**
 * How soon should the PMSTableView re-query for more elements?
 */
@property (readwrite, assign) NSInteger loadThreshold;

/**
 * Insert a data source into the receiver. This is used for dynamically changing the number of sections in the `UITableView`.
 *
 * @param idx Insert a data source.
 */
- (void)addDataSourceAtIndex:(NSUInteger)idx;

/**
 * Removes a data source from the receiver. This is used for dynamically changing the number of sections in the `UITableView`.
 *
 * @param idx Remove the given data source.
 */
- (void)removeDataSourceAtIndex:(NSUInteger)idx;

/**
 * Sets all the data in the receiver for the given source. Generally you will not be using this; see addData:forSource:onPage:hasMorePages:.
 *
 * @param objects The data to be set.
 * @param sourceId The source to be overwritten.
 * @param currentPage The "page" from which you retrieved this data.
 * @param morePages Whether or not the receiver will re-query this data source when and if the user scrolls down to the end of the section.
 */
- (void)setData:(NSArray *)objects
      forSource:(NSUInteger)sourceId
         onPage:(NSUInteger)currentPage
   hasMorePages:(bool)morePages;

/**
 * Adds more data to the receiver for the given source.
 * 
 * This is the method you will call after you have retrieved more data after having been notified by [PMSTableViewDelegate tableView:fetchPage:forSource:]. Following this, if the applicable part of the PMSTableView is still visible to the customer, then PMSTableView will call your code's [PMSTableViewDelegate tableView:cellForData:fromSource:] method in order to obtain a `UITableViewCell` to put into the table.
 *
 * The data that you add is never inspected by PMSTableView, except maybe for debug output. You can put any arbitrary value into the array that you can store into an `NSArray`.
 *
 * @param objects The data to put into the data source.
 * @param sourceId The source from which this data was extracted.
 * @param currentPage The "page" from which you retrieved this data.
 * @param morePages Whether or not the receiver will re-query this data source when and if the user scrolls down to the end of the section.
 */
- (void)addData:(NSArray *)objects
      forSource:(NSUInteger)sourceId
         onPage:(NSUInteger)currentPage
   hasMorePages:(bool)morePages;

/**
 * Sets whether the given source has more data to retrieve.
 *
 * If there is a situation in which you cannot know how many pages there are from a source, the best solution is to always tell PMSTableView that there are more pages. When your source runs out of pages, instead of potentially leaving an indeterminate spinner in the view indefinitely, instead call this method with a `morePages` parameter of `NO`. This method will remove any applicable loading indicator and will flag the source as to not be queried for additional data again. Calling the same with `YES` will re-enable the data source to be queried for more data in the future or immediately if the end of the view has been reached by the customer.
 *
 * @param morePages Whether or not the receiver will re-query this data soruce when and if the user scrolls down to the end of the section.
 * @param sourceId The source for which there is no more data.
 */
- (void)setHasMorePages:(bool)morePages
              forSource:(NSUInteger)sourceId;

/**
 * Sets whether the given source is requesting another page.
 *
 * This is used to enable the loading indicator to be removed;
 *
 * @param requestingAnotherPage Whether or not the receiver is still in the process of requesting more data.
 * @param sourceId The source for which this field is being set.
 */
- (void)setRequestingAnotherPage:(bool)requestingAnotherPage
                       forSoruce:(NSUInteger)sourceId;

@end
