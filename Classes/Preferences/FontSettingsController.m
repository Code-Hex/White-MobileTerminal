//
//  FontSettingsController.m
//  MobileTerminal
//
//  Created by CodeHex on 2014/09/20.
//
//

#import "FontSettingsController.h"
#define IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

@interface FontSettingsController ()

@end

@implementation FontSettingsController

@synthesize font;

- (void)viewDidLoad {
    [super viewDidLoad];
    sheets = [[NSMutableArray alloc] initWithObjects:
              [NSNumber numberWithFloat:11.0],
              [NSNumber numberWithFloat:12.0],
              [NSNumber numberWithFloat:13.0],
              [NSNumber numberWithFloat:14.0],
              [NSNumber numberWithFloat:15.0],
              [NSNumber numberWithFloat:16.0],
              [NSNumber numberWithFloat:17.0],
              [NSNumber numberWithFloat:17.5],
              [NSNumber numberWithFloat:18.0],
              [NSNumber numberWithFloat:18.5],
              [NSNumber numberWithFloat:19.0], nil];
    
    name = [[NSMutableArray alloc] initWithObjects:@"AnonymousPro",@"Courier",@"MesloLGM-Regular",@"SourceCodePro-Regular",@"UbuntuMono-Regular",@"Futura",nil];
}

- (void)dealloc
{
    [super dealloc];
    [sheets dealloc];
    [name dealloc];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return [sheets count];
    else if (section == 1)
        return [name count];
    else
        return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView reloadData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat fontSize = [defaults floatForKey:@"font-Size"];
    NSString *fontName = [defaults objectForKey:@"font-Name"];
    
if(indexPath.section == 0) {
    
    if (fontSize){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sheets objectAtIndex:[indexPath row]] inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    for (NSInteger index=0; index<[self.tableView numberOfRowsInSection:0]; index++) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;

    if (indexPath.row == index)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    NSLog(@"「%@」が選択されました", [sheets objectAtIndex:[indexPath row]]);
    [defaults setObject:[sheets objectAtIndex:[indexPath row]] forKey:@"font-Size"];
    [defaults synchronize]; // Store fontsize
} else {
    
    if (fontName){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[name objectAtIndex:[indexPath row]] inSection:1]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    for (NSInteger index=0; index<[self.tableView numberOfRowsInSection:0]; index++) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:1]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.row == index)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    NSLog(@"「%@」が選択されました", [name objectAtIndex:[indexPath row]]);
    [defaults setObject:[name objectAtIndex:[indexPath row]] forKey:@"font-Name"];
    [defaults synchronize]; // Store fontsize
    
}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
if(indexPath.section == 0) {
    NSUInteger index = [indexPath indexAtPosition:1];
    NSString* itemTitle = [sheets objectAtIndex:index];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemTitle] autorelease];
        NSString *num = [NSString stringWithFormat:@"%@", itemTitle];
        cell.textLabel.text = [num stringByAppendingString:@"px"];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat fontSize = [defaults floatForKey:@"font-Size"];
    NSUInteger check = [sheets indexOfObject:[NSNumber numberWithFloat:fontSize]];
    
   if (index != NSNotFound) {
       NSLog(@"check is Found!!");
      if (indexPath.row == check)
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
   } else {
       NSLog(@"check is Not Found...");
      if (indexPath.row == 0)
           cell.accessoryType = UITableViewCellAccessoryCheckmark;
   }
    
    return cell;

} else {
    
    NSUInteger index = [indexPath indexAtPosition:1];
    NSString* itemTitle = [name objectAtIndex:index];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemTitle] autorelease];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", itemTitle];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fontName = [defaults objectForKey:@"font-Name"];
    NSUInteger check = [name indexOfObject:fontName];
    
    if (index != NSNotFound) {
        NSLog(@"check is Found!!");
        if (indexPath.row == check)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        NSLog(@"check is Not Found...");
        if (indexPath.row == 0)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    
    return cell;
}
}


- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.backgroundColor = [UIColor whiteColor]; // Background Color
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return [NSString stringWithFormat:@"fontsize"];
    else if (section == 1)
        return [NSString stringWithFormat:@"fontname"];
    else
        return 0;
}

@end