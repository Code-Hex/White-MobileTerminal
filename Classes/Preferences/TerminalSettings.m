// TerminalSettings.m
// MobileTerminal

#import "TerminalSettings.h"
#import "VT100/ColorMap.h"

#define IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

@implementation TerminalSettings

@synthesize font;
@synthesize colorMap;
@synthesize args;
@synthesize fontname;

static NSString* kDefaultFontName = @"Courier";
static const CGFloat kDefaultIPhoneFont = 11.0f;
static const CGFloat kDefaultIPadFont = 19.0f;

- (id) init
{
  return [self initWithCoder:nil];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    
  self = [super init];
  if (self != nil) {
    if ([decoder containsValueForKey:@"args"])
      args = [[decoder decodeObjectForKey:@"args"] retain];
    else
      args = @"";

    if ([decoder containsValueForKey:@"colorMap"])
      colorMap = [[decoder decodeObjectForKey:@"colorMap"] retain];
    else
      colorMap = [[ColorMap alloc] init];

    // UIFont does not implement NSCoding, so decode its arguments instead
    font = nil;
    if ([decoder containsValueForKey:@"fontName"] &&
        [decoder containsValueForKey:@"fontSize"]) {
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      NSString* fontName = [defaults objectForKey:@"font-Name"];
      CGFloat fontSize = [defaults floatForKey:@"font-Size"];
      font = [UIFont fontWithName:fontName size:fontSize];
    }
      
    if (font == nil) { 
      // The iPad and iPhone have different default font sizes since the default
      // font on the iPad looks too small.
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        CGFloat fontsize = 0;
        if (IPAD){
            fontsize = [defaults floatForKey:@"font-Size"]?: kDefaultIPadFont;
            fontname = [defaults objectForKey:@"font-Name"]?: kDefaultFontName;
        }else{
            fontsize = [defaults floatForKey:@"font-Size"]?: kDefaultIPhoneFont;
            fontname = [defaults objectForKey:@"font-Name"]?: kDefaultFontName;
        }
      font = [UIFont fontWithName:fontname size:fontsize];
    }
    if (!font) {
      NSLog(@"Default font unavailable, using system font");
        font = [UIFont fontWithName:kDefaultFontName size:IPAD ? kDefaultIPadFont : kDefaultIPhoneFont];
    }
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [encoder encodeObject:args forKey:@"args"];
    
  [encoder encodeObject:colorMap forKey:@"colorMap"];
  // UIFont does not implement NSCoding, so encode its arguments instead
  NSString* fontName = [defaults objectForKey:@"font-Name"];
  CGFloat fontSize = [defaults floatForKey:@"font-Size"];
  [encoder encodeObject:fontName forKey:@"fontName"];
  [encoder encodeFloat:fontSize forKey:@"fontSize"];
}

@end
