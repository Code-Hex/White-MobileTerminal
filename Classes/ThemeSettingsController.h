//
//  ThemeSettingsController.h
//  MobileTerminal
//
//  Created by CodeHex on 2014/12/31.
//
//

#import <UIKit/UIKit.h>
#import "BGColorPickerViewController.h"
#import "BoldColorPickerViewController.h"
#import "CursorColorPickerViewController.h"
#import "TextColorPickerViewController.h"

@interface ThemeSettingsController : UITableViewController {
@private
    NSMutableArray* sections;
    NSMutableArray* pickers;
    NSMutableArray* controllers;
    NSMutableArray* blackorwhite;
    NSMutableArray* keyboardtype;
}

@property (retain, nonatomic) IBOutlet UIViewController *BGColorPickerViewController;
@property (retain, nonatomic) IBOutlet UIViewController *TextColorPickerViewController;
@property (retain, nonatomic) IBOutlet UIViewController *BoldColorPickerViewController;
@property (retain, nonatomic) IBOutlet UIViewController *CursorColorPickerViewController;

@end
