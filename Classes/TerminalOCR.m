//
//  TerminalOCR.m
//  MobileTerminal
//
//  Created by CodeHex on 2015/02/15.
//
//

#import "TerminalOCR.h"
#import "Terminal/TerminalKeyboard.h"
#import "Terminal/TerminalGroupView.h"
#import "MobileTerminalViewController.h"

@implementation TerminalOCR
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
    _ocr = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    _ocr.delegate = self;
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 240, 28)];
    self.textField.delegate = self;
    [self.textField setBorderStyle:UITextBorderStyleRoundedRect];
    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] initWithCustomView:self.textField];
    [toolbarItems addObject:commentItem];
    self.Done = [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                       style:UIBarButtonItemStyleBordered
                                                      target:nil
                                                      action:@selector(posocr:)];
    [toolbarItems addObject:self.Done];
    [self.commentToolbar setItems:toolbarItems];

}

-(void)doneBtnClicked {
    [self.textview resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cameraButtonTapped:(id)sender {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePickerController setAllowsEditing:YES];
        [imagePickerController setDelegate:self];
    
        [self presentViewController:imagePickerController animated:YES completion:nil];

}

- (IBAction)KeyInputButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [_delegate sendtext:self.textview.text];
    }];
}

- (IBAction)Done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageview.image = chosenImage;
    CIImage *ciImage = [[CIImage alloc] initWithImage:self.imageview.image];
    
    CIFilter *ciFilter =
    [CIFilter filterWithName:@"CIColorMonochrome"
               keysAndValues:kCIInputImageKey, ciImage,
     @"inputColor", [CIColor colorWithRed:0.75 green:0.75 blue:0.75],
     @"inputIntensity", [NSNumber numberWithFloat:1.0],
     nil];
    
    ciFilter =
    [CIFilter filterWithName:@"CIColorControls"
               keysAndValues:kCIInputImageKey, [ciFilter outputImage],
     @"inputSaturation", [NSNumber numberWithFloat:0.0],
     @"inputBrightness", [NSNumber numberWithFloat:-1.0],
     @"inputContrast", [NSNumber numberWithFloat:4.0],
     nil];
    
    ciFilter =
    [CIFilter filterWithName:@"CIUnsharpMask"
               keysAndValues:kCIInputImageKey, [ciFilter outputImage],
     @"inputRadius", [NSNumber numberWithFloat:2.5],
     @"inputIntensity", [NSNumber numberWithFloat:0.5],
     nil];
    
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImage =
    [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
    
    // 文字解析対象の画像の色、コントラストを調整したものを変数に保存する
    UIImage *adjustedImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
   _ocr.image = adjustedImage;
    [_ocr recognize];
    
    self.textview.text = _ocr.recognizedText;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)dealloc {
    [_textview release];
    [_camera release];
    [_keyinput release];
    [_imageview release];
    [_Done release];
    [_ocr release];
    [super dealloc];
}
@end