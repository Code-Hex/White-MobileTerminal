// AboutViewController.h
// MobileTerminal

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "UIImagefix.h"


@interface AboutViewController : UIViewController {
@private
    UILabel* versionLabel;
    UITextView *textview;
    UITableViewCell *cell;
    UITableViewCell *followcell;
}
@property(nonatomic, retain) IBOutlet UILabel* versionLabel;
@property(nonatomic, retain) IBOutlet UITextView *textview;
@property(nonatomic, retain) IBOutlet UITableViewCell *cell;
@property(nonatomic, retain) IBOutlet UITableViewCell *followcell;
@property(nonatomic, retain) IBOutlet UIImageView *about;

@end
