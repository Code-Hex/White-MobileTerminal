//
//  fnviewcontroller.m
//  MobileTerminal
//
//  Created by CodeHex on 2015/02/21.
//
//

#import "fnviewcontroller.h"

@implementation fnviewcontroller

@synthesize fntool1;
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    UIBarButtonItem *subbtn1 = [[[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(sub:)] autorelease];
    [itemsArray addObject:subbtn1];
    [itemsArray addObject:fix];
    UIBarButtonItem *subbtn2 = [[[UIBarButtonItem alloc] initWithTitle:@"Insert" style:UIBarButtonItemStyleBordered target:self action:@selector(sub:)] autorelease];
    [itemsArray addObject:subbtn2];
    [itemsArray addObject:fix];
    UIBarButtonItem *subbtn3 = [[[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(sub:)] autorelease];
    [itemsArray addObject:subbtn3];
    [itemsArray addObject:fix];
    UIBarButtonItem *subbtn4 = [[[UIBarButtonItem alloc] initWithTitle:@"End" style:UIBarButtonItemStyleBordered target:self action:@selector(sub:)] autorelease];
    [itemsArray addObject:subbtn4];
    [itemsArray addObject:fix];
    UIBarButtonItem *subbtn5 = [[[UIBarButtonItem alloc] initWithTitle:@"Page Up" style:UIBarButtonItemStyleBordered target:self action:@selector(sub:)] autorelease];
    [itemsArray addObject:subbtn5];
    [itemsArray addObject:fix];
    UIBarButtonItem *subbtn6 = [[[UIBarButtonItem alloc] initWithTitle:@"Page Down" style:UIBarButtonItemStyleBordered target:self action:@selector(sub:)] autorelease];
    [itemsArray addObject:subbtn6];
    [itemsArray addObject:fix];
    
    NSString *str = @"F";
    for (int i = 1; i <= 20; i++) {
        UIBarButtonItem *functionbtn = [[[UIBarButtonItem alloc] initWithTitle:[str stringByAppendingFormat:@"%d", i] style:UIBarButtonItemStyleBordered target:self action:@selector(func:)] autorelease];
        [itemsArray addObject:fix];
        [itemsArray addObject:functionbtn];
    }   [itemsArray addObject:fix];
    
    NSArray *items = [itemsArray copy];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = fntool1.frame;
    scrollView.bounds = fntool1.bounds;
    scrollView.autoresizingMask = fntool1.autoresizingMask;
    scrollView.showsVerticalScrollIndicator = false;
    scrollView.showsHorizontalScrollIndicator = false;
    //scrollView.bounces = false;
    UIView *superView = fntool1.superview;
    [fntool1 removeFromSuperview];
    fntool1.autoresizingMask = UIViewAutoresizingNone;
    fntool1.frame = CGRectMake(0, 0, 1060, fntool1.frame.size.height);
    fntool1.bounds = fntool1.frame;
    [fntool1 setItems:items];
    scrollView.contentSize = fntool1.frame.size;
    [scrollView addSubview:fntool1];
    [superView addSubview:scrollView];
    
    [fntool1 setBackgroundImage:[UIImage new]
             forToolbarPosition:UIBarPositionAny
                     barMetrics:UIBarMetricsDefault];
    [fntool1 setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
}

- (void)viewWillAppear:(BOOL)animated {

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"BlackOrWhite"]) {
        self.view.backgroundColor = [[[UIColor alloc] initWithWhite:1.f alpha:1.f] autorelease];
        fntool1.backgroundColor = [[[UIColor alloc] initWithWhite:1.f alpha:1.f] autorelease];
        fntool1.tintColor = [[[UIColor alloc] initWithWhite:0.f alpha:1.f] autorelease];
    } else {
        self.view.backgroundColor = [[[UIColor alloc] initWithWhite:0.f alpha:1.f] autorelease];
        fntool1.backgroundColor = [[[UIColor alloc] initWithWhite:0.f alpha:1.f] autorelease];
        fntool1.tintColor = [[[UIColor alloc] initWithWhite:1.f alpha:1.f] autorelease];
    }
    [super viewWillAppear:YES];
}

- (void)func:(UIBarButtonItem *)sender
{
    [delegate function:sender.title];
}

- (void)sub:(UIBarButtonItem *)sender
{
    [delegate subkey:sender.title];
}

- (void)dealloc {
    [fntool1 release];
    [super dealloc];
}



@end
