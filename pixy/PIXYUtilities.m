//
//  PIXYUtilities.m
//  pixy
//
//  Created by Dana Shakiba on 5/15/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import "PIXYUtilities.h"

@implementation PIXYUtilities

#pragma ------------------------------------------------------------------------
#pragma mark - Color Utilities
#pragma ------------------------------------------------------------------------

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString withAlpha:(CGFloat)alpha {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
+ (UIImage *)resizeImage:(UIImage *)image
                 newSize:(CGSize)newSize
    interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:image
                      newSize:newSize
                    transform:[self transformForOrientation:image newSize:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
+ (UIImage *)resizedImage:(UIImage *)image
                  newSize:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = image.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
+ (CGAffineTransform)transformForOrientation:(UIImage *)image
                                     newSize:(CGSize)newSize {
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    return transform;
}

#pragma ------------------------------------------------------------------------
#pragma mark - View Stuff
#pragma ------------------------------------------------------------------------

+ (void)centerView:(UIView *)view
{
    CGPoint center = CGPointMake(CGRectGetMidX(view.superview.bounds), CGRectGetMidY(view.superview.bounds));
    [view setCenter:center];
}

+ (void)horizontalCenterView:(UIView *)view
{
    CGRect frame = CGRectMake(CGRectGetMidX(view.superview.bounds) - CGRectGetMidX(view.bounds),
                              view.frame.origin.y,
                              view.frame.size.width,
                              view.frame.size.height);
    [view setFrame:frame];
}

+ (void)verticalCenterView:(UIView *)view
{
    CGRect frame = CGRectMake(view.frame.origin.x,
                              CGRectGetMidY(view.superview.bounds) - CGRectGetMidY(view.bounds),
                              view.frame.size.width,
                              view.frame.size.height);
    [view setFrame:frame];
}

+ (void)setFrameOriginX:(UIView *)view xOrigin:(CGFloat)xOrigin
{
    CGRect frame = CGRectMake(xOrigin,
                              view.frame.origin.y,
                              view.frame.size.width,
                              view.frame.size.height);
    [view setFrame:frame];
}

+ (void)setFrameOriginY:(UIView *)view yOrigin:(CGFloat)yOrigin
{
    CGRect frame = CGRectMake(view.frame.origin.x,
                              yOrigin,
                              view.frame.size.width,
                              view.frame.size.height);
    [view setFrame:frame];
}

+ (void)setFrameWidth:(UIView *)view width:(CGFloat)width
{
    CGRect frame = CGRectMake(view.frame.origin.x,
                              view.frame.origin.y,
                              width,
                              view.frame.size.height);
    [view setFrame:frame];
}

+ (void)setFrameHeight:(UIView *)view height:(CGFloat)height
{
    CGRect frame = CGRectMake(view.frame.origin.x,
                              view.frame.origin.y,
                              view.frame.size.width,
                              height);
    [view setFrame:frame];
}

+ (void)setFrameSize:(UIView *)view size:(CGSize)size
{
    CGRect frame = CGRectMake(view.frame.origin.x,
                              view.frame.origin.y,
                              size.width,
                              size.height);
    [view setFrame:frame];
}

#pragma ------------------------------------------------------------------------
#pragma mark - Attributed Strings
#pragma ------------------------------------------------------------------------

+ (NSMutableAttributedString *)mutableAttributedString:(NSString *)text
                                                  font:(UIFont *)font
                                             fontColor:(UIColor *)fontColor
{
    if (text == nil) {
        text = @"";
    }
    
    NSMutableAttributedString *mAttString = [[NSMutableAttributedString alloc] initWithString:text];
    [mAttString addAttribute:NSForegroundColorAttributeName value:fontColor
                       range:NSMakeRange(0, [text length])];
    [mAttString addAttribute:NSFontAttributeName value:font
                       range:NSMakeRange(0, [text length])];
    return mAttString;
}

#pragma ------------------------------------------------------------------------
#pragma mark - CGRectUtilites
#pragma ------------------------------------------------------------------------

+ (CGFloat)yOriginCentered:(UIView *)viewToCenter inContainerView:(UIView *)containerView
{
    CGFloat yOrigin = (containerView.bounds.size.height - viewToCenter.bounds.size.height) / 2.0f;
    return yOrigin;
}

#pragma ------------------------------------------------------------------------
#pragma mark - UIImage Utilities
#pragma ------------------------------------------------------------------------

CGSize imageSizeFromUIImage(UIImage *image)
{
    CGSize scaledImageSize = CGSizeMake(image.size.width * [UIScreen mainScreen].scale,
                                        image.size.height * [UIScreen mainScreen].scale);
    return scaledImageSize;
}

#pragma ------------------------------------------------------------------------
#pragma mark - Navigation Bar
#pragma ------------------------------------------------------------------------

+ (void)setNavigationBarColor:(UIColor *)color
                     animated:(BOOL)animated
{
    CGFloat duration = 0.0f;
    if (animated) duration = 0.25f;
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [[PixyAppDelegate navContoller].navigationBar setBarTintColor:color];
                     } completion:^(BOOL finished) {
                         
                     }];
}

+ (void)showHideNavigationBar
{
    BOOL hide = ![PixyAppDelegate navContoller].navigationBar.hidden;
    [[PixyAppDelegate navContoller] setNavigationBarHidden:hide
                                                  animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:hide
                                            withAnimation:UIStatusBarAnimationSlide];
}

+ (void)hideNavigationBar
{
    BOOL hidden = [PixyAppDelegate navContoller].navigationBar.hidden;
    if (!hidden) {
        [[PixyAppDelegate navContoller] setNavigationBarHidden:YES
                                                      animated:YES];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                withAnimation:UIStatusBarAnimationSlide];
    }
}

#pragma ------------------------------------------------------------------------
#pragma mark - View Snapshotting
#pragma ------------------------------------------------------------------------

+ (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end