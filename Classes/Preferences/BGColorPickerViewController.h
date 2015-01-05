//
//  BGColorPickerViewController.h
//  MobileTerminal
//
//  Created by CodeHex on 2015/01/03.
//
//

#import <UIKit/UIKit.h>
#import "../Color-Picker-for-iOS/ColorPicker/HRColorPickerView.h"

@class HRColorPickerView;

@protocol BGColorPickerViewControllerDelegate
- (void)setSelectedColor:(UIColor *)color;
@end

@interface BGColorPickerViewController : UIViewController{
    HRColorPickerView *colorPickerView;
    UIColor *color;
    UIButton *save;
    BOOL fullColor;
}
- (id)initWithColor:(UIColor *)defaultColor fullColor:(BOOL)fullColor;

@property (retain) id <BGColorPickerViewControllerDelegate> delegate;

@end