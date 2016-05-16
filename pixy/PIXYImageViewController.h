//
//  PIXYImageViewController.h
//  pixy
//
//  Created by Dana Shakiba on 5/15/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIXYPostModel;

@interface PIXYImageViewController : UIViewController

@property (weak, nonatomic) PIXYPostModel *post;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (assign, nonatomic) CGRect initialThumbnailFrame;

@end