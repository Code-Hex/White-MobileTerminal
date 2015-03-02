// TerminalKeyboard.m
// MobileTerminal

#import "TerminalKeyboard.h"
#import "UITextInputBase.h"

// This text field is the first responder that intercepts keyboard events and
// copy and paste events.
@interface TerminalKeyInput : UITextInputBase
{
@private
  TerminalKeyboard* keyboard;
  NSData* backspaceData;

  // UIKeyInput
  UITextAutocapitalizationType autocapitalizationType;
  UITextAutocorrectionType autocorrectionType;
  BOOL enablesReturnKeyAutomatically;
  UIKeyboardAppearance keyboardAppearance;
  UIKeyboardType keyboardType;
  UIReturnKeyType returnKeyType;
  BOOL secureTextEntry;
}

@property (nonatomic, retain) TerminalKeyboard* keyboard;

// https://github.com/hbang/NewTerm/blob/master/Classes/Terminal/TerminalKeyboard.h
@property (nonatomic) BOOL controlKeyMode;

// UIKeyInput
@property (nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic) UITextAutocorrectionType autocorrectionType;
@property (nonatomic) BOOL enablesReturnKeyAutomatically;
@property (nonatomic) UIKeyboardAppearance keyboardAppearance;
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic, getter=isSecureTextEntry) BOOL secureTextEntry;
@end

@implementation TerminalKeyInput

@synthesize keyboard;
@synthesize autocapitalizationType;
@synthesize autocorrectionType;
@synthesize enablesReturnKeyAutomatically;
@synthesize keyboardAppearance;
@synthesize keyboardType;
@synthesize returnKeyType;
@synthesize secureTextEntry;
@synthesize controlKeyMode;

- (id)init:(TerminalKeyboard*)theKeyboard
{
  if (self = [super init]) {
    keyboard = theKeyboard;
    bool isblack = [[NSUserDefaults standardUserDefaults] boolForKey:@"BlackOrWhite"];
    bool iskeytype = [[NSUserDefaults standardUserDefaults] boolForKey:@"KeyboardTypeURL"];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setEnablesReturnKeyAutomatically:NO];
    [self setReturnKeyType:UIReturnKeyDefault];
    [[NSUserDefaults standardUserDefaults] boolForKey:@"KeyTypeASCIIOnly"] ?: [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"KeyTypeASCIIOnly"];

    self.keyboardAppearance = isblack? UIKeyboardAppearanceDark : UIKeyboardAppearanceLight;
    self.keyboardType = iskeytype? UIKeyboardTypeURL : UIKeyboardTypeASCIICapable;
    [self setSecureTextEntry:[[NSUserDefaults standardUserDefaults] boolForKey:@"KeyTypeASCIIOnly"]];
    // Data to send in response to a backspace.  This is created now so it is
    // not re-allocated on ever backspace event.
    backspaceData = [[NSData alloc] initWithBytes:"\x7F" length:1];
    controlKeyMode = NO;
  }
  return self;
}

- (void)deleteBackward
{
  [[keyboard inputDelegate] receiveKeyboardInput:backspaceData];
}

- (BOOL)hasText
{
  // Make sure that the backspace key always works
  return YES;
}

- (void)insertText:(NSString *)input
{
    if (input.length == 1 && [input canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        unichar c = [input characterAtIndex:0];
        if (controlKeyMode)
            c -= (c < 0x60 && c > 0x40) ? 0x40 : (c < 0x7B && c > 0x60) ? 0x60 : 0;
        if (c == 0x0a) c = 0x0d;
        input = [NSString stringWithCharacters:&c length:1];
    }
    [[keyboard inputDelegate] receiveKeyboardInput:[input dataUsingEncoding:NSUTF8StringEncoding]];
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
  if (action == @selector(copy:)) {
    // Only show the copy menu if we actually have any data selected
    NSMutableData* data = [NSMutableData dataWithCapacity:0];
    [[keyboard inputDelegate] fillDataWithSelection:data];
    return data.length > 0;
  }
  if (action == @selector(paste:)) {
    // Only paste if the board contains plain text
    return [[UIPasteboard generalPasteboard] containsPasteboardTypes:UIPasteboardTypeListString];
  }
  return NO;
}

- (void)copy:(id)sender
{
  NSMutableData* data = [NSMutableData dataWithCapacity:0];
  [[keyboard inputDelegate] fillDataWithSelection:data];
  UIPasteboard* pb = [UIPasteboard generalPasteboard];
  pb.string = [[[NSString alloc] initWithData:data
                                    encoding:NSUTF8StringEncoding] autorelease];
}

- (void)paste:(id)sender
{
  UIPasteboard* pb = [UIPasteboard generalPasteboard];
  if (![pb containsPasteboardTypes:UIPasteboardTypeListString]) return;
  NSData* data = [pb.string dataUsingEncoding:NSUTF8StringEncoding];
  [[keyboard inputDelegate] receiveKeyboardInput:data];
}

- (BOOL)becomeFirstResponder
{
  [super becomeFirstResponder];
  return YES;
}

- (BOOL)canBecomeFirstResponder
{
  return YES;
}

@end


@implementation TerminalKeyboard

@synthesize inputDelegate;

- (id)init
{
  if (self = [super init]) {
    [self setOpaque:YES];  
    _inputTextField = [[TerminalKeyInput alloc] init:self];
    [self addSubview:_inputTextField];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  // Nothing to see here
}

- (BOOL)becomeFirstResponder
{
  return [_inputTextField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
  return [_inputTextField resignFirstResponder];
}
  
- (void)dealloc {
  [_inputTextField release];
  [super dealloc];
}

@end
