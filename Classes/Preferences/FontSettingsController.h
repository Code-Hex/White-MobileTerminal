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
    NSMutableArray* sheets;
    NSMutableArray* name;
}

@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UILabel *fontsize;
@property (nonatomic, retain) IBOutlet NSString *fontname;

@end
