//
//  PIXYBaseModel.h
//  pixy
//
//  Created by Dana Shakiba on 5/14/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PIXYBaseModel : MTLModel<MTLJSONSerializing>

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)getModelsFromArray:(NSArray *)array;

@end