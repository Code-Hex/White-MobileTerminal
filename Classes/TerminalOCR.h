//
//  TerminalOCR.h
//  MobileTerminal
//
//  Created by CodeHex on 2015/02/15.
//
//

#import <UIKit/UIKit.h>
#import "TesseractOCR.framework/Headers/TesseractOCR.h"
#import <HPGrowingTextView/HPGrowingTextView.h>

@class TerminalKeyboard;
@class TerminalGroupView;

@protocol OCRViewDelegate <NSObject>
@required
-(void)sendtext:(NSString*)strings;
@end

@interface TerminalOCR : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, TesseractDelegate, HPGrowingTextViewDelegate> {
    @private
    id<OCRViewDelegate> _delegate;
    UIView *containerView;
    HPGrowingTextView *textView;
}
@property (retain, nonatomic) IBOutlet UITextField *textField;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *camera;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *keyinput;
@property (retain, nonatomic) IBOutlet UIImageView *imageview;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *Done;
@property (retain, nonatomic) IBOutlet id<OCRViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet Tesseract *ocr;

@end
