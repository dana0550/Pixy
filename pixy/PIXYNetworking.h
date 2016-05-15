//
//  PIXYNetworking.h
//  pixy
//
//  Created by Dana Shakiba on 5/14/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIXYNetworking : NSObject

#pragma mark - Initializers
- (instancetype)init NS_UNAVAILABLE NS_DESIGNATED_INITIALIZER;

/*  Gets shared instance of PIXYNetworking. This is the designated initializer.
 */
+ (instancetype)sharedInstance;

#pragma mark - Posts

/*  Fetches posts from r/pics subreddit.
    Optionally you may pass a nextPage string parameter for pagination.
    Returns a dictionary containing the next page value and an array of posts.
 */
- (void)fetchPosts:(NSString *)nextPage
           success:(void(^)(NSDictionary *postsDictionary))success
        andFailure:(void(^)(NSError *error))failure;

@end