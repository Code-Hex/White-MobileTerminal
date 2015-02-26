// GestureRegistry.m
// MobileTerminal

#import "GestureActionRegistry.h"
#import "Preferences/GestureSettings.h"
#import "Preferences/Settings.h"

// A gesture action that enters data into the keyboard, simulating a key press.
@interface KeyboardInputGestureAction : NSObject <GestureAction>
{
@private
  id<TerminalInputProtocol> terminalInput;
  NSData* data;
  NSString* label;
}

- (instancetype)initWithInput:(id<TerminalInputProtocol>)inputProtocol
             string:(NSString*)inputString
              label:(NSString*)aLabel;
- (instancetype)initWithInput:(id<TerminalInputProtocol>)inputProtocol
               data:(NSData*)inputData
              label:(NSString*)aLabel NS_DESIGNATED_INITIALIZER;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *label;
- (void)performAction;

@end

@implementation KeyboardInputGestureAction

- (instancetype)initWithInput:(id<TerminalInputProtocol>)inputProtocol
             string:(NSString*)inputString
              label:(NSString*)aLabel
{
  return [self initWithInput:inputProtocol
                        data:[inputString dataUsingEncoding:NSUTF8StringEncoding]
                       label:aLabel];
}

- (instancetype)initWithInput:(id<TerminalInputProtocol>)inputProtocol
               data:(NSData*)inputData
               label:(NSString*)aLabel
{
  if (self = [super init]) {
    terminalInput = inputProtocol;
    data = [inputData retain];
    label = [aLabel retain];
  }
  return self;
}

- (void)dealloc
{
  [data release];
  [label release];
  [super dealloc];
}

- (NSString*)label
{
  return label;
}

- (void)performAction
{
  NSLog(@"Performing: %@", label);
  [terminalInput receiveKeyboardInput:data];
}

@end

@implementation GestureActionRegistry

@synthesize terminalInput;
@synthesize viewController;

- (void)awakeFromNib
{  
  gestureSettings = [[Settings sharedInstance] gestureSettings];
  
  // Initialize some additional Terminal gesture actions
  SelectorGestureAction* toggleKeyboard =
      [[SelectorGestureAction alloc] initWithTarget:viewController
                                             action:@selector(toggleKeyboard:)
                                              label:@"Hide/Show Keyboard"];  
  [gestureSettings addGestureAction:toggleKeyboard];
  [toggleKeyboard release];
  SelectorGestureAction* toggleCopyPaste =
    [[SelectorGestureAction alloc] initWithTarget:viewController
                                           action:@selector(toggleCopyPaste:)
                                            label:@"Enable/Disable Copy & Paste"];  
  [gestureSettings addGestureAction:toggleCopyPaste];
  [toggleCopyPaste release];
  
  NSString* path =
      [[NSBundle mainBundle] pathForResource:@"GestureInputActions"
                                      ofType:@"plist"]; 
  NSArray* inputs = 
      [[NSArray alloc] initWithContentsOfFile:path];
  if ([inputs count] % 2 != 0) {
    NSLog(@"GestureInputActions contains invalid number of entries: %d",
          (int)[inputs count]);
  } else {
    NSLog(@"Loaded %d input gestures from file", (int)[inputs count]);
    for (int i = 0; i < [inputs count]; i += 2) {
      NSString* label = inputs[i];
      NSString* command = inputs[(i + 1)];
      KeyboardInputGestureAction* action =
          [[KeyboardInputGestureAction alloc] initWithInput:self
                                                      string:command
                                                       label:label];
      [gestureSettings addGestureAction:action];
      [action release];
    }
  }
  [inputs release];
}

- (void)receiveKeyboardInput:(NSData*)data;
{
  [terminalInput receiveKeyboardInput:data];
}

@end
