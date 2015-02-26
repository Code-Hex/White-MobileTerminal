//
//  pointInside.m
//  MobileTerminal
//
//  Created by CodeHex on 2015/02/20.
//
//

#import <UIKit/UIKit.h>

@interface UIView (pointInside)
@property UIEdgeInsets tappableInsets;
@end

@implementation UIButton (pointInside)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = self.bounds;
    // 自身の bounds を Insets 分大きさを変える
    rect.origin.x += self.tappableInsets.left;
    rect.origin.y += self.tappableInsets.top;
    rect.size.width -= (self.tappableInsets.left + self.tappableInsets.right);
    rect.size.height -= (self.tappableInsets.top + self.tappableInsets.bottom);
    // 変更した rect に point が含まれるかどうかを返す
    return CGRectContainsPoint(rect, point);
}

@end