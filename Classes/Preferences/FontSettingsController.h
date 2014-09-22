//
//  FontSettingsController.h
//  MobileTerminal
//
//  Created by CodeHex on 2014/09/20.
//
//

#import <UIKit/UIKit.h>

@interface FontSettingsController : UITableViewController {
@private
    UIFont* font;
    NSMutableArray* sheets;
    NSMutableArray* name;
}

@property(nonatomic, retain) UIFont* font;

@end
