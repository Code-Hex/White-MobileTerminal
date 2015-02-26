//
//  FontSettingsController.m
//  MobileTerminal
//
//  Created by CodeHex on 2014/09/20.
//
//

#import "FontSettingsController.h"
#define IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

@implementation FontSettingsController

@synthesize slider;
@synthesize label;
@synthesize fontsize; // label fontsize
@synthesize fontname; // fontname of label

- (void)viewDidLoad {
    [super viewDidLoad];
    
    name = [[NSMutableArray alloc] initWithObjects:
            @"AnonymousPro",
            @"Courier",
            @"Cousine",
            @"CutiveMono-Regular",
            @"FiraMono-Regular",
            @"FixedsysTTF",
            @"HyperFont",
            @"Inconsolata-Regular",
            //@"Menlo-Regular",
            @"LuxiMono",
            @"MesloLGM-Regular",
            @"ProFontWindows",
            @"SourceCodePro-Regular",
            @"UbuntuMono-Regular",
            @"VT323-Regular",nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat fontSize = [defaults floatForKey:@"font-Size"];
    fontname = [defaults objectForKey:@"font-Name"];
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 110)];
    label.text = [NSString stringWithFormat:@"Blowin' in the Wind"];
    label.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:label];
    label.font = [UIFont fontWithName:fontname size:fontSize];
}

- (void)viewWillDisappear {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize]; // Store fontsize
}

- (void)dealloc
{
    [super dealloc];
    [sheets dealloc];
    [name dealloc];
    [slider release];
    [label release];
    [fontsize release];
    [fontname release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section == 0)? 120 : 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    else if (section == 1)
        return [name count];
    else
        return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *fontName = [defaults objectForKey:@"font-Name"];

if(indexPath.section == 1){
        if (fontName){
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[name objectAtIndex:[indexPath row]] inSection:1]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    
        for (NSInteger index=0; index<[self.tableView numberOfRowsInSection:1]; index++) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:1]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        
            if (indexPath.row == index)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
    
        NSLog(@"Selected %@", [name objectAtIndex:[indexPath row]]);
        fontname = [name objectAtIndex:[indexPath row]];
        label.font = [UIFont fontWithName:fontname size:slider.value];
        [defaults setObject:[name objectAtIndex:[indexPath row]] forKey:@"font-Name"];
    
        BOOL successful = [defaults synchronize];
        if (successful) NSLog(@"Stored settings.");
        }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger index = [indexPath indexAtPosition:1];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
if(indexPath.section == 0) {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat fontSize = [defaults floatForKey:@"font-Size"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"slider"] autorelease];
        slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 0, 240, 45)];
        fontsize = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 50, 45)];
        slider.minimumValue = 10.f;
        slider.maximumValue = 20.f;
        slider.value = fontSize;
        [slider addTarget:self action:@selector(FontSizeSlider:) forControlEvents:UIControlEventValueChanged];
        fontsize.text = [NSString stringWithFormat:@"%.1f",slider.value];
        fontsize.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:slider];
        [cell.contentView addSubview:fontsize];
    }
    if (IPAD && !fontSize){
        [defaults setFloat:19.f forKey:@"font-Size"];
    } else if (!IPAD && !fontSize){
        [defaults setFloat:11.f forKey:@"font-Size"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

} else if(indexPath.section == 1) {
    
    NSString* itemTitle = [name objectAtIndex:index];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemTitle] autorelease];
        
        UIFont *myfont = [UIFont fontWithName:itemTitle size:[UIFont systemFontSize]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", itemTitle];
        cell.textLabel.font = myfont;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fontName = [defaults objectForKey:@"font-Name"];
    NSUInteger check = [name indexOfObject:fontName];
    
    if (index != NSNotFound) {
        if (!fontName && indexPath.row == 1){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [defaults setObject:[name objectAtIndex:1] forKey:@"font-Name"];
        }
        
        if (indexPath.row == check)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        if (indexPath.row == 0)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
  }
    return 0;
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

- (void)FontSizeSlider:(UISlider*)sender{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:sender.value forKey:@"font-Size"];
    NSLog(@"%f",sender.value);
    fontsize.text = [NSString stringWithFormat:@"%.1f",sender.value];
    label.font = [UIFont fontWithName:fontname size:sender.value];
    BOOL successful = [defaults synchronize];
    if (successful) NSLog(@"Stored settings.");
}

@end