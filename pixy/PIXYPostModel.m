//
//  PIXYPostModel.m
//  pixy
//
//  Created by Dana Shakiba on 5/14/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import "PIXYPostModel.h"

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
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)permalinkURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)thumbnailURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)imageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma ------------------------------------------------------------------------
#pragma mark - Utilities
#pragma ------------------------------------------------------------------------

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZ";
    return dateFormatter;
}

@end