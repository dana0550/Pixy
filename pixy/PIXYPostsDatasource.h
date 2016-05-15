//
//  PIXYPostsDatasource.h
//  pixy
//
//  Created by Dana Shakiba on 5/14/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIKit;
@class PIXYPostModel;

@interface PIXYPostsDatasource : NSObject

/**
 This is an array of fetched posts.
 */
@property (nonatomic, strong) NSArray<PIXYPostModel *> *posts;

/**
 Returns the number of posts in the datasource.
 */
@property (nonatomic, assign) NSUInteger numberOfPosts;

/**
 Fetches posts
 */
- (void)fetchPosts:(void(^)())success
           failure:(void (^)())failure;

/**
 Refreshes the datasource. Used when pull to refresh action is triggered.
 */
- (void)refresh:(void(^)())success
     andFailure:(void(^)())failure;

/**
 Loads additional posts when pagination is used.
 */
- (BOOL)loadMore:(NSIndexPath *)currentIndexPath;

/**
 Checks if there are addtiional posts to load.
 */
- (BOOL)canLoadMore;

/**
 Returns the post at the current index path.
 */
- (PIXYPostModel *)postAtIndexPath:(NSIndexPath *)indexPath;

@end