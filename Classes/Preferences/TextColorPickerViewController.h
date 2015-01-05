//
//  TextColorPickerViewController.h
//  MobileTerminal
//
//  Created by CodeHex on 2015/01/03.
//
//

#import <UIKit/UIKit.h>
#import "../Color-Picker-for-iOS/ColorPicker/HRColorPickerView.h"

@class HRColorPickerView;

@protocol TextColorPickerViewControllerDelegate
- (void)setSelectedColor:(UIColor *)color;
@end

@interface TextColorPickerViewController : UIViewController{
    HRColorPickerView *colorPickerView;
    UIColor *color;
    BOOL fullColor;
}
- (id)initWithColor:(UIColor *)defaultColor fullColor:(BOOL)fullColor;

@property (retain) id <TextColorPickerViewControllerDelegate> delegate;

@end