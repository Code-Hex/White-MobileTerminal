// MenuView.m
// MobileTerminal

#import "MenuView.h"
#import <QuartzCore/QuartzCore.h>
#import "Preferences/Settings.h"
#import "Preferences/MenuSettings.h"

@implementation MenuView

@synthesize menuTableView;
@synthesize font;
@synthesize menuSettings;
@synthesize delegate;

- (void)awakeFromNib
{
  font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
  menuSettings = [[Settings sharedInstance] menuSettings];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;  
{
  return [font pointSize] * 1.5f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [menuSettings menuItemCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // This currently only supports one section
  if ([indexPath length] != 2 ||
      [indexPath indexAtPosition:0] != 0 ||
      [indexPath indexAtPosition:1] > [menuSettings menuItemCount]) {
    return nil;
  }
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  MenuItem* menuItem = [menuSettings menuItemAtIndex:(int)[indexPath indexAtPosition:1]];
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (![ud boolForKey:@"BlackOrWhite"]) {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [[[UIColor alloc] initWithWhite:1.f alpha:0.85f] autorelease];
        menuTableView.backgroundColor = [[[UIColor alloc] initWithWhite:0.667f alpha:0.65f] autorelease];
    } else {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [[[UIColor alloc] initWithWhite:0.f alpha:0.55f] autorelease];
        menuTableView.backgroundColor = [[[UIColor alloc] initWithWhite:0.333f alpha:0.65f] autorelease];
    }
  cell.textLabel.text = menuItem.label;
  cell.textLabel.font = font;

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [menuTableView reloadData];
  MenuItem* menuItem = [menuSettings menuItemAtIndex:(int)[indexPath indexAtPosition:1]];
  [delegate selectedCommand:menuItem.command];
}

static const double kAnimationDuration = 0.25f;

- (void)setHidden:(BOOL)isHidden
{
  // TODO(allen): Set the max size of the view based on the total number of
  // menu items.
  if (!isHidden) {
    // When re-displaying the table, start from the top of the menu in a fresh
    // state.
    [menuTableView reloadData];
    [menuTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1)
                              animated:NO];
    [menuTableView deselectRowAtIndexPath:[menuTableView indexPathForSelectedRow] animated:NO];
  }
  
  [UIView beginAnimations:NULL context:NULL];
  CATransition *animation = [CATransition animation];
  [animation setDuration:kAnimationDuration];
  if (isHidden) {
    [animation setType:kCATransitionFade];
  } else {
    // Slide up the menu as it appears
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromTop];
  }
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];	
  [[self layer] addAnimation:animation forKey:@"toggleMenuView"];
  [super setHidden:isHidden];
  [UIView commitAnimations];  
}


- (void)dealloc {
    [font release];
    [menuSettings release];
    [super dealloc];
}

@end
