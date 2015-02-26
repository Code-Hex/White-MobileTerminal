//
//  StoreThemeController.m
//  MobileTerminal
//
//  Created by CodeHex on 2015/02/23.
//
//

// #import "StoreThemeController.h"

/*
@implementation StoreThemeController

@synthesize BGColorPickerViewController;
@synthesize TextColorPickerViewController;
@synthesize BoldColorPickerViewController;
@synthesize CursorColorPickerViewController;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 65;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    title = @"";
    UIBarButtonItem *cancel = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
    UIBarButtonItem *save = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.rightBarButtonItem = save;

    
    pickers = [[NSMutableArray alloc] initWithObjects:
               @"Background",
               @"Text",
               @"BoldText",
               @"Cursor",nil];
    
    UIColor *background = [UIColor blackColor];
    UIColor *text = [UIColor whiteColor];
    UIColor *bold = [UIColor blueColor];
    UIColor *cursor = [UIColor redColor];
    
    controllers = [[NSMutableArray alloc]initWithObjects:
                   [[[BGColorPickerViewController alloc] initWithColor:background fullColor:YES] autorelease],
                   [[[TextColorPickerViewController alloc] initWithColor:text fullColor:YES] autorelease],
                   [[[BoldColorPickerViewController alloc] initWithColor:bold fullColor:YES] autorelease],
                   [[[CursorColorPickerViewController alloc] initWithColor:cursor fullColor:YES] autorelease],
                   nil];
    
}

- (void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(id)sender
{

    NSString *themes = [[NSBundle mainBundle] pathForResource:@"Themes" ofType:@"plist"];
    NSString *error;
    NSMutableDictionary *name = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:themes]
                                                                 mutabilityOption:NSPropertyListMutableContainers
                                                                           format:nil
                                                                 errorDescription:&error];
    NSArray *background_color = @[@10, @20, @30];
    NSArray *foreground_color = @[@100, @202, @130];
    NSArray *foregroundbold_color = @[@0, @0, @0];
    NSArray *cursor_color = @[@210, @220, @230];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"background"] = background_color;
    dic[@"foreground"] = foreground_color;
    dic[@"foregroundBold"] = foregroundbold_color;
    dic[@"cursor"] = cursor_color;
    [name setObject:dic forKey:@"test"];
    
    NSString *docFolder = [NSHomeDirectory() stringByAppendingPathComponent:@""];
    NSString *dataFilePath = [NSString stringWithFormat:@"%@/Themes.plist",docFolder];
    
    BOOL result = [name writeToFile:dataFilePath atomically:YES];
    result ? NSLog(@"Success") : NSLog(@"Failed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [super dealloc];
    [sections release];
    [pickers release];
    //[title release];
    [controllers release];
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
    
    return section == 0 ? 1 : [pickers count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSUInteger index = [indexPath indexAtPosition:1];
        UIViewController* itemController = [controllers objectAtIndex:index];
        [self.navigationController pushViewController:itemController animated:YES];
        itemController.navigationItem.title = [pickers objectAtIndex:index];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc]
                    initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.0f)];
        textField.delegate = self;
        textField.borderStyle = UITextBorderStyleNone;
        textField.placeholder = @"Input this theme title";
        textField.returnKeyType = UIReturnKeyDone;
        textField.textAlignment = UITextAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:textField];
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
    }
    return 0;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField*)textField
{
    title = textField.text;
    return YES;
}

-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.backgroundColor = [UIColor whiteColor]; // Background Color
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? [NSString stringWithFormat:@"New Theme"] : 0;
}

@end
*/