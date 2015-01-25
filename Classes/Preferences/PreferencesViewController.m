// PreferencesViewController.m
// MobileTerminal

#import "PreferencesViewController.h"
#import "RotationController.h"

@implementation PreferencesViewController

@synthesize navigationController;
@synthesize menuSettingsController;
@synthesize gestureSettingsController;
@synthesize fontSettingsController;
@synthesize themeSettingsController;
@synthesize aboutController;

#pragma mark -
#pragma mark Initialization

- (void)viewDidLoad
{
  [super viewDidLoad];
  sections = [[NSMutableArray alloc] init];
  controllers = [[NSMutableArray alloc] init];
  [sections addObject:@"Shortcut Menu"];
  [sections addObject:@"Gestures"];
  [sections addObject:@"Themes"];
  [sections addObject:@"Fonts"];
  [sections addObject:@"About"];
  [controllers addObject:menuSettingsController];
  [controllers addObject:gestureSettingsController];
  [controllers addObject:themeSettingsController];
  [controllers addObject:fontSettingsController];
  [controllers addObject:aboutController];
    
  self.navigationItem.title = @"Top";
    
  /* Delete cell separator */
  //self.tableView.SeparatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [super viewWillAppear:YES];
    NSLog(@"Preference WillAppear");
    //[navigationController setNavigationBarHidden:NO];
}

- (void)dealloc
{
  [super dealloc];
  [sections dealloc];
  [controllers dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return /*(section == 0) ? */[sections count];// : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath indexAtPosition:1];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //if (indexPath.section == 0) {
        NSString* itemTitle = [sections objectAtIndex:index];

        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemTitle] autorelease];
            cell.textLabel.text = itemTitle;
            if ([controllers objectAtIndex:index] != nil) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        return cell;
   /* } else {
        NSString* itemTitle = @"Quick Restart";
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemTitle] autorelease];
        }
        UISwitch *qswitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [qswitch addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        qswitch.on = [ud boolForKey:@"QuickRestart"] ? YES : NO;
        cell.accessoryView = qswitch;
        cell.textLabel.text = itemTitle;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
      */
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.backgroundColor = [UIColor whiteColor]; // Background Color
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSUInteger index = [indexPath indexAtPosition:1];  
  UIViewController* itemController = [controllers objectAtIndex:index];
  [self.navigationController pushViewController:itemController animated:YES];
  itemController.navigationItem.title = [sections objectAtIndex:index];
}

/*
-(void)restart:(id)sender {
    UISwitch *qswitch = (UISwitch *)sender;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    qswitch.on ? [ud setBool:true forKey:@"QuickRestart"] : [ud setBool:false forKey:@"QuickRestart"];
    NSLog(@"black or white switch tapped. value = %@", (qswitch.on ? @"ON(true)" : @"OFF(false)"));
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? [NSString stringWithFormat:@"Settings"] : section == 1 ? [NSString stringWithFormat:@"Quick Restart Mode"] : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return section == 1 ? [NSString stringWithFormat:@"When you are finished, quickly restart using the Notification Center."] : 0;
}
*/

@end

