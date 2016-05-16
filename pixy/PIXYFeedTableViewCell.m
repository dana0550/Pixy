//
//  PIXYFeedTableViewCell.m
//  pixy
//
//  Created by Dana Shakiba on 5/15/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import "PIXYFeedTableViewCell.h"
#import "PIXYPostModel.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "DateTools.h"

@interface PIXYFeedTableViewCell()

@property (weak, nonatomic) PIXYPostModel *post;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PIXYFeedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma ------------------------------------------------------------------------
#pragma mark - Public Methods
#pragma ------------------------------------------------------------------------

- (void)setupWithPost:(PIXYPostModel *)post
{
    _post = post;
    [self.authorLabel setText:[self formattedAuthorString]];
    [self.thumbnailImageView sd_setImageWithURL:_post.thumbnailURL
                               placeholderImage:nil];
    [self.titleLabel setText:_post.postTitle];
    
    if (self.titleLabel.gestureRecognizers.count == 0) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(titleLableTapped)];
        [self.titleLabel addGestureRecognizer:tapGesture];
    }
}

#pragma ------------------------------------------------------------------------
#pragma mark - Private Methods
#pragma ------------------------------------------------------------------------

- (NSString *)formattedAuthorString
{
    NSString *string = [NSString stringWithFormat:@"%@ \u2022 %@",
                        _post.author,
                        [_post.created shortTimeAgoSinceNow]];
    return string;
}

- (void)titleLableTapped
{
    if ([[UIApplication sharedApplication] canOpenURL:_post.permalink]) {
        [[UIApplication sharedApplication] openURL:_post.permalink];
    }
}

@end