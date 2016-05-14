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
+ (instancetype)sharedInstance;

#pragma mark - Posts
- (void)fetchPosts:(NSString *)nextPageURL
           success:(void(^)(NSDictionary *postsDictionary))success
        andFailure:(void(^)(NSError *error))failure;

@end