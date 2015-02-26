// TerminalSettings.h
// MobileTerminal

#import <Foundation/Foundation.h>

@class ColorMap;

// Settings that apply to a terminal.  This object implements the NSCoding
// protocol so that it can be serialized.
@interface TerminalSettings : NSObject

@property(nonatomic, retain) ColorMap* colorMap;


@end
