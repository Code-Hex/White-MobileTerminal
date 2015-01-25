//
//  UIBorderOnlyButton.m
//  MobileTerminal
//
//  Created by CodeHex on 2015/01/23.
//
//

#import "UIBorderOnlyButton.h"

@implementation UIBorderOnlyButton

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    super.backgroundColor = selected ? [UIColor colorWithCGColor:self.layer.borderColor] : self.BackgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _BackgroundColor = backgroundColor;
}

@end