// Settings.h
// MobileTerminal

#import <Foundation/Foundation.h>

// TODO(allen): Hard coding this here is less than ideal.  This should probably
// come from an initialization argument from MobileTerminalViewController. 
#define TERMINAL_COUNT 4

@class MenuSettings, TerminalSettings, GestureSettings;

// Settings for mobile terminal.  This object implements the NSCoding protocol
// so that the settings can be read and written to the preferences store.
@interface Settings : NSObject <NSCoding> {
@private
  float svnVersion;
  MenuSettings* menuSettings;
  GestureSettings* gestureSettings;
  TerminalSettings* terminalSettings;
}

@property(nonatomic) float svnVersion;
@property(nonatomic, retain) MenuSettings* menuSettings;
@property(nonatomic, retain) GestureSettings* gestureSettings;
@property(nonatomic, retain) TerminalSettings* terminalSettings;


+ (Settings*)sharedInstance;

// Write the settings to persistent storage
- (void)persist;

- (instancetype)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

@end
