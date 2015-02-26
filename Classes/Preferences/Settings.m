// Settings.m
// MobileTerminal

#import "Settings.h"

#import <UIKit/UIKit.h>

#import "GestureSettings.h"
#import "MenuSettings.h"
#import "TerminalSettings.h"

@implementation Settings

@synthesize svnVersion;
@synthesize menuSettings;
@synthesize gestureSettings;
@synthesize terminalSettings;

static NSString* kSettingsKey = @"com.googlecode.whitemobileterminal.Settings";
static NSString* kVersionKey = @"version";
static NSString* kMenuSettings = @"menuSettings";
static NSString* kGestureSettings = @"gestureSettings";

static NSString* kDefaultMenuItems[][2] = {
  { @"sl", @"sl" },
  { @"cd", @"cd" },
  { @"../", @"../" },  
  { @"pwd", @"pwd" },
  { @"ls -al", @"ls -al" },
  { @"chsh -s", @"chsh -s" },
  { @"find \"DIR\" -name \"NAME\"", @"find" },
  { @"ping google.com", @"ping google.com\n" },
  
};
static int kDefaultMenuItemsCount =
    sizeof(kDefaultMenuItems) / sizeof(NSString*) / 2;

static Settings* settings = nil;

+ (Settings*)sharedInstance
{
  if (settings == nil) {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* data = [defaults dataForKey:kSettingsKey];  
    if (data) {
      NSLog(@"Reading previous settings from NSUserDefaults");
      // Unwrap previous settings
      settings = [[NSKeyedUnarchiver unarchiveObjectWithData:data] retain];
      if (settings == nil) {
        NSLog(@"Unable to unarchive existing settings.  This shouldn't happen.");
      }
    }
    if (settings == nil) {
      NSLog(@"Using default settings");
      settings = [[Settings alloc] init];
    }
  }
  return settings;
}

- (void)persist
{
  NSLog(@"Writing settings to NSUserDefaults");
  NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
  [[NSUserDefaults standardUserDefaults] setObject:data forKey:kSettingsKey];
}

- (id) init
{
  return [self initWithCoder:nil];
}

- (void)initDefaultMenuSettings
{
  // TODO(allen): Put defaults values in an XML file.  Maybe using an XML file
  // would have been better than using NSUserDefaults.
  for (int i = 0; i < kDefaultMenuItemsCount; ++i) {
    MenuItem* menuItem = [MenuItem newItemWithLabel:kDefaultMenuItems[i][0]
                                         andCommand:kDefaultMenuItems[i][1]];
    [menuSettings addMenuItem:menuItem];
    [menuItem release];
  }
}

- (id)initWithCoder:(NSCoder *)decoder
{

  if (self = [super init]) {
      
    if ([decoder containsValueForKey:kVersionKey]) {
      float version = [decoder decodeIntForKey:kVersionKey];
      NSLog(@"Settings previously written by v%0.1f", version);
    }
      
    if ([decoder containsValueForKey:kMenuSettings]) {
      menuSettings = [[decoder decodeObjectForKey:kMenuSettings] retain];
    } else {
      menuSettings = [[MenuSettings alloc] init];
      [self initDefaultMenuSettings];
    }
      
    if ([decoder containsValueForKey:kGestureSettings]) {
      gestureSettings = [[decoder decodeObjectForKey:kGestureSettings] retain];
    } else
      gestureSettings = [[GestureSettings alloc] init];
    
      terminalSettings = [[TerminalSettings alloc] init];
  }
  return self;
}

- (void) dealloc
{
  [menuSettings release];
  [gestureSettings release];
  [terminalSettings release];
  [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  // include svn revision for future backwards compatibility
  [encoder encodeInt:svnVersion forKey:kVersionKey];
  
  [encoder encodeObject:menuSettings forKey:kMenuSettings];
  [encoder encodeObject:gestureSettings forKey:kGestureSettings];
}

@end
