//
//  fnviewcontroller.h
//  MobileTerminal
//
//  Created by CodeHex on 2015/02/21.
//
//
#import <UIKit/UIKit.h>

@protocol fnviewcontrollerDelegate
@required
- (void)function:(NSString *)sender;
- (void)subkey:(NSString *)sender;
@end

@interface fnviewcontroller : UIViewController {
    UIToolbar *fntool1;
    id<fnviewcontrollerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UIToolbar *fntool1;
@property (nonatomic, assign) id<fnviewcontrollerDelegate> delegate;

@end
