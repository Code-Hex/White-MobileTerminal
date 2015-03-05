// MobileTerminalViewController.m
// MobileTerminal

#import "MobileTerminalViewController.h"

#import "Terminal/TerminalKeyboard.h"
#import "Terminal/TerminalGroupView.h"
#import "Terminal/TerminalView.h"
#import "Preferences/Settings.h"
#import "Preferences/TerminalSettings.h"
#import "VT100/ColorMap.h"
#import "MenuView.h"
#import "GestureResponder.h"
#import "GestureActionRegistry.h"
#import <QuartzCore/QuartzCore.h>
#import "Preferences/UIBorderOnlyButton.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"

#define IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define CASE(str) if ([__s__ isEqualToString:(str)])
#define SWITCH(s) for (NSString *__s__ = (s); ; )
#define DEFAULT

@interface UIViewController (pop)

@end

@interface MobileTerminalViewController ()
@property (nonatomic) NSArray *commands;
@end

@implementation MobileTerminalViewController

@synthesize contentView;
@synthesize terminalGroupView;
@synthesize terminalSelector;
@synthesize preferencesButton;
@synthesize menuButton;
@synthesize interfaceDelegate;
@synthesize menuView;
@synthesize gestureResponder;
@synthesize gestureActionRegistry;
@synthesize colorMap;
@synthesize toolbar;
@synthesize keyhide;
@synthesize toolview;
@synthesize hidemenu;
@synthesize change;
@synthesize browser;
@synthesize ocr;
@synthesize webcontroller;
@synthesize texttoolbar;
@synthesize textView;
@synthesize tesseract;
@synthesize box;
@synthesize imagePickerController;
@synthesize FNController;

static NSString *const kFontIoniconsFamilyName = @"Ionicons";

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (void)awakeFromNib
{
  terminalKeyboard = [[TerminalKeyboard alloc] init];
    
  keyboardShow = NO;

  // Copy and paste is off by default
  copyPasteEnabled = NO;
}

- (void)registerForKeyboardNotifications
{

  [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
  
}

- (void)unregisterForKeyboardNotifications
{

  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

// New added functions
// https://github.com/coolstar/mobileterminal/blob/master/Classes/MobileTerminalViewController.m

-(void)up:(id)sender {
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x41] dataUsingEncoding:NSASCIIStringEncoding]];
}

-(void)down:(id)sender {
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x42] dataUsingEncoding:NSASCIIStringEncoding]];
}

-(void)right:(id)sender {
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x43] dataUsingEncoding:NSASCIIStringEncoding]];
}

-(void)left:(id)sender {
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x44] dataUsingEncoding:NSASCIIStringEncoding]];
}

-(void)space:(id)sender {
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c",(char)0x20] dataUsingEncoding:NSASCIIStringEncoding]];
}

-(void)bar:(id)sender {
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[@"|" dataUsingEncoding:NSASCIIStringEncoding]];
}

-(void)double_quotes:(id)sender {
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[@"\"" dataUsingEncoding:NSASCIIStringEncoding]];
}

-(void)grave_accent:(id)sender {
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[@"`" dataUsingEncoding:NSASCIIStringEncoding]];
}


-(void)longPress_left:(UILongPressGestureRecognizer *)left_sender {
    switch (left_sender.state) {
        case UIGestureRecognizerStateBegan:
            [self performSelector:@selector(repeat_left:) withObject:nil afterDelay:0.07];
            break;
            
        case UIGestureRecognizerStateEnded:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(repeat_left:) object:nil];
            break;
        default:
            NSLog(@"Default_left");
            break;

    }
    
}

-(void)repeat_left:(id)sender{
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x44] dataUsingEncoding:NSASCIIStringEncoding]];
    [self performSelector:@selector(repeat_left:) withObject:nil afterDelay:0.07];
}

-(void)longPress_right:(UILongPressGestureRecognizer *)right_sender {
    switch (right_sender.state) {
        case UIGestureRecognizerStateBegan:
            [self performSelector:@selector(repeat_right:) withObject:nil afterDelay:0.07];
            break;
            
        case UIGestureRecognizerStateEnded:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(repeat_right:) object:nil];
            break;
        default:
            NSLog(@"Default_right");
            break;
    }

}


-(void)repeat_right:(id)sender{
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x43] dataUsingEncoding:NSASCIIStringEncoding]];
    [self performSelector:@selector(repeat_right:) withObject:nil afterDelay:0.07];
}

-(void)longPress_up:(UILongPressGestureRecognizer *)up_sender {
    switch (up_sender.state) {
        case UIGestureRecognizerStateBegan:
            [self performSelector:@selector(repeat_up:) withObject:nil afterDelay:0.1];
            break;
            
        case UIGestureRecognizerStateEnded:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(repeat_up:) object:nil];
            break;
        default:
            NSLog(@"Default_up");
            break;
    }
    
}


-(void)repeat_up:(id)sender{
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x41] dataUsingEncoding:NSASCIIStringEncoding]];
    [self performSelector:@selector(repeat_up:) withObject:nil afterDelay:0.1];
}

-(void)longPress_down:(UILongPressGestureRecognizer *)down_sender {
    switch (down_sender.state) {
        case UIGestureRecognizerStateBegan:
            [self performSelector:@selector(repeat_down:) withObject:nil afterDelay:0.1];
            break;
            
        case UIGestureRecognizerStateEnded:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(repeat_down:) object:nil];
            break;
        default:
            NSLog(@"Default_down");
            break;
    }
    
}


-(void)repeat_down:(id)sender{
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x42] dataUsingEncoding:NSASCIIStringEncoding]];
    [self performSelector:@selector(repeat_down:) withObject:nil afterDelay:0.1];
}

-(void)longPress_space:(UILongPressGestureRecognizer *)space_sender {
    switch (space_sender.state) {
        case UIGestureRecognizerStateBegan:
            [self performSelector:@selector(repeat_space:) withObject:nil afterDelay:0.07];
            break;
            
        case UIGestureRecognizerStateEnded:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(repeat_space:) object:nil];
            break;
        default:
            NSLog(@"Default_space");
            break;
    }
    
}


-(void)repeat_space:(id)sender{
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c",(char)0x20] dataUsingEncoding:NSASCIIStringEncoding]];
    [self performSelector:@selector(repeat_space:) withObject:nil afterDelay:0.07];
}


-(void)esc:(id)sender {
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c",0x1b] dataUsingEncoding:NSASCIIStringEncoding]];
}

- (void)tab:(id)sender {
    [[terminalGroupView frontTerminal] receiveKeyboardInput:[NSData dataWithBytes:"\t" length:1]];
}

- (void)ctrl:(UIButton*)ctrl_button {
    TerminalKeyboard *keyInput = (TerminalKeyboard *)terminalKeyboard.inputTextField;
    keyInput.controlKeyMode = !keyInput.controlKeyMode;
    ctrl_button.selected = keyInput.controlKeyMode;
}



- (void)exit:(id)sender {
    Class class = NSClassFromString(@"UIAlertController");
    if(class){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Exit"
                                                    message:@"Would you like to exit it?"
                                             preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        
        UIAlertAction * okAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [[UIApplication sharedApplication] performSelector:@selector(suspend)];
                                   [NSThread sleepForTimeInterval:0.2];
                                   exit(0);
                               }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exit"
                                                        message:@"Would you like to exit it?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] performSelector:@selector(suspend)];
        [NSThread sleepForTimeInterval:0.2];
        exit(0);
    }
}

// TODO(allen): Fix the deprecation of UIKeyboardBoundsUserInfoKey
// below -- it requires more of a change because the replacement
// is not available in 3.1.3

- (void)keyboardWillShow:(NSNotification*)Notification
{
    CGRect keyboardFrameEnd = [[Notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey
                                ] CGRectValue];
    [self movecontentView:(self.view.frame.size.height + 6 - keyboardFrameEnd.size.height) notification:Notification];
}

- (void)keyboardWillHide:(NSNotification*)Notification
{
    CGRect keyboardFrame = [[Notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey
                                ] CGRectValue];
  [self movecontentView:(contentView.frame.size.height + keyboardFrame.size.height) notification:Notification];
}

- (void)keyboardDidChange:(NSNotification*)Notification
{
    CGRect keyboardFrame = [[Notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey
                                ] CGRectValue];
        [self movecontentView:(self.view.frame.size.height + 6 - keyboardFrame.size.height) notification:Notification];
}

- (void)movecontentView:(CGFloat)high notification:(NSNotification*)Notification
{
    NSTimeInterval duration = [[Notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve  = [[Notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    void (^animations)(void);
    animations = ^(void) {
        CGRect keyboardFrame = [[Notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        if (keyboardFrame.size.height > 0.f) {
            CGRect viewFrame = contentView.frame;
            viewFrame.size.height = high;
           contentView.frame = viewFrame;
        }
    };
    [UIView animateWithDuration:duration delay:0.f options:(curve << 16) animations:animations completion:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (keyboardShow) return;
    keyboardShow = YES;
}

- (void)keyboardWasHidden:(NSNotification*)aNotification
{
    if (!keyboardShow) return;
    keyboardShow = NO;
}

- (void)setShowKeyboard:(BOOL)showKeyboard
{
  if (showKeyboard)
    [terminalKeyboard becomeFirstResponder];
  else
    [terminalKeyboard resignFirstResponder];
}

- (void)toggleKeyboard:(id)sender
{
  BOOL isShow = keyboardShow;
  [self setShowKeyboard:!isShow];
}

- (void)toggleCopyPaste:(id)sender;
{
  copyPasteEnabled = !copyPasteEnabled;
  [gestureResponder setSwipesEnabled:!copyPasteEnabled];
  for (int i = 0; i < [terminalGroupView terminalCount]; ++i) {
    TerminalView* terminal = [terminalGroupView terminalAtIndex:i];
    [terminal setCopyPasteEnabled:copyPasteEnabled];
  }
}

// Invoked when the page control is clicked to make a new terminal active.  The
// keyboard events are forwarded to the new active terminal and it is made the
// front-most terminal view.
- (void)terminalSelectionDidChange:(id)sender 
{
  TerminalView* terminalView =
      [terminalGroupView terminalAtIndex:(int)[terminalSelector currentPage]];
  terminalKeyboard.inputDelegate = terminalView;
  gestureActionRegistry.terminalInput = terminalView;
  [terminalGroupView bringTerminalToFront:terminalView];
}

// Invoked when the preferences button is pressed
- (void)preferencesButtonPressed:(id)sender 
{
  // Remember the keyboard state for the next reload and don't listen for
  // keyboard hide/show events
  shouldShowKeyboard = keyboardShow;
  [self unregisterForKeyboardNotifications];

  [interfaceDelegate preferencesButtonPressed];
}

// Invoked when the menu button is pressed
- (void)menuButtonPressed:(id)sender 
{
    [menuView setHidden:![menuView isHidden]];
}

- (void)toolbarButtonPressed:(id)sender
{
    toolbar.layer.shouldRasterize = YES;
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFade;
    animation.duration = 0.25f;
    [toolbar.layer addAnimation:animation forKey:nil];
    [menuView setHidden:YES];
    [toolbar setHidden:![toolbar isHidden]];
    [menuButton setHidden:![menuButton isHidden]];
    [toolview setHidden:![toolview isHidden]];
    CGRect viewFrame = terminalGroupView.frame;
    if ([toolbar isHidden])
        viewFrame.size.height += 7.5;
    else
        viewFrame.size.height -= 7.5;
    terminalGroupView.frame = viewFrame;
}

// Invoked when a menu item is clicked, to run the specified command.
- (void)selectedCommand:(NSString*)command
{
  TerminalView* terminalView = [terminalGroupView frontTerminal];
  [terminalView receiveKeyboardInput:[command dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)handleCommand:(UIKeyCommand *)command
{
    NSString *input = command.input;
    
    UIKeyModifierFlags modifierFlags = command.modifierFlags;
    NSMutableString *inputCharacters = [[NSMutableString alloc] init];
    
    if ((modifierFlags & UIKeyModifierControl) == UIKeyModifierControl) {
        unichar c = [input characterAtIndex:0];
            c -= (c < 0x60 && c > 0x40) ? 0x40 : (c < 0x7B && c > 0x60) ? 0x60 : 0;
        [inputCharacters appendFormat:@"%c",c];
    } else if (input == UIKeyInputUpArrow)
        [inputCharacters appendFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x41];
    else if (input == UIKeyInputDownArrow)
        [inputCharacters appendFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x42];
    else if (input == UIKeyInputLeftArrow)
        [inputCharacters appendFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x44];
    else if (input == UIKeyInputRightArrow)
        [inputCharacters appendFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x43];
    else if (input == UIKeyInputEscape)
        [inputCharacters appendFormat:@"%c",(char)0x1b];

    [[terminalGroupView frontTerminal] receiveKeyboardInput:[inputCharacters dataUsingEncoding:NSUTF8StringEncoding]];
    [inputCharacters release];
}

- (NSArray *)keyCommands
{
    return self.commands;
}

/*
- (void)keyappear:(id)sender
{
    if (!keyboardShow)
        [terminalKeyboard becomeFirstResponder];
}
*/


- (void)viewDidLoad {
  [super viewDidLoad];
    
    unichar ichar = 0xf03a;
    NSString* menu = [[[NSString alloc] initWithCharacters:&ichar length:1] autorelease];
    [menuButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:18]];
    [menuButton setTitle:menu forState:UIControlStateNormal];
    ichar = 0xf085;
    NSString* conf = [[[NSString alloc] initWithCharacters:&ichar length:1] autorelease];
    [preferencesButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:18]];
    [preferencesButton setTitle:conf forState:UIControlStateNormal];
    ichar = 0xf131;
    NSString* eject = [[[NSString alloc] initWithCharacters:&ichar length:1] autorelease];
    [keyhide.titleLabel setFont:[UIFont fontWithName:kFontIoniconsFamilyName size:21]];
    [keyhide setTitle:eject forState:UIControlStateNormal];
    ichar = 0xf4a6;
    NSString* bar = [[[NSString alloc] initWithCharacters:&ichar length:1] autorelease];
    [toolview.titleLabel setFont:[UIFont fontWithName:kFontIoniconsFamilyName size:21]];
    [toolview setTitle:bar forState:UIControlStateNormal];
    ichar = 0xf0ac;
    NSString* earth = [[[NSString alloc] initWithCharacters:&ichar length:1] autorelease];
    [browser.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:21]];
    [browser setTitle:earth forState:UIControlStateNormal];
    ichar = 0xf083;
    NSString* retro = [[[NSString alloc] initWithCharacters:&ichar length:1] autorelease];
    [ocr.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:21]];
    [ocr setTitle:retro forState:UIControlStateNormal];

    popover = [[WYPopoverController alloc] initWithContentViewController:FNController];
    webcontroller = [[SVModalWebViewController alloc] initWithAddress:@"http://google.com"];
    tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    tesseract.delegate = self;
    FNController.delegate = self;
    popover.delegate = self;
    [keyhide addTarget:self action:@selector(toggleKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [toolview addTarget:self action:@selector(toolbarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [browser addTarget:self action:@selector(web:) forControlEvents:UIControlEventTouchUpInside];
    [ocr addTarget:self action:@selector(ocr:) forControlEvents:UIControlEventTouchUpInside];
        
  [self setNeedsStatusBarAppearanceUpdate];
    
  @try {
    [terminalGroupView startSubProcess];
  } @catch (NSException* e) {
    NSLog(@"Caught %@: %@", [e name], [e reason]);
    if ([[e name] isEqualToString:@"ForkException"]) {
        Class class = NSClassFromString(@"UIAlertController");
        if(class){
            UIAlertController *view = [UIAlertController alertControllerWithTitle:[e name]
                                                                           message:[e reason]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [view addAction:[UIAlertAction actionWithTitle:@"Exit"
                                                      style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       exit(0);
                                                   }]];
            [self presentViewController:view animated:YES completion:nil];
        } else {
            // This happens if we fail to fork for some reason.
            // TODO(allen): Provide a helpful hint -- a kernel patch?
            UIAlertView* view =
            [[UIAlertView alloc] initWithTitle:[e name]
                                       message:[e reason]
                                      delegate:self
                             cancelButtonTitle:@"Exit"
                             otherButtonTitles:NULL];
            [view show];
            return;
        }
    }
    [e raise];
    return;
  }

  // TODO(allen):  This should be configurable
  shouldShowKeyboard = YES;

  // Adding the keyboard to the view has no effect, except that it is will
  // later allow us to make it the first responder so we can show the keyboard
  // on the screen.
  [[self view] addSubview:terminalKeyboard];
    
  // The menu button points to the right, but for this context it should point
  // up, since the menu moves that way.
    
  //menuButton.transform = CGAffineTransformMakeRotation(-90.0f * M_PI / 180.0f);
   toolbar.clipsToBounds = YES;
   toolbar.hidden = YES;
   texttoolbar.clipsToBounds = YES;
   texttoolbar.hidden = YES;
    
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flexible = [[[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                  target:nil action:nil] autorelease];
    flexible.width = 3;
    
    
    unichar uichar = 0xf3d0;
    NSString *back = [[[NSString alloc] initWithCharacters:&uichar length:1] autorelease];
    backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn.titleLabel setFont:[UIFont fontWithName:kFontIoniconsFamilyName size:26]];
    [backbtn setFrame:CGRectMake(-10, 0, 20, 36)];
    [backbtn setTitle:back forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(toolbarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    hidemenu = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    
    UIBarButtonItem *ctrl = [[[UIBarButtonItem alloc] initWithTitle:@"Ctrl" style:UIBarButtonItemStyleBordered target:self action:@selector(ctrl:)] autorelease];
    
    UIBarButtonItem *esc = [[[UIBarButtonItem alloc] initWithTitle:@"Esc" style:UIBarButtonItemStyleBordered target:self action:@selector(esc:)] autorelease];
    
    UIBarButtonItem *tab = [[[UIBarButtonItem alloc] initWithTitle:@"Tab" style:UIBarButtonItemStyleBordered target:self action:@selector(tab:)] autorelease];
    
    UIBarButtonItem *bleft = [[[UIBarButtonItem alloc] initWithTitle:@"◁" style:UIBarButtonItemStyleBordered target:self action:@selector(left:)] autorelease];
    
    UIBarButtonItem *bright = [[[UIBarButtonItem alloc] initWithTitle:@"▷" style:UIBarButtonItemStyleBordered target:self action:@selector(right:)] autorelease];
    
    UIBarButtonItem *bup = [[[UIBarButtonItem alloc] initWithTitle:@"△" style:UIBarButtonItemStyleBordered target:self action:@selector(up:)] autorelease];
    
    UIBarButtonItem *bdown = [[[UIBarButtonItem alloc] initWithTitle:@"▽" style:UIBarButtonItemStyleBordered target:self action:@selector(down:)] autorelease];
    
    change = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-toggle-off"] style:UIBarButtonItemStyleBordered target:self action:@selector(changey:)];
    
    self.toolbar.items = [NSArray arrayWithObjects:
                          hidemenu,
                          flexible,
                          ctrl,
                          flexible,
                          change,
                          fix,
                          bleft,
                          fix,
                          bright,
                          fix,
                          bup,
                          fix,
                          bdown,
                          fix,
                          esc,
                          fix,
                          tab,
                          fix, nil];
    
    [toolbar setBackgroundImage:[UIImage new]
    forToolbarPosition:UIBarPositionAny
    barMetrics:UIBarMetricsDefault];
    [toolbar setShadowImage:[UIImage new]
              forToolbarPosition:UIToolbarPositionAny];
  [menuButton setNeedsLayout];  
  
  // Setup the page control that selects the active terminal

  [terminalSelector setNumberOfPages:[terminalGroupView terminalCount]];
  [terminalSelector setCurrentPage:0];
  // Make the first terminal active
  [self terminalSelectionDidChange:self];
   UILongPressGestureRecognizer *longPress_left = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_left:)];
    longPress_left.minimumPressDuration = 0.5;
    [[bleft valueForKey:@"view"] addGestureRecognizer:longPress_left];
    UILongPressGestureRecognizer *longPress_right = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_right:)];
    longPress_right.minimumPressDuration = 0.5;
    [[bright valueForKey:@"view"] addGestureRecognizer:longPress_right];
    UILongPressGestureRecognizer *longPress_up = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_up:)];
    longPress_up.minimumPressDuration = 0.5;
    [[bup valueForKey:@"view"] addGestureRecognizer:longPress_up];
    UILongPressGestureRecognizer *longPress_down = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_down:)];
    longPress_down.minimumPressDuration = 0.5;
    [[bdown valueForKey:@"view"] addGestureRecognizer:longPress_down];
    
    NSMutableArray *commands = [[NSMutableArray alloc] init];
    NSString *characters = @"abcdefghijklmnopqrstuvwxyz";
    for (NSInteger i = 0; i < characters.length; i++) { // Ctrl
        NSString *input = [characters substringWithRange:NSMakeRange(i, 1)];
        [commands addObject:[UIKeyCommand keyCommandWithInput:input modifierFlags:UIKeyModifierControl action:@selector(handleCommand:)]];
    }
    [commands addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputUpArrow modifierFlags:kNilOptions action:@selector(handleCommand:)]]; // Up
    [commands addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputDownArrow modifierFlags:kNilOptions action:@selector(handleCommand:)]]; // Down
    [commands addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputLeftArrow modifierFlags:kNilOptions action:@selector(handleCommand:)]]; // Left
    [commands addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputRightArrow modifierFlags:kNilOptions action:@selector(handleCommand:)]]; // Right
    [commands addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputEscape modifierFlags:kNilOptions action:@selector(handleCommand:)]]; // Esc
    self.commands = commands.copy;
    
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    unichar c = 0xf030;;
    NSString* camicon = [[[NSString alloc] initWithCharacters:&c length:1] autorelease];
    camera = [[[UIBarButtonItem alloc] initWithTitle:camicon style:UIBarButtonSystemItemCamera target:self action:@selector(camera:)] autorelease];
    [toolbarItems addObject:fix];
    [toolbarItems addObject:camera];
    [toolbarItems addObject:fix];
    CGFloat width = self.view.frame.size.width;
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, width - 110, textView.frame.size.height)];
    textView.delegate = self;
    textView.isScrollable = NO;
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textView.placeholder = @"Scanned text from image";
    textView.layer.cornerRadius = 8;
    textView.layer.borderWidth = 0.7;
    UIBarButtonItem *textItem = [[UIBarButtonItem alloc] initWithCustomView:textView];
    [toolbarItems addObject:textItem];


    send = [[[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonSystemItemAction target:self action:@selector(closetext:)] autorelease];
    [toolbarItems addObject:fix];
    [toolbarItems addObject:send];
    [toolbarItems addObject:fix];
    [texttoolbar setItems:toolbarItems];
    [toolbarItems release];
    [texttoolbar setBackgroundImage:[UIImage new]
             forToolbarPosition:UIBarPositionAny
                     barMetrics:UIBarMetricsDefault];
    [texttoolbar setShadowImage:[UIImage new]
         forToolbarPosition:UIToolbarPositionAny];
    [fix release];
    popover.theme.fillTopColor = [UIColor clearColor];
    popover.theme.fillBottomColor = [UIColor clearColor];
    popover.theme.outerStrokeColor = [UIColor clearColor];
    popover.theme.glossShadowColor = [UIColor clearColor];
    
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect high = texttoolbar.frame;
    high.size.height -= diff;
    high.origin.y += diff;
    texttoolbar.frame = high;
}

- (void)camera:(UIBarButtonItem *)sender
{
    imagePickerController = [[UIImagePickerController alloc]init];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Scan from image"
                                                                    message:@"Text recognition from image"
                                                             preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *btn =
        [UIAlertAction actionWithTitle:@"Take Photo"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops..."
                                                                                                          message:@"Camera does not work"
                                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                           [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                                     style:UIAlertActionStyleDefault
                                                                                   handler:nil]];
                                           alert.modalPresentationStyle = UIModalPresentationPopover;
                                           UIPopoverPresentationController *pop = alert.popoverPresentationController;
                                           pop.sourceView = self.view;
                                           pop.sourceRect = self.view.bounds;
                                           pop.permittedArrowDirections = 0;
                                           [self presentViewController:alert animated:YES completion:nil];
                                   } else {
                                       [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
                                       [imagePickerController setAllowsEditing:YES];
                                       [imagePickerController setDelegate:self];
                                       [self setShowKeyboard:NO];
                                       [self presentModalViewController:imagePickerController animated:YES];
                                   }
                                   
                               }];

        [ac addAction:btn];
        
        UIAlertAction *btn2 =
        [UIAlertAction actionWithTitle:@"Choose from Library"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                   [imagePickerController setAllowsEditing:YES];
                                   [imagePickerController setDelegate:self];
                                   [self setShowKeyboard:NO];
                                   if (IPAD) {
                                       UIPopoverController *PopoverController = [[[UIPopoverController alloc] initWithContentViewController:imagePickerController] autorelease];
                                       [PopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                                   } else
                                   [self presentViewController:imagePickerController animated:YES completion:nil];
                               }];
        
        [ac addAction:btn2];
        
        UIAlertAction *btn3 =
        [UIAlertAction actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                               handler:nil];
        
        [ac addAction:btn3];

        
        ac.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *pop = ac.popoverPresentationController;
        pop.sourceView = self.view;
        pop.sourceRect = self.view.bounds;
        [self presentViewController:ac animated:YES completion:nil];
        
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Scan from image" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose from Library", @"Cancel", nil];
        
        if (IPAD)
            [actionSheet showFromBarButtonItem:sender animated:YES];
        else
            [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops..."
                                                                    message:@"Camera does not work"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
            } else {
                [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
                [imagePickerController setAllowsEditing:YES];
                [imagePickerController setDelegate:self];
                [self setShowKeyboard:NO];
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            break;
        case 1:
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePickerController setAllowsEditing:YES];
            [imagePickerController setDelegate:self];
            [self setShowKeyboard:NO];
            [self presentViewController:imagePickerController animated:YES completion:nil];
            break;
        default:
            break;
    }
}

- (void)posttext:(id)sender
{
    TerminalView* terminalView = [terminalGroupView frontTerminal];
    [terminalView receiveKeyboardInput:[textView.text dataUsingEncoding:NSUTF8StringEncoding]];
    texttoolbar.layer.shouldRasterize = YES;
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.duration = 0.25f;
    [texttoolbar.layer addAnimation:animation forKey:nil];
    texttoolbar.hidden = YES;
    CGRect viewFrame = terminalGroupView.frame;
    viewFrame.size.height += 7.5;
    terminalGroupView.frame = viewFrame;
    [textView resignFirstResponder];
    [self setShowKeyboard:keyboardShow];
}

- (void)closetext:(id)sender
{
    texttoolbar.layer.shouldRasterize = YES;
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.duration = 0.25f;
    [texttoolbar.layer addAnimation:animation forKey:nil];
    texttoolbar.hidden = YES;
    CGRect viewFrame = terminalGroupView.frame;
    viewFrame.size.height += 7.5;
    terminalGroupView.frame = viewFrame;
    [textView resignFirstResponder];
    [self setShowKeyboard:keyboardShow];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Recognizing...";
    
    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_main   = dispatch_get_main_queue();
    dispatch_async(q_global, ^{
        tesseract.image = chosenImage;
        [tesseract recognize];
        dispatch_async(q_main, ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            textView.text = tesseract.recognizedText;
            [self setShowKeyboard:YES];
        });
    });
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *)preprocessedImageForTesseract:(Tesseract *)tesseracting sourceImage:(UIImage *)inputImage {
    
    GPUImageAdaptiveThresholdFilter *stillImageFilter = [[[GPUImageAdaptiveThresholdFilter alloc] init] autorelease];
    stillImageFilter.blurRadiusInPixels = 4.0;
    UIImage *filteredImage = [stillImageFilter imageByFilteringImage:inputImage];

    return filteredImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)change:(BOOL)inFlag
{
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:toolbar.items];
    unichar c;
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    if (inFlag) {
            c = 0xf204;
            NSString* btn = [[[NSString alloc] initWithCharacters:&c length:1] autorelease];
            change.title = btn;
            change.action = @selector(changey:);
        
        UIBarButtonItem *esc = [[[UIBarButtonItem alloc] initWithTitle:@"Esc" style:UIBarButtonItemStyleBordered target:self action:@selector(esc:)] autorelease];
        
        UIBarButtonItem *tab = [[[UIBarButtonItem alloc] initWithTitle:@"Tab" style:UIBarButtonItemStyleBordered target:self action:@selector(tab:)] autorelease];
        
        UIBarButtonItem *bleft = [[[UIBarButtonItem alloc] initWithTitle:@"◁" style:UIBarButtonItemStyleBordered target:self action:@selector(left:)] autorelease];
        
        UIBarButtonItem *bright = [[[UIBarButtonItem alloc] initWithTitle:@"▷" style:UIBarButtonItemStyleBordered target:self action:@selector(right:)] autorelease];
        
        UIBarButtonItem *bup = [[[UIBarButtonItem alloc] initWithTitle:@"△" style:UIBarButtonItemStyleBordered target:self action:@selector(up:)] autorelease];
        
        UIBarButtonItem *bdown = [[[UIBarButtonItem alloc] initWithTitle:@"▽" style:UIBarButtonItemStyleBordered target:self action:@selector(down:)] autorelease];
        
        NSArray *items = [NSArray arrayWithObjects:
                          change,
                          fix,
                          bleft,
                          fix,
                          bright,
                          fix,
                          bup,
                          fix,
                          bdown,
                          fix,
                          esc,
                          fix,
                          tab,
                          fix, nil];
        int i = 4;
        for (UIBarButtonItem *btn in items)
            [array replaceObjectAtIndex:i++ withObject:btn];
        [toolbar setItems:array animated:YES];
        
        UILongPressGestureRecognizer *longPress_left = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_left:)];
        longPress_left.minimumPressDuration = 0.5;
        [[bleft valueForKey:@"view"] addGestureRecognizer:longPress_left];
        UILongPressGestureRecognizer *longPress_right = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_right:)];
        longPress_right.minimumPressDuration = 0.5;
        [[bright valueForKey:@"view"] addGestureRecognizer:longPress_right];
        UILongPressGestureRecognizer *longPress_up = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_up:)];
        longPress_up.minimumPressDuration = 0.5;
        [[bup valueForKey:@"view"] addGestureRecognizer:longPress_up];
        UILongPressGestureRecognizer *longPress_down = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_down:)];
        longPress_down.minimumPressDuration = 0.5;
        [[bdown valueForKey:@"view"] addGestureRecognizer:longPress_down];

    
    } else {
        
        UIBarButtonItem *space = [[[UIBarButtonItem alloc] initWithTitle:@"Space" style:UIBarButtonItemStyleBordered target:self action:@selector(space:)] autorelease];
        
        UIButton *fnbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [fnbtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [fnbtn setFrame:CGRectMake(0, 0, 31, 36)];
        [fnbtn setTitle:@"Key" forState:UIControlStateNormal];
        [fnbtn addTarget:self action:@selector(keys:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *key = [[[UIBarButtonItem alloc] initWithCustomView:fnbtn] autorelease];
        
        UIBarButtonItem *varticalbar = [[[UIBarButtonItem alloc] initWithTitle:@"|" style:UIBarButtonItemStyleBordered target:self action:@selector(bar:)] autorelease];
        
        UIBarButtonItem *doublequ = [[[UIBarButtonItem alloc] initWithTitle:@"\"" style:UIBarButtonItemStyleBordered target:self action:@selector(double_quotes:)] autorelease];
        
        UIBarButtonItem *grave = [[[UIBarButtonItem alloc] initWithTitle:@"`" style:UIBarButtonItemStyleBordered target:self action:@selector(grave_accent:)] autorelease];
        
        UIBarButtonItem *exit = [[[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStyleBordered target:self action:@selector(exit:)] autorelease];
        
        [space setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]} forState:UIControlStateNormal];
        
        [exit setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]} forState:UIControlStateNormal];
        
        c = 0xf205;
        NSString* btn = [[[NSString alloc] initWithCharacters:&c length:1] autorelease];
        change.title = btn;
        change.action = @selector(changen:);
        
        NSArray *items = [NSArray arrayWithObjects:
                          change,
                          fix,
                          key,
                          fix,
                          space,
                          fix,
                          varticalbar,
                          fix,
                          doublequ,
                          fix,
                          grave,
                          fix,
                          exit, nil];
        int i = 4;
        for (UIBarButtonItem *btn in items)
            [array replaceObjectAtIndex:i++ withObject:btn];
        [toolbar setItems:array animated:YES];
        UILongPressGestureRecognizer *longPress_space = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_space:)];
        longPress_space.minimumPressDuration = 0.5;
        [[space valueForKey:@"view"] addGestureRecognizer:longPress_space];
    }
    
    [fix release];
    [array release];
}


- (void)keys:(UIButton*)sender
{
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat width = 300;
    CGFloat height = 44;
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    if (version >= 8.0) {
        if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
            CGFloat angle = 90.0 * M_PI / 180.0;
            FNController.view.transform = CGAffineTransformMakeRotation(angle);
            popover.popoverContentSize = CGSizeMake(height, width);
            [popover presentPopoverFromRect:sender.bounds
                                     inView:sender
                   permittedArrowDirections:UIPopoverArrowDirectionLeft
                                   animated:YES];
        } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            CGFloat angle = 270.0 * M_PI / 180.0;
            FNController.view.transform = CGAffineTransformMakeRotation(angle);
            popover.popoverContentSize = CGSizeMake(height, width);
            [popover presentPopoverFromRect:sender.bounds
                                     inView:sender
                   permittedArrowDirections:UIPopoverArrowDirectionRight
                                   animated:YES];
        } else {
            CGFloat angle = 0;
            FNController.view.transform = CGAffineTransformMakeRotation(angle);
            popover.popoverContentSize = CGSizeMake(width, height);
            [popover presentPopoverFromRect:sender.bounds
                                     inView:sender
                   permittedArrowDirections:UIPopoverArrowDirectionDown
                                   animated:YES];
        }
    } else {
        popover.popoverContentSize = CGSizeMake(width, height);
        [popover presentPopoverFromRect:sender.bounds
                                 inView:sender
               permittedArrowDirections:UIPopoverArrowDirectionDown
                               animated:YES];
    }
    
}

- (void)changey:(id)sender
{
    [self change:NO];
}

- (void)changen:(id)sender
{
    [self change:YES];
}

- (void)web:(id)sender
{
    webcontroller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self setShowKeyboard:NO];
    [self presentModalViewController:webcontroller animated:YES];
}

- (void)ocr:(id)sender
{
    textView.text = @"";
    texttoolbar.layer.shouldRasterize = YES;
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.25f;
    [texttoolbar.layer addAnimation:animation forKey:nil];
    texttoolbar.hidden = NO;
    menuView.hidden = YES;
    CGRect viewFrame = terminalGroupView.frame;
    viewFrame.size.height -= 7.5;
    terminalGroupView.frame = viewFrame;
}

- (void)function:(NSString *)sender
{
    SWITCH (sender) {
        CASE (@"F1") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%cOP",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F2") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%cOQ",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F3") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%cOR",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F4") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%cOS",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F5") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[15~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F6") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[17~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F7") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[18~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F8") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[19~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F9") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[20~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F10") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[21~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F11") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[23~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F12") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[24~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F13") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[25~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F14") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[26~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F15") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[28~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F16") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[29~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F17") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[31~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F18") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[32~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F19") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[33~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"F20") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[34~",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        DEFAULT {
            break;
        }
    }
}

- (void)subkey:(NSString *)sender
{
    SWITCH (sender) {
        CASE (@"Home") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[1",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"Insert") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[2",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"Delete") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[3",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"End") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[4",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"Page Up") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[5",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        CASE (@"Page Down") {
            [[terminalGroupView frontTerminal] receiveKeyboardInput:[[NSString stringWithFormat:@"%c[6",0x1B] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
        DEFAULT {
            break;
        }
    }
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [popover dismissPopoverAnimated:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat width = self.view.frame.size.width;
    CGRect newSize = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, width - 110, textView.frame.size.height);
    textView.frame = newSize;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    if ([textView.text isEqualToString:@""]) {
        send.title = @"close";
        send.action = @selector(closetext:);
    } else {
        send.title = @"input";
        send.action = @selector(posttext:);
    }
}

- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView {
    if ([textView.text isEqualToString:@""]) {
        send.title = @"close";
        send.action = @selector(closetext:);
    }

    return YES;
}

/* If you want to use statusbar
- (UIStatusBarStyle)preferredStatusBarStyle {
    BOOL light = [[NSUserDefaults standardUserDefaults] boolForKey:@"Statusbar"];
    return light? UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}
*/

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self  selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *themename = [ud objectForKey:@"colorMap"];
    NSDictionary *themes = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Themes" ofType:@"plist"]];
    colorMap = [[ColorMap alloc] initWithDictionary:themes[themename]];
    
    contentView.backgroundColor = colorMap.background;
    self.view.backgroundColor = colorMap.background;
 
    if (![ud boolForKey:@"BlackOrWhite"]) {
        toolbar.backgroundColor = [[[UIColor alloc] initWithWhite:1.f alpha:1.f] autorelease];
        toolbar.tintColor = [[[UIColor alloc] initWithWhite:0.f alpha:1.f] autorelease];
        texttoolbar.backgroundColor = [[[UIColor alloc] initWithWhite:1.f alpha:1.f] autorelease];
        texttoolbar.tintColor = [[[UIColor alloc] initWithWhite:0.f alpha:1.f] autorelease];
        textView.layer.borderColor = [[UIColor blackColor] CGColor];
        textView.textColor = [[[UIColor alloc] initWithWhite:0.f alpha:1.f] autorelease];
        textView.backgroundColor = [UIColor clearColor];
        textView.placeholderColor = [UIColor darkGrayColor];
        menuButton.tintColor = [[[UIColor alloc] initWithWhite:0.f alpha:1.f] autorelease];
        preferencesButton.tintColor = [[[UIColor alloc] initWithWhite:0.f alpha:1.f] autorelease];
        terminalSelector.pageIndicatorTintColor = [UIColor lightGrayColor];
        terminalSelector.currentPageIndicatorTintColor = [[[UIColor alloc] initWithWhite:0.f alpha:1.f] autorelease];
        terminalSelector.backgroundColor = [[[UIColor alloc] initWithWhite:1.f alpha:1.f] autorelease];
        textView.internalTextView.keyboardAppearance = UIKeyboardAppearanceLight;
        
        [change setTitleTextAttributes:@{UITextAttributeFont :
                                             [UIFont fontWithName:kFontAwesomeFamilyName
                                                             size:20],
                                         UITextAttributeTextColor:[[[UIColor alloc] initWithWhite:0.f alpha:1.f] autorelease]}
                              forState:UIControlStateNormal];
        
        [camera setTitleTextAttributes:@{UITextAttributeFont :
                                          [UIFont fontWithName:kFontAwesomeFamilyName
                                                          size:20],
                                      UITextAttributeTextColor:[[[UIColor alloc] initWithWhite:0.f alpha:1.f] autorelease]}
                           forState:UIControlStateNormal];
        
        [toolview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [toolview setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [keyhide setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [keyhide setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [preferencesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [preferencesButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [browser setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [browser setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [ocr setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [ocr setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [backbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
    } else {
        toolbar.backgroundColor = [[[UIColor alloc] initWithWhite:0.f alpha:1.f] autorelease];
        toolbar.tintColor = [[[UIColor alloc] initWithWhite:1.f alpha:1.f] autorelease];
        texttoolbar.backgroundColor =  [[[UIColor alloc] initWithWhite:0.f alpha:1.f] autorelease];
        texttoolbar.tintColor = [[[UIColor alloc] initWithWhite:1.f alpha:1.f] autorelease];
        textView.layer.borderColor = [[UIColor whiteColor] CGColor];
        textView.textColor = [[[UIColor alloc] initWithWhite:1.f alpha:1.f] autorelease];
        textView.backgroundColor = [UIColor clearColor];
        textView.placeholderColor = [UIColor lightGrayColor];
        menuButton.tintColor = [[[UIColor alloc] initWithWhite:1.f alpha:1.f] autorelease];
        preferencesButton.tintColor = [[[UIColor alloc] initWithWhite:1.f alpha:1.f] autorelease];
        terminalSelector.pageIndicatorTintColor = [UIColor darkGrayColor];
        terminalSelector.currentPageIndicatorTintColor = [[[UIColor alloc] initWithWhite:1.f alpha:1.f] autorelease];
        terminalSelector.backgroundColor = [[[UIColor alloc] initWithWhite:0.f alpha:1.f] autorelease];
        textView.internalTextView.keyboardAppearance = UIKeyboardAppearanceDark;
        
        [change setTitleTextAttributes:@{UITextAttributeFont :
                                             [UIFont fontWithName:kFontAwesomeFamilyName
                                                             size:20],
                                         UITextAttributeTextColor:[[[UIColor alloc] initWithWhite:1.f alpha:1.f] autorelease]}
                              forState:UIControlStateNormal];
        
        [camera setTitleTextAttributes:@{UITextAttributeFont :
                                          [UIFont fontWithName:kFontAwesomeFamilyName
                                                          size:20],
                                      UITextAttributeTextColor:[[[UIColor alloc] initWithWhite:1.f alpha:1.f] autorelease]}
                           forState:UIControlStateNormal];
        
        [toolview setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [toolview setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        
        [keyhide setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [keyhide setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        
        [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        
        [preferencesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [preferencesButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        
        [browser setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [browser setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        
        [ocr setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ocr setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        
        [backbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

    }
    [terminalKeyboard init];
    [interfaceDelegate rootViewDidAppear];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self registerForKeyboardNotifications];
    [self setShowKeyboard:shouldShowKeyboard];
    
    // Reset the font in case it changed in the preferenes view
    CGFloat fontSize = [ud floatForKey:@"font-Size"];
    NSString *fontName = [ud objectForKey:@"font-Name"];
    UIFont* font = [UIFont fontWithName:fontName size:fontSize];
    for (int i = 0; i < [terminalGroupView terminalCount]; ++i) {
        TerminalView* terminalView = [terminalGroupView terminalAtIndex:i];
        [terminalView setFont:font];
        [terminalView setColorMap:colorMap];
        [terminalView setNeedsLayout];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/*
- (BOOL)prefersStatusBarHidden
{
    return YES; // Or "NO"
}
*/

- (void)didReceiveMemoryWarning {
	// TODO(allen): Should clear scrollback buffers to save memory? 
  [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [terminalKeyboard release];
    [toolbar release];
    [hidemenu release];
    [change release];
    [webcontroller release];
    [texttoolbar release];
    [tesseract release];
    [imagePickerController release];
    [box release];
    [toolview release];
    [keyhide release];
    [backbtn release];
    [super dealloc];
}

@end
