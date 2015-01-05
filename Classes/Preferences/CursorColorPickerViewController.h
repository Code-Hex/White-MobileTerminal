//
//  CursorColorPickerViewController.h
//  MobileTerminal
//
//  Created by CodeHex on 2015/01/03.
//
//

#import <UIKit/UIKit.h>
#import "../Color-Picker-for-iOS/ColorPicker/HRColorPickerView.h"

@class HRColorPickerView;

@protocol CursorColorPickerViewControllerDelegate
- (void)setSelectedColor:(UIColor *)color;
@end

@interface CursorColorPickerViewController : UIViewController{
    HRColorPickerView *colorPickerView;
    UIColor *color;
    BOOL fullColor;
}
- (id)initWithColor:(UIColor *)defaultColor fullColor:(BOOL)fullColor;

@property (retain) id <CursorColorPickerViewControllerDelegate> delegate;

@end