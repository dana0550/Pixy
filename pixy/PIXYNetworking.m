//
//  PIXYNetworking.m
//  pixy
//
//  Created by Dana Shakiba on 5/14/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import "PIXYNetworking.h"
#import "PIXYPostModel.h"
@import AFNetworking;

@interface PIXYNetworking()

@property (nonatomic, strong) AFHTTPSessionManager *api;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation PIXYNetworking

#pragma ------------------------------------------------------------------------
#pragma mark - Initializers
#pragma ------------------------------------------------------------------------

+ (instancetype)sharedInstance
{
    static PIXYNetworking *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSURL *url = [NSURL URLWithString:@"https://www.reddit.com"];
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

#pragma ------------------------------------------------------------------------
#pragma mark - Posts
#pragma ------------------------------------------------------------------------

- (void)fetchPosts:(NSString *)nextPage
           success:(void(^)(NSDictionary *postsDictionary))success
        andFailure:(void(^)(NSError *error))failure
{
    [self GET:@"/r/pics/hot.json"
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          NSArray *dataArray = [[responseObject objectForKey:@"data"] objectForKey:@"children"];
          NSArray<PIXYPostModel *> *posts = [PIXYPostModel getModelsFromArray:dataArray];
          
          // Next Page Value
          NSString *nextPageValue = [[responseObject objectForKey:@"data"] objectForKey:@"after"];
          if (nextPageValue == nil) nextPageValue = @"";
          
          NSDictionary *postsDict = @{@"nextPage"   : nextPageValue,
                                      @"posts"      : posts};
          if (success) success(postsDict);
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) failure(error);
      }];
}

#pragma ------------------------------------------------------------------------
#pragma mark - AFNetworking
#pragma ------------------------------------------------------------------------

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self.manager GET:URLString
                  parameters:parameters
                     success:success
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [self handleStatusCode:operation];
                         if (failure) failure(operation, error);
                     }];
}

#pragma ------------------------------------------------------------------------
#pragma mark - Error Codes
#pragma ------------------------------------------------------------------------

- (void)handleStatusCode:(AFHTTPRequestOperation *)operation
{
    NSInteger statusCode = [operation.response statusCode];
    switch (statusCode) {
        case 401:
            break;
        case 402:
            break;
        case 403:
            break;
            
        default:
            break;
    }
}

@end