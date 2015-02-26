//
//  UIImagefix.h
//  MobileTerminal
//
//  Created by CodeHex on 2015/02/26.
//
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>
@interface UIImage (title)
- (UIImage *)makeimgofsize:(CGSize)size;
- (UIImage *)imageWithText:(NSString *)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize rectSize:(CGSize)rectSize;
- (UIImage *)imageWithColor:(UIColor *)color;
@end
