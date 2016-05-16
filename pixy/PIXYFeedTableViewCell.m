//
//  PIXYFeedTableViewCell.m
//  pixy
//
//  Created by Dana Shakiba on 5/15/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import "PIXYFeedTableViewCell.h"
#import "PIXYPostModel.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface PIXYFeedTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

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
    [self.authorLabel setText:[post formattedAuthorString]];
    
    [self.thumbnailButton sd_setImageWithURL:_post.thumbnailURL
                                    forState:UIControlStateNormal
                            placeholderImage:[UIImage imageNamed:@"Thumbnail Placeholder"]];
    
    [self.titleLabel setText:_post.postTitle];

    if (self.titleLabel.gestureRecognizers.count == 0) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(titleLableTapped)];
        [self.titleLabel addGestureRecognizer:tapGesture];
    }
    
    NSString *commentsTitle = [NSString stringWithFormat:@"%zd Comments", _post.numComments];
    [self.commentsButton setTitle:commentsTitle
                         forState:UIControlStateNormal];
    
    [self.scoreLabel setText:[NSString stringWithFormat:@"%zd", _post.score]];
}

#pragma ------------------------------------------------------------------------
#pragma mark - Button Actions
#pragma ------------------------------------------------------------------------

- (void)titleLableTapped
{
    if ([[UIApplication sharedApplication] canOpenURL:_post.permalink]) {
        [[UIApplication sharedApplication] openURL:_post.permalink];
    }
}

- (IBAction)commentsButtonAction
{
    if ([[UIApplication sharedApplication] canOpenURL:_post.permalink]) {
        [[UIApplication sharedApplication] openURL:_post.permalink];
    }
}

- (IBAction)thumbnailButtonAction
{
    [self.delegate thumbnailTapped:self];
}

@end