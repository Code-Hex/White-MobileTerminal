// TerminalGroupView.m
// MobileTerminal

#import "TerminalGroupView.h"
#import "TerminalView.h"
#import "Preferences/Settings.h"

// TODO(allen): This should be dynamic, or not supported at all.
static const int NUM_TERMINALS = 4;

@implementation TerminalGroupView

- (id)initWithCoder:(NSCoder *)decoder
{
  if (self = [super initWithCoder:decoder]) {
    terminals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < NUM_TERMINALS; ++i) {
      TerminalView* view = [[TerminalView alloc] initWithCoder:decoder];
      [view setFont];
      [terminals addObject:view];
        
      [self addSubview:view];
    }
    [self bringTerminalToFront:0];
  }
  return self;
}

- (void)dealloc
{
  [terminals release];
  [super dealloc];
}

- (void)startSubProcess
{
  for (int i = 0; i < [terminals count]; ++i) {
    TerminalView* view = [terminals objectAtIndex:i];
    [view startSubProcess];
  }
}

- (int)terminalCount
{
  return (int)[terminals count];
}

- (TerminalView*)terminalAtIndex:(int)index
{
  return [terminals objectAtIndex:index];
}

static const NSTimeInterval kAnimationDuration = 0.25f;

- (void)bringTerminalToFront:(TerminalView*)terminalView
{
  int previousActiveTerminalIndex = activeTerminalIndex;
  for (int i = 0; i < [terminals count]; ++i) {
    TerminalView* view = [terminals objectAtIndex:i];
    if (view == terminalView) {
      activeTerminalIndex = i;
      break;
    }
  }
    
    UIViewAnimationTransition transition = (previousActiveTerminalIndex < activeTerminalIndex) ? UIViewAnimationTransitionCurlUp : UIViewAnimationTransitionCurlDown;
  
  [UIView beginAnimations:NULL context:NULL];
  [UIView setAnimationDuration:kAnimationDuration];
  [UIView setAnimationTransition:transition forView:self cache:YES];
  [self bringSubviewToFront:terminalView];
  [UIView commitAnimations];
}

- (TerminalView*)frontTerminal
{
  return [self terminalAtIndex:activeTerminalIndex];
}

@end
