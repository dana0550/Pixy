//
//  PIXYImageViewController.m
//  pixy
//
//  Created by Dana Shakiba on 5/15/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import "PIXYImageViewController.h"
#import "PIXYUtilities.h"
#import "PIXYPostModel.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DateTools.h"

@interface PIXYImageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation PIXYImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = [_post formattedAuthorString];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    // Scroll View Setup
    self.imageScrollView.minimumZoomScale = 1.0f;
    self.imageScrollView.maximumZoomScale = 6.0f;
    [self setupGestureRecognizers];
}

- (void)back:(UIBarButtonItem *)sender
{
    // Set Nav Bar Color
    UIColor *barColor = [UIColor colorWithRed:(101.0/255.0)
                                        green:(175.0/255.0)
                                         blue:(255.0/255.0)
                                        alpha:1.0f];
    [PIXYUtilities setNavigationBarColor:barColor
                                animated:YES];
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [_imageView setFrame:_initialThumbnailFrame];
                         [self.overlayView setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         [self.navigationController popViewControllerAnimated:NO];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.backgroundImageView setImage:_backgroundImage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.initialThumbnailFrame];
    [_imageView setClipsToBounds:YES];
    [_imageView setUserInteractionEnabled:YES];
    [_imageView setBackgroundColor:[UIColor clearColor]];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_imageView sd_setImageWithURL:_post.thumbnailURL];
    [_imageView sd_setImageWithURL:_post.imageURL
                 placeholderImage:_imageView.image
                          options:SDWebImageHighPriority];
    [self.imageScrollView addSubview:_imageView];
    
    CGRect finalImageViewFrame = self.view.bounds;
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         [self.overlayView setAlpha:1.0];
                         [_imageView setFrame:finalImageViewFrame];
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)setupGestureRecognizers
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(imageTapped)];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(zoom:)];
    [doubleTap setNumberOfTapsRequired:2];
    
    [self.imageScrollView addGestureRecognizer:singleTap];
    [self.imageScrollView addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

#pragma ------------------------------------------------------------------------
#pragma mark - ScrollView Zooming
#pragma ------------------------------------------------------------------------

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView
                      withScale:(float)scale
                     withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

#pragma ------------------------------------------------------------------------
#pragma mark - Gesture Recognizer Handlers
#pragma ------------------------------------------------------------------------

- (void)imageTapped
{
    [PIXYUtilities showHideNavigationBar];
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [_imageView setFrame:self.view.bounds];
                     }];
}

- (void)zoom:(UIGestureRecognizer *)gestureRecognizer
{
    CGFloat minZoomScale = self.imageScrollView.minimumZoomScale;
    CGFloat maxZoomScale = self.imageScrollView.maximumZoomScale;
    CGFloat zoomScale = self.imageScrollView.zoomScale;
    
    if (zoomScale > minZoomScale) {
        // Already Zoomed In, so reset to minimum zoom scale
        [self.imageScrollView setZoomScale:minZoomScale
                                  animated:YES];
    } else {
        // Zoom In
        CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
        
        // Calculate Zoom Rect
        CGSize svSize = self.imageScrollView.bounds.size;
        CGFloat width = svSize.width / maxZoomScale;
        CGFloat height = svSize.height / maxZoomScale;
        CGFloat x = touchPoint.x - (width / 2.0f);
        CGFloat y = touchPoint.y - (height / 2.0f);
        CGRect rectTozoom = CGRectMake(x, y, width, height);
        
        // Hang on to your butts
        [self.imageScrollView zoomToRect:rectTozoom animated:YES];
    }
}

@end