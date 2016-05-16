//
//  PIXYUtilities.h
//  pixy
//
//  Created by Dana Shakiba on 5/15/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@import UIKit;

@interface PIXYUtilities : NSObject

#define PixyAppDelegate             ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark - Color
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)colorFromHexString:(NSString *)hexString withAlpha:(CGFloat)alpha;

#pragma mark - Resizes an image to the give size
+ (UIImage *)resizeImage:(UIImage *)image
                 newSize:(CGSize)newSize
    interpolationQuality:(CGInterpolationQuality)quality;

#pragma mark - View Stuff
+ (void)centerView:(UIView *)view;
+ (void)horizontalCenterView:(UIView *)view;
+ (void)verticalCenterView:(UIView *)view;
+ (void)setFrameOriginX:(UIView *)view xOrigin:(CGFloat)xOrigin;
+ (void)setFrameOriginY:(UIView *)view yOrigin:(CGFloat)yOrigin;
+ (void)setFrameWidth:(UIView *)view width:(CGFloat)width;
+ (void)setFrameHeight:(UIView *)view height:(CGFloat)height;
+ (void)setFrameSize:(UIView *)view size:(CGSize)size;

#pragma mark - Attributed Strings
+ (NSMutableAttributedString *)mutableAttributedString:(NSString *)text
                                                  font:(UIFont *)font
                                             fontColor:(UIColor *)fontColor;
#pragma mark - CGRect Utilites
+ (CGFloat)yOriginCentered:(UIView *)viewToCenter inContainerView:(UIView *)containerView;

#pragma mark - UIImage Utilities
CGSize imageSizeFromUIImage(UIImage *image);

#pragma mark - Navigation Bar
+ (void)setNavigationBarColor:(UIColor *)color animated:(BOOL)animated;
+ (void)showHideNavigationBar;
+ (void)hideNavigationBar;

#pragma mark - View Snapshotting
+ (UIImage *)snapshot:(UIView *)view;

@end