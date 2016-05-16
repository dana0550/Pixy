//
//  PIXYFeedTableViewCell.h
//  pixy
//
//  Created by Dana Shakiba on 5/15/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIXYFeedTableViewCell;
@class PIXYPostModel;

@protocol PIXYFeedTableViewCellDelegate <NSObject>

@optional
/**
 This delegate method is called when the thumbnail image of a post is tapped.
 @returns Returns PIXYPostModel for the selected post.
 */
- (void)thumbnailTapped:(PIXYFeedTableViewCell *)cell;

@end

@interface PIXYFeedTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PIXYFeedTableViewCellDelegate>delegate;
@property (weak, nonatomic) PIXYPostModel *post;
@property (weak, nonatomic) IBOutlet UIButton *thumbnailButton;

/**
 This sets up the table view cell. Meant to be called from cellForRowAtIndexPath
 method.
 @param Pass the PIXYPostModel to this method.
 */
- (void)setupWithPost:(PIXYPostModel *)post;

@end