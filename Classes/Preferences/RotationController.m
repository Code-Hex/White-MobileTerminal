//
//  RotationController.m
//  MobileTerminal
//
//  Created by CodeHex on 2015/01/03.
//
//

#import "RotationController.h"

@implementation UINavigationController (Portrait)
- (NSUInteger)supportedInterfaceOrientations
{
    if ([[self.viewControllers lastObject] isKindOfClass:[MobileTerminalViewController class]])
        return UIInterfaceOrientationMaskAllButUpsideDown;
    else
        return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end