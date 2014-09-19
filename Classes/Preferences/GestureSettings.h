// GestureSettings.h
// MobileTerminal

#import <Foundation/Foundation.h>

extern NSString* kGestureSingleDoubleTap;
extern NSString* kGestureDoubleDoubleTap;
extern NSString* kGestureSwipeUp;
extern NSString* kGestureSwipeDown;
extern NSString* kGestureSwipeLeft;
extern NSString* kGestureSwipeRight;
extern NSString* kGestureSwipeLeftUp;
extern NSString* kGestureSwipeLeftDown;
extern NSString* kGestureSwipeRightUp;
extern NSString* kGestureSwipeRightDown;

// A GestureAction is performed in response to a gesture.  Implementations may
// do something like hide and show the keyboard, or issue a specific command.
@protocol GestureAction
- (NSString*)label;
- (void)performAction;
@end

// An implementation of GestureActioin that invokes a selector.
@interface SelectorGestureAction : NSObject<GestureAction> {
@private
  NSString* label;
  id target;
  SEL action;
}
- (instancetype)initWithTarget:(id)target action:(SEL)action label:(NSString*)label;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *label;
- (void)performAction;
@end

// There are a fixed number of GestureItems, one for each gesture that is
// supported.  The item may or may not have a corresponding action.
@interface GestureItem : NSObject {
@private
  NSString* name;
  NSString* actionLabel;
}

@property(nonatomic, retain) NSString* name;
// The actionLabel may or may not map to a valid action
@property(nonatomic, retain) NSString* actionLabel;

@end

// Holds the collection of GestureItems.  GestureItems cannot be added or
// removed since there are a fixed number of gestures.
@interface GestureSettings : NSObject<NSCoding> {
@private
  NSMutableArray* gestureItems;
  NSMutableArray* gestureActions;
}

- (instancetype)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

// Number of gestures supported
@property (NS_NONATOMIC_IOSONLY, readonly) int gestureItemCount;

// The label and action
- (GestureItem*)gestureItemAtIndex:(int)index;
- (GestureItem*)gestureItemForName:(NSString*)name;

@property (NS_NONATOMIC_IOSONLY, readonly) int gestureActionCount;
- (id<GestureAction>)gestureActionAtIndex:(int)index;
- (void)addGestureAction:(id<GestureAction>)action;
- (id<GestureAction>)gestureActionForLabel:(NSString*)label;
- (id<GestureAction>)gestureActionForItemName:(NSString*)name;

@end
