//
//  PMSTableViewDelegate.h
//  PMSTable
//
//  Created by Christopher Miller on 6/30/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMSTableView;

/**
 * Contract that code must conform to in order to make full use of a PMSTableView.
 *
 * Two methods from `UITableViewDataSource` will never be called:
 *
 * - `tableView:cellForRowAtIndexPath:` will never be called. It will instead fire off one of three methods: tableView:cellForData:fromSource:, tableView:cellAsTitleForSource:, or tableView:cellAsLoadingIndicatorForSource:
 * - `tableView:numberOfRowsInSection:` will never be called. PMSTableView itself handles this because it is also handling the data internally.
 */
@protocol PMSTableViewDelegate <UITableViewDelegate, UITableViewDataSource>

@required

///---------------
/// @name Required
///---------------

/**
 * A request to fetch more data for a given data source. This method is expected to generate a call to [PMSTableView addData:forSource:onPage:hasMorePages:] or to [PMSTableView setHasMorePages:forSource:].
 *
 * @warning *Important:* This call will be sent in an asynchronous dispatch queue.
 *
 * @param tableView The PMSTableView that this call originated from.
 * @param page The page being requested. PMSTableView knows the current page, and will request the next page, so you do not need to increment the page yourself.
 * @param sourceId The source for which more data is needed.
 */
- (void)tableView:(PMSTableView *)tableView
        fetchPage:(NSUInteger)page
        forSource:(NSUInteger)sourceId;

/**
 * A request to either dequeue or construct a new `UITableViewCell` and to then configure it to display the data which you want to display.
 *
 * This call will not be sent in an asynchronous dispatch queue.
 *
 * @warning *Note:* The behavior of PMSTableView is undefined should this return `nil`.
 *
 * @param tableView The PMSTableView that this call originated from.
 * @param data The data as retreived earlier by tableView:fetchPage:forSource:.
 * @param sourceId The source this was retrieved from. This is useful if you have multiple sources that configure different views.
 *
 * @return A `UITableViewCell` or subclass that shows the data you wish to display. I suggest using the `dequeReusableCellWithIdentifier:` method of `UITableView` (which PMSTableView subclasses) if at all possible in order to avoid having to allocate a new `UITableViewCell` all the time. Failing this, you can create a new `UITableViewCell` just like normal, or load one from a NIB, or whatever else you may have up your sleeve.
 */
- (UITableViewCell *)tableView:(PMSTableView *)tableView
                   cellForData:(id)data
                    fromSource:(NSUInteger)sourceId;

/**
 * Should tableView use title cells? If YES, then you need to implement tableView:cellAsTitleForSource:.
 *
 * PMSTableView will check to see whether the receiver implements tableView:cellAsTitleForSource: before sending this message.
 *
 * @see tableView:cellAsTitleForSource:
 *
 * @param tableView The PMSTableView that this call originated from.
 *
 * @return Whether or not I should query to see if the receiver will provide a title cell.
 */
- (bool)tableViewUsesTitleCells:(PMSTableView *)tableView;

/**
 * Should tableView use loading cells? If YES, then you need to implement tableView:cellAsLoadingIndicatorForSource:.
 *
 * PMSTableView will check to see whether the receiver implements tableView:cellAsLoadingIndicatorForSource: before sending this message.
 *  
 * @see tableView:cellAsLoadingIndicatorForSource:
 * 
 * @param tableView The PMSTableView that this call originated from.
 *
 * @return Whether or not I should query to see if the receiver will provide a loading cell.
 */
- (bool)tableViewUsesLoadingCells:(PMSTableView *)tableView;

@optional

///------------------
/// @name Title Cells
///------------------

/**
 * Request for a title cell.
 * 
 * Request from PMSTableView for a title cell, which is a normal cell that is configured as a kind of section header. Normal text-based section headers do not necessarily look good in all styling situations, so it is often necessary to design your own title cells.
 * 
 * @param tableView The PMSTableView that this call originated from.
 * @param sourceId The source for which the title cell will be displayed on.
 *
 * @return A cell that will be used as a title or section header for the given data source (or section).
 */
- (UITableViewCell *)tableView:(PMSTableView *)tableView
          cellAsTitleForSource:(NSUInteger)sourceId;

///------------------
/// @name Header Text
///------------------

/**
 * Request for the section header text to use for a section in the PMSTableView.
 *
 * Section header text is not a full cell. It's a funky little label that floats above the section no matter where you are in the section, and will disappear when the section is no longer visible.
 * 
 * @param tableView The PMSTableView that this call originated from.
 * @param sourceId The source for which this text will become the section header for.
 *
 * @return An `NSString` which will be used as the section header text.
 */
- (NSString *)tableView:(PMSTableView *)tableView
    headerTextForSource:(NSUInteger)sourceId;

/**
 * Request for the section footer text to use for a section in the PMSTableView.
 *
 * Section footer text is not a full cell. It's a funky little label that floats below the section, and will be pushed out of view next to the section header for the following section.
 *
 * @param tableView The PMSTableView that this call originated from.
 * @param sourceId The source for which this text will become the section footer for.
 *
 * @return An `NSString` which will be used as the section footer text.
 */
- (NSString *)tableView:(PMSTableView *)tableView
    footerTextForSource:(NSUInteger)sourceId;

///-------------------
/// @name Loading Cell
///-------------------

/**
 * Request for a loading indicator cell to use while loading more data for a section in the PMSTableView.
 *
 * This is a really cool toy. Because you can configure this cell however you want, you can do all kinds of fun things. For instance, you could provide a determinate loading indicator instead of an indeterminate one (by hooking this up into your code called from tableView:fetchPage:forSource:) or any other number of things. I might be a bit biased, but this is wicked sick.
 *
 * @param tableView The PMSTableView that this call originated from.
 * @param sourceId The source for which this loading indicator is being used while more data is being loaded.
 * 
 * @return A cell that will be injected before the footer cell (if present) and will be removed when more data is loaded into the PMSTableView.
 */
 - (UITableViewCell *)tableView:(PMSTableView *)tableView
cellAsLoadingIndicatorForSource:(NSUInteger)sourceId;

@end
