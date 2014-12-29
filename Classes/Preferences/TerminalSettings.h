// TerminalSettings.h
// MobileTerminal

#import <Foundation/Foundation.h>

@class ColorMap;
@class UIFont;

// Settings that apply to a terminal.  This object implements the NSCoding
// protocol so that it can be serialized.
@interface TerminalSettings : NSObject <NSCoding> {
@private
  UIFont* font;
  ColorMap* colorMap;
  NSString* args;
  NSString* fontname;
}

@property(nonatomic, retain) UIFont* font;
@property(nonatomic, retain) ColorMap* colorMap;
@property(nonatomic, retain) NSString* args;
@property(nonatomic, retain) NSString* fontname;

- (instancetype)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

@end
