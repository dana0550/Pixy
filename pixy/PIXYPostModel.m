//
//  PIXYPostModel.m
//  pixy
//
//  Created by Dana Shakiba on 5/14/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import "PIXYPostModel.h"
#include "PIXYNetworking.h"

@implementation PIXYPostModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"postID"                  : @"id",
             @"author"                  : @"author",
             @"created"                 : @"created_utc",
             @"numComments"             : @"num_comments",
             @"permalink"               : @"permalink",
             @"score"                   : @"score",
             @"thumbnailURL"            : @"thumbnail",
             @"postTitle"               : @"title",
             @"imageURL"                : @"url"
             };
}

#pragma ------------------------------------------------------------------------
#pragma mark - Value Transformers
#pragma ------------------------------------------------------------------------

+ (NSValueTransformer *)createdJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id created,
                                                                 BOOL *success,
                                                                 NSError *__autoreleasing *error) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[created intValue]];
        return date;
    }];
}

+ (NSValueTransformer *)permalinkJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *urlString,
                                                                 BOOL *success,
                                                                 NSError *__autoreleasing *error) {
        NSString *prefix = @"https://www.reddit.com";
        NSString *secureURLString = [prefix stringByAppendingString:urlString];
        NSURL *url = [NSURL URLWithString:secureURLString];
        return url;
    }];
}

+ (NSValueTransformer *)thumbnailURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *urlString,
                                                                 BOOL *success,
                                                                 NSError *__autoreleasing *error) {
        NSString *secureURLString = [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
        NSURL *url = [NSURL URLWithString:secureURLString];
        return url;
    }];
}

+ (NSValueTransformer *)imageURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *urlString,
                                                                 BOOL *success,
                                                                 NSError *__autoreleasing *error) {
        NSString *secureURLString = [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
        NSURL *url = [NSURL URLWithString:secureURLString];
        return url;
    }];
}

+ (NSArray *)getModelsFromArray:(NSArray *)JSONarray
{
    // Preprocessing of Array
    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSDictionary *JSONDictionary in JSONarray) {
        [tempArray addObject:JSONDictionary[@"data"]];
    }
    
    NSError *error;
    NSArray *modelArray = [MTLJSONAdapter modelsOfClass:self.class
                                          fromJSONArray:tempArray
                                                  error:&error];
    if (error) {
        NSLog(@"Error getting model objects: %@", error.localizedDescription);
    }
    
    return modelArray;
}

#pragma ------------------------------------------------------------------------
#pragma mark - Networking
#pragma ------------------------------------------------------------------------

+ (void)fetchPosts:(NSString *)nextPage
           success:(void(^)(NSDictionary *postsDictionary))success
           failure:(void(^)(NSError *error))failure
{
    [[PIXYNetworking sharedInstance] fetchPosts:nextPage
                                        success:^(NSDictionary *postsDictionary) {
                                            if (success) success(postsDictionary);
                                        } andFailure:^(NSError *error) {
                                            if (failure) failure(error);
                                        }];
}

@end