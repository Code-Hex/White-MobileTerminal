//
//  CursorColorPickerViewController.m
//  MobileTerminal
//
//  Created by CodeHex on 2015/01/03.
//  Based on Copyright (c) 2014 Hayashi Ryota. All rights reserved.
//

#import "CursorColorPickerViewController.h"
#import "../Color-Picker-for-iOS/ColorPicker/HRColorPickerView.h"
#import "../Color-Picker-for-iOS/ColorPicker/HRColorPickerView.h"
#import "../Color-Picker-for-iOS/ColorPicker/HRColorMapView.h"
#import "../Color-Picker-for-iOS/ColorPicker/HRBrightnessSlider.h"

@implementation CursorColorPickerViewController


- (id)initWithColor:(UIColor *)defaultColor fullColor:(BOOL)_fullColor {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        color = defaultColor;
        fullColor = _fullColor;
    }
    return self;
}


- (void)loadView {
    UIBarButtonItem *save_btn = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Save"
                                 style:UIBarButtonSystemItemSave
                                 target:self
                                 action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = save_btn;
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    colorPickerView = [[HRColorPickerView alloc] init];
    colorPickerView.color = color;
    
    if (fullColor) {
        HRColorMapView *colorMapView = [[HRColorMapView alloc] init];
        colorMapView.saturationUpperLimit = @1;
        colorMapView.tileSize = @16;
        [colorPickerView addSubview:colorMapView];
        colorPickerView.colorMapView = colorMapView;
        
        HRBrightnessSlider *slider = [[HRBrightnessSlider alloc] init];
        slider.brightnessLowerLimit = @0;
        [colorPickerView addSubview:slider];
        colorPickerView.brightnessSlider = slider;
    }
    
    [self.view addSubview:colorPickerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.delegate) {
        [self.delegate setSelectedColor:colorPickerView.color];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    colorPickerView.frame = (CGRect) {.origin = CGPointZero, .size = self.view.frame.size};
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        CGRect frame = colorPickerView.frame;
        frame.origin.y = self.topLayoutGuide.length;
        frame.size.height -= self.topLayoutGuide.length;
        colorPickerView.frame = frame;
    }
}

- (void)save:(id)sender{
    NSUserDefaults *colorDefaults = [NSUserDefaults standardUserDefaults];
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:colorPickerView.color];
    [colorDefaults setObject:colorData forKey:@"Term_Cursor"];
    [colorDefaults synchronize];
    
    int rand = (int)arc4random_uniform(10);
    
    NSString *text = !rand?@"Unbelievable 😵":rand==1?@"Wow!! 😵":rand==2?@"That's awesome!! ☺️":rand==3?@"I can hardly wait! 😵":rand==4?@"How wonderful!! 😊":rand==5?@"That's pretty amazing!! 😊":rand==6?@"Really!? 😵":rand==7?@"I agree ☺️":rand==8?@"Excellent!! 😀":@"That's Nice!! 😀";
    Class class = NSClassFromString(@"UIAlertController");
    if(class){
        UIAlertController *alert = nil;
        alert = [UIAlertController alertControllerWithTitle:@"Accomplished"
                                                    message:text
                                             preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Accomplished"
                                                        message:text
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


@end