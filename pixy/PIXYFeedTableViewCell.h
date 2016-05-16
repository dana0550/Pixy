//
//  PIXYFeedTableViewCell.h
//  pixy
//
//  Created by Dana Shakiba on 5/15/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIXYPostModel;

@interface PIXYFeedTableViewCell : UITableViewCell

- (void)setupWithPost:(PIXYPostModel *)post;

@end
