//
//  PIXYPostsDatasource.m
//  pixy
//
//  Created by Dana Shakiba on 5/14/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import "PIXYPostsDatasource.h"
#import "PIXYNetworking.h"
#import "PIXYPostModel.h"
@import UIKit;

@interface PIXYPostsDatasource()

/**
 Used to check if the datasource is currently loading.
 */
@property (nonatomic, assign) BOOL isLoading;

/**
 This string stores the next page value to be passed along with the fetch
 request.
 */
@property (nonatomic, strong) NSString *nextPage;

@end

@implementation PIXYPostsDatasource

#pragma ------------------------------------------------------------------------
#pragma mark - Public Methods
#pragma ------------------------------------------------------------------------

- (void)fetchPosts:(void(^)())success
           failure:(void (^)())failure
{
    _isLoading = YES;
    [PIXYPostModel fetchPosts:self.nextPage
                      success:^(NSDictionary *postsDictionary) {
                      
                          _isLoading = NO;
                          self.nextPage = [postsDictionary objectForKey:@"nextPage"];
                          if (!self.posts) self.posts = [NSArray new];
                          self.posts = [self.posts arrayByAddingObjectsFromArray:[postsDictionary objectForKey:@"posts"]];
                          if (success) success();
                          
                      } failure:^(NSError *error) {
                        
                          _isLoading = NO;
                          if (failure) failure();
                          
                      }];
}

- (void)refresh:(void(^)())success
     andFailure:(void(^)())failure
{
    if (!_isLoading) {
        _isLoading = YES;
        _nextPage = nil;
        [PIXYPostModel fetchPosts:self.nextPage
                          success:^(NSDictionary *postsDictionary) {
                              
                              [self emptyDatasource];
                              self.nextPage = [postsDictionary objectForKey:@"nextPage"];
                              if (!self.posts) self.posts = [NSArray new];
                              self.posts = [self.posts arrayByAddingObjectsFromArray:[postsDictionary objectForKey:@"posts"]];
                              if (success) success();
                              
                          } failure:^(NSError *error) {
                              
                              _isLoading = NO;
                              if (failure) failure();
                              
                          }];
    }
}

- (BOOL)loadMore:(NSIndexPath *)currentIndexPath
{
    if (!_isLoading) {
        NSUInteger index = currentIndexPath.row;
        NSUInteger page = (self.numberOfPosts - 15);
        if (index >= page && self.nextPage.length > 0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (BOOL)canLoadMore
{
    if (self.nextPage.length > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (PIXYPostModel *)postAtIndexPath:(NSIndexPath *)indexPath
{
    PIXYPostModel *post = self.posts[indexPath.row];
    return post;
}

#pragma ------------------------------------------------------------------------
#pragma mark - Private Methods
#pragma ------------------------------------------------------------------------

- (void)emptyDatasource
{
    _isLoading = NO;
    _numberOfPosts = 0;
    _nextPage = nil;
    _posts = nil;
}

#pragma ------------------------------------------------------------------------
#pragma mark - Getters
#pragma ------------------------------------------------------------------------

- (NSUInteger)numberOfPosts
{
    return self.posts.count;
}

@end