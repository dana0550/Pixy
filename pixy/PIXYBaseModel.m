//
//  PIXYBaseModel.m
//  pixy
//
//  Created by Dana Shakiba on 5/14/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import "PIXYBaseModel.h"

@implementation PIXYBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary
{
    NSError *error = nil;
    id userModel = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:dictionary error:&error];
    
    if (error != nil) {
        NSLog(@">>> Model Error: %@", error);
    }
    
    return userModel;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary error:(NSError **)error
{
    self = [super initWithDictionary:dictionary error:error];
    if (self == nil) return nil;
    return self;
}

+ (NSArray *)getModelsFromArray:(NSArray *)array
{
    NSError *error;
    NSArray *modelArray = [MTLJSONAdapter modelsOfClass:self.class fromJSONArray:array error:&error];
    if (error) {
        NSLog(@"Get Models From Array ERROR %@", error.localizedDescription);
    }
    return modelArray;
}

@end