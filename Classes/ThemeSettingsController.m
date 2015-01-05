//
//  ThemeSettingsController.m
//  MobileTerminal
//
//  Created by CodeHex on 2014/12/31.
//
//

#import "ThemeSettingsController.h"

@implementation ThemeSettingsController

@synthesize BGColorPickerViewController;
@synthesize TextColorPickerViewController;
@synthesize BoldColorPickerViewController;
@synthesize CursorColorPickerViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sections = [[NSMutableArray alloc]initWithObjects:
                @"Basic",
                @"Grass",
                @"Homebrew",
                @"Man Page",
                @"Novel",
                @"Ocean",
                @"Pro",
                @"Red Sands",
                @"Silver Aerogel",
                @"My Theme", nil];
    
    pickers = [[NSMutableArray alloc]initWithObjects:
               @"Background",
               @"Text",
               @"BoldText",
               @"Cursor",nil];
    
    blackorwhite = [[NSMutableArray alloc]initWithObjects:@"BlackMode",nil];
    
    NSUserDefaults *colorDefaults = [NSUserDefaults standardUserDefaults];
    NSData *colorData1 = [colorDefaults objectForKey:@"Term_Background"];
    NSData *colorData2 = [colorDefaults objectForKey:@"Term_Text"];
    NSData *colorData3 = [colorDefaults objectForKey:@"Term_BoldText"];
    NSData *colorData4 = [colorDefaults objectForKey:@"Term_Cursor"];
    UIColor *background = [NSKeyedUnarchiver unarchiveObjectWithData:colorData1];
    UIColor *text = [NSKeyedUnarchiver unarchiveObjectWithData:colorData2];
    UIColor *bold = [NSKeyedUnarchiver unarchiveObjectWithData:colorData3];
    UIColor *cursor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData4];
    
    controllers = [[NSMutableArray alloc]initWithObjects:
                   [[BGColorPickerViewController alloc] initWithColor:background ?: [UIColor blackColor] fullColor:YES],
                   [[TextColorPickerViewController alloc] initWithColor:text ?: [UIColor colorWithRed:0.2 green:0.8 blue:0 alpha:1] fullColor:YES],
                   [[BoldColorPickerViewController alloc] initWithColor:bold ?: [UIColor colorWithRed:0.6 green:0 blue:0 alpha:1] fullColor:YES],
                   [[CursorColorPickerViewController alloc] initWithColor:cursor ?: [UIColor colorWithRed:0.6 green:0 blue:0 alpha:1] fullColor:YES],
                   nil];

}

- (void)viewWillDisappear {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize]; // Store themes
}

- (void)dealloc
{
    [super dealloc];
    [sections dealloc];
    [pickers dealloc];
    [controllers dealloc];
    [blackorwhite dealloc];
    [BGColorPickerViewController dealloc];
    [TextColorPickerViewController dealloc];
    [BoldColorPickerViewController dealloc];
    [CursorColorPickerViewController dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? [sections count] : section == 1 ? [pickers count] : section == 2 ? [blackorwhite count] : 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView reloadData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *colors = [defaults objectForKey:@"colorMap"];
    
    if (indexPath.section == 0) {
        
        if (colors){
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sections objectAtIndex:[indexPath row]] inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        for (NSInteger index=0; index<[self.tableView numberOfRowsInSection:0]; index++) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (indexPath.row == index)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        
        NSLog(@"Selected %@", [sections objectAtIndex:[indexPath row]]);
        [defaults setObject:[sections objectAtIndex:[indexPath row]] forKey:@"colorMap"];
        BOOL successful = [defaults synchronize];
        if (successful) NSLog(@"Stored settings.");
    } else if (indexPath.section == 1) {
        NSUInteger index = [indexPath indexAtPosition:1];
        UIViewController* itemController = [controllers objectAtIndex:index];
        [self.navigationController pushViewController:itemController animated:YES];
        itemController.navigationItem.title = [pickers objectAtIndex:index];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        NSUInteger index = [indexPath indexAtPosition:1];
        NSString* itemTitle = [sections objectAtIndex:index];
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemTitle] autorelease];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", itemTitle];
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *color = [defaults objectForKey:@"colorMap"];
        NSUInteger check = [sections indexOfObject:color];
        
        if (index != NSNotFound) {
            if (!color && indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [defaults setObject:[sections objectAtIndex:0] forKey:@"colorMap"];
            }
            
            if (indexPath.row == check)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            if (indexPath.row == 0)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {
        NSUInteger index = [indexPath indexAtPosition:1];
        NSString* itemTitle = [pickers objectAtIndex:index];
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemTitle] autorelease];
            cell.textLabel.text = itemTitle;
            if ([controllers objectAtIndex:index] != nil) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        return cell;
        
    } else if (indexPath.section == 2) {
        NSUInteger index = [indexPath indexAtPosition:1];
        NSString* itemTitle = [blackorwhite objectAtIndex:index];
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemTitle] autorelease];
        }
        UISwitch *bwswitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [bwswitch addTarget:self action:@selector(bwchanger:) forControlEvents:UIControlEventTouchUpInside];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        bwswitch.on = ![ud boolForKey:@"BlackOrWhite"] ? YES : NO;
        cell.accessoryView = bwswitch;
        
        cell.textLabel.text = itemTitle;
        
        return cell;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView
willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.backgroundColor = [UIColor whiteColor]; // Background Color
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? [NSString stringWithFormat:@"Themes"] : section == 1 ? [NSString stringWithFormat:@"My Theme"] : section == 2 ? [NSString stringWithFormat:@"UIChange"] : 0;
}

-(void)bwchanger:(id)sender {
    UISwitch *bwswitch = (UISwitch *)sender;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    bwswitch.on ? [ud setBool:false forKey:@"BlackOrWhite"] : [ud setBool:true forKey:@"BlackOrWhite"];
    NSLog(@"switch tapped. value = %@", (bwswitch.on ? @"ON(false)" : @"OFF(true)"));
}



@end