// FontMetrics.h
// MobileTerminal
//
//

#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIFont.h>

@interface FontMetrics : NSObject {
@private
  CTFontRef ctFont;
  CGFloat ascent;
  CGFloat descent;
  CGFloat leading;
  CGSize boundingBox;
}

- (id)init;
- (CTFontRef)ctFont;

// The dimensions of a single glyph on the screen
- (CGSize)boundingBox;
- (float)descent;

@end
