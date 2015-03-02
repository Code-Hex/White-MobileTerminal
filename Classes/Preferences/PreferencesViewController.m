// PreferencesViewController.m
// MobileTerminal

#import "PreferencesViewController.h"
#import "RotationController.h"
#import "UIImagefix.h"

@implementation PreferencesViewController

@synthesize navigationController;
@synthesize menuSettingsController;
@synthesize gestureSettingsController;
@synthesize fontSettingsController;
@synthesize themeSettingsController;
@synthesize aboutController;

- (void)viewDidLoad
{
  [super viewDidLoad];
  sections = [[NSMutableArray alloc] init];
  controllers = [[NSMutableArray alloc] init];
  icons = [[NSMutableArray alloc] init];
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
  unichar c = 0xf03a;
  NSString *icon = [NSString stringWithCharacters:&c length:1];
  [icons addObject:icon];
  c = 0xf0a6;
  icon = [NSString stringWithCharacters:&c length:1];
  [icons addObject:icon];
  c = 0xf009;
  icon = [NSString stringWithCharacters:&c length:1];
  [icons addObject:icon];
  c = 0xf031;
  icon = [NSString stringWithCharacters:&c length:1];
  [icons addObject:icon];
  c = 0xf120;
  icon = [NSString stringWithCharacters:&c length:1];
  [icons addObject:icon];
  self.navigationItem.title = @"Settings";
  self.tableView.backgroundColor = [UIColor whiteColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"settings"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *attention = [ud objectForKey:@"Alreadytweeted"];
    
    if(![attention isEqual:@"Yes"]){
        Class class = NSClassFromString(@"UIAlertController");
        if(class){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thank you!!"
                                                                           message:@"Thank you for using the terminal.\n I do not wish to donate. Instead, I am want to spread the splendor of this terminal to a lot of people.\n\nBest regards\n- CodeHex -"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"No, Thanks"
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil]];
            
            UIAlertAction * okAction =
            [UIAlertAction actionWithTitle:@"Tweet"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                                       [tweet setInitialText:@"\"#WhiteTerminal is simple & powerful & awesome!! Don't you wanna try it?\nhttp://cydia.saurik.com/package/com.codehex.whiteterminal/\""];
                                       [self presentViewController:tweet animated:YES completion:nil];
                                   }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you!!"
                                                            message:@"Thank you for using the WhiteTerminal.\n I don't wish to donate. Instead, I'm want to spread the splendor of this terminal to a lot of people.\n\nBest regards\n- CodeHex -"
                                                           delegate:self
                                                  cancelButtonTitle:@"No, Thanks"
                                                  otherButtonTitles:@"Tweet", nil];
            [alert show];
        }
        [ud setObject:@"Yes" forKey:@"Alreadytweeted"];
        [ud synchronize];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweet setInitialText:@"\"#WhiteTerminal is simple & powerful & awesome!! Don't you wanna try it?\nhttp://cydia.saurik.com/package/com.codehex.whiteterminal/\""];
    [self presentViewController:tweet animated:YES completion:nil];
}


- (void)dealloc
{
  [super dealloc];
  [sections release];
  [controllers release];
  [icons release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath indexAtPosition:1];
    static NSString *CellIdentifier = @"Cell";
    UIImage *img = [UIImage imageNamed:@"Icon-Small.png"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        NSString* itemTitle = [sections objectAtIndex:index];
        NSString* itemIcon = [icons objectAtIndex:index];
    
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemTitle] autorelease];
            cell.textLabel.text = itemTitle;
            cell.imageView.image = [img imageWithText:itemIcon fontName:@"FontAwesome" fontSize:17 rectSize:CGSizeMake(20,20)];
            if ([controllers objectAtIndex:index] != nil)
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSUInteger index = [indexPath indexAtPosition:1];  
  UIViewController* itemController = [controllers objectAtIndex:index];
  [self.navigationController pushViewController:itemController animated:YES];
  itemController.navigationItem.title = [sections objectAtIndex:index];
  [self.tableView reloadData];
}

@end

