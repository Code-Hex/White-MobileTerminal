//
//  UIImagefix.m
//  MobileTerminal
//
//  Created by CodeHex on 2015/02/26.
//
//

#import "UIImagefix.h"

@implementation UIImage (title)
- (UIImage *)makeimgofsize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newThumbnail;
}

// http://captainshadow.hatenablog.com/entry/20121208/1354971284 Thanks!!
- (UIImage *)imageWithText:(NSString *)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize rectSize:(CGSize)rectSize {
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(rectSize, NO, 0.0f);
    else
        UIGraphicsBeginImageContext(rectSize);
    
    CGSize textAreaSize = [text sizeWithFont:font constrainedToSize:rectSize];
    
    [text drawInRect:CGRectMake((rectSize.width - textAreaSize.width) * 0.5f,
                                (rectSize.height - textAreaSize.height) * 0.5f,
                                textAreaSize.width,
                                textAreaSize.height)
            withFont:font
       lineBreakMode:NSLineBreakByWordWrapping
           alignment:NSTextAlignmentCenter];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
