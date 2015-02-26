// MobileTerminalViewController.h
// MobileTerminal

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "MenuView.h"
#import "Preferences/PreferencesViewController.h"
#import "Frameworks/TesseractOCR.framework/Headers/TesseractOCR.h"
#import "HPGrowingTextView/class/HPGrowingTextView.h"
#import "SVModalWebViewController.h"
#import "Frameworks/GPUImage.framework/Headers/GPUImage.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "WYPopoverController/WYPopoverController.h"
#import "fnviewcontroller.h"

@class TerminalGroupView;
@class TerminalKeyboard;
@class GestureResponder;
@class GestureActionRegistry;
@class ColorMap;
@class SVModalWebViewController;
@class WYPopoverController;
@class fnviewcontroller;

// Protocol to get notified about when the preferences button is pressed.
// TOOD(allen): We should find a better way to do this.
@protocol MobileTerminalInterfaceDelegate
@required
- (void)preferencesButtonPressed;
- (void)rootViewDidAppear;
@end

@interface MobileTerminalViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIPopoverControllerDelegate, MenuViewDelegate, TesseractDelegate, HPGrowingTextViewDelegate, WYPopoverControllerDelegate, fnviewcontrollerDelegate>{
@private
  UIView* contentView;
  TerminalGroupView* terminalGroupView;
  UIPageControl* terminalSelector;
  TerminalKeyboard* terminalKeyboard;
  BOOL shouldShowKeyboard;
  // If the keyboard is actually shown right now (not if it should be shown)
  BOOL keyboardShow;
  BOOL copyPasteEnabled;
  UIButton* preferencesButton;
  UIButton* menuButton;
  MenuView* menuView;
  id<MobileTerminalInterfaceDelegate> interfaceDelegate;
  GestureResponder* gestureResponder;
  GestureActionRegistry* gestureActionRegistry;
  UIBarButtonItem *hidemenu;
  UIBarButtonItem *change;
  UIBarButtonItem *camera;
  UIBarButtonItem *send;
  UIButton *browser;
  UIButton *ocr;
  Tesseract *tesseract;  
  SVModalWebViewController *webcontroller;
  HPGrowingTextView *textView;
  MBProgressHUD *hud;
  WYPopoverController *popover;
  fnviewcontroller *FNController;
  UIButton *box;
  UIButton *backbtn;
}

@property (nonatomic, retain) IBOutlet UIView* contentView;
@property (nonatomic, retain) IBOutlet TerminalGroupView* terminalGroupView;
@property (nonatomic, retain) IBOutlet UIPageControl* terminalSelector;
@property (nonatomic, retain) IBOutlet UIButton* preferencesButton;
@property (nonatomic, retain) IBOutlet UIButton* menuButton;
@property (nonatomic, retain) IBOutlet id<MobileTerminalInterfaceDelegate> interfaceDelegate;
@property (nonatomic, retain) IBOutlet MenuView* menuView;
@property (nonatomic, retain) IBOutlet GestureResponder* gestureResponder;
@property (nonatomic, retain) IBOutlet GestureActionRegistry* gestureActionRegistry;
@property (nonatomic, retain) IBOutlet ColorMap* colorMap;
@property (nonatomic, retain) IBOutlet UIToolbar *texttoolbar;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIButton *toolview;
@property (nonatomic, retain) IBOutlet UIButton *keyhide;
@property (nonatomic, retain) IBOutlet UIButton *browser;
@property (nonatomic, retain) IBOutlet UIButton *ocr;
@property (nonatomic, retain) IBOutlet UIView *behind;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *hidemenu;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *change;
@property (nonatomic, retain) IBOutlet SVModalWebViewController *webcontroller;
@property (nonatomic, retain) IBOutlet HPGrowingTextView *textView;
@property (nonatomic, retain) IBOutlet fnviewcontroller *FNController;
@property (nonatomic, retain) IBOutlet Tesseract *tesseract;
@property (nonatomic, retain) IBOutlet UIButton *box;
@property (nonatomic, retain) IBOutlet UIImagePickerController *imagePickerController;
@property UIEdgeInsets tappableInsets;

@end

