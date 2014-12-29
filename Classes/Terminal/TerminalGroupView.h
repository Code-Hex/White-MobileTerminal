// TerminalGroupView.h
// MobileTerminal

#import <UIKit/UIKit.h>

@class TerminalView;

// A terminal group view is parent view for multiple terminals.  It is a wrapper
// that should make it simple to select the current active terminal.  It is
// the responsibility of the caller to handle changing the terminal keyboards
// delegate when changing the active terminal.
@interface TerminalGroupView : UIView {
@private
  int activeTerminalIndex;
  NSMutableArray* terminals;
}

- (instancetype)initWithCoder:(NSCoder *)decoder;

- (void)startSubProcess;

// Makes the specified terminal active
- (void)bringTerminalToFront:(TerminalView*)terminalView;
// Returns the active terminal
@property (NS_NONATOMIC_IOSONLY, readonly, strong) TerminalView *frontTerminal;

@property (NS_NONATOMIC_IOSONLY, readonly) int terminalCount;
- (TerminalView*)terminalAtIndex:(int)index;

@end
