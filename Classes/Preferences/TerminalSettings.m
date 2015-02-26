// TerminalSettings.m
// MobileTerminal

#import "TerminalSettings.h"
#import "VT100/ColorMap.h"

@implementation TerminalSettings

@synthesize colorMap;

- (id)init
{
    if (self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *themename = [defaults objectForKey:@"colorMap"];
        NSDictionary *themes = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Themes" ofType:@"plist"]];
        colorMap = themename ? [[ColorMap alloc] initWithDictionary:themes[themename]] : [[ColorMap alloc] init];
    }
    return self;
}

@end
