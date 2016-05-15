//
//  PIXYPostModel.h
//  pixy
//
//  Created by Dana Shakiba on 5/14/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import "PIXYBaseModel.h"

@interface PIXYPostModel : PIXYBaseModel

/**
 The post id.
 */
@property (nonatomic, copy) NSString *postID;

/**
 The author of the post.
 */
@property (nonatomic, copy) NSString *author;

/**
 The creation time of the post.
 */
@property (nonatomic) NSDate *created;

/**
 The number of comments on the post.
 */
@property (nonatomic, assign) NSInteger numComments;

/**
 Link to the post.
 */
@property (nonatomic) NSURL *permalink;

/**
 The net score of the post.
 */
@property (nonatomic, assign) NSInteger score;

/**
 The thumbnail image of the post.
 */
@property (nonatomic) NSURL *thumbnailURL;

/**
 The image URL of the post.
 */
@property (nonatomic) NSURL *imageURL;

/**
 The title of the post.
 */
@property (nonatomic, copy) NSString *postTitle;

@end