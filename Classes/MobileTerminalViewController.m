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
#define ORIENTATION [[UIDevice currentDevice] orientation]

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

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (void)awakeFromNib
{
  terminalKeyboard = [[TerminalKeyboard alloc] init];
  keyboardShown = NO;  

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

-(void)longPress_left:(UILongPressGestureRecognizer *)left_sender {
    switch (left_sender.state) {
        case UIGestureRecognizerStateBegan:
            [self performSelector:@selector(repeat_left:) withObject:nil afterDelay:0.1];
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
    [self performSelector:@selector(repeat_left:) withObject:nil afterDelay:0.1];
}

-(void)longPress_right:(UILongPressGestureRecognizer *)right_sender {
    switch (right_sender.state) {
        case UIGestureRecognizerStateBegan:
            [self performSelector:@selector(repeat_right:) withObject:nil afterDelay:0.1];
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
    [self performSelector:@selector(repeat_right:) withObject:nil afterDelay:0.1];
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

-(IBAction)esc:(id)sender {
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[[NSString stringWithFormat:@"%c",0x1b] dataUsingEncoding:NSASCIIStringEncoding]];
}

-(IBAction)ctrl:(id)sender {
    [[terminalGroupView terminalAtIndex:[terminalSelector currentPage]] receiveKeyboardInput:[[NSString stringWithFormat:@"%c",0x00] dataUsingEncoding:NSASCIIStringEncoding]];
}

// TODO(allen): Fix the deprecation of UIKeyboardBoundsUserInfoKey
// below -- it requires more of a change because the replacement
// is not available in 3.1.3

- (void)keyboardWasShown:(NSNotification*)aNotification
{
  if (keyboardShown) {
    return;
  }
  keyboardShown = YES;

  NSDictionary* info = [aNotification userInfo];
  
  // Get the size of the keyboard.
  NSValue* aValue = info[UIKeyboardBoundsUserInfoKey];
  CGSize keyboardSize = [aValue CGRectValue].size;
  
  // Reset the height of the terminal to full screen not shown by the keyboard
  CGRect viewFrame = [contentView frame];
  viewFrame.size.height -= keyboardSize.height;
  contentView.frame = viewFrame;
}

- (void)keyboardWasHidden:(NSNotification*)aNotification
{
  if (!keyboardShown) {
    return;
  }
  keyboardShown = NO;

  NSDictionary* info = [aNotification userInfo];
  
  // Get the size of the keyboard.
  NSValue* aValue = info[UIKeyboardBoundsUserInfoKey];
  CGSize keyboardSize = [aValue CGRectValue].size;  
  
  // Resize to the original height of the screen without the keyboard
  CGRect viewFrame = [contentView frame];
  viewFrame.size.height += keyboardSize.height;
  contentView.frame = viewFrame;
}

- (void)setShowKeyboard:(BOOL)showKeyboard
{
  if (showKeyboard) {
    [terminalKeyboard becomeFirstResponder];
  } else {
    [terminalKeyboard resignFirstResponder];
  }
}

- (void)toggleKeyboard:(id)sender
{
  BOOL isShown = keyboardShown;
  [self setShowKeyboard:!isShown];
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
  shouldShowKeyboard = keyboardShown;
  [self unregisterForKeyboardNotifications];

  [interfaceDelegate preferencesButtonPressed];
}

// Invoked when the menu button is pressed
- (void)menuButtonPressed:(id)sender 
{
  [menuView setHidden:![menuView isHidden]];
}

// Invoked when a menu item is clicked, to run the specified command.
- (void)selectedCommand:(NSString*)command
{
  TerminalView* terminalView = [terminalGroupView frontTerminal];
  [terminalView receiveKeyboardInput:[command dataUsingEncoding:NSUTF8StringEncoding]];
  
  // Make the menu disappear
  [menuView setHidden:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  // User clicked the Exit button below
  exit(0);
}

- (void)viewDidLoad {
  [super viewDidLoad];

  @try {
    [terminalGroupView startSubProcess];
  } @catch (NSException* e) {
    NSLog(@"Caught %@: %@", [e name], [e reason]);
    if ([[e name] isEqualToString:@"ForkException"]) {
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
  menuButton.transform = CGAffineTransformMakeRotation(-90.0f * M_PI / 180.0f);
  [menuButton setNeedsLayout];  
  
  // Setup the page control that selects the active terminal
  [terminalSelector setNumberOfPages:[terminalGroupView terminalCount]];
  [terminalSelector setCurrentPage:0];
  // Make the first terminal active
  [self terminalSelectionDidChange:self];
   UILongPressGestureRecognizer *longPress_left = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_left:)];
    longPress_left.minimumPressDuration = 0.8;
    [_left addGestureRecognizer:longPress_left];
    UILongPressGestureRecognizer *longPress_right = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_right:)];
    longPress_right.minimumPressDuration = 0.8;
    [_right addGestureRecognizer:longPress_right];
    UILongPressGestureRecognizer *longPress_up = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_up:)];
    longPress_up.minimumPressDuration = 0.8;
    [_up addGestureRecognizer:longPress_up];
    UILongPressGestureRecognizer *longPress_down = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_down:)];
    longPress_down.minimumPressDuration = 0.8;
    [_down addGestureRecognizer:longPress_down];

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
}

- (BOOL)shouldAutorotate {
    // After iOS6
    switch (ORIENTATION) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            return YES;
        default:
            return NO;
    }

}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
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
  [super dealloc];
}

@end
