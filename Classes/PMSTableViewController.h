//
//  PaginatedMultisourceTableViewController.h
//  PaginatedMultisourceTableViewController
//
//  Created by Chris Miller on 10/19/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMSTableViewControllerDelegate

- (void)fetchPage:(NSUInteger)page
        forSource:(size_t)sourceId;
- (CGFloat)heightForCellAtRow:(NSUInteger)row
                   fromSource:(size_t)sourceId;
- (CGFloat)heightForTitleCellFromSource:(size_t)sourceId;
- (void)configureCell:(UITableViewCell *)cell
              forData:(NSObject *)data
           fromSource:(size_t)sourceId;
- (void)configureCell:(UITableViewCell *)cell
     asTitleForSource:(size_t)sourceId;

@end

/**
 * I recommend you use an enum starting at zero for the sourceId.
 */
@interface PMSTableViewController : NSObject <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView * tableView;
    IBOutlet id<PMSTableViewControllerDelegate> dg;
    NSArray * dataSources;
    bool useTitleCells;
}

@property (nonatomic, retain) IBOutlet  UITableView * tableView;
@property (nonatomic, assign) IBOutlet id<PMSTableViewControllerDelegate>
                                                    dg;
@property (readwrite, retain)           NSArray     * dataSources;
@property (readwrite, assign)           bool          useTitleCells;

- (void)setData:(NSArray *)objects
      forSource:(size_t)sourceId
         onPage:(size_t)currentPage
   hasMorePages:(BOOL)morePages;

- (void)addData:(NSArray *)objects
      forSource:(size_t)sourceId
         onPage:(size_t)currentPage
   hasMorePages:(BOOL)morePages;

@end
