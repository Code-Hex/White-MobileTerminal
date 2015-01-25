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
#define IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

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
@synthesize toolbar;
@synthesize ctrl;
@synthesize space;

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
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
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
                                                  name:UIKeyboardWillShowNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

// New added functions
// https://github.com/coolstar/mobileterminal/blob/master/Classes/MobileTerminalViewController.m

-(IBAction)up:(id)sender {
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x41] dataUsingEncoding:NSASCIIStringEncoding]];
}

-(IBAction)down:(id)sender {
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x42] dataUsingEncoding:NSASCIIStringEncoding]];
}

-(IBAction)right:(id)sender {
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x43] dataUsingEncoding:NSASCIIStringEncoding]];
}

-(IBAction)left:(id)sender {
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x44] dataUsingEncoding:NSASCIIStringEncoding]];
}

-(IBAction)space:(id)sender {
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[[NSString stringWithFormat:@"%c",(char)0x20] dataUsingEncoding:NSASCIIStringEncoding]];
}

-(IBAction)bar:(id)sender {
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[@"|" dataUsingEncoding:NSASCIIStringEncoding]];
}

-(IBAction)double_quotes:(id)sender {
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[@"\"" dataUsingEncoding:NSASCIIStringEncoding]];
}

-(IBAction)grave_accent:(id)sender {
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[@"`" dataUsingEncoding:NSASCIIStringEncoding]];
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
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x44] dataUsingEncoding:NSASCIIStringEncoding]];
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
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x43] dataUsingEncoding:NSASCIIStringEncoding]];
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
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x41] dataUsingEncoding:NSASCIIStringEncoding]];
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
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[[NSString stringWithFormat:@"%c%c%c",(char)0x1B,(char)0x5B,(char)0x42] dataUsingEncoding:NSASCIIStringEncoding]];
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
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[[NSString stringWithFormat:@"%c",(char)0x20] dataUsingEncoding:NSASCIIStringEncoding]];
    [self performSelector:@selector(repeat_space:) withObject:nil afterDelay:0.07];
}


-(IBAction)esc:(id)sender {
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[[NSString stringWithFormat:@"%c",0x1b] dataUsingEncoding:NSASCIIStringEncoding]];
}

- (IBAction)tab:(id)sender {
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[NSData dataWithBytes:"\t" length:1]];
}

- (IBAction)ctrl:(UIButton*)ctrl_button {
    TerminalKeyboard *keyInput = (TerminalKeyboard *)terminalKeyboard.inputTextField;
    keyInput.controlKeyMode = !keyInput.controlKeyMode;
    ctrl_button.selected = keyInput.controlKeyMode;
}

- (IBAction)menudown:(id)ctrl_button {
    menuView.hidden = YES;
}

- (IBAction)exit:(id)sender {
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
                                   UILocalNotification *notification = [[UILocalNotification alloc] init];
                                   NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                   if (notification && [ud boolForKey:@"QuickRestart"])
                                   {
                                       notification.timeZone = [NSTimeZone defaultTimeZone];
                                       notification.repeatInterval = 0;
                                       notification.alertBody = @"Restart terminal to resume.";
                                       notification.alertAction = @"Restart";
                                       [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                                   }
                                   [notification release];
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

// TODO(allen): Fix the deprecation of UIKeyboardBoundsUserInfoKey
// below -- it requires more of a change because the replacement
// is not available in 3.1.3

- (void)keyboardWillShow:(NSNotification*)Notification
{
    CGRect keyboardFrameEnd = [[Notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey
                                ] CGRectValue];
    [self movecontentView:(_behind.frame.size.height + 6 - keyboardFrameEnd.size.height) notification:Notification];
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
        [self movecontentView:(_behind.frame.size.height + 6 - keyboardFrame.size.height) notification:Notification];
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
      [terminalGroupView terminalAtIndex:[terminalSelector currentPage]];
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
    toolbar.layer.shouldRasterize = YES;
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.25f;
    [toolbar.layer addAnimation:animation forKey:nil];
    if (![toolbar isHidden]) {
        CGRect viewFrame = terminalGroupView.frame;
        viewFrame.size.height += toolbar.frame.size.height;
        terminalGroupView.frame = viewFrame;
    } else {
        CGRect viewFrame = terminalGroupView.frame;
        viewFrame.size.height -= toolbar.frame.size.height;
        terminalGroupView.frame = viewFrame;
    }
    
    if (![toolbar isHidden] && [menuView isHidden]) {
        [toolbar setHidden:YES];
        [menuView setHidden:[menuView isHidden]];
    } else {
        [toolbar setHidden:![menuView isHidden]];
        [menuView setHidden:![menuView isHidden]];
    }
}

// Invoked when a menu item is clicked, to run the specified command.
- (void)selectedCommand:(NSString*)command
{
  TerminalView* terminalView = [terminalGroupView frontTerminal];
  [terminalView receiveKeyboardInput:[command dataUsingEncoding:NSUTF8StringEncoding]];
  
  // Make the menu disappear
    menuView.hidden = YES;
    toolbar.hidden = YES;
    CGRect viewFrame = terminalGroupView.frame;
    viewFrame.size.height += toolbar.frame.size.height;
    terminalGroupView.frame = viewFrame;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UIApplication sharedApplication] performSelector:@selector(suspend)];
    [NSThread sleepForTimeInterval:0.2];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification)
    {
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.repeatInterval = 0;
        notification.alertBody = @"Restart terminal to resume.";
        notification.alertAction = @"Restart";
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    [notification release];
    exit(0);
}

- (void)viewDidLoad {
  [super viewDidLoad];
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *result = [ud objectForKey:@"AlreadyLaunched"];
    
    if(![result isEqual:@"Yes"]){
        NSLog(@"WelcomeTerminal!!");
        [ud setObject:@"Yes" forKey:@"AlreadyLaunched"];
        [ud setBool:false forKey:@"BlackOrWhite"];
        [ud setBool:false forKey:@"KeyboardTypeURL"];
        [ud setObject:@"Courier" forKey:@"font-Name"];
        [ud setBool:true forKey:@"QuickRestart"];
        [ud setObject:IPAD?[NSNumber numberWithFloat:19.0]:[NSNumber numberWithFloat:11.0] forKey:@"font-Size"];
        [ud synchronize];
    }
    
  NSData *colorData = [ud objectForKey:@"Background"];
  [self setNeedsStatusBarAppearanceUpdate];
  UIColor *background = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
  contentView.backgroundColor = background;
  _behind.backgroundColor = background;
    
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
    if (![ud boolForKey:@"BlackOrWhite"]) {
        toolbar.backgroundColor = [[UIColor alloc] initWithWhite:1.f alpha:0.85f];
        toolbar.tintColor = [UIColor blackColor];
        _left.tintColor = [UIColor blackColor];
        _right.tintColor = [UIColor blackColor];
        _up.tintColor = [UIColor blackColor];
        _down.tintColor = [UIColor blackColor];
        menuButton.tintColor = [UIColor blackColor];
        preferencesButton.tintColor = [UIColor blackColor];
        terminalSelector.pageIndicatorTintColor = [UIColor lightGrayColor];
        terminalSelector.currentPageIndicatorTintColor = [UIColor blackColor];
        terminalSelector.backgroundColor = [[UIColor alloc] initWithWhite:1.f alpha:0.85f];
    } else {
        toolbar.backgroundColor = [[UIColor alloc] initWithWhite:0.f alpha:0.8f];
        toolbar.tintColor = [UIColor whiteColor];
        _left.tintColor = [UIColor whiteColor];
        _right.tintColor = [UIColor whiteColor];
        _up.tintColor = [UIColor whiteColor];
        _down.tintColor = [UIColor whiteColor];
        menuButton.tintColor = [UIColor whiteColor];
        preferencesButton.tintColor = [UIColor whiteColor];
        terminalSelector.pageIndicatorTintColor = [UIColor darkGrayColor];
        terminalSelector.currentPageIndicatorTintColor = [UIColor whiteColor];
        terminalSelector.backgroundColor = [[UIColor alloc] initWithWhite:0.f alpha:0.8f];
    }
    
    [self.toolbar setBackgroundImage:[UIImage new]
    forToolbarPosition:UIBarPositionAny
    barMetrics:UIBarMetricsDefault];
    [self.toolbar setShadowImage:[UIImage new]
              forToolbarPosition:UIToolbarPositionAny];
  [menuButton setNeedsLayout];  
  
  // Setup the page control that selects the active terminal

  [terminalSelector setNumberOfPages:[terminalGroupView terminalCount]];
  [terminalSelector setCurrentPage:0];
  // Make the first terminal active
  [self terminalSelectionDidChange:self];
   UILongPressGestureRecognizer *longPress_left = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_left:)];
    longPress_left.minimumPressDuration = 0.5;
    [_left addGestureRecognizer:longPress_left];
    UILongPressGestureRecognizer *longPress_right = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_right:)];
    longPress_right.minimumPressDuration = 0.5;
    [_right addGestureRecognizer:longPress_right];
    UILongPressGestureRecognizer *longPress_up = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_up:)];
    longPress_up.minimumPressDuration = 0.5;
    [_up addGestureRecognizer:longPress_up];
    UILongPressGestureRecognizer *longPress_down = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_down:)];
    longPress_down.minimumPressDuration = 0.5;
    [_down addGestureRecognizer:longPress_down];
    UILongPressGestureRecognizer *longPress_space = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_space:)];
    longPress_space.minimumPressDuration = 0.5;
    [[space valueForKey:@"view"] addGestureRecognizer:longPress_space];

}


/* If you want to use statusbar
- (UIStatusBarStyle)preferredStatusBarStyle {
    BOOL light = [[NSUserDefaults standardUserDefaults] boolForKey:@"Statusbar"];
    return light? UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}
*/

- (BOOL)prefersStatusBarHidden
{
    return YES; // Or "NO"
}

- (void)viewDidAppear:(BOOL)animated
{
  [interfaceDelegate rootViewDidAppear];
  [self registerForKeyboardNotifications];
  [self setShowKeyboard:shouldShowKeyboard];

  // Reset the font in case it changed in the preferenes view
  TerminalSettings* settings = [[Settings sharedInstance] terminalSettings];
  UIFont* font = [settings font];
  for (int i = 0; i < [terminalGroupView terminalCount]; ++i) {
    TerminalView* terminalView = [terminalGroupView terminalAtIndex:i];
    [terminalView setFont:font];
    [terminalView setNeedsLayout];
  }
    [super viewDidAppear:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  // We rotated, and almost certainly changed the frame size of the text view.
  [[self view] layoutSubviews];
}

- (void)didReceiveMemoryWarning {
	// TODO(allen): Should clear scrollback buffers to save memory? 
  [super didReceiveMemoryWarning];
}

- (void)dealloc {
  [terminalKeyboard release];
    [_left release];
    [_right release];
    [_up release];
    [_down release];
    [toolbar release];
    [ctrl release];
    [_behind release];
    [space release];
  [super dealloc];
}

@end
